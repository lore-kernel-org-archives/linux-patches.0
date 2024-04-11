Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF0BD145B3E;
	Thu, 11 Apr 2024 10:14:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830460; cv=none; b=Nfeaavw/l1VavbOGSlJuiktJ89c0EArAMvZf6UuHRYPFIAd+y90/vJpc5+xTw0hsD+ZImRm9tCMaeeB4irV7QAaUP4RsKgSCWyC3SjHpC540Rn0NxKZ7/Hw9U4JmBwwQxcEQjTk/TdbkeDXDMRJMTLSn31qKikBclIbFH/+gj3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830460; c=relaxed/simple;
	bh=xOENAnL9Bd80ZyZbPZTKpKzWq/Z7Ibx/pg+ZUTTIXBE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i9g5dNO3o3cgC7WBJcwzFnvmBOpJz1eQ563anXBVJk4GnRlTUX84f4wK126xoswjpdjBNlvtCnspwXSH55Qy0Ka6A27aDLTAVn0H04ZXELsw53aUGEDE1zzOtYJn3S1toJ2zh2XWc/yxjE7Anju9FyhX5OHlMa91JA3mEWiAhPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EaWghpvD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EaWghpvD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35CB1C433C7;
	Thu, 11 Apr 2024 10:14:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830460;
	bh=xOENAnL9Bd80ZyZbPZTKpKzWq/Z7Ibx/pg+ZUTTIXBE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EaWghpvDZ+FJSsnH9CtW+Fyg5vu6ltn6RdfBXYFwcFH7xNuAQVT/PlVF+ZKocFLL9
	 FFG2yCrY0M2M3hgr7nLYs3xTULh9fq9sjlEZ6WQ1r1RJieUV1DBFsArOzhAWqSMF0G
	 nXRbOtOWy5O1qfgEGdI80y2OXxbzIjDhSc+bwHvI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roberto Sassu <roberto.sassu@huawei.com>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 010/215] smack: Set SMACK64TRANSMUTE only for dirs in smack_inode_setxattr()
Date: Thu, 11 Apr 2024 11:53:39 +0200
Message-ID: <20240411095425.192039483@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095424.875421572@linuxfoundation.org>
References: <20240411095424.875421572@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 6f2613f874fa9..65743be5b30f5 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -1290,7 +1290,8 @@ static int smack_inode_setxattr(struct dentry *dentry, const char *name,
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



