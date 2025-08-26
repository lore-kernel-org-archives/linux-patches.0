Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF704350D53;
	Tue, 26 Aug 2025 13:48:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216105; cv=none; b=pT5Lu3DzPVrfyGyz0Fe4kvHokvGaxnePVNnDOg+Kvx1zttL8XZxG27IkkFfSEUc62Vl0TihNCEhmFhDyF2VKRfNSKm4ngmSk54LnV2tVSvi8bkmtcJvtIh/QP0WzPV//ksFgGJjNIgxBmAF3gVrNC+vV42r5EHMCci/v3IPT5Lo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216105; c=relaxed/simple;
	bh=N4Xf91yeCVS5jnUa4HSf3G6z16csF3RYpzLUWRvH9OU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xxu24gvDcnlWRbzlk2+USjxRyYzNeiH0vcVYBIEk5msELpIiVrHx3UoE4vlXye3pvzF2yjYWKYoEjJttq08+Wih8U15kbQjspqkX+ln8MM6yGkqQSs28EniM6bSLVLyZDHX0FJGEUZaRTaBQtFwLvU2lDvgt89rMdV7bmnUapqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aLtRvMqy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aLtRvMqy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62668C4CEF1;
	Tue, 26 Aug 2025 13:48:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216105;
	bh=N4Xf91yeCVS5jnUa4HSf3G6z16csF3RYpzLUWRvH9OU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aLtRvMqy1RTFum3g0F3wlQbfxO6k3c4kqXwfB/uHbtbq3QrPZYujwNkn8wZn7zEMM
	 JZosfuc6ZNt+MNEPGVMMrti67ECOuUB/i6dPqDp3dAK8VyYQ4vYYaJhUe/uNaYkUBl
	 M4w4CbsmwEbq6BNFlg2XEeEqu5vU83opMPQ58Azg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+478f2c1a6f0f447a46bb@syzkaller.appspotmail.com,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 286/644] udf: Verify partition map count
Date: Tue, 26 Aug 2025 13:06:17 +0200
Message-ID: <20250826110953.469436461@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

[ Upstream commit 1a11201668e8635602577dcf06f2e96c591d8819 ]

Verify that number of partition maps isn't insanely high which can lead
to large allocation in udf_sb_alloc_partition_maps(). All partition maps
have to fit in the LVD which is in a single block.

Reported-by: syzbot+478f2c1a6f0f447a46bb@syzkaller.appspotmail.com
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/udf/super.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/fs/udf/super.c b/fs/udf/super.c
index 4275d2bc0c36..69e4f00ce791 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -1411,7 +1411,7 @@ static int udf_load_logicalvol(struct super_block *sb, sector_t block,
 	struct genericPartitionMap *gpm;
 	uint16_t ident;
 	struct buffer_head *bh;
-	unsigned int table_len;
+	unsigned int table_len, part_map_count;
 	int ret;
 
 	bh = udf_read_tagged(sb, block, block, &ident);
@@ -1432,7 +1432,16 @@ static int udf_load_logicalvol(struct super_block *sb, sector_t block,
 					   "logical volume");
 	if (ret)
 		goto out_bh;
-	ret = udf_sb_alloc_partition_maps(sb, le32_to_cpu(lvd->numPartitionMaps));
+
+	part_map_count = le32_to_cpu(lvd->numPartitionMaps);
+	if (part_map_count > table_len / sizeof(struct genericPartitionMap1)) {
+		udf_err(sb, "error loading logical volume descriptor: "
+			"Too many partition maps (%u > %u)\n", part_map_count,
+			table_len / (unsigned)sizeof(struct genericPartitionMap1));
+		ret = -EIO;
+		goto out_bh;
+	}
+	ret = udf_sb_alloc_partition_maps(sb, part_map_count);
 	if (ret)
 		goto out_bh;
 
-- 
2.39.5



