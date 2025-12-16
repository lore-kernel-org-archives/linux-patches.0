Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95DEA348890;
	Tue, 16 Dec 2025 12:06:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886761; cv=none; b=PExwIQ91e3J8n328BwZFdzjYJuKf/G2ylvWVBN0BRq1Wj43kOj1mLoN/s9KrMq+i9qepxseRdBLrfhJDFtI4ft71V4DpGg8Sj7OTti0e3Mx1lkz/tRicrLwlhQRh+lcMOQojxtBKkQuBJs6R/Z0OWTlrzRhrEjEwcAVj4sAhUAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886761; c=relaxed/simple;
	bh=PRFh+XzLBasfIsE4x2mkZ0IuRJvDngppwCk/EZi11Ts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rEIskivXQXt3o+EMbTNJaAFul3JwyJrvhr9m/iGtF9N1DQpYbo+2AmAuDNjkiBnGV6JbtvhUyl5w5Cs+nyPqk7MthYlwfUtrrk0COYJ4nyFmTAPI3Va+dfZcWgoZYragJFqm6Qwn1OxzfiTgj6AT9qD//Hu09dtZ41ADEWw7Eys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jchGNAkG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jchGNAkG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B061C4CEF1;
	Tue, 16 Dec 2025 12:06:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886761;
	bh=PRFh+XzLBasfIsE4x2mkZ0IuRJvDngppwCk/EZi11Ts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jchGNAkGHFBMWMHtats8ZJ4J5puKRlQibV3J7gO8R4Slg71BQJWVGA7SIbnCo0xcT
	 67CR2Z+970+dXS6iyH2CltY3ytD6zW/GzSN5B/vEfWSBhkUcq4zRVKNSW1F1Tlka/W
	 RsUjN+4tBt88saMQqQ582FuObRkTzGJhngaeFT4w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Andreev <andreev@swemel.ru>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 003/614] smack: deduplicate xattr setting in smack_inode_init_security()
Date: Tue, 16 Dec 2025 12:06:10 +0100
Message-ID: <20251216111401.415787175@linuxfoundation.org>
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

[ Upstream commit 8e5d9f916a9678e2dcbed2289b87efd453e4e052 ]

Signed-off-by: Konstantin Andreev <andreev@swemel.ru>
Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
Stable-dep-of: 78fc6a94be25 ("smack: fix bug: invalid label of unix socket file")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/smack/smack_lsm.c | 56 ++++++++++++++++++++------------------
 1 file changed, 29 insertions(+), 27 deletions(-)

diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index a005f5afb8e0d..9eefb5cfccba5 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -980,6 +980,24 @@ smk_rule_transmutes(struct smack_known *subject,
 	return (may > 0) && (may & MAY_TRANSMUTE);
 }
 
+static int
+xattr_dupval(struct xattr *xattrs, int *xattr_count,
+	     const char *name, const void *value, unsigned int vallen)
+{
+	struct xattr * const xattr = lsm_get_xattr_slot(xattrs, xattr_count);
+
+	if (!xattr)
+		return 0;
+
+	xattr->value = kmemdup(value, vallen, GFP_NOFS);
+	if (!xattr->value)
+		return -ENOMEM;
+
+	xattr->value_len = vallen;
+	xattr->name = name;
+	return 0;
+}
+
 /**
  * smack_inode_init_security - copy out the smack from an inode
  * @inode: the newly created inode
@@ -997,7 +1015,6 @@ static int smack_inode_init_security(struct inode *inode, struct inode *dir,
 	struct task_smack *tsp = smack_cred(current_cred());
 	struct inode_smack * const issp = smack_inode(inode);
 	struct smack_known *dsp = smk_of_inode(dir);
-	struct xattr *xattr = lsm_get_xattr_slot(xattrs, xattr_count);
 	bool trans_cred;
 	bool trans_rule;
 
@@ -1016,8 +1033,6 @@ static int smack_inode_init_security(struct inode *inode, struct inode *dir,
 	 * Mark the inode as changed.
 	 */
 	if (trans_cred || (trans_rule && smk_inode_transmutable(dir))) {
-		struct xattr *xattr_transmute;
-
 		/*
 		 * The caller of smack_dentry_create_files_as()
 		 * should have overridden the current cred, so the
@@ -1029,35 +1044,22 @@ static int smack_inode_init_security(struct inode *inode, struct inode *dir,
 
 		if (S_ISDIR(inode->i_mode)) {
 			issp->smk_flags |= SMK_INODE_TRANSMUTE;
-			xattr_transmute = lsm_get_xattr_slot(xattrs,
-							     xattr_count);
-			if (xattr_transmute) {
-				xattr_transmute->value = kmemdup(TRANS_TRUE,
-								 TRANS_TRUE_SIZE,
-								 GFP_NOFS);
-				if (!xattr_transmute->value)
-					return -ENOMEM;
-
-				xattr_transmute->value_len = TRANS_TRUE_SIZE;
-				xattr_transmute->name = XATTR_SMACK_TRANSMUTE;
-			}
+
+			if (xattr_dupval(xattrs, xattr_count,
+				XATTR_SMACK_TRANSMUTE,
+				TRANS_TRUE,
+				TRANS_TRUE_SIZE
+			))
+				return -ENOMEM;
 		}
 	}
 
 	issp->smk_flags |= SMK_INODE_INSTANT;
 
-	if (xattr) {
-		const char *inode_label = issp->smk_inode->smk_known;
-
-		xattr->value = kstrdup(inode_label, GFP_NOFS);
-		if (!xattr->value)
-			return -ENOMEM;
-
-		xattr->value_len = strlen(inode_label);
-		xattr->name = XATTR_SMACK_SUFFIX;
-	}
-
-	return 0;
+	return xattr_dupval(xattrs, xattr_count,
+			    XATTR_SMACK_SUFFIX,
+			    issp->smk_inode->smk_known,
+		     strlen(issp->smk_inode->smk_known));
 }
 
 /**
-- 
2.51.0



