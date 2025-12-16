Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F8B4345730;
	Tue, 16 Dec 2025 11:37:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885061; cv=none; b=Y+qO0PzxmuSIen2s1/6K6H1lKMWwNWCorWsI/mo7qXxw8TJC5pqtwZCoqCKzPSrsnc8KPYHazxo8Q79hTTFNZGXrNQh3CI6s+s5Q+I880w8a9NMGhmUVxmXh377FnA2Lv31C7RhJxb0uxhrX/t46GvfQMLIGF3t5s+m4XYdbTzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885061; c=relaxed/simple;
	bh=vMWYA9sd2YGUksJev3TE0F+8H62Z7hQJoepn8rEHfjY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jhxJ1jZ/rf1qDza9JWKV5hUMPHzaYktir6ScOjoVh8p4nSUOej4oEt2SJSbiPmgDI3+znFqtMlL7r7oWgBVr9aYH6KuNJt6/i9JNd7U42hI3xQrZJUUYx/yNOprR1IYz/I5hqeVOygF41wFhfoF/hgUxXqX9Ky5ctmOvlY4GF7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h16UBMSM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h16UBMSM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABA7EC4CEF1;
	Tue, 16 Dec 2025 11:37:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885061;
	bh=vMWYA9sd2YGUksJev3TE0F+8H62Z7hQJoepn8rEHfjY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h16UBMSMZpna3DhEyxu86r/RKgCzAusfzLKljdCTqcRD7kWy945iCLQEVKrZn3Iy5
	 Z1bmBGvRKuMbOBN0pEhsDwWQ05AbULEvi9rGrfszn0WasNnVW8Mkeo8+eF1BtATpl8
	 +Q4lIxUiAOqBm6K9vKBmR11M22KuDSKPWKb28QB4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Andreev <andreev@swemel.ru>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 004/507] smack: always "instantiate" inode in smack_inode_init_security()
Date: Tue, 16 Dec 2025 12:07:25 +0100
Message-ID: <20251216111345.688377550@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 8609ae26e365e..5cd19f3498cbd 100644
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



