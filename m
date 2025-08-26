Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E1DF1F9F73;
	Tue, 26 Aug 2025 12:51:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756212707; cv=none; b=OShs/k5pk/XTGb0TfYxmF9PcOkBGceX0nVcwbjP+xuSqU9w4dB2DbFFKRHT3T2ry2jxjznG2C9eagzLop0aKGWb6qhCjkutOJPFCCuptayrCeUhYh1wgq1TVVF8K/uMA2FOYH1w1swFK6dmmaP6styOtJIDxk4NVRc1LQHqYc34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756212707; c=relaxed/simple;
	bh=m2Z8FQYI/AGx8yL9Mmkz5hq0qFLg1cJUDzFxnCCXB/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XNbvBIulAqx4KQ8HHQHFezVPE9cJ2t+2tLGl306XWBYtKreg25JTjFWeWc+pdJxL1s7XfHj14rri1MQrIGR9Ny26PIIxSzZirWGNbvzcnJ196J9m2jswvGy2hbo5nBTZRFFv0fVO82TuNk6bFu4GqAeCL3Pur9Ps7RDemF/MFbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k6ZOJOON; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k6ZOJOON"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79BB8C113CF;
	Tue, 26 Aug 2025 12:51:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756212706;
	bh=m2Z8FQYI/AGx8yL9Mmkz5hq0qFLg1cJUDzFxnCCXB/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k6ZOJOON+GKmVexmCsek7lyzgkUVWd0GB4SA4U7/M/IEGG+jFdNqDgJa/5g8qXX4n
	 y2Y41oACdkATXqnqnR8+LHrdOhOkqilM0VgiZGcnfdlemzj50PY+L3o6oR8wZEcSH+
	 K8j+Fl4+c8aNRhu30CzkUQhGxUts/+eSbKifI6fE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+478f2c1a6f0f447a46bb@syzkaller.appspotmail.com,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 072/587] udf: Verify partition map count
Date: Tue, 26 Aug 2025 13:03:41 +0200
Message-ID: <20250826110954.765884916@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 20dff9ed2471..cb13a07a4aa8 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -1409,7 +1409,7 @@ static int udf_load_logicalvol(struct super_block *sb, sector_t block,
 	struct genericPartitionMap *gpm;
 	uint16_t ident;
 	struct buffer_head *bh;
-	unsigned int table_len;
+	unsigned int table_len, part_map_count;
 	int ret;
 
 	bh = udf_read_tagged(sb, block, block, &ident);
@@ -1430,7 +1430,16 @@ static int udf_load_logicalvol(struct super_block *sb, sector_t block,
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



