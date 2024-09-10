Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E85918C336;
	Tue, 10 Sep 2024 10:28:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964120; cv=none; b=cirQFp1c350Vl/MP9Z/Wb/AUOp5d7Jvl1fRXOzDeFcpcCZVQou7Yl9nvxGJSwyTES7JlAZEw+S1vLLb+uZTHahj48syN8faKVauZ3HxyITpXPOz4idmkrIYdasHW3zmjSIR/vw/uHCfi0BIgC4IbpnxJwWAwWwH0mroO2c6ncpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964120; c=relaxed/simple;
	bh=3KT11esrjMtMlfo/2XRK74pS4LjnUtMv3VDK7Ihx3Po=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RAvEcBGbtzN1vIVdGzt5ukj/fo1wgVH8WAFLfwlE1Avvdlz2bRH4fKP6pNf7DcoJ+PMSdkdbd9QfawhsrKZ6NqYs+vacCITLD+ERE27u+jYnVnDQlZFJiMOqxFHY5fDw7ndF+Q3N4cDnRh0qp8A5BMb8So8J0shM73CQ7kjVhRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1xl1kDof; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1xl1kDof"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03DC6C4CEC3;
	Tue, 10 Sep 2024 10:28:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964120;
	bh=3KT11esrjMtMlfo/2XRK74pS4LjnUtMv3VDK7Ihx3Po=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1xl1kDofOnNRM0TdjNJL/5Rs80hnRj71oTH5Ob/na2BG40VDGwbCkr3AtmviJ0f5v
	 PT/W7nhkEt3sUzDQhMGzDZ1laALwClB9IyMDI+eNeQeKMhccYwLoF+BHR9U5waErN+
	 RTpSXt+drDdOHNBYdh9MrPVVgqmYICUOmuWPtl3Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 075/269] udf: Avoid excessive partition lengths
Date: Tue, 10 Sep 2024 11:31:02 +0200
Message-ID: <20240910092610.876306741@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
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

From: Jan Kara <jack@suse.cz>

[ Upstream commit ebbe26fd54a9621994bc16b14f2ba8f84c089693 ]

Avoid mounting filesystems where the partition would overflow the
32-bits used for block number. Also refuse to mount filesystems where
the partition length is so large we cannot safely index bits in a
block bitmap.

Link: https://patch.msgid.link/20240620130403.14731-1-jack@suse.cz
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/udf/super.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/fs/udf/super.c b/fs/udf/super.c
index e0080fda2526..3c78535f406b 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -1080,12 +1080,19 @@ static int udf_fill_partdesc_info(struct super_block *sb,
 	struct udf_part_map *map;
 	struct udf_sb_info *sbi = UDF_SB(sb);
 	struct partitionHeaderDesc *phd;
+	u32 sum;
 	int err;
 
 	map = &sbi->s_partmaps[p_index];
 
 	map->s_partition_len = le32_to_cpu(p->partitionLength); /* blocks */
 	map->s_partition_root = le32_to_cpu(p->partitionStartingLocation);
+	if (check_add_overflow(map->s_partition_root, map->s_partition_len,
+			       &sum)) {
+		udf_err(sb, "Partition %d has invalid location %u + %u\n",
+			p_index, map->s_partition_root, map->s_partition_len);
+		return -EFSCORRUPTED;
+	}
 
 	if (p->accessType == cpu_to_le32(PD_ACCESS_TYPE_READ_ONLY))
 		map->s_partition_flags |= UDF_PART_FLAG_READ_ONLY;
@@ -1141,6 +1148,14 @@ static int udf_fill_partdesc_info(struct super_block *sb,
 		bitmap->s_extPosition = le32_to_cpu(
 				phd->unallocSpaceBitmap.extPosition);
 		map->s_partition_flags |= UDF_PART_FLAG_UNALLOC_BITMAP;
+		/* Check whether math over bitmap won't overflow. */
+		if (check_add_overflow(map->s_partition_len,
+				       sizeof(struct spaceBitmapDesc) << 3,
+				       &sum)) {
+			udf_err(sb, "Partition %d is too long (%u)\n", p_index,
+				map->s_partition_len);
+			return -EFSCORRUPTED;
+		}
 		udf_debug("unallocSpaceBitmap (part %d) @ %u\n",
 			  p_index, bitmap->s_extPosition);
 	}
-- 
2.43.0



