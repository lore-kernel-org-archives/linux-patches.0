Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE6D4345758;
	Tue, 16 Dec 2025 11:37:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885038; cv=none; b=on6QMMf7hkZJa0uHiA60wLXRar03saXCI2bqXB+erkdOgcD66wqnLpamDeMQB/dH84XHW20jDzRSV02JmFKAzbMmH2TTIDwFSI+igDY/AA6COKDRFPuVh8UE1yFyaGkxMrKvKMRummcgYWEOjoL8y5o+SwI3Uy0icUJByS8aFic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885038; c=relaxed/simple;
	bh=Y9AXI9U8w+7R8tRkjC7Y1qPlJCiHo6gj+XaUnuZxJLQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L0VcpvRjSvWr83rcrPdkoC41EI+2UzIt9PgrqmFxp+fR3xVCc5VmxlZdwpXqeMvysKoshvu7VF6tTaVa8UpnFyw3ukAMv57r8GmiIZtHhhO5LfJXpzq+wz7EoTjxwE7is6Ci6aOZm/CNX3U8zjQEWCnEnZz/+kFg4iCIPjZc/y4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cV9wuaJs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cV9wuaJs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DE01C4CEF1;
	Tue, 16 Dec 2025 11:37:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885037;
	bh=Y9AXI9U8w+7R8tRkjC7Y1qPlJCiHo6gj+XaUnuZxJLQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cV9wuaJs+2JI12PCAVRcY63srfWdtshZUSB1fQUqmmZwfyIFw32xNagbtrf+DUf/O
	 q8LbuBjpzPKtDhDseqmaTMkhSTuTNZ2MEvkPkYGElo4v7wKpo6VUvXMZPRTzltmIob
	 itjfFhNzKY7wX1U8s8zrLEcAlIwYABSeW0YeDsro=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Andreev <andreev@swemel.ru>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 002/507] smack: fix bug: SMACK64TRANSMUTE set on non-directory
Date: Tue, 16 Dec 2025 12:07:23 +0100
Message-ID: <20251216111345.618286637@linuxfoundation.org>
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
index 8629e58ea4fa1..d6f814aa15bae 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -1027,18 +1027,20 @@ static int smack_inode_init_security(struct inode *inode, struct inode *dir,
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



