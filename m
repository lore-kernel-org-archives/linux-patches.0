Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6AAF35AC21
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:19:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302762; cv=none; b=n9SQ8umjLn9xqsWx0jz6fPTT14XmdtDEmlzIBUrAMrbNmP6V/iELjHwCTA0a/IJ8//0o8C8Tuz6PiKMsFAta1gGwEfUxajdnfaKHwnh8Al7T18dRz1gfgeaUsPmQsbNcGcZZIsO+6/oe4fuplJD/8oyrcova6D6eHvA3E7G5fT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302762; c=relaxed/simple;
	bh=GXEJQKyIk9slipmBN5HeNHSR86ZZLx/DxvScrjq72JA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i/OA7LIzVT0uMZDmWpU/ugtHriml84LGXUenvjdcSbvHGTCObm0IO+QhS0s7TxhgqwebcnHnt0KR21M79KDpWBF4MXPztPIST7/1i5BRQkcf0CPqSeBGiePTQD2Kx3AFdWJ2Jkg6OV44hqHE5TX0Q5N7fRC2di6o9S2jnYeCiX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kTezmOml; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kTezmOml"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E71D3C116D0;
	Sat, 28 Feb 2026 18:19:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302762;
	bh=GXEJQKyIk9slipmBN5HeNHSR86ZZLx/DxvScrjq72JA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kTezmOml9tn+bvrfnIrFlqLoMDI2zV9c0M/lfqrpB6YYeOkXFomq8vYP7f9jXTkJa
	 V1pILRAbgl9DohuZph5rRlRgUMko8eAfDVPqh/RfmmY7HQaHiYqOh6/Ecl0iEz9Wwn
	 6l1Nxr+aBCJ0YrDfT8i6JDojiLasroIV79YvZrL4MKqf6+RoPt7J8T3WZnZbvBXamQ
	 morriPrrgLC6iIDvD6bJOvjuSxgo388g3+e1fy9AGC4esvOesN6tbrkQueNVa/mPRi
	 BSAijLM20uDYCvY+C46fsc4eJV0IGqnIT9s4cYtIJNlYF++7VGAhxBRwkPvI6XwSDn
	 ARu4+JryLKUgA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Qing Wang <wangqing7171@gmail.com>,
	syzbot+d130f98b2c265fae5297@syzkaller.appspotmail.com,
	Amir Goldstein <amir73il@gmail.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 133/147] ovl: Fix uninit-value in ovl_fill_real
Date: Sat, 28 Feb 2026 13:17:21 -0500
Message-ID: <20260228181736.1605592-133-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181736.1605592-1-sashal@kernel.org>
References: <20260228181736.1605592-1-sashal@kernel.org>
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
index cc1e802570644..09a5542723787 100644
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -654,7 +654,7 @@ static int ovl_fill_real(struct dir_context *ctx, const char *name,
 		container_of(ctx, struct ovl_readdir_translate, ctx);
 	struct dir_context *orig_ctx = rdt->orig_ctx;
 
-	if (rdt->parent_ino && strcmp(name, "..") == 0) {
+	if (rdt->parent_ino && namelen == 2 && !strncmp(name, "..", 2)) {
 		ino = rdt->parent_ino;
 	} else if (rdt->cache) {
 		struct ovl_cache_entry *p;
-- 
2.51.0

