Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 843863C17;
	Fri, 31 Oct 2025 14:05:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761919514; cv=none; b=SngAh1joRtb93z1aHx3g3sZ0l4dl16KwbmDpMLUSerWLF/QwmskOvTEj2NNrdCEqHr+qC86s/GBnAhBC/Ma554bNGAfH6iUnSzHHNsz+mmh1r50pFInNWTTwHPuiK8lJSztrbiUT9UzHU08Qbj5j+WuMDOEs3BL/4ya8gA+z4es=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761919514; c=relaxed/simple;
	bh=J/aX8WcxlOKn8Kh+Db09sWRzF/8/JhILveOUOOeEfBg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XN7NjWUOX+eQ89PbQg1tVu8ldpiHIpctKHk1QWwrCCpUUMxVes0PP0DSHiPEOa8sWc0plm7EFCZCtS9Y3q+hwAtU24lVxn6A0obOrQHlRR4jXvXiFsAcj1yaFzo5m05WoNTQ7ShiHwA56KhKijLhb3YCP9G8X5GmRLv/BMhvvuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v6q2xi/u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v6q2xi/u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 107C4C4CEE7;
	Fri, 31 Oct 2025 14:05:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761919514;
	bh=J/aX8WcxlOKn8Kh+Db09sWRzF/8/JhILveOUOOeEfBg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v6q2xi/uKMc4ENCaiH3HPE+DEq2iyi1753p8Henm8DJ11erme897GtcO2snIzUK9b
	 ce4UspAoRCIsQK5k620J3zXpvbKvaKrwh9NXV2Rnk0I1myEyNwKw9MjSOaeJZb92hd
	 f4Htdl+JCDR1dDSy7AxZ5o+vjuhOM2Mx/5x1Ry/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 15/40] btrfs: zoned: refine extent allocator hint selection
Date: Fri, 31 Oct 2025 15:01:08 +0100
Message-ID: <20251031140044.385099309@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251031140043.939381518@linuxfoundation.org>
References: <20251031140043.939381518@linuxfoundation.org>
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

From: Naohiro Aota <naohiro.aota@wdc.com>

[ Upstream commit 0d703963d297964451783e1a0688ebdf74cd6151 ]

The hint block group selection in the extent allocator is wrong in the
first place, as it can select the dedicated data relocation block group for
the normal data allocation.

Since we separated the normal data space_info and the data relocation
space_info, we can easily identify a block group is for data relocation or
not. Do not choose it for the normal data allocation.

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/extent-tree.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index bb3602059906d..7bab2512468d5 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4299,7 +4299,8 @@ static int prepare_allocation_clustered(struct btrfs_fs_info *fs_info,
 }
 
 static int prepare_allocation_zoned(struct btrfs_fs_info *fs_info,
-				    struct find_free_extent_ctl *ffe_ctl)
+				    struct find_free_extent_ctl *ffe_ctl,
+				    struct btrfs_space_info *space_info)
 {
 	if (ffe_ctl->for_treelog) {
 		spin_lock(&fs_info->treelog_bg_lock);
@@ -4323,6 +4324,7 @@ static int prepare_allocation_zoned(struct btrfs_fs_info *fs_info,
 			u64 avail = block_group->zone_capacity - block_group->alloc_offset;
 
 			if (block_group_bits(block_group, ffe_ctl->flags) &&
+			    block_group->space_info == space_info &&
 			    avail >= ffe_ctl->num_bytes) {
 				ffe_ctl->hint_byte = block_group->start;
 				break;
@@ -4344,7 +4346,7 @@ static int prepare_allocation(struct btrfs_fs_info *fs_info,
 		return prepare_allocation_clustered(fs_info, ffe_ctl,
 						    space_info, ins);
 	case BTRFS_EXTENT_ALLOC_ZONED:
-		return prepare_allocation_zoned(fs_info, ffe_ctl);
+		return prepare_allocation_zoned(fs_info, ffe_ctl, space_info);
 	default:
 		BUG();
 	}
-- 
2.51.0



