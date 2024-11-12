Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C232E2309AE;
	Tue, 12 Nov 2024 10:40:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731408026; cv=none; b=T5XfhnsW0wR6f5UVhAQzNFQZvAqzhJlY4ZxZRfJNanxoJylVa2/nD4psEc7wVhpMj8y2d8zXAHqf75yP0ob4G1cnbakctaDhSW2VLH2H1tffp7/sQkryENzScEDtuwC1AtdBr8OLxw6gS0l4zb7fLvpUP8R04b90z3ZgmpP5eoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731408026; c=relaxed/simple;
	bh=LSrnYL1BdTZ1txQaq7iV5LDZpR9aBj2PfJv7H6plVwY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i2bKVOJFsJk/Pt7roh3SPa/SQRayaMcsyENDWe1xlT2a03+cTf5DWjAt+TBWPt2om3DWwjzUN/ONoD1dpBNnrt+tEA8cT8P53ZZyletC3DZtZJEwviP2fUAE4V2fwJmo1SX4BbUWMPItK6Nc3ogMbrvP3sTm44CZPhh0MxOQzWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nf6bPcrR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nf6bPcrR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D862CC4CECD;
	Tue, 12 Nov 2024 10:40:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731408025;
	bh=LSrnYL1BdTZ1txQaq7iV5LDZpR9aBj2PfJv7H6plVwY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nf6bPcrRwiN0nNdOwwWbbxWTtpckRC0ssiQuqGKvTrpunBWh5Ak/g8FRcB7mDy7a5
	 XtxaT3+I/l/f+JQVeTVgSI5Tg9tRGftNjXrRFxWus31V0+N98zZ/zPuU2jLmdCKpB6
	 wZKqDr36Zj0tmJCJkFVO1UaRTjDBBdwn7x/KmGwQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 037/184] NFS: Further fixes to attribute delegation a/mtime changes
Date: Tue, 12 Nov 2024 11:19:55 +0100
Message-ID: <20241112101902.291710297@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101900.865487674@linuxfoundation.org>
References: <20241112101900.865487674@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 40f45ab3814f2aff1ddada629c910aad982fc8e1 ]

When asked to set both an atime and an mtime to the current system time,
ensure that the setting is atomic by calling inode_update_timestamps()
only once with the appropriate flags.

Fixes: e12912d94137 ("NFSv4: Add support for delegated atime and mtime attributes")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Anna Schumaker <anna.schumaker@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/inode.c | 49 +++++++++++++++++++++++++++++++------------------
 1 file changed, 31 insertions(+), 18 deletions(-)

diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index b4914a11c3c25..b6519f4b12663 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -628,23 +628,35 @@ nfs_fattr_fixup_delegated(struct inode *inode, struct nfs_fattr *fattr)
 	}
 }
 
+static void nfs_update_timestamps(struct inode *inode, unsigned int ia_valid)
+{
+	enum file_time_flags time_flags = 0;
+	unsigned int cache_flags = 0;
+
+	if (ia_valid & ATTR_MTIME) {
+		time_flags |= S_MTIME | S_CTIME;
+		cache_flags |= NFS_INO_INVALID_CTIME | NFS_INO_INVALID_MTIME;
+	}
+	if (ia_valid & ATTR_ATIME) {
+		time_flags |= S_ATIME;
+		cache_flags |= NFS_INO_INVALID_ATIME;
+	}
+	inode_update_timestamps(inode, time_flags);
+	NFS_I(inode)->cache_validity &= ~cache_flags;
+}
+
 void nfs_update_delegated_atime(struct inode *inode)
 {
 	spin_lock(&inode->i_lock);
-	if (nfs_have_delegated_atime(inode)) {
-		inode_update_timestamps(inode, S_ATIME);
-		NFS_I(inode)->cache_validity &= ~NFS_INO_INVALID_ATIME;
-	}
+	if (nfs_have_delegated_atime(inode))
+		nfs_update_timestamps(inode, ATTR_ATIME);
 	spin_unlock(&inode->i_lock);
 }
 
 void nfs_update_delegated_mtime_locked(struct inode *inode)
 {
-	if (nfs_have_delegated_mtime(inode)) {
-		inode_update_timestamps(inode, S_CTIME | S_MTIME);
-		NFS_I(inode)->cache_validity &= ~(NFS_INO_INVALID_CTIME |
-						  NFS_INO_INVALID_MTIME);
-	}
+	if (nfs_have_delegated_mtime(inode))
+		nfs_update_timestamps(inode, ATTR_MTIME);
 }
 
 void nfs_update_delegated_mtime(struct inode *inode)
@@ -682,15 +694,16 @@ nfs_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
 			attr->ia_valid &= ~ATTR_SIZE;
 	}
 
-	if (nfs_have_delegated_mtime(inode)) {
-		if (attr->ia_valid & ATTR_MTIME) {
-			nfs_update_delegated_mtime(inode);
-			attr->ia_valid &= ~ATTR_MTIME;
-		}
-		if (attr->ia_valid & ATTR_ATIME) {
-			nfs_update_delegated_atime(inode);
-			attr->ia_valid &= ~ATTR_ATIME;
-		}
+	if (nfs_have_delegated_mtime(inode) && attr->ia_valid & ATTR_MTIME) {
+		spin_lock(&inode->i_lock);
+		nfs_update_timestamps(inode, attr->ia_valid);
+		spin_unlock(&inode->i_lock);
+		attr->ia_valid &= ~(ATTR_MTIME | ATTR_ATIME);
+	} else if (nfs_have_delegated_atime(inode) &&
+		   attr->ia_valid & ATTR_ATIME &&
+		   !(attr->ia_valid & ATTR_MTIME)) {
+		nfs_update_delegated_atime(inode);
+		attr->ia_valid &= ~ATTR_ATIME;
 	}
 
 	/* Optimization: if the end result is no change, don't RPC */
-- 
2.43.0



