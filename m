Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BAB92676E9;
	Tue, 26 Aug 2025 14:35:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218900; cv=none; b=B9WXOieoNg6G83XfVWxSfE4pw+q1DoeZgRWcRftrYF+yZW8EDQIFoJtZkHYf7dr1rBPKCp64UJlEC5zq5OWgmgwLypcuQHFpcpC8hrOA7KG51RBCUpGDagDiI/dN+3Ubt7HSdlsgjHpvHIqn+Xq1MlNBTD+pceqcvsMuM77WSt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218900; c=relaxed/simple;
	bh=BTucbJI08GIfRzoow0F7rGS8pRWyjhP3HbTMju1Gh4M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eNgICHiNPICMzf6K0PqF9dBrENw32AksSpBJimEv9Q/6Ps+UxkdZwJo0cAjAhZWC6s5dZSpSfXu0goh0r/rAOUP8B7wxYX+J/W6R4Y86YFvCK2iLAIZHCyoeTp6QxWw9sEoauZj3UElmuIaKctcrqrp9qgDo7htp5vlqOpRl7Oc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0Ej9/vSt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0Ej9/vSt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A71E4C4CEF1;
	Tue, 26 Aug 2025 14:34:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218900;
	bh=BTucbJI08GIfRzoow0F7rGS8pRWyjhP3HbTMju1Gh4M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0Ej9/vStcui+lXrl2g8JqtuDPPUV4snNqC3/roS1Di0+t865hf9xDrDao6YWPPiPx
	 waB3/76mmm0Z5DQ+48hO8Geqi8QXDD2Xs4dMKCeEGIKLJmuI5g51I4EGuuMYp1qA4i
	 j55vRBiIZEiVvix47b8XFCqLO9fxrroLWZYtbYVE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+478f2c1a6f0f447a46bb@syzkaller.appspotmail.com,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 176/403] udf: Verify partition map count
Date: Tue, 26 Aug 2025 13:08:22 +0200
Message-ID: <20250826110911.750216921@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 9f2de5e7c6e1..361bc8acfb0f 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -1417,7 +1417,7 @@ static int udf_load_logicalvol(struct super_block *sb, sector_t block,
 	struct genericPartitionMap *gpm;
 	uint16_t ident;
 	struct buffer_head *bh;
-	unsigned int table_len;
+	unsigned int table_len, part_map_count;
 	int ret;
 
 	bh = udf_read_tagged(sb, block, block, &ident);
@@ -1438,7 +1438,16 @@ static int udf_load_logicalvol(struct super_block *sb, sector_t block,
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



