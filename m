Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5B4D22E3E6;
	Thu, 17 Apr 2025 18:07:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913231; cv=none; b=c8D/8ZtBNZvHEoMu651CtlmeYRIR+bPmVXe84wDw86ut9koH04r3IQyyisfR3x4oRVoRdAb15UXMVIPP00I5O6lYKN6yxdcNkh3K3pAn1X3zg28FOtXfV4a1u19jMPv2ccgyatpp0rWBq5qqVBa0IKzHoVAbBJC7ObLAccBWA2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913231; c=relaxed/simple;
	bh=dcRG8ytckGuETuoJKqWuysYlfWrc3lHsQbfYdbePmFA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lzxUEDQzxSqKp0jxoJaRo87nkwveQ+IE+GYLW+ne/TYI5+DDmzyKAvGXPW93LSBplKsSTQa6ZT2b3qgljpKsWw1GbkI01T9m/Oa5y0Ni0fwTzbJSObV6Z02a88oYfAheyFvnojBC3r4MfXlqPpsI/gWn06xZAiLux6tDVpMDgJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dr9wtbUL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dr9wtbUL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7DCFC4CEE4;
	Thu, 17 Apr 2025 18:07:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913231;
	bh=dcRG8ytckGuETuoJKqWuysYlfWrc3lHsQbfYdbePmFA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dr9wtbULBM1CNJE6oqyodaUR7yIO4mdeDKujGWoK5KhfFXJgX/TLkf4LJWnaroJ0G
	 VHqjIh7nvmuODur6TWSKIyRueZnaGkE6g4r9gR8neliKEW9WPMygN5K/mUcFwXQBma
	 O/0tldCp4p19rTFme0Wn5TsmwLgVZMPs1sMtBwnM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@infradead.org>,
	Ming Lei <ming.lei@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.14 271/449] block: make sure ->nr_integrity_segments is cloned in blk_rq_prep_clone
Date: Thu, 17 Apr 2025 19:49:19 +0200
Message-ID: <20250417175128.954275476@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Lei <ming.lei@redhat.com>

commit fc0e982b8a3a169b1c654d9a1aa45bf292943ef2 upstream.

Make sure ->nr_integrity_segments is cloned in blk_rq_prep_clone(),
otherwise requests cloned by device-mapper multipath will not have the
proper nr_integrity_segments values set, then BUG() is hit from
sg_alloc_table_chained().

Fixes: b0fd271d5fba ("block: add request clone interface (v2)")
Cc: stable@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20250310115453.2271109-1-ming.lei@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-mq.c |    1 +
 1 file changed, 1 insertion(+)

--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3314,6 +3314,7 @@ int blk_rq_prep_clone(struct request *rq
 		rq->special_vec = rq_src->special_vec;
 	}
 	rq->nr_phys_segments = rq_src->nr_phys_segments;
+	rq->nr_integrity_segments = rq_src->nr_integrity_segments;
 
 	if (rq->bio && blk_crypto_rq_bio_prep(rq, rq->bio, gfp_mask) < 0)
 		goto free_and_out;


