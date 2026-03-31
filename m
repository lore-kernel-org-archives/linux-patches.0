Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E6A73DE431;
	Tue, 31 Mar 2026 16:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975868; cv=none; b=aZHkEb9DQSzZKOaoFhdtXRQBGkvtB7C31KFeu8PsFjdHMXfK/yQr9jcED5YC38jL5VyS5IIuhgEG4fngw6tVeMNAlbjSGDa++KLUECaKsCGHFqYNZyf4vuKAhlvrldwf7T1E3nhhdrJrA9jgfhryhOTjgjWC6/u2WPrYhVHtXQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975868; c=relaxed/simple;
	bh=vSVxSRBlvMpb+Xljuju28wvUpA3aaJTlv/67G2gKspk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BmDRXHooD1iN2mPblzEuv/BjPOqNF4iJCE6k8wJEHu6KMGTweXiDshnA1eXtVrBJI5bnOUX+XTcnBe0zdrANZ0ma88UyBCDSsCuzi4pcxL+T6kG0tT6oDmHh2YydlMLvXkJImggBtRGnRAsjnWCO1SbdfKXVi+eVzJB+xha04Rc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qttopUxQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qttopUxQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7C33C19423;
	Tue, 31 Mar 2026 16:51:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975868;
	bh=vSVxSRBlvMpb+Xljuju28wvUpA3aaJTlv/67G2gKspk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qttopUxQSltWOxQ6JhlE5hLVecOMK9iBbZwMO+ZIOcYJU1SAzezxXPsc4gGl/M8Hf
	 Kyg2+JE1fmYwNBwLm+L/ctdPkeh7F67IZhkQmaM3bhJw/t9ES8vjTlWctFnJEI4BIk
	 PmVUExZfxsh3LRQ3wOg9l2vXcCV2mdJKAhqytGRM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alberto Garcia <berto@igalia.com>,
	Brian Geffon <bgeffon@google.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 118/244] PM: hibernate: Drain trailing zero pages on userspace restore
Date: Tue, 31 Mar 2026 18:21:08 +0200
Message-ID: <20260331161746.020325981@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161741.651718120@linuxfoundation.org>
References: <20260331161741.651718120@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alberto Garcia <berto@igalia.com>

[ Upstream commit 734eba62cd32cb9ceffa09e57cdc03d761528525 ]

Commit 005e8dddd497 ("PM: hibernate: don't store zero pages in the
image file") added an optimization to skip zero-filled pages in the
hibernation image. On restore, zero pages are handled internally by
snapshot_write_next() in a loop that processes them without returning
to the caller.

With the userspace restore interface, writing the last non-zero page
to /dev/snapshot is followed by the SNAPSHOT_ATOMIC_RESTORE ioctl. At
this point there are no more calls to snapshot_write_next() so any
trailing zero pages are not processed, snapshot_image_loaded() fails
because handle->cur is smaller than expected, the ioctl returns -EPERM
and the image is not restored.

The in-kernel restore path is not affected by this because the loop in
load_image() in swap.c calls snapshot_write_next() until it returns 0.
It is this final call that drains any trailing zero pages.

Fixed by calling snapshot_write_next() in snapshot_write_finalize(),
giving the kernel the chance to drain any trailing zero pages.

Fixes: 005e8dddd497 ("PM: hibernate: don't store zero pages in the image file")
Signed-off-by: Alberto Garcia <berto@igalia.com>
Acked-by: Brian Geffon <bgeffon@google.com>
Link: https://patch.msgid.link/ef5a7c5e3e3dbd17dcb20efaa0c53a47a23498bb.1773075892.git.berto@igalia.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/power/snapshot.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/kernel/power/snapshot.c b/kernel/power/snapshot.c
index 30894d8f0a781..c56b08121dbc5 100644
--- a/kernel/power/snapshot.c
+++ b/kernel/power/snapshot.c
@@ -2861,6 +2861,17 @@ int snapshot_write_finalize(struct snapshot_handle *handle)
 {
 	int error;
 
+	/*
+	 * Call snapshot_write_next() to drain any trailing zero pages,
+	 * but make sure we're in the data page region first.
+	 * This function can return PAGE_SIZE if the kernel was expecting
+	 * another copy page. Return -ENODATA in that situation.
+	 */
+	if (handle->cur > nr_meta_pages + 1) {
+		error = snapshot_write_next(handle);
+		if (error)
+			return error > 0 ? -ENODATA : error;
+	}
 	copy_last_highmem_page();
 	error = hibernate_restore_protect_page(handle->buffer);
 	/* Do that only if we have loaded the image entirely */
-- 
2.53.0



