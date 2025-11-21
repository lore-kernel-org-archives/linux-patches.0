Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50907246762;
	Fri, 21 Nov 2025 13:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731786; cv=none; b=E9BmmgBOCQyHXD6eMwTMoa7rTUWwOPLvqLSVvcqvtPdnXwFFgw0mjWN4tedHjSoTpyPjfkWkbK9NRumjS48MJZcS3yX4S2rwq7oqWY1HFtd2vi3dqNyPCBTapbHS8UwnsuVbOZPxOklHNM7es1BMsXQlpCzQpV0aFZX2MsBrhpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731786; c=relaxed/simple;
	bh=UPlKQPeYQEJ04F/4sL/Yc7wNtUbsRAQSbBnAAceUJI4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ccv8Dp5lAMyFEPPkFYD0eYvmJEw+hYKdVX0PlkKlRv/OCURpu81m+29pvK9yA4NY47PEUjsvmIfEhRPBTfk4vSKXTtrHXVEkDsb8+qsoIyhJNL1vhHCNs8B8uXwhA6BvXkTjL1gLno+xoGrQS0+6hIEhwUGEoO8ZRU6kpJNNbLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fVuJ7Cn3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fVuJ7Cn3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98B18C4CEF1;
	Fri, 21 Nov 2025 13:29:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731786;
	bh=UPlKQPeYQEJ04F/4sL/Yc7wNtUbsRAQSbBnAAceUJI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fVuJ7Cn34CUlG0y49jFM0yU+SZJwKOaeP1gdPWsgzCCmtDROY7GVRjRB8A+wpZ4nv
	 xNAcjbQMSFQl7YzkFuNlg2WahdaxRTMFmLTs98rs5WOvau/+owKJzQWz9COoxnTH1w
	 hWXg6DwHTDprzgADcR4x9tDxZKDi+BsaIKlxVaAE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dai Ngo <dai.ngo@oracle.com>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 079/185] NFS: Fix LTP test failures when timestamps are delegated
Date: Fri, 21 Nov 2025 14:11:46 +0100
Message-ID: <20251121130146.721291963@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130143.857798067@linuxfoundation.org>
References: <20251121130143.857798067@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 5bf5fb5ddd34c..5bab9db5417c2 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -711,6 +711,8 @@ nfs_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
 	struct inode *inode = d_inode(dentry);
 	struct nfs_fattr *fattr;
 	int error = 0;
+	kuid_t task_uid = current_fsuid();
+	kuid_t owner_uid = inode->i_uid;
 
 	nfs_inc_stats(inode, NFSIOS_VFSSETATTR);
 
@@ -732,9 +734,11 @@ nfs_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
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
@@ -744,10 +748,12 @@ nfs_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
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



