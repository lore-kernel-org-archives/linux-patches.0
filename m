Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D9AD76032;
	Mon, 29 Jan 2024 17:17:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548623; cv=none; b=Lfl6x3XNduW21JU/Uucp541A2el32iQ7oagXM7Z5XCl8lLGdJDVS9jSa2DZzkd1C5Cbczj8XGrYjxnuIQ5N5ea6NwO9LcIYZFbwFxFVpcI3jqfUyvHbRAOINNIMUVTxiRXknz2RIAwe+k6li0Qw3nvCqhl1GoyuJQ/nMnD3AaNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548623; c=relaxed/simple;
	bh=/tPfLa85SPBY7QHU+Yn8Y/v4noKRj8prLE0mPQJV7fQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AWfBXWqeew5146MWTbEYv/P7QqAe/o+9SMh+6oO/nFDQZtfMwz2S3kI28tRx7Hf0KvHLfY9d5aR6dTR2ygO7RNkbYk/sRf12TeCKxZhL8t3d0dxu9R3h+k9l9+2NxEOFNlU8bKvlkq3/HL/7132Jd6s1Daxx5KAi2TMF4peEAXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zc6JmO7r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zc6JmO7r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2642C433F1;
	Mon, 29 Jan 2024 17:17:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548622;
	bh=/tPfLa85SPBY7QHU+Yn8Y/v4noKRj8prLE0mPQJV7fQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zc6JmO7rriUzwnXM0VcDS11pjqW/BB+rbpYHuW7qDDgToM2uwvjk9KeX8m3M0LS3x
	 zmCZfB9Ti13cw2wiB3X8aHCrrHu7s+qROUuJvZgC7FFdvCAe9fhQeSJ1n7lZ07Evb5
	 MQB0g5jTrWWFOmp93/dlp16Fm7kIMsHY3w7ocBzs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 292/331] btrfs: zoned: optimize hint byte for zoned allocator
Date: Mon, 29 Jan 2024 09:05:56 -0800
Message-ID: <20240129170023.405611817@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Naohiro Aota <naohiro.aota@wdc.com>

[ Upstream commit 02444f2ac26eae6385a65fcd66915084d15dffba ]

Writing sequentially to a huge file on btrfs on a SMR HDD revealed a
decline of the performance (220 MiB/s to 30 MiB/s after 500 minutes).

The performance goes down because of increased latency of the extent
allocation, which is induced by a traversing of a lot of full block groups.

So, this patch optimizes the ffe_ctl->hint_byte by choosing a block group
with sufficient size from the active block group list, which does not
contain full block groups.

After applying the patch, the performance is maintained well.

Fixes: 2eda57089ea3 ("btrfs: zoned: implement sequential extent allocation")
CC: stable@vger.kernel.org # 5.15+
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/extent-tree.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 69abb6eb81df..b89b558b1592 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4152,6 +4152,24 @@ static int prepare_allocation_zoned(struct btrfs_fs_info *fs_info,
 		if (fs_info->data_reloc_bg)
 			ffe_ctl->hint_byte = fs_info->data_reloc_bg;
 		spin_unlock(&fs_info->relocation_bg_lock);
+	} else if (ffe_ctl->flags & BTRFS_BLOCK_GROUP_DATA) {
+		struct btrfs_block_group *block_group;
+
+		spin_lock(&fs_info->zone_active_bgs_lock);
+		list_for_each_entry(block_group, &fs_info->zone_active_bgs, active_bg_list) {
+			/*
+			 * No lock is OK here because avail is monotinically
+			 * decreasing, and this is just a hint.
+			 */
+			u64 avail = block_group->zone_capacity - block_group->alloc_offset;
+
+			if (block_group_bits(block_group, ffe_ctl->flags) &&
+			    avail >= ffe_ctl->num_bytes) {
+				ffe_ctl->hint_byte = block_group->start;
+				break;
+			}
+		}
+		spin_unlock(&fs_info->zone_active_bgs_lock);
 	}
 
 	return 0;
-- 
2.43.0



