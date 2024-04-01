Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C54DDBA3F;
	Mon,  1 Apr 2024 16:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990618; cv=none; b=pdcu2hGgIh8gzPcCju35APuTuAetW0AGxFD3sp7Jmdnq9w+8H5tEYI2Qz5WYuUfIzT916WGmgLr+xofI8B/AZrSsNAnD/XSUsC1bG36nD6Pm+z8DEGVzC5+owLgOem+IHD+uGG6xFIZfi2OrB90CET0X7tB3ESJ1zh0BsDsSevA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990618; c=relaxed/simple;
	bh=EwJTJpvLZU1ey9rgpI4kmnklSoG/EYppDTxZtf0amOo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X2jwsh2OE7JEPeZik9xTmULszSlcOspoEZofkqeN8jYX1xSuyjUYoRauc/WBvkeIhnFbOwWbvcmvL28zKReKvS3EKzkycLNZdWTRqvH5rf2E/prUWkbmC80caQkintQlF3AEZV4aWjrR1ai80EBBZVOGpHR8sbsjWf4wiXIe32w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EywWHG+c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EywWHG+c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CC90C433C7;
	Mon,  1 Apr 2024 16:56:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990618;
	bh=EwJTJpvLZU1ey9rgpI4kmnklSoG/EYppDTxZtf0amOo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EywWHG+cVALF0s1ks7IxDvihvFbRVP8tps5mTCFBk+yotXEGggS3Ssn3RIGOPMbrc
	 9j1TLwT8mt8UDSt0WFtrug6xTwoO40eOtS50TV3vD+wP3nPFZtaXKIvSObvgxsJnF7
	 SlbCHiPg+rcn9P6Ea4lG0D+gkRxYB48dPM/SGQw0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roberto Sassu <roberto.sassu@huawei.com>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 014/272] smack: Set SMACK64TRANSMUTE only for dirs in smack_inode_setxattr()
Date: Mon,  1 Apr 2024 17:43:24 +0200
Message-ID: <20240401152530.739702153@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
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

[ Upstream commit 9c82169208dde516510aaba6bbd8b13976690c5d ]

Since the SMACK64TRANSMUTE xattr makes sense only for directories, enforce
this restriction in smack_inode_setxattr().

Cc: stable@vger.kernel.org
Fixes: 5c6d1125f8db ("Smack: Transmute labels on specified directories") # v2.6.38.x
Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/smack/smack_lsm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index fbadc61feedd1..07f7351148ecf 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -1309,7 +1309,8 @@ static int smack_inode_setxattr(struct user_namespace *mnt_userns,
 		check_star = 1;
 	} else if (strcmp(name, XATTR_NAME_SMACKTRANSMUTE) == 0) {
 		check_priv = 1;
-		if (size != TRANS_TRUE_SIZE ||
+		if (!S_ISDIR(d_backing_inode(dentry)->i_mode) ||
+		    size != TRANS_TRUE_SIZE ||
 		    strncmp(value, TRANS_TRUE, TRANS_TRUE_SIZE) != 0)
 			rc = -EINVAL;
 	} else
-- 
2.43.0



