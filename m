Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8932E1BF37;
	Fri, 15 Nov 2024 16:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731687115; cv=none; b=CnXgKD//JPaZwpsozIrxFzsngN9cwwFx1RyZW2dOWfinMk3HCKtr6fMxmbzWIVesA5D4tH9/6ZcMOdY2Vl1uCrSIdOznGWNlb5nlc9TDqiu+upIda6a7u5BwZWC4tjsPRFkdBb6qjTsOZ55dZ+33zPCJCEe4lGD7FCSWitfOsYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731687115; c=relaxed/simple;
	bh=osgNz0gKptCvUBgqJAqxMcZYAThmuDPQIhZOKDwmIjw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=IA7lzes+0aQoOCLskTDENoJECWEQhOE1NVg/U3IQnDcoxR5LcAMbHX40DrMhTGvMKVQLxCJHDQMBfQiBIefIQMqFolFO2sa3a4TREP7X4tH+3OV0DH8rBsFI2XfnyS2DhXHP1CY0AYz0cZm5kRl7W0bNKvtl90SGj4UjdwJ7uGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GsHecrcC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GsHecrcC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACF34C4CECF;
	Fri, 15 Nov 2024 16:11:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731687115;
	bh=osgNz0gKptCvUBgqJAqxMcZYAThmuDPQIhZOKDwmIjw=;
	h=From:Date:Subject:To:Cc:From;
	b=GsHecrcC+rdfZhGzjeqqfOdp4K4d8SN5emtWij+2DXzbCHJEtWPinpGCJHARna/6e
	 Rna2zDLKzrthWl5m8MletxgK0t7gFsYcmmN7Zay3eKcshEp6Bd8jIl0vUCGi3Zw5pW
	 aEUtqWho17ibIDXeNBZQrOZtLWUxDbGFwULHB1Bqr/k5JwevoMBVZlc1gj0evfBWNE
	 cP9gqgys07s2SD+KU4EfOnMFWPTMp8hflpy73q2fcoz9g8OSbFXysaD82AkCs3adPC
	 RUZy4UBW2MTvoMlArbumRadfqzrnNmMNS22X6giJvKgcPOwxEfQgTNxcKqfjdCfg89
	 3N7giTWmeysCw==
From: Nathan Chancellor <nathan@kernel.org>
Date: Fri, 15 Nov 2024 09:10:04 -0700
Subject: [PATCH] ubifs: Fix uninitialized use of err in
 ubifs_jnl_write_inode()
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241115-ubifs-fix-uninitialized-err-v1-1-446849982e27@kernel.org>
X-B4-Tracking: v=1; b=H4sIAFtyN2cC/x3MQQqDMBBG4avIrDvgiKbYq5Quoo72B4ll0ogo3
 t3g8oPHOyiqQSO9ioNMV0QsIUMeBfVfHyZlDNlUlVUtIg2nDmPkERungIA//IxdB1Yzbl3nnRd
 9Nq6nfPiZ5vC+vz/neQGQDUj5bQAAAA==
X-Change-ID: 20241115-ubifs-fix-uninitialized-err-96ba6a1e756c
To: Richard Weinberger <richard@nod.at>, 
 Zhihao Cheng <chengzhihao1@huawei.com>
Cc: linux-mtd@lists.infradead.org, llvm@lists.linux.dev, 
 patches@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1332; i=nathan@kernel.org;
 h=from:subject:message-id; bh=osgNz0gKptCvUBgqJAqxMcZYAThmuDPQIhZOKDwmIjw=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDOnmRacqN7FZfNOueJf48tTUp3d25QYG/+a+uqxwa9VMz
 cVa+S8NOkpZGMS4GGTFFFmqH6seNzScc5bxxqlJMHNYmUCGMHBxCsBENsQxMrzJWPk2+nzi4ojD
 c29nVD33MmdWaPgZyi/CeUtIq7RfRIqRYdqkqoxb3LHzLy1xslgozpyaJjXh1dsqdaO9Wnd0Yle
 18AIA
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

Clang warns (or errors with CONFIG_WERROR=y):

  fs/ubifs/journal.c:986:20: error: variable 'err' is uninitialized when used here [-Werror,-Wuninitialized]
    986 |                 ubifs_ro_mode(c, err);
        |                                  ^~~

Set err to -EPERM before the call to ubifs_ro_mode() and reuse it in the
return statement to resolve the warning.

Fixes: 957e1c4e1779 ("ubifs: ubifs_jnl_write_inode: Only check once for the limitation of xattr count")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 fs/ubifs/journal.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ubifs/journal.c b/fs/ubifs/journal.c
index 8e98be64237154105cd6f7cb62cf0338ac26d3e9..36ba79fbd2ff80ff3d5c1f0bf965e439d8c55ab2 100644
--- a/fs/ubifs/journal.c
+++ b/fs/ubifs/journal.c
@@ -983,8 +983,9 @@ int ubifs_jnl_write_inode(struct ubifs_info *c, const struct inode *inode)
 
 	if (kill_xattrs && ui->xattr_cnt > ubifs_xattr_max_cnt(c)) {
 		ubifs_err(c, "Cannot delete inode, it has too much xattrs!");
+		err = -EPERM;
 		ubifs_ro_mode(c, err);
-		return -EPERM;
+		return err;
 	}
 
 	/*

---
base-commit: fe051552f5078fa02d593847529a3884305a6ffe
change-id: 20241115-ubifs-fix-uninitialized-err-96ba6a1e756c

Best regards,
-- 
Nathan Chancellor <nathan@kernel.org>

