Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A35F71891A5;
	Tue, 10 Sep 2024 09:46:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961564; cv=none; b=U10julYwc4/4krKcY/j/k/Q/60nakPYAEWaHusVbBtmZ0ofdpP5xepxzh0zTUuZ3mBgKZU5OqORaxo0/yIY4PnOCS0OYQYFwIgZQ2PP9RlPiZXvuxxiRxOiLOrlFKxRppc4f4bT9O8tIILt/Zy/8D2TjKQrLQA6fSDnPw84D3gM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961564; c=relaxed/simple;
	bh=oiJ7BG4iLBUcXvKDKWSo7U9MJerzDzTxe9u+z7Te0Dc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dhXa2QSFJsZAyvslMl26G6fb87jnR5zYPS206JmB0sBUTVo5Z1I/aSb1jXtrvXMEx/wJBiH4iCmJPwySnlGrp/AzuNpQfNoPAGa0Gr3CuHP2zXpIYg7wX1npQBv0It7/31agX8xbf+PeQiuIw5CcSc/oM0tqmU03ludHWlDk9DU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B1FYyGz0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B1FYyGz0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FFB8C4CEC3;
	Tue, 10 Sep 2024 09:46:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961564;
	bh=oiJ7BG4iLBUcXvKDKWSo7U9MJerzDzTxe9u+z7Te0Dc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B1FYyGz083LKubXut6uP1LZk97Kr7O07NzskMBC1leN65Y9JwnKBMX/43HXYlUQ2s
	 2WzXSuaF8iixxMeAr6Pr+Gu5Xq1hPt/Z7+H0xS2v0okzc7opVvL/nu+amCRpzPGlqC
	 /cHp/DiG02sMa52ntOIbi1RUO0NdBFSGCS9ANd3s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 113/375] udf: Avoid excessive partition lengths
Date: Tue, 10 Sep 2024 11:28:30 +0200
Message-ID: <20240910092626.206737856@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index 92d477053905..3460ecc826d1 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -1111,12 +1111,19 @@ static int udf_fill_partdesc_info(struct super_block *sb,
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
@@ -1172,6 +1179,14 @@ static int udf_fill_partdesc_info(struct super_block *sb,
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



