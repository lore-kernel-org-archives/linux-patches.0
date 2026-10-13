Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52E423AFD03;
	Tue, 13 Oct 2026 11:55:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892555; cv=none; b=o8DrL+onAnrvL8pHTUx+PhXMG5YVp4VlWfZ24kulatDFm7EbfYXmSZKsWMv8oAFl3rZEOQ9TDLcJkB/AemB/XBIMyZ6M6bVGLeL8XtoREI5poYbd4a/aYNJnQUPIsqKCFwSKa7xQM9MnvwioEvmQuB5nCOYy93b7WPRRQseZttc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892555; c=relaxed/simple;
	bh=MDQgfv5qPWXlxlBFCt6/gX9T6DnuaJx17NCzFUd7hoE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ddc69MTpbdm118YJYxWefB4t9Y+xSzk9GNGsl+fhs0JX4Y8RJR9CJ7vlvJOkDaZybT7QCtbw/6mI9A4OJTO8QH50CfpqbV4vlgKT6uPJYWPhEg7LOcHmThTiXEv530NAFlFHeyl9mpBTIVgraDtlokCu/6Mw2Pq5VGJFWudyBrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lHwLAnVD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lHwLAnVD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE5AE1F000FF;
	Tue, 13 Oct 2026 11:55:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892554;
	bh=pag2B0p32D33UkG/lWX62mSqMHaqNAgY972/rey/350=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lHwLAnVDMJdts9LhYPo52m5APPPn+s+dOeaEl94SXDPlCulIbs7aT/OTWQbXKQyAe
	 GHTjf1B6Dv6k9pjJas+Gjy6vD8QwyEzu3C6xY25jlVVJdF08DYYeDHzoAOWdeYcp2I
	 NlmN4VrW3ar3DdCvccK6d3Ikz9UjIOmfwWNnQFWA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 210/281] zloop: zero out only the unread tail of short reads
Date: Tue, 13 Oct 2026 13:38:46 +0200
Message-ID: <20261013112900.259309498@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>

[ Upstream commit 58304e139cb3fa640da74bc02101f0926d0607e2 ]

zloop_complete_rq() handles a short read from a zone's backing file by
zero-filling every bio in the request. This is correct when the entire
request is beyond the written part of the zone. When a read request
straddles the boundary between written and unwritten data, read_iter()
returns a partial byte count and zloop then zeroes the whole request
even for the partially read area with valid data.

Such an unexpected zero data read was observed with fio test script
t/zbd/test-zbd-support and its test case 69, failing with "bad magic
header 0".

Avoid the unexpected zero data read by zeroing out only the unread tail
part. When read data size cmd->ret is smaller than the request size,
call the new helper function zloop_fill_zero_rq() that walks through
each bio_vec and fills zeros from the specified start offset.

Fixes: eb0570c7df23 ("block: new zoned loop block device driver")
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Link: https://patch.msgid.link/20260916065657.62724-1-shinichiro.kawasaki@opensource.wdc.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/zloop.c | 31 ++++++++++++++++++++++++-------
 1 file changed, 24 insertions(+), 7 deletions(-)

diff --git a/drivers/block/zloop.c b/drivers/block/zloop.c
index 1333fae05ac5d..a011f3e518a55 100644
--- a/drivers/block/zloop.c
+++ b/drivers/block/zloop.c
@@ -799,6 +799,27 @@ static void zloop_cmd_workfn(struct work_struct *work)
 	current->flags = orig_flags;
 }
 
+static void zloop_fill_zero_rq(struct request *rq, unsigned int zero_from)
+{
+	struct req_iterator iter;
+	struct bio_vec bv;
+	unsigned int pos = 0;
+	unsigned int end, off;
+
+	rq_for_each_segment(bv, rq, iter) {
+		end = pos + bv.bv_len;
+		if (end > zero_from) {
+			if (pos < zero_from)
+				off = zero_from - pos;
+			else
+				off = 0;
+			memzero_page(bv.bv_page, bv.bv_offset + off,
+				     bv.bv_len - off);
+		}
+		pos = end;
+	}
+}
+
 static void zloop_complete_rq(struct request *rq)
 {
 	struct zloop_cmd *cmd = blk_mq_rq_to_pdu(rq);
@@ -813,13 +834,9 @@ static void zloop_complete_rq(struct request *rq)
 			pr_err("Zone %u: failed read sector %llu, %llu sectors\n",
 			       zone_no, cmd->sector, cmd->nr_sectors);
 
-		if (cmd->ret >= 0 && cmd->ret != blk_rq_bytes(rq)) {
-			/* short read */
-			struct bio *bio;
-
-			__rq_for_each_bio(bio, rq)
-				zero_fill_bio(bio);
-		}
+		/* Short read. Zero out the unread tail beyond cmd->ret. */
+		if (cmd->ret >= 0 && cmd->ret != blk_rq_bytes(rq))
+			zloop_fill_zero_rq(rq, cmd->ret);
 		break;
 	case REQ_OP_WRITE:
 	case REQ_OP_ZONE_APPEND:
-- 
2.53.0



