Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9968D2AEE4;
	Mon, 23 Jun 2025 21:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715038; cv=none; b=IfFHOO0ZdYSWdRDDZl2EJBC9Plg+jeapQ3w/qcDdKhACLYwyS7WHTUUU6p1DzT8TdRmgi6A8mbFKPHBg7hDRec9yOiF3BfomsGfH9mqWmiamTRI1KYevIoboOeiHYnraPJ9PLMqTimCokNY7h2/NbHV76rJRf6NMQZDfmsnAm64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715038; c=relaxed/simple;
	bh=APX3t7zx2eHOoh0jUhJIiwqZDnLm5evEmLyELypPvvM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J86ZJsd0+xPWhtQI/HN64f74/rsY9O8VYAvqQIh4tO6Y0AQwj9rJV8s7hXFPu7MGFC3G+oqyDBD9JGw0WNzUixWGLP5FKRhKYlRIa6hBWmTV9GytsefWwJQ4clcuAKsKglkmsyQCdod1C2ft4dhg8cFH8rQZ9+9v+TmrVvmZtUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sE5MvOiZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sE5MvOiZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3216AC4CEEA;
	Mon, 23 Jun 2025 21:43:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715038;
	bh=APX3t7zx2eHOoh0jUhJIiwqZDnLm5evEmLyELypPvvM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sE5MvOiZmHMFk268gNFLEbiqrJapI/Gj/2gSNXDXvOgElnZH4DTzkSMLBHFzxQwgM
	 zBcH520TcUmNtutbgq+a2nJn7JdeGPJvSRDuUu3sulkdxU0dLxRAt5BLsPOl4Dn0XS
	 ovKsZhePxJIZdTRV2kk+07FneqxMFmUNRyt7reQk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Yi <yi.zhang@huawei.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 237/355] ext4: prevent stale extent cache entries caused by concurrent get es_cache
Date: Mon, 23 Jun 2025 15:07:18 +0200
Message-ID: <20250623130633.876717633@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Yi <yi.zhang@huawei.com>

[ Upstream commit f22a0ef2231a7d8374bb021eb86404d0e9de5a02 ]

The EXT4_IOC_GET_ES_CACHE and EXT4_IOC_PRECACHE_EXTENTS currently
invokes ext4_ext_precache() to preload the extent cache without holding
the inode's i_rwsem. This can result in stale extent cache entries when
competing with operations such as ext4_collapse_range() which calls
ext4_ext_remove_space() or ext4_ext_shift_extents().

The problem arises when ext4_ext_remove_space() temporarily releases
i_data_sem due to insufficient journal credits. During this interval, a
concurrent EXT4_IOC_GET_ES_CACHE or EXT4_IOC_PRECACHE_EXTENTS may cache
extent entries that are about to be deleted. As a result, these cached
entries become stale and inconsistent with the actual extents.

Loading the extents cache without holding the inode's i_rwsem or the
mapping's invalidate_lock is not permitted besides during the writeback.
Fix this by holding the i_rwsem during EXT4_IOC_GET_ES_CACHE and
EXT4_IOC_PRECACHE_EXTENTS.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Link: https://patch.msgid.link/20250423085257.122685-6-yi.zhang@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/extents.c | 2 ++
 fs/ext4/ioctl.c   | 8 +++++++-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index ac97ef3c76e97..12da59c03c7cf 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -5034,7 +5034,9 @@ int ext4_get_es_cache(struct inode *inode, struct fiemap_extent_info *fieinfo,
 	}
 
 	if (fieinfo->fi_flags & FIEMAP_FLAG_CACHE) {
+		inode_lock_shared(inode);
 		error = ext4_ext_precache(inode);
+		inode_unlock_shared(inode);
 		if (error)
 			return error;
 		fieinfo->fi_flags &= ~FIEMAP_FLAG_CACHE;
diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index 56829507e68c8..b6da12b4c8a82 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -1139,8 +1139,14 @@ static long __ext4_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		return 0;
 	}
 	case EXT4_IOC_PRECACHE_EXTENTS:
-		return ext4_ext_precache(inode);
+	{
+		int ret;
 
+		inode_lock_shared(inode);
+		ret = ext4_ext_precache(inode);
+		inode_unlock_shared(inode);
+		return ret;
+	}
 	case FS_IOC_SET_ENCRYPTION_POLICY:
 		if (!ext4_has_feature_encrypt(sb))
 			return -EOPNOTSUPP;
-- 
2.39.5



