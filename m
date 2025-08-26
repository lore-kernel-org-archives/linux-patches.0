Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDD4F352066;
	Tue, 26 Aug 2025 14:13:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217627; cv=none; b=b9d9tIT2LtkzYEXct4LcvbvIFIn3H+fXvYYtrXVXdOW4ZIQRl8JWpX4OZVYMemfUEzNqNplm/VnvzM+39uAKU4sNM3O4Rqlb1wTx3mH1shrZIA2hRf2M0zreEX9L0VhathHRfuL8CoK/vo+OV/yA1Njp21CEE9AbUo06IgXLGk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217627; c=relaxed/simple;
	bh=6X+vhEe38Eql3131+bwFzfEVysXSZ/4bYJzHmaMdYmk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RlFOaR5N9t69HGgwsuj23KiC5Y1ZeMuY34PbeV2GXvYxcuoQYKYwkcTKcO0mZ0mc3yGb4XFbvq/NV190YnWnZRYY+EV1hM/vWfyRZ3MN7X+8bzqguzx9ytSOvJO0YF1cyFebO/MTLFEN1N4RAZXzT5lt1adPL/bExUTCjZEiyXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=abFh6j/9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="abFh6j/9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 494B4C4CEF1;
	Tue, 26 Aug 2025 14:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217627;
	bh=6X+vhEe38Eql3131+bwFzfEVysXSZ/4bYJzHmaMdYmk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=abFh6j/9wFwKP9uTJUxYf0sKOxe/NsArK+IDrMXc2u9+RHzKtMGNSH9678ltYU4Ac
	 nmRJAuzlyvur2jzu9H7K4G68Pc1MtsPxC44vLNIVMJiMDFc7VViLh5zyry+SQO0PO3
	 zCmKwbu/moyGO6OWL0MbQafxZd/Bj8G9A1+QfJqw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+478f2c1a6f0f447a46bb@syzkaller.appspotmail.com,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 215/523] udf: Verify partition map count
Date: Tue, 26 Aug 2025 13:07:05 +0200
Message-ID: <20250826110929.767113946@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 8dae5e73a00b..723184b1201f 100644
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



