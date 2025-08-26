Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63A4D2C0F9C;
	Tue, 26 Aug 2025 14:25:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218302; cv=none; b=SPS254U29qtxfDQNJt8rBBQemX5W5/XRLYuaEH1Z7R3snvO2/5j7Huz5fHjSt+cri+OGRW7ufjxM1VVvWYkfhOLPFWv4lfpuQebCaDw3+OfaTbXxg+GDOjJXHOCgBWd042EY8nEt+G0b7eiY6oD1eXKZINjs/65y7tmNKHCA18U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218302; c=relaxed/simple;
	bh=appIQ4gHbCTcIikBIA5ku/11S+c6+XH7n97Uf0FmjLg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SlCR0U1ft4b0seVwLxqwYq7Iux5v77KHvmfXroXg8VtFU5DYYVjEZ4Lwk8PMKkZiDldw9SHpEPtzIKM63eSRBpkV2jywf+6myyMvulRR0Xoez4p0Yi/FZdqpqz0MAKxh0H/alYPqAyv80i3hgLqNL7Eemcfy4mW3yB9pJRu0skM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vyDIRlIb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vyDIRlIb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD734C4CEF1;
	Tue, 26 Aug 2025 14:25:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218302;
	bh=appIQ4gHbCTcIikBIA5ku/11S+c6+XH7n97Uf0FmjLg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vyDIRlIb9BbKDODNlixRFmFBdVlR+ruaTrzTWaV36O0pcmBzQmeMw0akU7Ds+hQnR
	 Lslm0bZRjqScnDPGG3PbSxuncjDUmX9Rkz6dcJiIeSUF2PxXiNWsLT+xkCsTheL0TS
	 JvtTCJnk+h4AkunLsKZBw39iPk99uF1j6Tw7qngY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	tj@kernel.org,
	Ming Lei <ming.lei@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Shivani Agarwal <shivani.agarwal@broadcom.com>
Subject: [PATCH 5.10 439/523] block: dont call rq_qos_ops->done_bio if the bio isnt tracked
Date: Tue, 26 Aug 2025 13:10:49 +0200
Message-ID: <20250826110935.282923717@linuxfoundation.org>
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

From: Ming Lei <ming.lei@redhat.com>

commit a647a524a46736786c95cdb553a070322ca096e3 upstream.

rq_qos framework is only applied on request based driver, so:

1) rq_qos_done_bio() needn't to be called for bio based driver

2) rq_qos_done_bio() needn't to be called for bio which isn't tracked,
such as bios ended from error handling code.

Especially in bio_endio():

1) request queue is referred via bio->bi_bdev->bd_disk->queue, which
may be gone since request queue refcount may not be held in above two
cases

2) q->rq_qos may be freed in blk_cleanup_queue() when calling into
__rq_qos_done_bio()

Fix the potential kernel panic by not calling rq_qos_ops->done_bio if
the bio isn't tracked. This way is safe because both ioc_rqos_done_bio()
and blkcg_iolatency_done_bio() are nop if the bio isn't tracked.

Reported-by: Yu Kuai <yukuai3@huawei.com>
Cc: tj@kernel.org
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Acked-by: Tejun Heo <tj@kernel.org>
Link: https://lore.kernel.org/r/20210924110704.1541818-1-ming.lei@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
[ Shivani: Modified to apply on 5.10.y ]
Signed-off-by: Shivani Agarwal <shivani.agarwal@broadcom.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/bio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/block/bio.c
+++ b/block/bio.c
@@ -1430,7 +1430,7 @@ again:
 	if (!bio_integrity_endio(bio))
 		return;
 
-	if (bio->bi_disk)
+	if (bio->bi_disk && bio_flagged(bio, BIO_TRACKED))
 		rq_qos_done_bio(bio->bi_disk->queue, bio);
 
 	/*


