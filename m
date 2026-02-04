Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA0C8423A71;
	Wed,  4 Feb 2026 15:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217559; cv=none; b=pMTm+NyjG6wD0OolWrClGxf2FjTvyxV1dvYNrloSiBvjyklLKqQvLR93n0M0z1xuKHRn4ILxmic5u31NMUoEfIn/ryXNHs/Fz3V9A1+etJreXK2Mzilbw5qqidl062frLVxa8lnSbzdMKXVGS2e0+gn1GwsJPKo1PSjPXv2gc6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217559; c=relaxed/simple;
	bh=p9TWvBUtE1JjcQA8+MWrotYSz6i7RBqD/J0Oj0Pp4Q8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ncoh8fYGm3RgMmbYpcO2eutLEkxFhhFFxO3ezQRaiXNFQGwWcCZfNYWp+e4N4Ip+ZkvtmNfDoiUIIesc304SReVq68Tu3epsC7DPDXBPM6fGQt/uPLZujAdmAdlJalrsQBcdkcPoGO36crwKmkKOu/k/9ciiAmKFWl7cgoBpyLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gbd6g9RN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gbd6g9RN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EC77C4CEF7;
	Wed,  4 Feb 2026 15:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770217559;
	bh=p9TWvBUtE1JjcQA8+MWrotYSz6i7RBqD/J0Oj0Pp4Q8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gbd6g9RNchD38KqmgzOssasRUaUKpbwEtTuSjC2hV82k8eSbTX6DPDPQ8IfjlVULA
	 hyIf6+3nvPA1DzV71f/OT5q0XPxPEO0rI7hX/goKA/pam2QOUwTjpixILZ/XbGPyod
	 vve7DNCO8iE9lTTUIJSzT9PsI4iGqjvjQvyq9KNI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Boris Burkov <boris@bur.io>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 017/280] btrfs: store fs_info in space_info
Date: Wed,  4 Feb 2026 15:36:31 +0100
Message-ID: <20260204143910.251856299@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143909.614719725@linuxfoundation.org>
References: <20260204143909.614719725@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Boris Burkov <boris@bur.io>

[ Upstream commit 42f620aec182f62ee72e3fce41cb3353951b3508 ]

This is handy when computing space_info dynamic reclaim thresholds where
we do not have access to a block group. We could add it to the various
functions as a parameter, but it seems reasonable for space_info to have
an fs_info pointer.

Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Boris Burkov <boris@bur.io>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: a11224a016d6 ("btrfs: fix memory leaks in create_space_info() error paths")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/space-info.c | 1 +
 fs/btrfs/space-info.h | 1 +
 2 files changed, 2 insertions(+)

diff --git a/fs/btrfs/space-info.c b/fs/btrfs/space-info.c
index bede72f3dffc3..069df2ebd1ca5 100644
--- a/fs/btrfs/space-info.c
+++ b/fs/btrfs/space-info.c
@@ -230,6 +230,7 @@ static int create_space_info(struct btrfs_fs_info *info, u64 flags)
 	if (!space_info)
 		return -ENOMEM;
 
+	space_info->fs_info = info;
 	for (i = 0; i < BTRFS_NR_RAID_TYPES; i++)
 		INIT_LIST_HEAD(&space_info->block_groups[i]);
 	init_rwsem(&space_info->groups_sem);
diff --git a/fs/btrfs/space-info.h b/fs/btrfs/space-info.h
index fea2f93674e7c..d6b34f2738b53 100644
--- a/fs/btrfs/space-info.h
+++ b/fs/btrfs/space-info.h
@@ -65,6 +65,7 @@ enum btrfs_flush_state {
 };
 
 struct btrfs_space_info {
+	struct btrfs_fs_info *fs_info;
 	spinlock_t lock;
 
 	u64 total_bytes;	/* total bytes in the space,
-- 
2.51.0



