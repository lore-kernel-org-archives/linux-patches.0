Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9860626F2B6;
	Tue, 16 Dec 2025 12:06:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886765; cv=none; b=GWwf+D5OdJS68PTn7nd055jb3Lr/FQhtY6rVJmQMk+arFLfsdLnI00JZ8ceobeJ0TxcO23KPIsGAwowXiFSNFJ/4MpC+g0x4RP26gAKIqcA9n8rRiKK2eCUA4gNYsTjqEVLfrlGj1io1u+whSKc92nczUWaEU6A/FADjIaPwW+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886765; c=relaxed/simple;
	bh=5fWNv+RdmmxYFtDRDIkjc1k9dmI9P1Z5kZpt8HYRirw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LbUd4aAYympyVyUW28XAP0B0hDYh+lbgfzkN1XDPh3QIHsgUI6L6/yBo9lavDDq3XciASKWd6R6MaW01JAOPCJlWIEwE+/Kui1PIYgEKlaMQ83Bs225viDbxkNVizWE2XkH14Dj4WUBJCdP9mZtT7LId87JeQ3Fpq7uL9n4+p1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2qQGA/ur; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2qQGA/ur"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD1B8C4CEF1;
	Tue, 16 Dec 2025 12:06:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886764;
	bh=5fWNv+RdmmxYFtDRDIkjc1k9dmI9P1Z5kZpt8HYRirw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2qQGA/ur2Nn/MSRAp9DvhQhXga5ZDDHkTLvYqkOgJRUpVuSAZyETTrxnERre5QWZ5
	 T/ydZ6qjgB43zNXYpfnz1cTLl8g4sfnrkpS1dNeXEcV7iXEptFQAdh8Zkn973ppwgh
	 fCXWTG1oFD5Iy2APvKEz49MNGOECFcuJtpb+/Hz0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Andreev <andreev@swemel.ru>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 004/614] smack: always "instantiate" inode in smack_inode_init_security()
Date: Tue, 16 Dec 2025 12:06:11 +0100
Message-ID: <20251216111401.451724960@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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
index 9eefb5cfccba5..db2a9aa9f1a05 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -1015,6 +1015,8 @@ static int smack_inode_init_security(struct inode *inode, struct inode *dir,
 	struct task_smack *tsp = smack_cred(current_cred());
 	struct inode_smack * const issp = smack_inode(inode);
 	struct smack_known *dsp = smk_of_inode(dir);
+	int rc = 0;
+	int transflag = 0;
 	bool trans_cred;
 	bool trans_rule;
 
@@ -1043,18 +1045,20 @@ static int smack_inode_init_security(struct inode *inode, struct inode *dir,
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



