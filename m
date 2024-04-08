Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33F386FE1A;
	Mon,  8 Apr 2024 13:01:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712581265; cv=none; b=oLpNa+ObSifC2cUKXWuGc1CsLUOziFCIX4ruB7sBXBhiphJKPV0irpvFP92Zk/ZdO29qmGdEp59ZNWBUZOH7ybYnVG3uVOd6Txy7vc6pdZ+C6qfGJlmoj+voTKuYIAKy2zof2NRTmvPPHseGci34H6/DA+82o21DYYBXumUFWeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712581265; c=relaxed/simple;
	bh=RIIeOvTUKx7pYNNIK3nyzhs3/Ex+KCrxhPKu7D6MsMM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ox2AwtjPgzE1tF+HuXpuPrhtO6lpxYwYGUtBNIfayey6zNoxi6ZIQSXYK7oyIpSmbYRh7zDlQBEnO3VBZNNAh9S9plOH+YEVq5HC9bO3vQh2QqYeIEv3+GJlKh1EQv1rmdrABQGOHSCK0GL5yYxxt7dNNr0/nnzW7WgqwWK5k9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=osSLhpF6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="osSLhpF6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53988C433C7;
	Mon,  8 Apr 2024 13:01:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712581264;
	bh=RIIeOvTUKx7pYNNIK3nyzhs3/Ex+KCrxhPKu7D6MsMM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=osSLhpF6C/BkmNrsEcyre0VjE+qlVKTRgVVG6vYcGhG/9VuFsxKGBdL4cHYyZfEyZ
	 7eNMO36lAy39ufdfHwxCda7FpRrPz9Tia77durzcu7zbl7ALlT89p6ZEYhWI6La5TI
	 BhFCIQ3O2rN+qg72ngzhOVLmjkxysFERdyfySx48=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roberto Sassu <roberto.sassu@huawei.com>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 013/690] smack: Set SMACK64TRANSMUTE only for dirs in smack_inode_setxattr()
Date: Mon,  8 Apr 2024 14:47:59 +0200
Message-ID: <20240408125400.027109814@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index a5a78aef6403a..c45f0d61447c7 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -1264,7 +1264,8 @@ static int smack_inode_setxattr(struct user_namespace *mnt_userns,
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



