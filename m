Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0B30359FA3;
	Tue, 16 Dec 2025 12:05:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886707; cv=none; b=mKlEYV1SRc1iKGIWApFl3luKA7v8zhozyV6Nf1mwjsp9zf0zRxq7U3soqA5Vn2V0eVI+UulULGA9viI9dhH3t9gD/quWHwegQFJiYDDZH3uDj45aRus2y1Ijl/Rj25gb5Fn8S/PShTE6IOMIV+8Hn/8xjg3MtU6xpvzBNahEqfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886707; c=relaxed/simple;
	bh=p6g24h3QY2JSG29R/zwep/n2vOUtrtsHCfpU4kvNubI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZiDyDTtFK2yoRLlBevUIf6DHtDozkqeUvrp81KYUZOEsvh4JMb0qTHbub2VXJGUoTkfdC3kDTxuVZpPS8RibrUEM7bUyUMrHD7JgCKtP8rqCD3WPY6nYm7DFpMQ/AzELtnQ8qbICnAg0ycAz3yU/9Wn5iD2pIyX1T5Nxpk/CF/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M6EvLZvr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M6EvLZvr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 573A0C4CEF1;
	Tue, 16 Dec 2025 12:05:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886707;
	bh=p6g24h3QY2JSG29R/zwep/n2vOUtrtsHCfpU4kvNubI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M6EvLZvrcRsZcu0vPCVn175niw7jpy9RCWa9JI8hSWnztw/GmnL5MoSjEbRtTb9uI
	 i4dQFQBnMRtI5TSiQB8lsUYKKHZ5VaSfxR/xEaB963yKqfjr51xFNGELKg+G+ipThc
	 qCErZxY43DiIemGtGTZB4VwDvAmh7jbrLheOE7FY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Andreev <andreev@swemel.ru>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 001/614] smack: fix bug: SMACK64TRANSMUTE set on non-directory
Date: Tue, 16 Dec 2025 12:06:08 +0100
Message-ID: <20251216111401.343136940@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/smack/smack_lsm.c | 26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index af986587841d8..39a4caeb6bc8e 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -1015,18 +1015,20 @@ static int smack_inode_init_security(struct inode *inode, struct inode *dir,
 		if (tsp->smk_task != tsp->smk_transmuted)
 			isp = issp->smk_inode = dsp;
 
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



