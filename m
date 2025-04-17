Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95B1C2561DA;
	Thu, 17 Apr 2025 18:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914631; cv=none; b=QJwRE8Qu/o+6IhRzPem+hk79vYo4MZEQuP5iQ0B3h4ZoN+tkLRna5XoDljRiCR5GecrefnEue7IK/Sdy4Lbu3ha5fKNtqcpplR7jMkrBszQWx+OmThoI/CGBtVveiKnUCw6zfbXL6ivv/PSNSVjyN8atQCbxY1wt5JHaUDTdPTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914631; c=relaxed/simple;
	bh=n0+4Igx9QHHX2oP3MKx663ET0CnII0jlUsQhoLPdRbk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PsrMXfVU81fLVyQJ+DHSx4wYd4t5pGjiSYqlwW0IOGZnMUj1Qq+UrclfGNJog698uvY73CxQMXyaAelu4BJThYATBi6wVHDvr1qlbEKJtr4Io/crs3kfTt83bLL+SjWcoM5ujsMpNU7zU+/2nDJ/9CWFh48r8rtOog3MaZZNBpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PomymBRE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PomymBRE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FDDDC4CEE4;
	Thu, 17 Apr 2025 18:30:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914631;
	bh=n0+4Igx9QHHX2oP3MKx663ET0CnII0jlUsQhoLPdRbk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PomymBREaowOu+zvjmdZI96/BPjLWMaUuKWqCK92owjY1OE4AgIk6V7mfe+ptB4GX
	 jFxlzgyzPenyjOn01/qFmwBySqvqrjCPQiQCn+DyjlS6nNvDB2jj9muHzQ2iZNT8U4
	 +hObgFLO63UKBfqwZvjDDWAZlvgQyDiJ5QiSL4gE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@infradead.org>,
	Ming Lei <ming.lei@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.13 249/414] block: make sure ->nr_integrity_segments is cloned in blk_rq_prep_clone
Date: Thu, 17 Apr 2025 19:50:07 +0200
Message-ID: <20250417175121.436498042@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3310,6 +3310,7 @@ int blk_rq_prep_clone(struct request *rq
 		rq->special_vec = rq_src->special_vec;
 	}
 	rq->nr_phys_segments = rq_src->nr_phys_segments;
+	rq->nr_integrity_segments = rq_src->nr_integrity_segments;
 
 	if (rq->bio && blk_crypto_rq_bio_prep(rq, rq->bio, gfp_mask) < 0)
 		goto free_and_out;


