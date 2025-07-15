Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30E282D8790;
	Tue, 15 Jul 2025 13:43:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586984; cv=none; b=iZFWun5TGqiuPEloTDMSqBh+WBIpPEVhZdBcETxHiG2sSfMkxfOqrMiUzlSQ06cRZAdAv40W2h3nx1LPOtKxy63B10bLwGh0RnhuiHtyfgdMnwE8IwyB+nXQiYxrBAclRJzidUUCYZWxZYYlsDMWjrYfaRaJwkGGgB5zPMqHIQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586984; c=relaxed/simple;
	bh=wNuOyJgAwOWCfGgZrlEbj3Mh0MwC8GLsXK6i0GVYsSI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xq9txjhIGyN52qX/k1TZFD/ysr99Ahm9QjydZ9Kap6sB47ulVEIaYkeyamaA6o/5fG7UegbHwCBng9xfksEvW7LaDHgcOVmk4cLidkwsaSN617uM94rcAYALGT1UXgCmWuzbSD/KA4gtvAVMarhLfXajIavIhFPYOijCiz+6Fjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FumPQ8sB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FumPQ8sB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBFE4C4CEF6;
	Tue, 15 Jul 2025 13:43:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586984;
	bh=wNuOyJgAwOWCfGgZrlEbj3Mh0MwC8GLsXK6i0GVYsSI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FumPQ8sBB+0eak14Dy+4ZtWJQD+18jO4Awf01Kjiopz1EeaIlTRY6Rn6+0jxOlHRs
	 X3Ur85vi/wSOma9f38yHgnl4SAl41rRIo2kz2zzGDm+U86dOyoe4ESMA26brk/2i01
	 a/4T0vPZJGoNdgsQ5wTasK/xMXtV4vk6XJCFxdyA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaron Thompson <dev@aaront.org>,
	Timur Tabi <ttabi@nvidia.com>,
	Danilo Krummrich <dakr@kernel.org>
Subject: [PATCH 6.15 091/192] drm/nouveau: Do not fail module init on debugfs errors
Date: Tue, 15 Jul 2025 15:13:06 +0200
Message-ID: <20250715130818.559574810@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130814.854109770@linuxfoundation.org>
References: <20250715130814.854109770@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aaron Thompson <dev@aaront.org>

commit 78f88067d5c56d9aed69f27e238742841461cf67 upstream.

If CONFIG_DEBUG_FS is enabled, nouveau_drm_init() returns an error if it
fails to create the "nouveau" directory in debugfs. One case where that
will happen is when debugfs access is restricted by
CONFIG_DEBUG_FS_ALLOW_NONE or by the boot parameter debugfs=off, which
cause the debugfs APIs to return -EPERM.

So just ignore errors from debugfs. Note that nouveau_debugfs_root may
be an error now, but that is a standard pattern for debugfs. From
include/linux/debugfs.h:

"NOTE: it's expected that most callers should _ignore_ the errors
returned by this function. Other debugfs functions handle the fact that
the "dentry" passed to them could be an error and they don't crash in
that case. Drivers should generally work fine even if debugfs fails to
init anyway."

Fixes: 97118a1816d2 ("drm/nouveau: create module debugfs root")
Cc: stable@vger.kernel.org
Signed-off-by: Aaron Thompson <dev@aaront.org>
Acked-by: Timur Tabi <ttabi@nvidia.com>
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Link: https://lore.kernel.org/r/20250703211949.9916-1-dev@aaront.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/nouveau/nouveau_debugfs.c |    6 +-----
 drivers/gpu/drm/nouveau/nouveau_debugfs.h |    5 ++---
 drivers/gpu/drm/nouveau/nouveau_drm.c     |    4 +---
 3 files changed, 4 insertions(+), 11 deletions(-)

--- a/drivers/gpu/drm/nouveau/nouveau_debugfs.c
+++ b/drivers/gpu/drm/nouveau/nouveau_debugfs.c
@@ -314,14 +314,10 @@ nouveau_debugfs_fini(struct nouveau_drm
 	drm->debugfs = NULL;
 }
 
-int
+void
 nouveau_module_debugfs_init(void)
 {
 	nouveau_debugfs_root = debugfs_create_dir("nouveau", NULL);
-	if (IS_ERR(nouveau_debugfs_root))
-		return PTR_ERR(nouveau_debugfs_root);
-
-	return 0;
 }
 
 void
--- a/drivers/gpu/drm/nouveau/nouveau_debugfs.h
+++ b/drivers/gpu/drm/nouveau/nouveau_debugfs.h
@@ -24,7 +24,7 @@ extern void nouveau_debugfs_fini(struct
 
 extern struct dentry *nouveau_debugfs_root;
 
-int  nouveau_module_debugfs_init(void);
+void nouveau_module_debugfs_init(void);
 void nouveau_module_debugfs_fini(void);
 #else
 static inline void
@@ -42,10 +42,9 @@ nouveau_debugfs_fini(struct nouveau_drm
 {
 }
 
-static inline int
+static inline void
 nouveau_module_debugfs_init(void)
 {
-	return 0;
 }
 
 static inline void
--- a/drivers/gpu/drm/nouveau/nouveau_drm.c
+++ b/drivers/gpu/drm/nouveau/nouveau_drm.c
@@ -1456,9 +1456,7 @@ nouveau_drm_init(void)
 	if (!nouveau_modeset)
 		return 0;
 
-	ret = nouveau_module_debugfs_init();
-	if (ret)
-		return ret;
+	nouveau_module_debugfs_init();
 
 #ifdef CONFIG_NOUVEAU_PLATFORM_DRIVER
 	platform_driver_register(&nouveau_platform_driver);


