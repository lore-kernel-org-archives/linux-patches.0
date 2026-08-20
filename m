Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2098C379EDA;
	Thu, 20 Aug 2026 15:14:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238890; cv=none; b=h/G8OygejZ/MrscMZcwbH/TXBeS115VX1RyrjTd3QJD9o4RAguTmymGDpmcnzpCSRRtZA2WSXzwHmxyV54cmOJmN5QP1q/9YFS3e/bipk1RbmvyDSeR+ee9gi/PMHbV6OFNX27Kiix4kvNxfmsWkmmkrZqQ8KZSCOA0Xqxbv4yI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238890; c=relaxed/simple;
	bh=1mS+9A4aSmZs2W1Nq5kORhUWPir2iJo99dKvZs+GZUk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XDNpFwKPWiqI62t+h5gkS0SbAnSkZ4Pg/KHhgoR6pPIewWpw+MB0AEbA5mjsWd9kKMlu/Yyfl//ZLmTntnQPOyugsZY2adDIsl3oAVXXQ3aUy17fa9UvS/ZpEkbcde/Ju/NdujatFEszB9gNMicug6/Qm+7q8wUAr2L7cpAUIsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HpNOR1Xg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HpNOR1Xg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C4521F000E9;
	Thu, 20 Aug 2026 15:14:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238889;
	bh=kOLMTJXouQlrf7fGAKyllj2ql1ToINMlybktTZy7T0I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HpNOR1XgEK+tsEZxAtQDVezB3ZOMHngkiEfwLYo2mZiSpiXGHiDbSCa8HT2iGx1CM
	 UylOjpjenJQLcajlx8tjbvy9izhaDfKm8XbyfyupjNpzh+yK0XbsFTJj37g4KXrRtL
	 kkpRCQJ3Tsp04ahu8MnPtk8Al8pJjw6QuZHNAykI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Brost <matthew.brost@intel.com>,
	Stuart Summers <stuart.summers@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>
Subject: [PATCH 6.18 074/217] drm/xe: Order ring writes before ring tail updates
Date: Thu, 20 Aug 2026 16:54:02 +0200
Message-ID: <20260820145239.848418586@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145237.531699751@linuxfoundation.org>
References: <20260820145237.531699751@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Brost <matthew.brost@intel.com>

commit 9f83c94469ff0fa37274b873ba24922e02531fa7 upstream.

The ring buffer and the LRC context image are both mapped WC, so the ring
tail update can become visible to the device before the ring contents it
is meant to publish.

The GuC CT send does contain an xe_device_wmb(), so sending the H2G would
flush the ring contents. The problem is that it comes too late:
xe_lrc_set_ring_tail() publishes the tail before the H2G is sent, and the
device samples the tail from the context image independently of it, either
at context switch-in or while the context is already resident. A submitter
which is interrupted between updating the tail and sending its H2G
therefore leaves the device free to observe the new tail while the ring
contents behind it are not yet visible:

  1. Thread A emits a job into the ring, sets the tail to T_A and sends
     the H2G, which flushes A's ring contents. The GuC starts scheduling
     the context in, but it is not executing yet.
  2. Thread B emits a job into ring[T_A..T_B]. Those writes are not yet
     visible to the device.
  3. Thread B updates the ring tail to T_B. That write targets a
     different page and becomes visible first.
  4. Thread B is interrupted before it sends its H2G, so the flush which
     would have published ring[T_A..T_B] has not happened yet.
  5. The context is switched in and samples the ring tail from the
     context image, picking up T_B rather than T_A.
  6. The GPU executes A's job, advances HEAD to T_A, and continues on to
     ring[T_A..T_B], which still holds the previous wrap's contents, so
     the CS parses stale commands.

The result is command stream corruption, which typically manifests as a
hang or a spurious pagefault rather than anything that points back at the
submission path.

Kernel jobs are by far the most likely to hit this. Kernel queues such as
the migration queue are shared and can be driven by many threads
concurrently, producing back-to-back submissions on an LRC which is
already executing. User queues are typically tied to a single submitting
thread, so the same interleaving is much harder to produce.

Add an xe_device_wmb() at the end of xe_lrc_write_ring() so that it covers
every ring tail publication site, and so the invariant is local: once
xe_lrc_write_ring() returns, the ring contents are visible to the device.

Fixes: dd08ebf6c352 ("drm/xe: Introduce a new DRM driver for Intel GPUs")
Closes: https://gitlab.freedesktop.org/drm/xe/kernel/-/work_items/8651
Closes: https://gitlab.freedesktop.org/drm/xe/kernel/-/work_items/7810
Cc: stable@vger.kernel.org
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Assisted-by: GitHub_Copilot:claude-opus-5
Reviewed-by: Stuart Summers <stuart.summers@intel.com>
Link: https://patch.msgid.link/20260807171716.140475-1-matthew.brost@intel.com
(cherry picked from commit 136360290f314890428a3fbf31aaa8e4f1d43567)
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_lrc.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/gpu/drm/xe/xe_lrc.c
+++ b/drivers/gpu/drm/xe/xe_lrc.c
@@ -1692,6 +1692,13 @@ void xe_lrc_write_ring(struct xe_lrc *lr
 
 		__xe_lrc_write_ring(lrc, ring, &noop, sizeof(noop));
 	}
+
+	/*
+	 * The ring and the LRC context image are both WC, so the ring tail
+	 * update which publishes these writes can become visible to the device
+	 * first. Ensure the ring contents are visible before returning.
+	 */
+	xe_device_wmb(xe);
 }
 
 u64 xe_lrc_descriptor(struct xe_lrc *lrc)


