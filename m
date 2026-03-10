Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 703B0248F73;
	Tue, 10 Mar 2026 11:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141055; cv=none; b=bTEKA4MY6LPNUeRzfazN1TCQ22FJO/ozbxOy/t97mgQBPmfUEDkEjJCqFg/MogQQsLDSfg58PSdC+v6+DcDamElraLJxljWwEudHhp5xqn4Om49nIptVewW788PRMpcIsX4jbm3CFJOq/k03x6AnRZjssZ7aIwA2SpqEB6z9wMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141055; c=relaxed/simple;
	bh=HINZ7R48m4n4EyAUXOfZi8b8dpo/Z9OD4yPw0jw7GRc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HJi4or+seDAxGlvUkeKT4ohNY/1S/i5UD12abQKyu/jq8LOq33dSnGzuUk6DeC6paL4A1HI/TKHoe9PasbdQu+dg0wCLkmCPLslAqUVR/h+8Xomjdmcp+GVWCdCzlv1KQ2d+m1cy0t2erunJ/acWl304QdLHPxMscYohj1kQq4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qRhtINf+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qRhtINf+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7916C19423;
	Tue, 10 Mar 2026 11:10:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141055;
	bh=HINZ7R48m4n4EyAUXOfZi8b8dpo/Z9OD4yPw0jw7GRc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qRhtINf+la1uCShyBXFst2EMJDK/2RLCUkPOarfxc5ikAbBecwITl+55+hILLnLkT
	 tTFImSDyjcztVLrV8eTt8C6mk904i/z5CiScrRfbuiHFdDhPR25ej/jTVD6T2mthdw
	 iLRMSOhbT3oQ5ipaAiKrREHsuxeD/IBQYA0GM6cZ2FgKb/WhD0SFan3f99nVpUhTIo
	 UINu4cgE0ipFrwemLgBp/QWdm/Zb4QI+xLSgjoylskr2BmxpYioSEFhPFKY3sSQQNL
	 xWPGTNkR8+vuNl4pnitDfYIFmj+BJo4sU1P1UWhmMEPe6tHdotXKvNuuDMGEWLTYOL
	 LCGNiJzAM7OXQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 054/311] zloop: advertise a volatile write cache
Date: Tue, 10 Mar 2026 07:01:41 -0400
Message-ID: <7b0ca419929be66886f9fea0b71b57c87b87a105.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
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
index 8e334f5025fc0..ae9bf2a85c21c 100644
--- a/drivers/block/zloop.c
+++ b/drivers/block/zloop.c
@@ -542,6 +542,21 @@ static void zloop_rw(struct zloop_cmd *cmd)
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
@@ -562,11 +577,7 @@ static void zloop_handle_cmd(struct zloop_cmd *cmd)
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
@@ -981,7 +992,8 @@ static int zloop_ctl_add(struct zloop_options *opts)
 	struct queue_limits lim = {
 		.max_hw_sectors		= SZ_1M >> SECTOR_SHIFT,
 		.chunk_sectors		= opts->zone_size,
-		.features		= BLK_FEAT_ZONED,
+		.features		= BLK_FEAT_ZONED | BLK_FEAT_WRITE_CACHE,
+
 	};
 	unsigned int nr_zones, i, j;
 	struct zloop_device *zlo;
-- 
2.51.0

