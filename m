Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D056313DDDD;
	Thu, 11 Apr 2024 09:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712829507; cv=none; b=mNd0LXmC4OZaFAtLc7sNMERGF6pIMsc/ut3fQKIRO/0cyCn0Sf1W3AGlTbhwJeVvRnwVQ/o4xMdbNJfeY+pWhR1pTeCwOBG1wFpZ5n3ktShDdCH0SWqBRRiUwlredZnasiUPkiOqeiAZu43dT6Annb+oO9ZuVRoo4MUqdDwBnG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712829507; c=relaxed/simple;
	bh=gXOLO0KLUU3L14fDPd0lUZ9iHeCXqECMCnMCqnnNQas=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rclc/TRhv4ontK+HBOHOqdepKesPGGygo7csVVQLbcdFLcJEqkthq0KDwWq+OCC/BZrFC8dcBRiYkUz3FKZYxFuGYNpBo/zgIBEA3r9z1ENju4MJAJIcxAvqQ8rwGoZvDj16U3abG71vJ1ooIvFS8Khs4r3XvvcChAiaY5MG1bY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UAxhn9M9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UAxhn9M9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C5C7C433F1;
	Thu, 11 Apr 2024 09:58:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712829507;
	bh=gXOLO0KLUU3L14fDPd0lUZ9iHeCXqECMCnMCqnnNQas=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UAxhn9M9nBLjAoMhQVggELc6sGHRQS5izBvd2uy1HOnLTg/YD9LvLtnIsR67yzUPI
	 vpHqvpzWtZ2JpF06Num9linelTKXYfsNchoOPrEpe8NBkrVRpxVC6ctqBskzhcFhKE
	 ZB1FxrXayc5kLhiRzmmZddZQ4fnz0krRTPxnTOA0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roberto Sassu <roberto.sassu@huawei.com>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 011/175] smack: Set SMACK64TRANSMUTE only for dirs in smack_inode_setxattr()
Date: Thu, 11 Apr 2024 11:53:54 +0200
Message-ID: <20240411095419.883077285@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095419.532012976@linuxfoundation.org>
References: <20240411095419.532012976@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 128a5f464740e..2f2dc49f53dff 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -1341,7 +1341,8 @@ static int smack_inode_setxattr(struct dentry *dentry, const char *name,
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



