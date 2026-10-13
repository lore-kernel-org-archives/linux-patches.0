Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 048CC3E639D;
	Tue, 13 Oct 2026 12:16:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893766; cv=none; b=D8GshQaGMLg70Hj17b6sXIyF/UnHRs1KVFhj/A2kjDXzQUe6MSxhxTHah3swk5XCu6+TJX8LLs2wdKEy0JYhsDiJSG+5haANZaHXEvPQfcIsjj/x2e7kq6Kt+ShA2CGWysxcJ33b5NUskt7fjopmz432GM3eMWLsbjCV7TQP+jY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893766; c=relaxed/simple;
	bh=+5SRpsh49ERKZnXvsR3yEbeA8rHDwn9chSuAH3xGdps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gs8AesrcaNzKHyyeRQR+gRMgIz474Cfih14SR+dWIP3G7TJ7GpM8Oq8B8HKW37mNSl4wz3tyNUMGM9gHTgNHCGbayf+fbTbBQR2kltOIFi7eKV+wI7nkhrYNzK/70IhCymdaUUXg2vzVYo4YS6vhybTeTwsJ+CHgNQ/iwPiVNQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eW3eZ0HA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eW3eZ0HA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 565881F000FF;
	Tue, 13 Oct 2026 12:16:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893764;
	bh=oWXiuk0TRq4ImnFSNnFeP+S6vg1bpyehTWBMSUVaRgs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eW3eZ0HA/O1M3dRoQzqIXp3Q6b70SZ9iSF6IO+cUYQCTLdYY8slDaBSqWpFD8j5wa
	 pDB8PJzUV4F9mrz+c6CHL3j8rK7wiZvGBml8K83/0C7cYm/kTiMv5Z9FZw3ZteXkWr
	 SJiCjHyIHykPHqqytXAdTmaJ+kH1eFSA0FYc/iKw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 334/621] btrfs: split btrfs_fs_closing() and change return type to bool
Date: Tue, 13 Oct 2026 13:35:29 +0200
Message-ID: <20261013112928.778513580@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Sterba <dsterba@suse.com>

[ Upstream commit e582f22030a7a59d4d0bb2881371df259d4a2ecd ]

There are two tests in btrfs_fs_closing() but checking the
BTRFS_FS_CLOSING_DONE bit is done only in one place
load_extent_tree_free(). As this is an inline we can reduce size of the
generated code. The types can be also changed to bool as this becomes a
simple condition.

   text    data     bss     dec     hex filename
1674006  146704   15560 1836270  1c04ee pre/btrfs.ko
1673772  146704   15560 1836036  1c0404 post/btrfs.ko

DELTA: -234

Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: 51a0e8399858 ("btrfs: skip global block reserve accounting for rescue mounts")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/block-group.c |  2 +-
 fs/btrfs/fs.h          | 18 ++++++++++--------
 2 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index e9ee10bee2ece..271afe14a6862 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -761,7 +761,7 @@ static int load_extent_tree_free(struct btrfs_caching_control *caching_ctl)
 	nritems = btrfs_header_nritems(leaf);
 
 	while (1) {
-		if (btrfs_fs_closing(fs_info) > 1) {
+		if (btrfs_fs_closing_done(fs_info)) {
 			last = (u64)-1;
 			break;
 		}
diff --git a/fs/btrfs/fs.h b/fs/btrfs/fs.h
index eccc61463947b..a50d11df93f8c 100644
--- a/fs/btrfs/fs.h
+++ b/fs/btrfs/fs.h
@@ -1096,15 +1096,17 @@ void __btrfs_clear_fs_compat_ro(struct btrfs_fs_info *fs_info, u64 flag,
 #define btrfs_test_opt(fs_info, opt)	((fs_info)->mount_opt & \
 					 BTRFS_MOUNT_##opt)
 
-static inline int btrfs_fs_closing(const struct btrfs_fs_info *fs_info)
+static inline bool btrfs_fs_closing(const struct btrfs_fs_info *fs_info)
 {
-	/* Do it this way so we only ever do one test_bit in the normal case. */
-	if (test_bit(BTRFS_FS_CLOSING_START, &fs_info->flags)) {
-		if (test_bit(BTRFS_FS_CLOSING_DONE, &fs_info->flags))
-			return 2;
-		return 1;
-	}
-	return 0;
+	return unlikely(test_bit(BTRFS_FS_CLOSING_START, &fs_info->flags));
+}
+
+static inline bool btrfs_fs_closing_done(const struct btrfs_fs_info *fs_info)
+{
+	if (btrfs_fs_closing(fs_info) && test_bit(BTRFS_FS_CLOSING_DONE, &fs_info->flags))
+		return true;
+
+	return false;
 }
 
 /*
-- 
2.53.0



