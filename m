Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 094601474CB;
	Thu, 11 Apr 2024 10:30:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831442; cv=none; b=Z52zp0TrtpiHZ00Qy0j0R+1z9vLcIJcJAMLy+Ce88P0Sbo9vLcZljVLcG7UIqhdkj6wZ9fb/frD04gZR9jjAZzLGyLgXvhKrUsbDar79ss03xSsJIKq3F5lXCwaHVMFFkewJdwGNUo5gKvRweq/7+uHCAV/RWAYJgQ2oCMD26gk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831442; c=relaxed/simple;
	bh=R8apMdgGf4luzQa0J/AduyWIx8XUJidoE5RuvRrPcQw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NP7nRPSzqQwXQY+l9CmfOcsuZi0JYl1hOMHktH21ixdtd0E8ZmgtN6A+xf4BlvnSOw5jm5epqQqm3vwoeuYFzpF/HJ0KFKTO+PWL86l0PKenFrgyzicIGUqm7PktGiio9sv7LpyaA/rKUEdGS09dxO6CFb3OA/QALT5lbLumQbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gj0j2YF3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gj0j2YF3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 860E5C433F1;
	Thu, 11 Apr 2024 10:30:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831441;
	bh=R8apMdgGf4luzQa0J/AduyWIx8XUJidoE5RuvRrPcQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gj0j2YF3Bmn0KGVOtaTCFTKQrPfLq2xtGMsQch5TxKbgcPiFYk608LNtgm1+PQ1sw
	 Gm7hbgZrr9vDmkOxYvEd82iUhRpYlcpuXIJIWyMa6NOgpQ0Q9/8rUueVNyqVaD3/Z1
	 k7ThKvLwrJkRP0XbtR6VPC71+F5WA7C8956pURsM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roberto Sassu <roberto.sassu@huawei.com>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 010/294] smack: Set SMACK64TRANSMUTE only for dirs in smack_inode_setxattr()
Date: Thu, 11 Apr 2024 11:52:53 +0200
Message-ID: <20240411095435.948426053@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>
References: <20240411095435.633465671@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 5388f143eecd8..0be25e05c1a03 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -1280,7 +1280,8 @@ static int smack_inode_setxattr(struct dentry *dentry, const char *name,
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



