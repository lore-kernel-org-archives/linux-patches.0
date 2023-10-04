Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E17241D68D
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:19:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a/os0lQp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62555C433C8;
	Wed,  4 Oct 2023 18:19:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696443582;
	bh=d6DBFN7PTpWMTjxi2GnoovjR0fBIsj4QldnkIBps+Vw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a/os0lQpN8g0crwZJDhum9mYI3HkoljgKCbabR9h0x87631IT1CBPtOGON2sH5xS+
	 6DSMQbXymMbsAEtvlhC4LCk9EOKn6lwErj21oQh/Wt8M+9jE3a1GIJgXKUKSlt4ub7
	 GizyQlA6KjUdP+zeNqw2lwjtYqeCCWiAcfVFPzGs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roberto Sassu <roberto.sassu@huawei.com>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 207/259] smack: Retrieve transmuting information in smack_inode_getsecurity()
Date: Wed,  4 Oct 2023 19:56:20 +0200
Message-ID: <20231004175226.793816775@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175217.404851126@linuxfoundation.org>
References: <20231004175217.404851126@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roberto Sassu <roberto.sassu@huawei.com>

[ Upstream commit 3a3d8fce31a49363cc31880dce5e3b0617c9c38b ]

Enhance smack_inode_getsecurity() to retrieve the value for
SMACK64TRANSMUTE from the inode security blob, similarly to SMACK64.

This helps to display accurate values in the situation where the security
labels come from mount options and not from xattrs.

Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/smack/smack_lsm.c | 22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 1232c1d71d9f8..cd6a03e945eb7 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -1476,10 +1476,19 @@ static int smack_inode_getsecurity(struct user_namespace *mnt_userns,
 	struct super_block *sbp;
 	struct inode *ip = (struct inode *)inode;
 	struct smack_known *isp;
+	struct inode_smack *ispp;
+	size_t label_len;
+	char *label = NULL;
 
-	if (strcmp(name, XATTR_SMACK_SUFFIX) == 0)
+	if (strcmp(name, XATTR_SMACK_SUFFIX) == 0) {
 		isp = smk_of_inode(inode);
-	else {
+	} else if (strcmp(name, XATTR_SMACK_TRANSMUTE) == 0) {
+		ispp = smack_inode(inode);
+		if (ispp->smk_flags & SMK_INODE_TRANSMUTE)
+			label = TRANS_TRUE;
+		else
+			label = "";
+	} else {
 		/*
 		 * The rest of the Smack xattrs are only on sockets.
 		 */
@@ -1501,13 +1510,18 @@ static int smack_inode_getsecurity(struct user_namespace *mnt_userns,
 			return -EOPNOTSUPP;
 	}
 
+	if (!label)
+		label = isp->smk_known;
+
+	label_len = strlen(label);
+
 	if (alloc) {
-		*buffer = kstrdup(isp->smk_known, GFP_KERNEL);
+		*buffer = kstrdup(label, GFP_KERNEL);
 		if (*buffer == NULL)
 			return -ENOMEM;
 	}
 
-	return strlen(isp->smk_known);
+	return label_len;
 }
 
 
-- 
2.40.1



