Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68F4D3803CD;
	Tue, 10 Mar 2026 11:25:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141914; cv=none; b=WYEejuLCyf9NMw4rLE9heNDsCn4VfNqUuA0Z8RAuQkJg34wKM9gxQDlerEjAKulDU1RWf1RtyXQ5AIzx49szaM4XehepHoHdB4q0ppeING1D6ys3aYDTLESu7hJqMF+g97D/NAXbBtfW4/6fVUG9m1NVD9lvFR8GSVsk02gzq68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141914; c=relaxed/simple;
	bh=QwZMJuJVca9euDyBXZw8CCfM11is7wWSMVn9lAYcYyw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iBG0d7tB87OcFJ17pn8mDH52z2B/JAdqCSNPF15bhf8zHXjZ0FPndtrAEG1kW7TnENqTfNDBTJZ6YR4bedPYsYaLyd/8KLbVJblv3qlnU+a1iUIc8QZ02pJR72Be9IBNsfNbQcLwAAHfjeoLbDz/U0PV9kX41sY5PjYkeBIVIp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fVVJTFwN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fVVJTFwN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DD82C2BCAF;
	Tue, 10 Mar 2026 11:25:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141914;
	bh=QwZMJuJVca9euDyBXZw8CCfM11is7wWSMVn9lAYcYyw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fVVJTFwNNFqIjM7OfJ2lDCTYMYtLrmwXzh0cRJ3O9s7MFWNd3z6NfWyHd8Y8n6LGk
	 goKTNzaOa/JFyGV7bFWTvK8Wvd45TtjhDSdzQ8F1kw4HVPI2Bx54jXTKEdrayN5qt+
	 d4INIwL0j34g0OTHTB1eaa9dMBiqhJ425aCDZmlz8weiEiDvCq/g5Ct00DLHdUS93U
	 sUdvljaL74/2PIenMpFGwH0whUlkJjvrQorgJPuR0uBNcP1hvQrj/pJOCBypFkZCcD
	 vLzKgDSPg53q9sXakUtMP2OYrPaPGgA70+synj5DaSxG/Izzne+rCRm4XKMm06pGF+
	 +lhF0Ann+vJsQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 037/314] zloop: advertise a volatile write cache
Date: Tue, 10 Mar 2026 07:14:56 -0400
Message-ID: <d7b0038db88da94fe3786ffaba0119db1c888e6f.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 6acf7860dcc79ed045cc9e6a79c8a8bb6959dba7 ]

Zloop is file system backed and thus needs to sync the underlying file
system to persist data.  Set BLK_FEAT_WRITE_CACHE so that the block
layer actually send flush commands, and fix the flush implementation
as sync_filesystem requires s_umount to be held and the code currently
misses that.

Fixes: eb0570c7df23 ("block: new zoned loop block device driver")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/zloop.c | 24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/drivers/block/zloop.c b/drivers/block/zloop.c
index 39a425db670c8..2419677524453 100644
--- a/drivers/block/zloop.c
+++ b/drivers/block/zloop.c
@@ -499,6 +499,21 @@ static void zloop_rw(struct zloop_cmd *cmd)
 	zloop_put_cmd(cmd);
 }
 
+/*
+ * Sync the entire FS containing the zone files instead of walking all files.
+ */
+static int zloop_flush(struct zloop_device *zlo)
+{
+	struct super_block *sb = file_inode(zlo->data_dir)->i_sb;
+	int ret;
+
+	down_read(&sb->s_umount);
+	ret = sync_filesystem(sb);
+	up_read(&sb->s_umount);
+
+	return ret;
+}
+
 static void zloop_handle_cmd(struct zloop_cmd *cmd)
 {
 	struct request *rq = blk_mq_rq_from_pdu(cmd);
@@ -515,11 +530,7 @@ static void zloop_handle_cmd(struct zloop_cmd *cmd)
 		zloop_rw(cmd);
 		return;
 	case REQ_OP_FLUSH:
-		/*
-		 * Sync the entire FS containing the zone files instead of
-		 * walking all files
-		 */
-		cmd->ret = sync_filesystem(file_inode(zlo->data_dir)->i_sb);
+		cmd->ret = zloop_flush(zlo);
 		break;
 	case REQ_OP_ZONE_RESET:
 		cmd->ret = zloop_reset_zone(zlo, rq_zone_no(rq));
@@ -892,7 +903,8 @@ static int zloop_ctl_add(struct zloop_options *opts)
 		.max_hw_sectors		= SZ_1M >> SECTOR_SHIFT,
 		.max_hw_zone_append_sectors = SZ_1M >> SECTOR_SHIFT,
 		.chunk_sectors		= opts->zone_size,
-		.features		= BLK_FEAT_ZONED,
+		.features		= BLK_FEAT_ZONED | BLK_FEAT_WRITE_CACHE,
+
 	};
 	unsigned int nr_zones, i, j;
 	struct zloop_device *zlo;
-- 
2.51.0

