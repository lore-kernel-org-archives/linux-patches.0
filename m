Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C112025A357;
	Wed, 25 Feb 2026 01:38:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983484; cv=none; b=tqsnBq3qU4xO0C3BHcv2M8z6Qj5cg1RhBe4oXHpKCHlZ869Wbt+gek37tfthsl7L0P+mxIGDKU/sg/ZaiOkGHBE57YAZe5q9c1sMDmqY4qF5mPYqkFzVKl7IVfdUlwRa1WN5h0t7PXl9Wsdb/6ilESK9WPA+bXMHM/E/r5wan/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983484; c=relaxed/simple;
	bh=i30jYq93QYutE53lVRBtbtKtX6pEMYzUKuTiEhQvN/E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qlZubG7sXe3TGqWvqmo6ACo1s59pApcztHmwwNHp40NlggqJ085RneQpE1bCfSHqsWNv29G3Ock07CDH10gux/XozMEiP4gYbrst3a4yRUIiwCL/kpe36UQUm70Nh9/sIk9TbdThx6iyqrcpRFz7FlrG7kJQqmNXP8AhTdliCTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gG4uSHP8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gG4uSHP8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 828B9C116D0;
	Wed, 25 Feb 2026 01:38:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983484;
	bh=i30jYq93QYutE53lVRBtbtKtX6pEMYzUKuTiEhQvN/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gG4uSHP8Jvvn6jB0xjyzPdAtdtm7kUUg2XQq0BGGWgCY5mYbaGjttUexr0JBEJMJ8
	 yDvcRIANy3Z0GQyWlSTmgOQJzOo7c2rqtxor5CWKyR/2vK3RCRdGPJu8hBvCEGAAgL
	 5cCDMCAugOYdqUswM3UqpcMNTw8Cf+I2jjBTlhb4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+d130f98b2c265fae5297@syzkaller.appspotmail.com,
	Qing Wang <wangqing7171@gmail.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 597/781] ovl: Fix uninit-value in ovl_fill_real
Date: Tue, 24 Feb 2026 17:21:46 -0800
Message-ID: <20260225012414.437611782@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

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
index 160960bb0ad0b..724ec9d93fc82 100644
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -755,7 +755,7 @@ static bool ovl_fill_real(struct dir_context *ctx, const char *name,
 	struct dir_context *orig_ctx = rdt->orig_ctx;
 	bool res;
 
-	if (rdt->parent_ino && strcmp(name, "..") == 0) {
+	if (rdt->parent_ino && namelen == 2 && !strncmp(name, "..", 2)) {
 		ino = rdt->parent_ino;
 	} else if (rdt->cache) {
 		struct ovl_cache_entry *p;
-- 
2.51.0



