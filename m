Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DC37346E5E
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:17:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302625; cv=none; b=cj5FMCnQG9fr4qyY73HiTUU5lUU2kwP44jFjaNihN1qWFCEtskY5LuxRJzHUjKEwixgG0VBhLwZcyT5OVYrEmi1MbBBM8lsGfQXN4saFiCtP+iqD9OMVuVk7clCqpbV3XmvdCGqy8qWHnijFIqjLFPSPi6qQHrp95+mXZdZbQ5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302625; c=relaxed/simple;
	bh=DMbugtuLdqw4U5o/L9ZK9Zl7Z35wrzqefsPvxDIY5no=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t7sxXlRWVIAF/dV8TqI5abv6BZuf1bU3vmwkqil+cJ72ruNRhAbgrhpub3Vi+tHLF/sMl5SOr7Em/W294lAA5SN2ennCL9xikWPT9Corm7yHMZ9sOw3SGClHo8UlN0zZLdzioSEej/HmdK8eAaMX5Qxr7JoB8Mm6ZZCmU3Emgvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SH8N9oHw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SH8N9oHw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 900ACC116D0;
	Sat, 28 Feb 2026 18:17:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302625;
	bh=DMbugtuLdqw4U5o/L9ZK9Zl7Z35wrzqefsPvxDIY5no=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SH8N9oHwrE7Dg1ClTw9MHNFRKhv9unTuWNpQa7GJjohaDRjg4nGvpPieYLaXvsyBv
	 BfbKhy0Ak6qDDHLQDR1JxSgUeGUHkxwMnNFXMvDQltZRWIXfX5ioFdK80XWzvepAak
	 /bg5qClNCtbZyRzVsPjM0sKOX2PkjGriu0iX/o3/1/zsdCtSMEXZlOY5XmXk/VYEQ7
	 vi5bNFfbvrf2m+1/IukGMWrNK9v3hjltTjP2tGvXXieuHPAC/RJRiPDo/BevEJa4rK
	 JbSCRU0kuY8VZY66MuA6hXT5rjcub6ydaXuptUz5gRNKXQC1XkZWz4UDy1Zxv30/LJ
	 QecdaIOb5TBIQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Qing Wang <wangqing7171@gmail.com>,
	syzbot+d130f98b2c265fae5297@syzkaller.appspotmail.com,
	Amir Goldstein <amir73il@gmail.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 144/164] ovl: Fix uninit-value in ovl_fill_real
Date: Sat, 28 Feb 2026 13:14:43 -0500
Message-ID: <20260228181505.1600663-144-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181505.1600663-1-sashal@kernel.org>
References: <20260228181505.1600663-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Qing Wang <wangqing7171@gmail.com>

[ Upstream commit 1992330d90dd766fcf1730fd7bf2d6af65370ac4 ]

Syzbot reported a KMSAN uninit-value issue in ovl_fill_real.

This iusse's call chain is:
__do_sys_getdents64()
    -> iterate_dir()
        ...
            -> ext4_readdir()
                -> fscrypt_fname_alloc_buffer() // alloc
                -> fscrypt_fname_disk_to_usr // write without tail '\0'
                -> dir_emit()
                    -> ovl_fill_real() // read by strcmp()

The string is used to store the decrypted directory entry name for an
encrypted inode. As shown in the call chain, fscrypt_fname_disk_to_usr()
write it without null-terminate. However, ovl_fill_real() uses strcmp() to
compare the name against "..", which assumes a null-terminated string and
may trigger a KMSAN uninit-value warning when the buffer tail contains
uninit data.

Reported-by: syzbot+d130f98b2c265fae5297@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=d130f98b2c265fae5297
Fixes: 4edb83bb1041 ("ovl: constant d_ino for non-merge dirs")
Signed-off-by: Qing Wang <wangqing7171@gmail.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Link: https://patch.msgid.link/20260128132406.23768-2-amir73il@gmail.com
Acked-by: Miklos Szeredi <mszeredi@redhat.com>
Reviewed-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/overlayfs/readdir.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
index 9c580ef8cd6fc..666cc62578f65 100644
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -656,7 +656,7 @@ static int ovl_fill_real(struct dir_context *ctx, const char *name,
 		container_of(ctx, struct ovl_readdir_translate, ctx);
 	struct dir_context *orig_ctx = rdt->orig_ctx;
 
-	if (rdt->parent_ino && strcmp(name, "..") == 0) {
+	if (rdt->parent_ino && namelen == 2 && !strncmp(name, "..", 2)) {
 		ino = rdt->parent_ino;
 	} else if (rdt->cache) {
 		struct ovl_cache_entry *p;
-- 
2.51.0

