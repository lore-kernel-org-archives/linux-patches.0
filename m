Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E64263233EE;
	Tue, 16 Dec 2025 11:18:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765883890; cv=none; b=MiplBpGVd6lsnLH9OMYT4bAVn2e+kjKLnMJTIALS3rB6u2EBs/jyl/K012mid1Lp8Eax+lbf0GUebrCaG/f93yS06ufUWSM+Gs+bkKiAmFi/G803JCAmXzIAshz+sSXolE9wXwHvaDuQXziI+mg/SQTMpA12TBzIEDzDd/lcTP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765883890; c=relaxed/simple;
	bh=kPwaVFDVWjNllEC4CXSRCjQqFcanYCuBFILsoq8J3PU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pdRo2BwUJGrUwpJKvcqeikZ/MSdvKXzUdEkWAHLyUswCYUn1G3q+yKMGbow25U3UrLBPhleZWzvN5GDMbe4XXmx7eCFfg7+vHA2wtl99uhgABIJNNPsEEMCWMeDn7EWAjyntpDqDp6OST+iCRgUbN5c+6VSQHuxJXgz+CSZqERc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SjkVwpTx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SjkVwpTx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBC0CC4CEF1;
	Tue, 16 Dec 2025 11:18:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765883889;
	bh=kPwaVFDVWjNllEC4CXSRCjQqFcanYCuBFILsoq8J3PU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SjkVwpTxK9KQpjBz31YnkKytfEkmjIeuPXCSeXtjP091liGMFJC4kD+0vG9T1oMno
	 1jnJQFDk41fKExqzdNYVdZWEczczngmN+5d5QOaA4u6sJIL7Tj1uUThqc8/21pILd0
	 LZlD6gi7i7RYr9mNWi7RJd9KcUBw7FAC8/nWIJs4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Andreev <andreev@swemel.ru>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 004/354] smack: always "instantiate" inode in smack_inode_init_security()
Date: Tue, 16 Dec 2025 12:09:31 +0100
Message-ID: <20251216111321.063247340@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

From: Konstantin Andreev <andreev@swemel.ru>

[ Upstream commit 69204f6cdb90f56b7ca27966d1080841108fc5de ]

If memory allocation for the SMACK64TRANSMUTE
xattr value fails in smack_inode_init_security(),
the SMK_INODE_INSTANT flag is not set in
(struct inode_smack *issp)->smk_flags,
leaving the inode as not "instantiated".

It does not matter if fs frees the inode
after failed smack_inode_init_security() call,
but there is no guarantee for this.

To be safe, mark the inode as "instantiated",
even if allocation of xattr values fails.

Signed-off-by: Konstantin Andreev <andreev@swemel.ru>
Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
Stable-dep-of: 78fc6a94be25 ("smack: fix bug: invalid label of unix socket file")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/smack/smack_lsm.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 586ba83c6e1be..d0a062a20024d 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -1032,6 +1032,8 @@ static int smack_inode_init_security(struct inode *inode, struct inode *dir,
 	struct task_smack *tsp = smack_cred(current_cred());
 	struct inode_smack * const issp = smack_inode(inode);
 	struct smack_known *dsp = smk_of_inode(dir);
+	int rc = 0;
+	int transflag = 0;
 	bool trans_cred;
 	bool trans_rule;
 
@@ -1060,18 +1062,20 @@ static int smack_inode_init_security(struct inode *inode, struct inode *dir,
 			issp->smk_inode = dsp;
 
 		if (S_ISDIR(inode->i_mode)) {
-			issp->smk_flags |= SMK_INODE_TRANSMUTE;
+			transflag = SMK_INODE_TRANSMUTE;
 
 			if (xattr_dupval(xattrs, xattr_count,
 				XATTR_SMACK_TRANSMUTE,
 				TRANS_TRUE,
 				TRANS_TRUE_SIZE
 			))
-				return -ENOMEM;
+				rc = -ENOMEM;
 		}
 	}
 
-	issp->smk_flags |= SMK_INODE_INSTANT;
+	issp->smk_flags |= (SMK_INODE_INSTANT | transflag);
+	if (rc)
+		return rc;
 
 	return xattr_dupval(xattrs, xattr_count,
 			    XATTR_SMACK_SUFFIX,
-- 
2.51.0



