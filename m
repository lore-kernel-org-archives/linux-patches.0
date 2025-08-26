Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4065E2FD1D5;
	Tue, 26 Aug 2025 13:16:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214216; cv=none; b=hne8JlafKTfVwTFa1alxlGrAbu6FmGd1AVEavwbe7GP+JmK1xVqZhmQ9Wt3jku7dvYUF5j/Slh5iyjK0TiNK3jdYmcgz5+KYidzrhHb8UiEOs8DkRbG9SNwpWL91Ut5zaOhkuJOcu0kzZ/Vchrh4j7+V/wwpFsOmHMl+wqOuFBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214216; c=relaxed/simple;
	bh=BLb2IWZl/yJ9CNTawHe4gwadTH7qlXPOF8dVKaGhb4E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NTW9Q2cXElfcAcfnTGbxIxDPX6AzNnfxW2GECcocMTi3XRI5nz3AWFGK27HkscoYU0REyoG1lSx8bfuPss9F7iB6t3c+Y0KH2RenrtdTcDbbDM6pMAH3buSLJKdpBh+YsXx4kYTrjYulZdzTuhzsJgRSdHaytabYXLlaB8cbM2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rFxJJnFc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rFxJJnFc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1E27C4CEF1;
	Tue, 26 Aug 2025 13:16:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214216;
	bh=BLb2IWZl/yJ9CNTawHe4gwadTH7qlXPOF8dVKaGhb4E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rFxJJnFcYgEWS3FP9syT9U6EpjlcvzNCrNK3HlW1szFcIUEet5QLz1XO0b4WPGQTE
	 s7P/hvywjxlxKBfmNB7oiTIDuaUQctr9YliVkKTeoqzjem0ssgEKaaIePcCiZrT0Ck
	 w92aa2tyWx/A43tRMWRFpAfhvsHCPn/7DFlPCkqQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+478f2c1a6f0f447a46bb@syzkaller.appspotmail.com,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 055/482] udf: Verify partition map count
Date: Tue, 26 Aug 2025 13:05:08 +0200
Message-ID: <20250826110932.182957431@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index fa790be4f19f..a186d2418b50 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -1410,7 +1410,7 @@ static int udf_load_logicalvol(struct super_block *sb, sector_t block,
 	struct genericPartitionMap *gpm;
 	uint16_t ident;
 	struct buffer_head *bh;
-	unsigned int table_len;
+	unsigned int table_len, part_map_count;
 	int ret;
 
 	bh = udf_read_tagged(sb, block, block, &ident);
@@ -1431,7 +1431,16 @@ static int udf_load_logicalvol(struct super_block *sb, sector_t block,
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



