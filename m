Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 240DD2FB08C;
	Wed, 25 Feb 2026 06:58:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002691; cv=none; b=rQUdyiSe3nCek56bnZwRBlStbqypjE/W/F4lgX7N9q3Qb9/zdepk/kPHF9iEFt9PBJQTH2MiYBze9FWG9bHT2usjxbPyHTOITIzyWaMM7H8BQaKHtyKp1dLZ0Nv/qK2JigQzFeEQCt6EY5P3ujsL+PR/T9HZMWtxMlYDrfTy8aw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002691; c=relaxed/simple;
	bh=S8DX9Ha8aCqlFcJ+TK7Fpjm3yzrAwK04ukdY5aHexe0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aShXRHpPLCRoOctii1LuOLzSwtaRORGc2XN1wGdfemhOn1iOjFf3YX4gt2FbOu18pdLU+bsvYzCRRpKim58+lZaiyNSY3H2UQ0xsE2RRdmNfkz4i03alVac86rqMxyoJIASNX5CSrLkJwOi3VEL8my31v/ea4U3plDyyEWdnyeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lps4nll3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lps4nll3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E883FC116D0;
	Wed, 25 Feb 2026 06:58:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002691;
	bh=S8DX9Ha8aCqlFcJ+TK7Fpjm3yzrAwK04ukdY5aHexe0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lps4nll3mWuS7EiGAGkJpKVWJqeynAqvg1+voQ3NgBMLD39MSNVL3z4vjRjAwp4DN
	 Gtglo4dndLMigbDtAAU+2FGxtoFk3FnTDAFcQNnj07TLPgunRCjqVevmbDOrSSYFqp
	 Tn93x2Dy4H5oGuY9fpyhf22gVEPJZGvF7jKFwv4I=
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
Subject: [PATCH 6.18 484/641] ovl: Fix uninit-value in ovl_fill_real
Date: Tue, 24 Feb 2026 17:23:30 -0800
Message-ID: <20260225012400.247346050@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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
index 1e9792cc557b8..3c27e7a16f94b 100644
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -761,7 +761,7 @@ static bool ovl_fill_real(struct dir_context *ctx, const char *name,
 	struct dir_context *orig_ctx = rdt->orig_ctx;
 	bool res;
 
-	if (rdt->parent_ino && strcmp(name, "..") == 0) {
+	if (rdt->parent_ino && namelen == 2 && !strncmp(name, "..", 2)) {
 		ino = rdt->parent_ino;
 	} else if (rdt->cache) {
 		struct ovl_cache_entry *p;
-- 
2.51.0



