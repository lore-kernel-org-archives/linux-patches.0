Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050803;
	b=RkBgKAxs4N8j7eh1FclxDJspB1Lxuk7FTg2r9do6yM72Pw1wOAJf2+90s80F1P1Ng8xg
	 hBLxJZbBVasTzX7S2hFymjIDXD+kgTEi4I4Dz/Y1HX8QZGyI3uESzLJBr69bWPH2Hkf3w
	 63NF/Hu3UnH7A7tKZntPCI0UtxbvSQr6gHBjbk8XGQo6w0wCSDkcc45JtVLSvUFc8kjZT
	 HAPejCn1K6WCkO6C3NAuAJIRf8wAC+2orE/WlcjKW0g34vqHnSERyOLAvr8aMgJZHSWjt
	 oGxoGZiMAlwKnMkMVfirOSqCLV5snnRWkHW49MxXt/5xGRqkMY24HbZ83k04LtIxzVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050803;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wyl+ov1+aVoGVuANptcMgeEZOq0BLZ6znHypt8i1POQ=;
	b=ShqKXgJJIu/+8PLRSR5kh0Bk08DUgD4PgPnF5iQlO2S3cR6ZSchtoGg1rvHIRQUrBzU0
	 KNHxntRGixzQsXjuOvkNOZBaKf3xGvJqtfkDUEOumYp95aza2NoZ3EasTgSUwJufPl0+u
	 P6cqmKuSrR7D2W+MbvKyol+l+Uygy4M6dv9GJUylhfHg95iFG9a4Fiav9Tj7JrLQCoIxo
	 dpuX5Dkl5KSVK9IBTu8pN9d2/HFFH6Tz/tlcSO8mIg9cUmYV+n8TYU19dbiIjtFiIP03L
	 g1CzWoVtS+fI5ZPK3pkwzf3222/G97HzaAXXQsBbX1P0JxRNLiZYD91a3z+VSAHnRxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="qFW/Urwp";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 312EB606A32C;
	Thu, 19 Nov 2026 01:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qFW/Urwp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EAD41F000C4;
	Thu, 19 Nov 2026 01:13:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050803;
	bh=wyl+ov1+aVoGVuANptcMgeEZOq0BLZ6znHypt8i1POQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qFW/UrwpsbknOLNsDsT+6s39TPs9+by1vKB9zXk8fY7TYLZB+6DlYx8yjyZL4k/PD
	 Hd31x20B9wDFxf3bfRVYRLBL3kOSPFNqgJn+2HE8WdwsnDBnEuiEMAbZ3b2U3fIguH
	 OkHmj2Y2r1WbjkzqZOWeZ5lpzdc5lkjECkAdIRC8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Hannes Reinecke <hare@suse.de>,
	Bart Van Assche <bvanassche@acm.org>,
	Christoph Hellwig <hch@lst.de>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	Dennis Maisenbacher <dennis.maisenbacher@wdc.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2801/2857] block: Allow using bio_attempt_back_merge() internally
Date: Wed, 18 Nov 2026 16:03:55 +0100
Message-ID: <20261118150342.444119824@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Damien Le Moal <dlemoal@kernel.org>

[ Upstream commit dd850ff3eee428b4e1276bd51263dd937643ba19 ]

Remove "static" from the definition of bio_attempt_back_merge() and
declare this function in block/blk.h to allow using it internally from
other block layer files. The definition of enum bio_merge_status is
also moved to block/blk.h.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Tested-by: Hans Holmberg <hans.holmberg@wdc.com>
Tested-by: Dennis Maisenbacher <dennis.maisenbacher@wdc.com>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Link: https://lore.kernel.org/r/20240408014128.205141-6-dlemoal@kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 9531230ee1fc ("blk-mq: don't bring back flags of a completed request")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-merge.c | 8 +-------
 block/blk.h       | 8 ++++++++
 2 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/block/blk-merge.c b/block/blk-merge.c
index b90c413c83c44..e72ddcc0e7d60 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -974,13 +974,7 @@ static void blk_account_io_merge_bio(struct request *req)
 	part_stat_unlock();
 }
 
-enum bio_merge_status {
-	BIO_MERGE_OK,
-	BIO_MERGE_NONE,
-	BIO_MERGE_FAILED,
-};
-
-static enum bio_merge_status bio_attempt_back_merge(struct request *req,
+enum bio_merge_status bio_attempt_back_merge(struct request *req,
 		struct bio *bio, unsigned int nr_segs)
 {
 	const blk_opf_t ff = bio_failfast(bio);
diff --git a/block/blk.h b/block/blk.h
index 75316eab02470..db6232c5be60f 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -251,6 +251,14 @@ unsigned long blk_rq_timeout(unsigned long timeout);
 void blk_add_timer(struct request *req);
 const char *blk_status_to_str(blk_status_t status);
 
+enum bio_merge_status {
+	BIO_MERGE_OK,
+	BIO_MERGE_NONE,
+	BIO_MERGE_FAILED,
+};
+
+enum bio_merge_status bio_attempt_back_merge(struct request *req,
+		struct bio *bio, unsigned int nr_segs);
 bool blk_attempt_plug_merge(struct request_queue *q, struct bio *bio,
 		unsigned int nr_segs);
 bool blk_bio_list_merge(struct request_queue *q, struct list_head *list,
-- 
2.53.0



