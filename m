Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 036B9346FA0
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302235; cv=none; b=tfteU1ucao/VP9SLI0Uo/2kybUQpM6cA94ByqBMRPo/BMJOuC8w7eOBDDgmB5Mf6WWYGuj3LEH9EemlXlAFhsz3zURDxkeTaA2Fxpc3y7E5Ex8ImRpmw3PsTvjRsoCK7DHGhFpsazVIXnMKmM8sm6mG+mi6gKC9YhEoZ7lc4s9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302235; c=relaxed/simple;
	bh=HUQ4xqbsqwrWchhCW0mtGcwQdFqv30NK5yhhhGDdw00=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XCJnMAqP+EP2aLa5jr3WYAU2PIixdde3UWK243RF1M7wdmZGORm1s3JPwYkSv4SldyKjJp0sj+T042aoDOepE0n0Yd142y6Kwv8NTi80YwIo1mYxw81blCesgrEn5YymGCQbA8frxmMQ+DAyT0lyvg9Wm/CD0MAK53ywtWFrLkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FJLfd89a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FJLfd89a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B5C7C19423;
	Sat, 28 Feb 2026 18:10:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302234;
	bh=HUQ4xqbsqwrWchhCW0mtGcwQdFqv30NK5yhhhGDdw00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FJLfd89a1I/yDF7MvqS5jEIZA9ar19T6aNVUq1mXYbz7ueosbvWLajkfMlKgItO2O
	 x9chq41iFmvDuLH6dXXAh8PsXwokJchgBuNlsjL1OSxNkq/zsBceRoyDE9STGlaNM4
	 NiFDYVQCSWxxIvqVTW7MMIiiUKbKTB1Pc6wGycN7rpTDhmDRUM+eZGmbBGUVqhldOK
	 kn94GsQsDhwpCK2MQWxz0l6KLOopjPiJ2nwEO/gxt7LxnVJM7xqqVLDZZTTweaS/sV
	 GUD6LWWLOAILFxIqEEj6pEDqlWoKt09KrUgaP1xOjO9FjVKpm9x40N7ovsCvpQSgxT
	 sR2W06Q223VDg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Qing Wang <wangqing7171@gmail.com>,
	syzbot+d130f98b2c265fae5297@syzkaller.appspotmail.com,
	Amir Goldstein <amir73il@gmail.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 245/283] ovl: Fix uninit-value in ovl_fill_real
Date: Sat, 28 Feb 2026 13:06:27 -0500
Message-ID: <20260228180709.1583486-245-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
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
index de39e067ae65a..0d667e9534573 100644
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -659,7 +659,7 @@ static bool ovl_fill_real(struct dir_context *ctx, const char *name,
 		container_of(ctx, struct ovl_readdir_translate, ctx);
 	struct dir_context *orig_ctx = rdt->orig_ctx;
 
-	if (rdt->parent_ino && strcmp(name, "..") == 0) {
+	if (rdt->parent_ino && namelen == 2 && !strncmp(name, "..", 2)) {
 		ino = rdt->parent_ino;
 	} else if (rdt->cache) {
 		struct ovl_cache_entry *p;
-- 
2.51.0

