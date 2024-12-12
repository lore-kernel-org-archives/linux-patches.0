Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6AAA223C40;
	Thu, 12 Dec 2024 17:44:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025465; cv=none; b=Rzj6Iwf4aT32yJZ+3de8VLSLr54Ln1F/i+BjHP3T1j9mkOiMFZMlJIyFx4Sfikb3idJYYz2D39SsPvpbbS+tmT2P+8AUWUxzkcuJ5MsdW17b8EklQ3VKSchfK1dUqbd+iVYAtPuoe83DQwqzmRv9FXyh6LNBY513MfMPCCK+Dw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025465; c=relaxed/simple;
	bh=8B20a2LBhx+sQk7abeLFCu0SBGFmpaWf7u0tVuHhIeQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qc5tY+/nZ9BMhPPxIJRpo7FLRa1v7uHA6d8Mq7RmuSpbaXowDq8s2I3IArlnVPc5vNretnGSu5G/J66X8Ssgekxf9NQ7uRzxftJUa3T8QTWIjkLuUUAx4B+uR61LxXmo5MoCaEQVXWlc2qh624RlB5ZCGqQdw26QUy9yPUnG3iw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zx+/ukMh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zx+/ukMh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63219C4CECE;
	Thu, 12 Dec 2024 17:44:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025464;
	bh=8B20a2LBhx+sQk7abeLFCu0SBGFmpaWf7u0tVuHhIeQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zx+/ukMhnnlVRCewfvPNzv16VhwYsNCuBXxtp8BYjq65CmjXz5jKhbRqPOYLu36mh
	 az35/zwOdyFrURmGBtxXJpS8SDc4A6kTVzZaVtQig1bI6iZHKDm+iFWLnmkRrQ/5v8
	 AqRT+OQoNjvYP8PVAMkap/5CLZ640GMA4+e1NJOU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.4 147/321] ext4: fix FS_IOC_GETFSMAP handling
Date: Thu, 12 Dec 2024 16:01:05 +0100
Message-ID: <20241212144235.786758167@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Theodore Ts'o <tytso@mit.edu>

commit 4a622e4d477bb12ad5ed4abbc7ad1365de1fa347 upstream.

The original implementation ext4's FS_IOC_GETFSMAP handling only
worked when the range of queried blocks included at least one free
(unallocated) block range.  This is because how the metadata blocks
were emitted was as a side effect of ext4_mballoc_query_range()
calling ext4_getfsmap_datadev_helper(), and that function was only
called when a free block range was identified.  As a result, this
caused generic/365 to fail.

Fix this by creating a new function ext4_getfsmap_meta_helper() which
gets called so that blocks before the first free block range in a
block group can get properly reported.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/fsmap.c   |   54 +++++++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/ext4/mballoc.c |   18 ++++++++++++++----
 fs/ext4/mballoc.h |    1 +
 3 files changed, 68 insertions(+), 5 deletions(-)

--- a/fs/ext4/fsmap.c
+++ b/fs/ext4/fsmap.c
@@ -185,6 +185,56 @@ static inline ext4_fsblk_t ext4_fsmap_ne
 	return fmr->fmr_physical + fmr->fmr_length;
 }
 
+static int ext4_getfsmap_meta_helper(struct super_block *sb,
+				     ext4_group_t agno, ext4_grpblk_t start,
+				     ext4_grpblk_t len, void *priv)
+{
+	struct ext4_getfsmap_info *info = priv;
+	struct ext4_fsmap *p;
+	struct ext4_fsmap *tmp;
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
+	ext4_fsblk_t fsb, fs_start, fs_end;
+	int error;
+
+	fs_start = fsb = (EXT4_C2B(sbi, start) +
+			  ext4_group_first_block_no(sb, agno));
+	fs_end = fs_start + EXT4_C2B(sbi, len);
+
+	/* Return relevant extents from the meta_list */
+	list_for_each_entry_safe(p, tmp, &info->gfi_meta_list, fmr_list) {
+		if (p->fmr_physical < info->gfi_next_fsblk) {
+			list_del(&p->fmr_list);
+			kfree(p);
+			continue;
+		}
+		if (p->fmr_physical <= fs_start ||
+		    p->fmr_physical + p->fmr_length <= fs_end) {
+			/* Emit the retained free extent record if present */
+			if (info->gfi_lastfree.fmr_owner) {
+				error = ext4_getfsmap_helper(sb, info,
+							&info->gfi_lastfree);
+				if (error)
+					return error;
+				info->gfi_lastfree.fmr_owner = 0;
+			}
+			error = ext4_getfsmap_helper(sb, info, p);
+			if (error)
+				return error;
+			fsb = p->fmr_physical + p->fmr_length;
+			if (info->gfi_next_fsblk < fsb)
+				info->gfi_next_fsblk = fsb;
+			list_del(&p->fmr_list);
+			kfree(p);
+			continue;
+		}
+	}
+	if (info->gfi_next_fsblk < fsb)
+		info->gfi_next_fsblk = fsb;
+
+	return 0;
+}
+
+
 /* Transform a blockgroup's free record into a fsmap */
 static int ext4_getfsmap_datadev_helper(struct super_block *sb,
 					ext4_group_t agno, ext4_grpblk_t start,
@@ -539,6 +589,7 @@ static int ext4_getfsmap_datadev(struct
 		error = ext4_mballoc_query_range(sb, info->gfi_agno,
 				EXT4_B2C(sbi, info->gfi_low.fmr_physical),
 				EXT4_B2C(sbi, info->gfi_high.fmr_physical),
+				ext4_getfsmap_meta_helper,
 				ext4_getfsmap_datadev_helper, info);
 		if (error)
 			goto err;
@@ -560,7 +611,8 @@ static int ext4_getfsmap_datadev(struct
 
 	/* Report any gaps at the end of the bg */
 	info->gfi_last = true;
-	error = ext4_getfsmap_datadev_helper(sb, end_ag, last_cluster, 0, info);
+	error = ext4_getfsmap_datadev_helper(sb, end_ag, last_cluster + 1,
+					     0, info);
 	if (error)
 		goto err;
 
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -5432,13 +5432,14 @@ int
 ext4_mballoc_query_range(
 	struct super_block		*sb,
 	ext4_group_t			group,
-	ext4_grpblk_t			start,
+	ext4_grpblk_t			first,
 	ext4_grpblk_t			end,
+	ext4_mballoc_query_range_fn	meta_formatter,
 	ext4_mballoc_query_range_fn	formatter,
 	void				*priv)
 {
 	void				*bitmap;
-	ext4_grpblk_t			next;
+	ext4_grpblk_t			start, next;
 	struct ext4_buddy		e4b;
 	int				error;
 
@@ -5449,10 +5450,19 @@ ext4_mballoc_query_range(
 
 	ext4_lock_group(sb, group);
 
-	start = max(e4b.bd_info->bb_first_free, start);
+	start = max(e4b.bd_info->bb_first_free, first);
 	if (end >= EXT4_CLUSTERS_PER_GROUP(sb))
 		end = EXT4_CLUSTERS_PER_GROUP(sb) - 1;
-
+	if (meta_formatter && start != first) {
+		if (start > end)
+			start = end;
+		ext4_unlock_group(sb, group);
+		error = meta_formatter(sb, group, first, start - first,
+				       priv);
+		if (error)
+			goto out_unload;
+		ext4_lock_group(sb, group);
+	}
 	while (start <= end) {
 		start = mb_find_next_zero_bit(bitmap, end + 1, start);
 		if (start > end)
--- a/fs/ext4/mballoc.h
+++ b/fs/ext4/mballoc.h
@@ -226,6 +226,7 @@ ext4_mballoc_query_range(
 	ext4_group_t			agno,
 	ext4_grpblk_t			start,
 	ext4_grpblk_t			end,
+	ext4_mballoc_query_range_fn	meta_formatter,
 	ext4_mballoc_query_range_fn	formatter,
 	void				*priv);
 


