Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86AB843AD6;
	Mon,  1 Apr 2024 16:12:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987942; cv=none; b=qPAxf5GQxWGU5PMgpSajm3MNMLhO3yhcEVMZ/+mLIBN/pv+u6vfOigUStTnc4OzSBFN5CoYh2JgvUsgZyuWe5JEDjVFQSdUdVgvkHQs8D5NTMdWbxHynl0xXx/+j7kuTnaRGL9lLGo5dGvGdc1fFguMuSuH80jZyIU7CE3Z4tF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987942; c=relaxed/simple;
	bh=Uc3sh1WCEPvJW4m5EaGRzZBDftt3ADpNpRZjE1eDgis=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eUlfX+LjlKiKDwpcjaPnAJ+sqWwjVh7zasx7mHS1cxogX4vG3QijlCm0WWmwUg4+xhZFbfcAzzWmqdrgmu1EcB0Ou3zwp/PhbW1oFjUG+3e2ZRDTo4tCh2T3bD1UuZxohhdD7eMYbjKj8OWLCwmUl/sGfFtClLUBArZ71HeNoqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xbdMQpA2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xbdMQpA2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B7EBC43390;
	Mon,  1 Apr 2024 16:12:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987942;
	bh=Uc3sh1WCEPvJW4m5EaGRzZBDftt3ADpNpRZjE1eDgis=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xbdMQpA2sIRO9qAX8LTiht+eEG5t9R8IEhwc+DleerCKsTi+l8i2Xw8Z6JthxvudS
	 nnFry6xkqSOA/XsFq0FDkACZ4I6wAA7mXtCO/WCPOohokwd29/rnK3neGHAqddfPLp
	 Ix8lGwrH5S43LhrA2NMw0RrZMhN91PfuAOUY+d/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roberto Sassu <roberto.sassu@huawei.com>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 010/432] smack: Set SMACK64TRANSMUTE only for dirs in smack_inode_setxattr()
Date: Mon,  1 Apr 2024 17:39:57 +0200
Message-ID: <20240401152553.437646830@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index 1f1ea8529421f..0fe3ccec62a52 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -1312,7 +1312,8 @@ static int smack_inode_setxattr(struct mnt_idmap *idmap,
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



