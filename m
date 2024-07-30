Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D13671A76B2;
	Tue, 30 Jul 2024 17:21:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360105; cv=none; b=Y+PP86M/vFAyp99NMnkCVtQD4GmEXfCV2je/07Bmre4ErANeNQBTvRBoSpYWfQKKOAe0VagkigsyoUnznsMn88WFNhHATk+jWPbeZRi9SAbk+gn4biimFuP6MRJIsfKI/IXio+LYhpsAuwwFHsa2K3/6av7hQizWyAHujFeGQMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360105; c=relaxed/simple;
	bh=bpmOFINXbdc9rD1hA1iiZf/ApQV0AOFONhaqn7INBM8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S6sjRom1kBp97FjrxWbRYWbGFuPmJQHPXQqAdzzf1IWvSGlhklYj3tfjl2PrME9WAbQLg4wq5UQrxjaAv+sDDtpIsRvgxqE1iv2oukryC1N6L5ER/POCilhpzAr3kOIFyemsoZHGWpgvuV0egGu1InyPJckzDBIYzM5/1pk+nng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KUt5LfM1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KUt5LfM1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D7DAC32782;
	Tue, 30 Jul 2024 17:21:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360105;
	bh=bpmOFINXbdc9rD1hA1iiZf/ApQV0AOFONhaqn7INBM8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KUt5LfM1hPTLjybhbCrh+IhhZV5gtTT7GZ9r/F1UOdsxZKfNQ496HPoBNzoKlkrvD
	 Xxx07SanBIxz+FtA51zSOvz6cyF0/aNQIeRmW00ikhqowEOxWhTMCJ2hZqSWF4RGtD
	 ekJVcrEXXpnY/O3RWJcTlxFw2yr7fQM1kkQ7CQQQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yi Zhang <yi.zhang@redhat.com>,
	Christoph Hellwig <hch@infradead.org>,
	Ye Bin <yebin10@huawei.com>,
	Ming Lei <ming.lei@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.10 591/809] block: check bio alignment in blk_mq_submit_bio
Date: Tue, 30 Jul 2024 17:47:47 +0200
Message-ID: <20240730151748.172496192@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Lei <ming.lei@redhat.com>

commit 0676c434a99be42f3bacca4adfd27df65edbf903 upstream.

IO logical block size is one fundamental queue limit, and every IO has
to be aligned with logical block size because our bio split can't deal
with unaligned bio.

The check has to be done with queue usage counter grabbed because device
reconfiguration may change logical block size, and we can prevent the
reconfiguration from happening by holding queue usage counter.

logical_block_size stays in the 1st cache line of queue_limits, and this
cache line is always fetched in fast path via bio_may_exceed_limits(),
so IO perf won't be affected by this check.

Cc: Yi Zhang <yi.zhang@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Ye Bin <yebin10@huawei.com>
Cc: stable@vger.kernel.org
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20240620030631.3114026-1-ming.lei@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-mq.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2914,6 +2914,17 @@ static void blk_mq_use_cached_rq(struct
 	INIT_LIST_HEAD(&rq->queuelist);
 }
 
+static bool bio_unaligned(const struct bio *bio, struct request_queue *q)
+{
+	unsigned int bs_mask = queue_logical_block_size(q) - 1;
+
+	/* .bi_sector of any zero sized bio need to be initialized */
+	if ((bio->bi_iter.bi_size & bs_mask) ||
+	    ((bio->bi_iter.bi_sector << SECTOR_SHIFT) & bs_mask))
+		return true;
+	return false;
+}
+
 /**
  * blk_mq_submit_bio - Create and send a request to block device.
  * @bio: Bio pointer.
@@ -2966,6 +2977,15 @@ void blk_mq_submit_bio(struct bio *bio)
 			return;
 	}
 
+	/*
+	 * Device reconfiguration may change logical block size, so alignment
+	 * check has to be done with queue usage counter held
+	 */
+	if (unlikely(bio_unaligned(bio, q))) {
+		bio_io_error(bio);
+		goto queue_exit;
+	}
+
 	if (unlikely(bio_may_exceed_limits(bio, &q->limits))) {
 		bio = __bio_split_to_limits(bio, &q->limits, &nr_segs);
 		if (!bio)


