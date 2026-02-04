Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08E01423A71;
	Wed,  4 Feb 2026 15:06:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217563; cv=none; b=nl6S/zf89amL6vGFjI6wgnhjksYGuG+ULYnf2i2U+gjIm+76uNQ1DIO+aDqy5h45YJ80qmACr9zMqMckgI0wAfQVdfkFFmV3to3ZZJkAOOGkYZ6mJBZx5b6ofAdDVlc1TzOLWCK/123XUi8iQCqTIfTpYKZI94dFuE1GFYAF1EU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217563; c=relaxed/simple;
	bh=g+OpgI5Wc04TfRMtHYXsy4DyZVTC/rQ/O3u3NQhehjE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HeaM3wlYaSh3A1Gj96Y9rMhpe0PPd6eyJy7g4CxBtF7HmYcRt0AaFDnnL4Mg1vO8GmEjoKfoxkMl1RkaPzQvsjXtcrT5Rephhh6ud3SlDMeGdVt8gwjR2MWfW8LOyp4fKj36ATQWF8yGhYAr50w6o4XSH+74cIsEQ6fE/g1bSEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SD4T5FvC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SD4T5FvC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F545C4CEF7;
	Wed,  4 Feb 2026 15:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770217562;
	bh=g+OpgI5Wc04TfRMtHYXsy4DyZVTC/rQ/O3u3NQhehjE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SD4T5FvC/o06HmTRMjLMxN+itKp2Zg9vTBhjbDRhvbyuNyjhTQfpog0vD4jMvN4gP
	 rJDghwS/YR55QrYSJcJ5BfyF2Zq6+4KcIaL5hfv22msxMDmr4S7e8zSk4kJE4qJ9bH
	 OOfnu0DcviEvUizpH9aTasQKcVQ9xvggWpAKmpoI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 018/280] btrfs: factor out init_space_info() from create_space_info()
Date: Wed,  4 Feb 2026 15:36:32 +0100
Message-ID: <20260204143910.288032207@linuxfoundation.org>
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

From: Naohiro Aota <naohiro.aota@wdc.com>

[ Upstream commit ac5578fef380e68e539a2238ba63dd978a450ef2 ]

Factor out initialization of the space_info struct, which is used in a
later patch. There is no functional change.

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: a11224a016d6 ("btrfs: fix memory leaks in create_space_info() error paths")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/space-info.c | 27 ++++++++++++++++-----------
 1 file changed, 16 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/space-info.c b/fs/btrfs/space-info.c
index 069df2ebd1ca5..88cd37a13c0ee 100644
--- a/fs/btrfs/space-info.c
+++ b/fs/btrfs/space-info.c
@@ -219,19 +219,11 @@ void btrfs_update_space_info_chunk_size(struct btrfs_space_info *space_info,
 	WRITE_ONCE(space_info->chunk_size, chunk_size);
 }
 
-static int create_space_info(struct btrfs_fs_info *info, u64 flags)
+static void init_space_info(struct btrfs_fs_info *info,
+			    struct btrfs_space_info *space_info, u64 flags)
 {
-
-	struct btrfs_space_info *space_info;
-	int i;
-	int ret;
-
-	space_info = kzalloc(sizeof(*space_info), GFP_NOFS);
-	if (!space_info)
-		return -ENOMEM;
-
 	space_info->fs_info = info;
-	for (i = 0; i < BTRFS_NR_RAID_TYPES; i++)
+	for (int i = 0; i < BTRFS_NR_RAID_TYPES; i++)
 		INIT_LIST_HEAD(&space_info->block_groups[i]);
 	init_rwsem(&space_info->groups_sem);
 	spin_lock_init(&space_info->lock);
@@ -245,6 +237,19 @@ static int create_space_info(struct btrfs_fs_info *info, u64 flags)
 
 	if (btrfs_is_zoned(info))
 		space_info->bg_reclaim_threshold = BTRFS_DEFAULT_ZONED_RECLAIM_THRESH;
+}
+
+static int create_space_info(struct btrfs_fs_info *info, u64 flags)
+{
+
+	struct btrfs_space_info *space_info;
+	int ret;
+
+	space_info = kzalloc(sizeof(*space_info), GFP_NOFS);
+	if (!space_info)
+		return -ENOMEM;
+
+	init_space_info(info, space_info, flags);
 
 	ret = btrfs_sysfs_add_space_info_type(info, space_info);
 	if (ret)
-- 
2.51.0



