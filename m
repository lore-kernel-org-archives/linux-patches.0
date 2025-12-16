Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85DFB56B81;
	Tue, 16 Dec 2025 11:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765883855; cv=none; b=NtMMRIEn8araS3LxqoAEzjaFjyqNG/Eyb/PwsdZk/BSWhOwv07d4ogVkx/UhwbD1Yiw7IOkZ8GweM9AHAg0GZWc5PNYnkOQJBmaMwWEsBqz9+KKei4BZjUnfIjJ7DkkNTU79IoBKcni4BtzEDzRQiVSXjeTn6NyZfxKKomOKlso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765883855; c=relaxed/simple;
	bh=T0ogwIUnTkWiXFfaVtEAJ+PUkj/ROn8kknGysr7/Yyc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BKkNC/Hfvr00VnDojB2PkFOSGBHJBF44rwFWFrbRNNM4NFVN8FLOQUpnzwQVcHH4PAuBDTO+O6iChIQMLkrTfbKzR3vPo0HAFcynoxArPrvJYDUm4K6BvpItu0TYXpDjpgEI4Gewv/h6YGEXsNKZ7efKBGfkQgRxt7KHjWh+0pc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ss5jK3v+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ss5jK3v+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2F8BC4CEF1;
	Tue, 16 Dec 2025 11:17:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765883855;
	bh=T0ogwIUnTkWiXFfaVtEAJ+PUkj/ROn8kknGysr7/Yyc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ss5jK3v+pVuYMH/SU9B599cTIKXtEy6R6y95bdOnxcZGsGc5Llqsg49Bk07vhVX9y
	 3BdM/ATUyY8bhVxWlp2OYIPWx2ULGkbk6JtaWN8wJ1XYO7KALn++q/t/P3j7/ZfJeG
	 R/cQnFuDzY/6+w4YcimZ5X09ed3XpT/Ynd8P8YGI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Andreev <andreev@swemel.ru>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 002/354] smack: fix bug: SMACK64TRANSMUTE set on non-directory
Date: Tue, 16 Dec 2025 12:09:29 +0100
Message-ID: <20251216111320.991763569@linuxfoundation.org>
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

[ Upstream commit 195da3ff244deff119c3f5244b464b2236ea1725 ]

When a new file system object is created
and the conditions for label transmutation are met,
the SMACK64TRANSMUTE extended attribute is set
on the object regardless of its type:
file, pipe, socket, symlink, or directory.

However,
SMACK64TRANSMUTE may only be set on directories.

This bug is a combined effect of the commits [1] and [2]
which both transfer functionality
from smack_d_instantiate() to smack_inode_init_security(),
but only in part.

Commit [1] set blank  SMACK64TRANSMUTE on improper object types.
Commit [2] set "TRUE" SMACK64TRANSMUTE on improper object types.

[1] 2023-06-10,
Fixes: baed456a6a2f ("smack: Set the SMACK64TRANSMUTE xattr in smack_inode_init_security()")
Link: https://lore.kernel.org/linux-security-module/20230610075738.3273764-3-roberto.sassu@huaweicloud.com/

[2] 2023-11-16,
Fixes: e63d86b8b764 ("smack: Initialize the in-memory inode in smack_inode_init_security()")
Link: https://lore.kernel.org/linux-security-module/20231116090125.187209-5-roberto.sassu@huaweicloud.com/

Signed-off-by: Konstantin Andreev <andreev@swemel.ru>
Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
Stable-dep-of: 78fc6a94be25 ("smack: fix bug: invalid label of unix socket file")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/smack/smack_lsm.c | 26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 18e15585dce41..d2fca7b1c6374 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -1044,18 +1044,20 @@ static int smack_inode_init_security(struct inode *inode, struct inode *dir,
 		if (!trans_cred)
 			issp->smk_inode = dsp;
 
-		issp->smk_flags |= SMK_INODE_TRANSMUTE;
-		xattr_transmute = lsm_get_xattr_slot(xattrs,
-						     xattr_count);
-		if (xattr_transmute) {
-			xattr_transmute->value = kmemdup(TRANS_TRUE,
-							 TRANS_TRUE_SIZE,
-							 GFP_NOFS);
-			if (!xattr_transmute->value)
-				return -ENOMEM;
-
-			xattr_transmute->value_len = TRANS_TRUE_SIZE;
-			xattr_transmute->name = XATTR_SMACK_TRANSMUTE;
+		if (S_ISDIR(inode->i_mode)) {
+			issp->smk_flags |= SMK_INODE_TRANSMUTE;
+			xattr_transmute = lsm_get_xattr_slot(xattrs,
+							     xattr_count);
+			if (xattr_transmute) {
+				xattr_transmute->value = kmemdup(TRANS_TRUE,
+								 TRANS_TRUE_SIZE,
+								 GFP_NOFS);
+				if (!xattr_transmute->value)
+					return -ENOMEM;
+
+				xattr_transmute->value_len = TRANS_TRUE_SIZE;
+				xattr_transmute->name = XATTR_SMACK_TRANSMUTE;
+			}
 		}
 	}
 
-- 
2.51.0



