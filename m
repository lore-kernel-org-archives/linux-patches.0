Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C222331208;
	Mon, 29 Dec 2025 16:19:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025147; cv=none; b=m4eqSo5yFKDOxXMD2NfIjtMmi11tD/G8PoQyndrytba0igxGZQOqHxA3fmxIMePEBbNOELiJYGzyx7Ctd4fBA1ysjkgMY8HaAucx6tmE5h+CaLTwHRVY6NnG6EVwqzFFOQw++S+YqNPKnTjZ9DGbxqabi5FuMnAU8/8CTd0OlFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025147; c=relaxed/simple;
	bh=/WcizgzHUlMZnHJJ41I0JdfsBf42GEdhsBad9gMgb60=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NoUdyIpcTmjHKT9XNDMIyImdcbqVw3zOrK3sVOF5YkuVLYoIn0gY3mS+12TsJD4Kl53BkH2gNAJ5OOk4rLL45C4oL76NevgxBO0ztEeTlDUd8TNxTAQgW3890LsXSupCDxrbEPOyZ847hMSte54Zy1jadAyRreJhO9CiAcmF7yg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EuifDfw8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EuifDfw8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53A54C4CEF7;
	Mon, 29 Dec 2025 16:19:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025146;
	bh=/WcizgzHUlMZnHJJ41I0JdfsBf42GEdhsBad9gMgb60=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EuifDfw8Q/+mrQF50huItmCUIJmieVRyJdUtbugvEqrljLlh02DADiQdcNoves+f5
	 2FNlIyCwxXuVVMpZ34iKkZpgYFB5d1c0aw+SLne6UYTFGFYHRIp4akgYfvt5BUEU6u
	 Su9s3uVSlXk5KL/Gnapdo3VvZ1xbqgPLoieBfUlU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nilay Shroff <nilay@linux.ibm.com>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 111/430] block: introduce alloc_sched_data and free_sched_data elevator methods
Date: Mon, 29 Dec 2025 17:08:33 +0100
Message-ID: <20251229160728.452529294@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nilay Shroff <nilay@linux.ibm.com>

[ Upstream commit 61019afdf6ac17c8e8f9c42665aa1fa82f04a3e2 ]

The recent lockdep splat [1] highlights a potential deadlock risk
involving ->elevator_lock and ->freeze_lock dependencies on -pcpu_alloc_
mutex. The trace shows that the issue occurs when the Kyber scheduler
allocates dynamic memory for its elevator data during initialization.

To address this, introduce two new elevator operation callbacks:
->alloc_sched_data and ->free_sched_data. The subsequent patch would
build upon these newly introduced methods to suppress lockdep splat[1].

[1] https://lore.kernel.org/all/CAGVVp+VNW4M-5DZMNoADp6o2VKFhi7KxWpTDkcnVyjO0=-D5+A@mail.gmail.com/

Signed-off-by: Nilay Shroff <nilay@linux.ibm.com>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 9869d3a6fed3 ("block: fix race between wbt_enable_default and IO submission")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq-sched.h | 24 ++++++++++++++++++++++++
 block/elevator.h     |  2 ++
 2 files changed, 26 insertions(+)

diff --git a/block/blk-mq-sched.h b/block/blk-mq-sched.h
index 1f8e58dd4b49..4e1b86e85a8a 100644
--- a/block/blk-mq-sched.h
+++ b/block/blk-mq-sched.h
@@ -38,6 +38,30 @@ void blk_mq_free_sched_res(struct elevator_resources *res,
 		struct blk_mq_tag_set *set);
 void blk_mq_free_sched_res_batch(struct xarray *et_table,
 		struct blk_mq_tag_set *set);
+/*
+ * blk_mq_alloc_sched_data() - Allocates scheduler specific data
+ * Returns:
+ *         - Pointer to allocated data on success
+ *         - NULL if no allocation needed
+ *         - ERR_PTR(-ENOMEM) in case of failure
+ */
+static inline void *blk_mq_alloc_sched_data(struct request_queue *q,
+		struct elevator_type *e)
+{
+	void *sched_data;
+
+	if (!e || !e->ops.alloc_sched_data)
+		return NULL;
+
+	sched_data = e->ops.alloc_sched_data(q);
+	return (sched_data) ?: ERR_PTR(-ENOMEM);
+}
+
+static inline void blk_mq_free_sched_data(struct elevator_type *e, void *data)
+{
+	if (e && e->ops.free_sched_data)
+		e->ops.free_sched_data(data);
+}
 
 static inline void blk_mq_sched_restart(struct blk_mq_hw_ctx *hctx)
 {
diff --git a/block/elevator.h b/block/elevator.h
index 621a63597249..e34043f6da26 100644
--- a/block/elevator.h
+++ b/block/elevator.h
@@ -58,6 +58,8 @@ struct elevator_mq_ops {
 	int (*init_hctx)(struct blk_mq_hw_ctx *, unsigned int);
 	void (*exit_hctx)(struct blk_mq_hw_ctx *, unsigned int);
 	void (*depth_updated)(struct request_queue *);
+	void *(*alloc_sched_data)(struct request_queue *);
+	void (*free_sched_data)(void *);
 
 	bool (*allow_merge)(struct request_queue *, struct request *, struct bio *);
 	bool (*bio_merge)(struct request_queue *, struct bio *, unsigned int);
-- 
2.51.0



