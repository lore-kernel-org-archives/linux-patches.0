Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5063D2EAD1B;
	Thu,  3 Jul 2025 14:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554621; cv=none; b=ncXnrqaytTfsDgtP3W91aoGIlw3LBkVI9NSB0ejfS9nmKtj+TydasB+VmUU1Z+2cML3TVt9ZRcNX3Ut+cDswhFOwPjN1LmFnFSgo7Z5ebo3jNNpwVfFMuYilmaBJisalAWCQ9B2hojP/3KfboQRYU+qBPnb/0oCtpMFUbxry3uY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554621; c=relaxed/simple;
	bh=Cd0J/L6+OSzCfM+VEZwOv1U6oH6QoZhL+dsAN0vvW98=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VEo7Bseq8itOk0cdqiut7Bde8khIJxMy/cMTimcxDG96o6o+jgaWm9x95AIkZiBZ0CPGXlkKB71EVrqaW5IR9tKXiWGrO3NlpbwF/6txSXda+HiXvtmTS45C6gGDjZ+GN7v+GSV4vcRYpefm1nxdBLl7/nPud4oBJC34uTBmOME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uZlXWN9o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uZlXWN9o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2E00C4CEE3;
	Thu,  3 Jul 2025 14:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554621;
	bh=Cd0J/L6+OSzCfM+VEZwOv1U6oH6QoZhL+dsAN0vvW98=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uZlXWN9oW/2Ns1sAICZoZYjmXzMFfdn5LFqf70qeGu2VfkWUADGjIJkEn1i3n59Tz
	 xX9GCWJtj0KY8MxlykV7048f+Ibuqs57v0Xgx+gUaganlPP2P0H7LI96cJoH3LifaY
	 SZhrpHoWf3yQFrnJOPZbjka1RzXye9MV7wtIsEXY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sagi Grimberg <sagi@grimberg.me>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 006/263] NFSv4.2: fix setattr caching of TIME_[MODIFY|ACCESS]_SET when timestamps are delegated
Date: Thu,  3 Jul 2025 16:38:46 +0200
Message-ID: <20250703144004.550206921@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sagi Grimberg <sagi@grimberg.me>

[ Upstream commit aba41e90aadeca8d4656f90639aa5f91ce564f1c ]

nfs_setattr will flush all pending writes before updating a file time
attributes. However when the client holds delegated timestamps, it can
update its timestamps locally as it is the authority for the file
times attributes. The client will later set the file attributes by
adding a setattr to the delegreturn compound updating the server time
attributes.

Fix nfs_setattr to avoid flushing pending writes when the file time
attributes are delegated and the mtime/atime are set to a fixed
timestamp (ATTR_[MODIFY|ACCESS]_SET. Also, when sending the setattr
procedure over the wire, we need to clear the correct attribute bits
from the bitmask.

I was able to measure a noticable speedup when measuring untar performance.
Test: $ time tar xzf ~/dir.tgz
Baseline: 1m13.072s
Patched: 0m49.038s

Which is more than 30% latency improvement.

Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Anna Schumaker <anna.schumaker@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/inode.c    | 49 +++++++++++++++++++++++++++++++++++++++++++----
 fs/nfs/nfs4proc.c |  8 ++++----
 2 files changed, 49 insertions(+), 8 deletions(-)

diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index 4695292378bbe..8ab7868807a7d 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -635,6 +635,34 @@ nfs_fattr_fixup_delegated(struct inode *inode, struct nfs_fattr *fattr)
 	}
 }
 
+static void nfs_set_timestamps_to_ts(struct inode *inode, struct iattr *attr)
+{
+	unsigned int cache_flags = 0;
+
+	if (attr->ia_valid & ATTR_MTIME_SET) {
+		struct timespec64 ctime = inode_get_ctime(inode);
+		struct timespec64 mtime = inode_get_mtime(inode);
+		struct timespec64 now;
+		int updated = 0;
+
+		now = inode_set_ctime_current(inode);
+		if (!timespec64_equal(&now, &ctime))
+			updated |= S_CTIME;
+
+		inode_set_mtime_to_ts(inode, attr->ia_mtime);
+		if (!timespec64_equal(&now, &mtime))
+			updated |= S_MTIME;
+
+		inode_maybe_inc_iversion(inode, updated);
+		cache_flags |= NFS_INO_INVALID_CTIME | NFS_INO_INVALID_MTIME;
+	}
+	if (attr->ia_valid & ATTR_ATIME_SET) {
+		inode_set_atime_to_ts(inode, attr->ia_atime);
+		cache_flags |= NFS_INO_INVALID_ATIME;
+	}
+	NFS_I(inode)->cache_validity &= ~cache_flags;
+}
+
 static void nfs_update_timestamps(struct inode *inode, unsigned int ia_valid)
 {
 	enum file_time_flags time_flags = 0;
@@ -703,14 +731,27 @@ nfs_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
 
 	if (nfs_have_delegated_mtime(inode) && attr->ia_valid & ATTR_MTIME) {
 		spin_lock(&inode->i_lock);
-		nfs_update_timestamps(inode, attr->ia_valid);
+		if (attr->ia_valid & ATTR_MTIME_SET) {
+			nfs_set_timestamps_to_ts(inode, attr);
+			attr->ia_valid &= ~(ATTR_MTIME|ATTR_MTIME_SET|
+						ATTR_ATIME|ATTR_ATIME_SET);
+		} else {
+			nfs_update_timestamps(inode, attr->ia_valid);
+			attr->ia_valid &= ~(ATTR_MTIME|ATTR_ATIME);
+		}
 		spin_unlock(&inode->i_lock);
-		attr->ia_valid &= ~(ATTR_MTIME | ATTR_ATIME);
 	} else if (nfs_have_delegated_atime(inode) &&
 		   attr->ia_valid & ATTR_ATIME &&
 		   !(attr->ia_valid & ATTR_MTIME)) {
-		nfs_update_delegated_atime(inode);
-		attr->ia_valid &= ~ATTR_ATIME;
+		if (attr->ia_valid & ATTR_ATIME_SET) {
+			spin_lock(&inode->i_lock);
+			nfs_set_timestamps_to_ts(inode, attr);
+			spin_unlock(&inode->i_lock);
+			attr->ia_valid &= ~(ATTR_ATIME|ATTR_ATIME_SET);
+		} else {
+			nfs_update_delegated_atime(inode);
+			attr->ia_valid &= ~ATTR_ATIME;
+		}
 	}
 
 	/* Optimization: if the end result is no change, don't RPC */
diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 56f41ec327397..6c3896a9b9d0f 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -325,14 +325,14 @@ static void nfs4_bitmap_copy_adjust(__u32 *dst, const __u32 *src,
 
 	if (nfs_have_delegated_mtime(inode)) {
 		if (!(cache_validity & NFS_INO_INVALID_ATIME))
-			dst[1] &= ~FATTR4_WORD1_TIME_ACCESS;
+			dst[1] &= ~(FATTR4_WORD1_TIME_ACCESS|FATTR4_WORD1_TIME_ACCESS_SET);
 		if (!(cache_validity & NFS_INO_INVALID_MTIME))
-			dst[1] &= ~FATTR4_WORD1_TIME_MODIFY;
+			dst[1] &= ~(FATTR4_WORD1_TIME_MODIFY|FATTR4_WORD1_TIME_MODIFY_SET);
 		if (!(cache_validity & NFS_INO_INVALID_CTIME))
-			dst[1] &= ~FATTR4_WORD1_TIME_METADATA;
+			dst[1] &= ~(FATTR4_WORD1_TIME_METADATA|FATTR4_WORD1_TIME_MODIFY_SET);
 	} else if (nfs_have_delegated_atime(inode)) {
 		if (!(cache_validity & NFS_INO_INVALID_ATIME))
-			dst[1] &= ~FATTR4_WORD1_TIME_ACCESS;
+			dst[1] &= ~(FATTR4_WORD1_TIME_ACCESS|FATTR4_WORD1_TIME_ACCESS_SET);
 	}
 }
 
-- 
2.39.5



