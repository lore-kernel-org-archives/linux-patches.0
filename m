Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F382C2BE7DD;
	Tue, 26 Aug 2025 11:35:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208124; cv=none; b=g1/p6F/kV6YQ2pV39oiWD5l/YtuX2Fr1hmxDOns8nwpTMnlCqyptnjJeun5dYKtZnf0Az9ixWAUiWJVXInZAYJnL/bxQVsJ6P6HKPImuYyaPGVBColvSiiBhyV3mo7Desn4hA2+okCQ1LXd+hBE7XVO5oZ5So7twvqz7PgzXut4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208124; c=relaxed/simple;
	bh=zNzY7Wk17aSN7GHlntvTxYSASBC7TDw0Zg7+Gpr5ETY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g/+djUoLCqIVA3OLaEeT8QswQuyj+V3edUOCz4ZwqdLNZQH+SOLs4cZdD8jh3dDkYynbLPbvlDNjtwN0tqVfgfsWueo1GGoABSvqYVHYaKAFxZYyJ1wFSjze/62hve9QAbkGU2l+WP415tUxYzxnwW2cR3dQXL+25CrbqRZLndA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WpPGBHCE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WpPGBHCE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 397C2C4CEF4;
	Tue, 26 Aug 2025 11:35:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208123;
	bh=zNzY7Wk17aSN7GHlntvTxYSASBC7TDw0Zg7+Gpr5ETY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WpPGBHCE9Dv+xABiFbhDITLobRBlDltdKoZptKs11AdFYAv/GL0vnvGy+hUs5qvDy
	 MQK9FojozkvOBmcoBZRPmKJGPD5c4eTHim/OKJAne8fTYjunmQ3W3BL9FfzQcIi0RM
	 4h2bp6S/d2BhVgiMbbAv7I0dPfiZ2kMjK56np8NU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nilay Shroff <nilay@linux.ibm.com>,
	Ming Lei <ming.lei@redhat.com>,
	Yu Kuai <yukuai3@huawei.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 445/457] block: skip q->rq_qos check in rq_qos_done_bio()
Date: Tue, 26 Aug 2025 13:12:09 +0200
Message-ID: <20250826110948.282015141@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nilay Shroff <nilay@linux.ibm.com>

[ Upstream commit 275332877e2fa9d6efa7402b1e897f6c6ee695bb ]

If a bio has BIO_QOS_THROTTLED or BIO_QOS_MERGED set,
it implicitly guarantees that q->rq_qos is present.
Avoid re-checking q->rq_qos in this case and call
__rq_qos_done_bio() directly as a minor optimization.

Suggested-by : Yu Kuai <yukuai1@huaweicloud.com>

Signed-off-by: Nilay Shroff <nilay@linux.ibm.com>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: Yu Kuai <yukuai3@huawei.com>
Link: https://lore.kernel.org/r/20250814082612.500845-2-nilay@linux.ibm.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 370ac285f23a ("block: avoid cpu_hotplug_lock depedency on freeze_lock")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-rq-qos.h | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/block/blk-rq-qos.h b/block/blk-rq-qos.h
index 39749f4066fb..28125fc49eff 100644
--- a/block/blk-rq-qos.h
+++ b/block/blk-rq-qos.h
@@ -142,8 +142,14 @@ static inline void rq_qos_done_bio(struct bio *bio)
 	    bio->bi_bdev && (bio_flagged(bio, BIO_QOS_THROTTLED) ||
 			     bio_flagged(bio, BIO_QOS_MERGED))) {
 		struct request_queue *q = bdev_get_queue(bio->bi_bdev);
-		if (q->rq_qos)
-			__rq_qos_done_bio(q->rq_qos, bio);
+
+		/*
+		 * If a bio has BIO_QOS_xxx set, it implicitly implies that
+		 * q->rq_qos is present. So, we skip re-checking q->rq_qos
+		 * here as an extra optimization and directly call
+		 * __rq_qos_done_bio().
+		 */
+		__rq_qos_done_bio(q->rq_qos, bio);
 	}
 }
 
-- 
2.50.1



