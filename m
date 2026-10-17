Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B17D38AC99;
	Sat, 17 Oct 2026 16:24:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254250; cv=none; b=Z205mwLdY/nHpcTyT24zOm4ZsTFpkE51xLD4fmRpga5B2i4/LvdQRJkEDV6cjJf+v0ZDyompHu4MDaptypMjz2AryT4Xs9WqIQTjnu//JvUzSTo2kB+FdIkOdbYBpF84BEHOKGLB9gO3KUtVm+zJZFE0OwxPCWJPugab/iNSZLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254250; c=relaxed/simple;
	bh=8SFrrA5Q5F80T8FFQJ2KK8R93mRJ8KsWJynznqY3psY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OeMF/maXJsL21cKMAsDCdCVpetKXYK72BAi0RtKQ+RnM1FNIqR96jI7+ob4DttoL7I7AKTSphs8OVm0zfFz+PIeiQIcQAz8YLEWlCv95dPCv8VwmH+JiBOA+4l5+BVjPl1cbMzoZbdgyex/uSBmT1aQ8gVKy18sxTgGN226w9sA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k3hq6BQV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k3hq6BQV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 620621F000C4;
	Sat, 17 Oct 2026 16:24:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254249;
	bh=Tqh3g+vUimnBf9XkVF3qzeYIu+ICYdXEdAqdUdnsNgs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k3hq6BQVMTJRLFKyYrsEwK1T6uy7S0YgWsMC2fnKXgGJKiqwYd/n520EEMtQ8VNbx
	 SbLCEvMYKvF3UirYhNkb4L13O3NH0v2cuSpX5sCADfXCLBT8joYJP+d/4akA+3mhNi
	 AA8zaXjpVxMFSBmsubLs22DTREFnd90AWjhICHgc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 334/869] io_uring/napi: cap busy_poll_to 10 msec
Date: Sat, 17 Oct 2026 17:52:55 +0200
Message-ID: <20261017160045.643023649@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit df8599ee18c0e5fe343ffe0b4c379636b8bb839a ]

Currently there's no cap on the maximum amount of time that napi is
allowed to poll if no events are found, which can lead to kernel
complaints on a task being stuck as there's no conditional rescheduling
done within that loop.

Just cap it to 10 msec in total, that's already way above any kind of
sane value that will reap any benefits, yet low enough that it's
nowhere near being able to trigger preemption complaints.

Fixes: 8d0c12a80cde ("io-uring: add napi busy poll support")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/napi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/io_uring/napi.c b/io_uring/napi.c
index 1de1543d80344..5542d78a4bd8c 100644
--- a/io_uring/napi.c
+++ b/io_uring/napi.c
@@ -240,6 +240,8 @@ int io_register_napi(struct io_ring_ctx *ctx, void __user *arg)
 	if (copy_to_user(arg, &curr, sizeof(curr)))
 		return -EFAULT;
 
+	/* cap NAPI at 10 msec of spin time */
+	napi.busy_poll_to = min(10000, napi.busy_poll_to);
 	WRITE_ONCE(ctx->napi_busy_poll_dt, napi.busy_poll_to * NSEC_PER_USEC);
 	WRITE_ONCE(ctx->napi_prefer_busy_poll, !!napi.prefer_busy_poll);
 	WRITE_ONCE(ctx->napi_enabled, true);
-- 
2.53.0



