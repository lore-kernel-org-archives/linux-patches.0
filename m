Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 387C030FF24;
	Tue,  2 Sep 2025 13:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819564; cv=none; b=EaEm3c/uEF0rVHIt9xz4Q5QajriHsLC6cVE83/dL2REXPwL5/0buWWDBR/hW4JciXUx0bw7kNf6jEZ/RUqpwVrADLAXhdFlyjos+7w91eTbBpxc9IVvO21Z2jWZMALSMgQi5IS2VpmAbWdHjKORv+jjC4+IDgJTrJwVHaJ/8cXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819564; c=relaxed/simple;
	bh=4gv+Z72U45JLwdqrehfR1w/yzJfWYNxVpASTf94cRNA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=po8SrKDwJSSKmupZPUxqvcdGRtl8hG6R/OKSlW1o251LWHsb6eK459qCrqEY3T6FZbsWc0hT9E7Lqdf22LYpKRk2kqhFIduSxfJovjDm2y/+96j54ExQttTJBEKv/6SICL/06TFxkwovsale2fjkaxPOXjv7Iufipw6cxQYRke8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K6bV60Rs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K6bV60Rs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D3DDC4CEED;
	Tue,  2 Sep 2025 13:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756819564;
	bh=4gv+Z72U45JLwdqrehfR1w/yzJfWYNxVpASTf94cRNA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K6bV60RsCePhCsD4NHNgJX2lvNVBn+c7UwFSrL23MLg5iYDA7LRDJOPcqpJiqJh22
	 wfxqNa7baNVb4CJdhPVHGSC07DiCIP18NcIi5Jzg8hM7n5cbeEOoFrAZdwCbUnf16R
	 FB8AOfLtarlsiK0t3G4giISKh72/2n8JoN3E+d4M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
	Nilay Shroff <nilay@linux.ibm.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 072/142] block: validate QoS before calling __rq_qos_done_bio()
Date: Tue,  2 Sep 2025 15:19:34 +0200
Message-ID: <20250902131951.023505084@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131948.154194162@linuxfoundation.org>
References: <20250902131948.154194162@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nilay Shroff <nilay@linux.ibm.com>

[ Upstream commit e3ef9445cd9d90e43de0bd3cd55d437773dfd139 ]

If a bio has BIO_QOS_xxx set, it doesn't guarantee that q->rq_qos is
also present at-least for stacked block devices. For instance, in case
of NVMe when multipath is enabled, the bottom device may have QoS
enabled but top device doesn't. So always validate QoS is enabled and
q->rq_qos is present before calling __rq_qos_done_bio().

Fixes: 370ac285f23a ("block: avoid cpu_hotplug_lock depedency on freeze_lock")
Reported-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Closes: https://lore.kernel.org/all/3a07b752-06a4-4eee-b302-f4669feb859d@linux.ibm.com/
Signed-off-by: Nilay Shroff <nilay@linux.ibm.com>
Link: https://lore.kernel.org/r/20250826163128.1952394-1-nilay@linux.ibm.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-rq-qos.h | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/block/blk-rq-qos.h b/block/blk-rq-qos.h
index 1fe22000a3790..b538f2c0febc2 100644
--- a/block/blk-rq-qos.h
+++ b/block/blk-rq-qos.h
@@ -149,12 +149,15 @@ static inline void rq_qos_done_bio(struct bio *bio)
 	q = bdev_get_queue(bio->bi_bdev);
 
 	/*
-	 * If a bio has BIO_QOS_xxx set, it implicitly implies that
-	 * q->rq_qos is present. So, we skip re-checking q->rq_qos
-	 * here as an extra optimization and directly call
-	 * __rq_qos_done_bio().
+	 * A BIO may carry BIO_QOS_* flags even if the associated request_queue
+	 * does not have rq_qos enabled. This can happen with stacked block
+	 * devices — for example, NVMe multipath, where it's possible that the
+	 * bottom device has QoS enabled but the top device does not. Therefore,
+	 * always verify that q->rq_qos is present and QoS is enabled before
+	 * calling __rq_qos_done_bio().
 	 */
-	__rq_qos_done_bio(q->rq_qos, bio);
+	if (test_bit(QUEUE_FLAG_QOS_ENABLED, &q->queue_flags) && q->rq_qos)
+		__rq_qos_done_bio(q->rq_qos, bio);
 }
 
 static inline void rq_qos_throttle(struct request_queue *q, struct bio *bio)
-- 
2.50.1



