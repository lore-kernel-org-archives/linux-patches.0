Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B6C8178CE7;
	Tue, 18 Jun 2024 12:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715532; cv=none; b=R0UJzIkvW+eMgFdCNVNia3Az3CPaH/BoXNPiWwDCEceRwwzO/Os2nIDXwm/WSq7KIVpTwElyPxeptA7yxliuq11soA/Vho7u8IWPsvqGRs1Pxf++L7Wnsdr4iUF7Ovx/ut3xTt4srFIe+WuTMNe/KV6BWnFHlJgBSKBUUsqRsl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715532; c=relaxed/simple;
	bh=eoDK0GX6Jeei7V6Aie2pCYK56i2PlyJhQT6soCX3kTs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qwspPG401oM7/Dtl095ckpkVItGAtHoij2t/mD1BFnMOjnhJGM++RnrfuLKjQ+0lEd7AHRRoNIC8nu8JZ7ch1mxcwNH/bgrZB1ClZADw5QMnEclifquNbVramH32fGXnG7rnGuVxVhdUZOhVE4+FkA/POQnqdBiAtDPvgiKC31g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NJyv2kP/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NJyv2kP/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7F17C3277B;
	Tue, 18 Jun 2024 12:58:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715532;
	bh=eoDK0GX6Jeei7V6Aie2pCYK56i2PlyJhQT6soCX3kTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NJyv2kP/iyMJKHKNfe6kdmQV3xbtnnMKPvKfDhi7Ectas59zbEkPX/43MbjiuVOD4
	 fQSqatr56Wfn0Quo+6y8AAeicxQV+Ya6GB7QOaBHJyGO+ZIWO5Oj+PsBhJXIVhomkt
	 LGRhX8//5YCexVjQW5NgTWQ7njpzySPrk1VqE/oE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Bobrowski <repnop@google.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 339/770] fsnotify: optimize the case of no marks of any type
Date: Tue, 18 Jun 2024 14:33:12 +0200
Message-ID: <20240618123420.353605745@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
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

From: Amir Goldstein <amir73il@gmail.com>

[ Upstream commit e43de7f0862b8598cd1ef440e3b4701cd107ea40 ]

Add a simple check in the inline helpers to avoid calling fsnotify()
and __fsnotify_parent() in case there are no marks of any type
(inode/sb/mount) for an inode's sb, so there can be no objects
of any type interested in the event.

Link: https://lore.kernel.org/r/20210810151220.285179-5-amir73il@gmail.com
Reviewed-by: Matthew Bobrowski <repnop@google.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/fsnotify.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/include/linux/fsnotify.h b/include/linux/fsnotify.h
index 79add91eaa04e..a9477c14fad5c 100644
--- a/include/linux/fsnotify.h
+++ b/include/linux/fsnotify.h
@@ -30,6 +30,9 @@ static inline void fsnotify_name(struct inode *dir, __u32 mask,
 				 struct inode *child,
 				 const struct qstr *name, u32 cookie)
 {
+	if (atomic_long_read(&dir->i_sb->s_fsnotify_connectors) == 0)
+		return;
+
 	fsnotify(mask, child, FSNOTIFY_EVENT_INODE, dir, name, NULL, cookie);
 }
 
@@ -41,6 +44,9 @@ static inline void fsnotify_dirent(struct inode *dir, struct dentry *dentry,
 
 static inline void fsnotify_inode(struct inode *inode, __u32 mask)
 {
+	if (atomic_long_read(&inode->i_sb->s_fsnotify_connectors) == 0)
+		return;
+
 	if (S_ISDIR(inode->i_mode))
 		mask |= FS_ISDIR;
 
@@ -53,6 +59,9 @@ static inline int fsnotify_parent(struct dentry *dentry, __u32 mask,
 {
 	struct inode *inode = d_inode(dentry);
 
+	if (atomic_long_read(&inode->i_sb->s_fsnotify_connectors) == 0)
+		return 0;
+
 	if (S_ISDIR(inode->i_mode)) {
 		mask |= FS_ISDIR;
 
-- 
2.43.0



