Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 501F021ABC9;
	Wed,  4 Feb 2026 15:28:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218905; cv=none; b=J8s9ZUyq8YlE/hf4OfDf9UpRlamVNYQc9EXnkvSJ/fQYyP3zMHkMgJwuT+9v+mW/vEeDYxtby7jKKPss6F7qtXYbEwGQl0O5LnR3UUPNdpc25pvxz7j1LoyDwsMmbRo/FTjWDtTUrSjIoSvTdVBc2RDvNo1fLpMv9I7MpBXsoAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218905; c=relaxed/simple;
	bh=zpP712wHkCX0ZcR/yqmHj4ermrRt/Fdzbs1K0SqCwg8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PZu7ymOEYeos4kI6tK+7NQ5Re0EbpqHWqxP2Ym4PMh+DEe7NT1vqXEEi+FYhXBG9XyokyMynH3QsDP8xElv2Kxl4doW7qessTVSVpSc8MG9bcox6HzlVYXlYYSObUz3JTpqVGkUhnplU1SIUytI4T5x29rHk37mY1VtUaYnnxLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mqDQ+Acu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mqDQ+Acu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7464C4CEF7;
	Wed,  4 Feb 2026 15:28:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218905;
	bh=zpP712wHkCX0ZcR/yqmHj4ermrRt/Fdzbs1K0SqCwg8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mqDQ+AcuKab+yldYLKreJyO8g09YCsqSwwZeY0FgLNxPvEYhWpHo2XlD6jbEV3rbg
	 eC2cg1y9v7cabLoab5W/jGNaLoI9MDBMKsFSI+I0i9dBvOZzJL9Ef05my8cJ4xIv6M
	 J8kheK4T5cXk4h7qPCakX66dSGoSElmzf7JvS5C0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chunsheng Luo <luochunsheng@ustc.edu>,
	Amir Goldstein <amir73il@gmail.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 001/122] readdir: require opt-in for d_type flags
Date: Wed,  4 Feb 2026 15:39:43 +0100
Message-ID: <20260204143851.913403161@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143851.857060534@linuxfoundation.org>
References: <20260204143851.857060534@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amir Goldstein <amir73il@gmail.com>

[ Upstream commit c644bce62b9c6b441143a03c910f986109c47001 ]

Commit c31f91c6af96 ("fuse: don't allow signals to interrupt getdents
copying") introduced the use of high bits in d_type as flags. However,
overlayfs was not adapted to handle this change.

In ovl_cache_entry_new(), the code checks if d_type == DT_CHR to
determine if an entry might be a whiteout. When fuse is used as the
lower layer and sets high bits in d_type, this comparison fails,
causing whiteout files to not be recognized properly and resulting in
incorrect overlayfs behavior.

Fix this by requiring callers of iterate_dir() to opt-in for getting
flag bits in d_type outside of S_DT_MASK.

Fixes: c31f91c6af96 ("fuse: don't allow signals to interrupt getdents copying")
Link: https://lore.kernel.org/all/20260107034551.439-1-luochunsheng@ustc.edu/
Link: https://github.com/containerd/stargz-snapshotter/issues/2214
Reported-by: Chunsheng Luo <luochunsheng@ustc.edu>
Reviewed-by: Chunsheng Luo <luochunsheng@ustc.edu>
Tested-by: Chunsheng Luo <luochunsheng@ustc.edu>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Link: https://patch.msgid.link/20260108074522.3400998-1-amir73il@gmail.com
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/readdir.c       | 3 +++
 include/linux/fs.h | 6 +++++-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/readdir.c b/fs/readdir.c
index 7764b86389788..73707b6816e9a 100644
--- a/fs/readdir.c
+++ b/fs/readdir.c
@@ -316,6 +316,7 @@ SYSCALL_DEFINE3(getdents, unsigned int, fd,
 	struct getdents_callback buf = {
 		.ctx.actor = filldir,
 		.ctx.count = count,
+		.ctx.dt_flags_mask = FILLDIR_FLAG_NOINTR,
 		.current_dir = dirent
 	};
 	int error;
@@ -400,6 +401,7 @@ SYSCALL_DEFINE3(getdents64, unsigned int, fd,
 	struct getdents_callback64 buf = {
 		.ctx.actor = filldir64,
 		.ctx.count = count,
+		.ctx.dt_flags_mask = FILLDIR_FLAG_NOINTR,
 		.current_dir = dirent
 	};
 	int error;
@@ -569,6 +571,7 @@ COMPAT_SYSCALL_DEFINE3(getdents, unsigned int, fd,
 	struct compat_getdents_callback buf = {
 		.ctx.actor = compat_filldir,
 		.ctx.count = count,
+		.ctx.dt_flags_mask = FILLDIR_FLAG_NOINTR,
 		.current_dir = dirent,
 	};
 	int error;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 9b2230fb2332f..3e965c77fa1b1 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2207,6 +2207,8 @@ struct dir_context {
 	 * INT_MAX  unlimited
 	 */
 	int count;
+	/* @actor supports these flags in d_type high bits */
+	unsigned int dt_flags_mask;
 };
 
 /* If OR-ed with d_type, pending signals are not checked */
@@ -3985,7 +3987,9 @@ static inline bool dir_emit(struct dir_context *ctx,
 			    const char *name, int namelen,
 			    u64 ino, unsigned type)
 {
-	return ctx->actor(ctx, name, namelen, ctx->pos, ino, type);
+	unsigned int dt_mask = S_DT_MASK | ctx->dt_flags_mask;
+
+	return ctx->actor(ctx, name, namelen, ctx->pos, ino, type & dt_mask);
 }
 static inline bool dir_emit_dot(struct file *file, struct dir_context *ctx)
 {
-- 
2.51.0



