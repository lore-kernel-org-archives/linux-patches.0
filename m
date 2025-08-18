Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 137A51E48A;
	Mon, 18 Aug 2025 13:48:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524932; cv=none; b=CovZwdTZLAJn3GCP1mNmRM7jdVe7/19JtK2ZJej9W926DSmTQXKKhTwSDWKvwTDzg4yqIq+fKCY/EeLVrh8PjtYFhaAd1VRUkCYe3Lr9sXk5IawhhbPGD4IPcAxtOkplBafo2EMKVdvf5eBuMQHO8ymuwybRQLFdVzotO5ioWd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524932; c=relaxed/simple;
	bh=9wLxvVKDFZ9EoYYIYdJoK+y1w4iBCWWGjfRjfs4o33M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=btyFTlkTwwc+4pudMxW+1P9xcVih/4xM/6Y3nPeaPIBUulNS/aA2ZWcMAyAXVs5q0aPxmTqKIppQ2QjXmv1kMq6HW38Oij1rO7j9vtT7LgA+f2qhIMfLGtwh+pfP9eEvkHM7ZoVopgMVipGzjeBshXAn27wBDCXNMrZWI9q91r8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nii7ahWs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nii7ahWs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7989CC4CEF1;
	Mon, 18 Aug 2025 13:48:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524931;
	bh=9wLxvVKDFZ9EoYYIYdJoK+y1w4iBCWWGjfRjfs4o33M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nii7ahWsnAQpg2cFn+7dAdrhITD3HIDlR6EsyHT8luA0zTK5+MfSOxcj/EyY/XwtM
	 UWJuofgpYbEcrxqX4gq6KHUeUELqwaWWJKrBqPV8IpPRb6LDhFYN7IoUBZ5wuD+vHD
	 JOod7rMASj+GCpbpc1zyOehGjZoQlL190n2COChY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+478f2c1a6f0f447a46bb@syzkaller.appspotmail.com,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 108/570] udf: Verify partition map count
Date: Mon, 18 Aug 2025 14:41:35 +0200
Message-ID: <20250818124509.967312698@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index 1c8a736b3309..b2f168b0a0d1 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -1440,7 +1440,7 @@ static int udf_load_logicalvol(struct super_block *sb, sector_t block,
 	struct genericPartitionMap *gpm;
 	uint16_t ident;
 	struct buffer_head *bh;
-	unsigned int table_len;
+	unsigned int table_len, part_map_count;
 	int ret;
 
 	bh = udf_read_tagged(sb, block, block, &ident);
@@ -1461,7 +1461,16 @@ static int udf_load_logicalvol(struct super_block *sb, sector_t block,
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



