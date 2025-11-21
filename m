Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDE171F09B3;
	Fri, 21 Nov 2025 13:19:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731167; cv=none; b=lUGukzNHfeB+9IlUI3JkyeK0+EAv0A1BaPvnTwGRNelHB1fXjyrxtuXs9e/GGfh4y6LncMX2gJu4PpeAvgVJ4eWWWFNFJRFe9V4JG4mxh4P1aMslXzF9etSw4D4rjNhcooByx7qZ1oCS1BkGxHpnip54surj5bhxb5+Hf2koYs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731167; c=relaxed/simple;
	bh=S3OgCF7pHC8K7dncM45/EuxVYGVBIsLEaOCj0PudpgA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DixJeM5rkPs6jsFuxnE+pfgZD3zSyIGuQop1bdJe4ZlG9E43LfzaQmAKsB+fUiQzwpkpnWnydw2t66EOcjmpM1DLnb15WJNtktHFNP5yS47bmYtbmU5vso//kOjdaCu7miJzYkmQ+qL/809ALax+vw2Ue6iSExU0OBmB8pyqmtg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PvCD3Dg3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PvCD3Dg3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F578C4CEF1;
	Fri, 21 Nov 2025 13:19:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731167;
	bh=S3OgCF7pHC8K7dncM45/EuxVYGVBIsLEaOCj0PudpgA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PvCD3Dg3ZYruOvFkwM3BtC0uMb2ibjfLJe6+r3s+4QAMF7vjazeM+yXvVi8n88Wgt
	 AYOWqIH+/xr4QczNLaX0fmY7abkRAFQof+3W3GLvDj/EP3omGaCP5hdtOpkL6RF0iW
	 MirIYJOEFxwchvXo5DVQFDC8pybjEuZC2wHwggZs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dai Ngo <dai.ngo@oracle.com>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 112/247] NFS: Fix LTP test failures when timestamps are delegated
Date: Fri, 21 Nov 2025 14:10:59 +0100
Message-ID: <20251121130158.603639938@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
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

From: Dai Ngo <dai.ngo@oracle.com>

[ Upstream commit b623390045a81fc559decb9bfeb79319721d3dfb ]

The utimes01 and utime06 tests fail when delegated timestamps are
enabled, specifically in subtests that modify the atime and mtime
fields using the 'nobody' user ID.

The problem can be reproduced as follow:

# echo "/media *(rw,no_root_squash,sync)" >> /etc/exports
# export -ra
# mount -o rw,nfsvers=4.2 127.0.0.1:/media /tmpdir
# cd /opt/ltp
# ./runltp -d /tmpdir -s utimes01
# ./runltp -d /tmpdir -s utime06

This issue occurs because nfs_setattr does not verify the inode's
UID against the caller's fsuid when delegated timestamps are
permitted for the inode.

This patch adds the UID check and if it does not match then the
request is sent to the server for permission checking.

Fixes: e12912d94137 ("NFSv4: Add support for delegated atime and mtime attributes")
Signed-off-by: Dai Ngo <dai.ngo@oracle.com>
Signed-off-by: Anna Schumaker <anna.schumaker@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/inode.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index 49df9debb1a69..35bdb49236bac 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -718,6 +718,8 @@ nfs_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
 	struct nfs_fattr *fattr;
 	loff_t oldsize = i_size_read(inode);
 	int error = 0;
+	kuid_t task_uid = current_fsuid();
+	kuid_t owner_uid = inode->i_uid;
 
 	nfs_inc_stats(inode, NFSIOS_VFSSETATTR);
 
@@ -739,9 +741,11 @@ nfs_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
 	if (nfs_have_delegated_mtime(inode) && attr->ia_valid & ATTR_MTIME) {
 		spin_lock(&inode->i_lock);
 		if (attr->ia_valid & ATTR_MTIME_SET) {
-			nfs_set_timestamps_to_ts(inode, attr);
-			attr->ia_valid &= ~(ATTR_MTIME|ATTR_MTIME_SET|
+			if (uid_eq(task_uid, owner_uid)) {
+				nfs_set_timestamps_to_ts(inode, attr);
+				attr->ia_valid &= ~(ATTR_MTIME|ATTR_MTIME_SET|
 						ATTR_ATIME|ATTR_ATIME_SET);
+			}
 		} else {
 			nfs_update_timestamps(inode, attr->ia_valid);
 			attr->ia_valid &= ~(ATTR_MTIME|ATTR_ATIME);
@@ -751,10 +755,12 @@ nfs_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
 		   attr->ia_valid & ATTR_ATIME &&
 		   !(attr->ia_valid & ATTR_MTIME)) {
 		if (attr->ia_valid & ATTR_ATIME_SET) {
-			spin_lock(&inode->i_lock);
-			nfs_set_timestamps_to_ts(inode, attr);
-			spin_unlock(&inode->i_lock);
-			attr->ia_valid &= ~(ATTR_ATIME|ATTR_ATIME_SET);
+			if (uid_eq(task_uid, owner_uid)) {
+				spin_lock(&inode->i_lock);
+				nfs_set_timestamps_to_ts(inode, attr);
+				spin_unlock(&inode->i_lock);
+				attr->ia_valid &= ~(ATTR_ATIME|ATTR_ATIME_SET);
+			}
 		} else {
 			nfs_update_delegated_atime(inode);
 			attr->ia_valid &= ~ATTR_ATIME;
-- 
2.51.0



