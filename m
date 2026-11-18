Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050741;
	b=zBRFNi//ygl4OVEJCjuRo+cnhvlERiiOnm7oGcyRyaYzdDospfNOOTkFZuKS6eYTOFrn
	 ji0UJbhNhXDyU0jz09tLVFVGCQF6f4+a6ieS05XcYcvlcfMj36iXKcESJL9Wx4JyFh99D
	 GleYjB/2+FCySD55USJXenx7+leoETD/vfVgl76GXdd78+KE4BnDl3pQTkxuDk2TDpr7B
	 oywWt++6GBmqoB5SBDIN3OToTBpuuDXFXA53+Q86i0Qzti+q0iA+Ux14fEhSDN+kvduJ7
	 pQxR7SdDIEMwjNg0at8LrIJofkNVC2wMh7KNKuiwysUg3cU9LEBR8PIYyUqH5TM20Tw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050741;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZaVSg9FGJb1IaP2cjGkVx05FMQArOl1+WMJLwPBM1Qo=;
	b=JJ8J0Ppnvieop4gllicxyqTAEzYyI2OECq2oKeJjFLCVSzKOr7E4F8CSRkwm2K1dcfe+
	 wwrowtUUTS86KplbXlLbd/pzc7f8sh2IkcQ2gSftDnfnGbbyZhx2x2p9EdETgrM4JzJmd
	 Iod0kpTky5Xqy7HgxqMlESIQFK597y3K0r+BcM0QTk1ew+h7trdzY826C3sRPYjcdGraA
	 nwheARwNwqRCtL3w/DqaOvPPJhaFIrP0qZ55z1hkVWXrGd/b2QO+7nQZIxNSJt1jjOQ+0
	 PgvVRug2wOvEfA4lzYkASRTUrwZch1vIwfo9LtucTDqRp0t5yu2KG7Pqk+l1s+rlA7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rqO0uHVB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAE4F606A33B;
	Thu, 19 Nov 2026 01:12:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rqO0uHVB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A8911F000C4;
	Thu, 19 Nov 2026 01:12:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050741;
	bh=ZaVSg9FGJb1IaP2cjGkVx05FMQArOl1+WMJLwPBM1Qo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rqO0uHVB8P7Pceq7gW5e7+ffwDhBHQO6VbJVeUDaTY/gdiOVLnU1Co17LSisAtdmS
	 nioU3cvJqDC8d/k+BJAmE8mVyvdwY9i541wNa210w377ZM1vgCrm9WxVlFKMYC2Keb
	 M9h5WwLq7UqkMjUzTGZIcTC2+2J3RPtSppoXx5TE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2799/2857] block: dont lose the status of a failed flush request
Date: Wed, 18 Nov 2026 16:03:53 +0100
Message-ID: <20261118150342.369593299@linuxfoundation.org>
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

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 67c43ceaa29e9b904216651697adf20445b219fc ]

flush_end_io() stores the status in fq->rq_status for whoever drops the
last reference to finish the flush sequence. blk_mq_put_rq_ref() calls
it with BLK_STS_OK from tag iterators and the timeout handler and
overwrites an error the real completion stored. With two extra
references, reading /sys/block/<disk>/inflight is enough for that, a
failed flush completes everything waiting on it with success and fsync()
lies to the application.

Only store a status that is an error.

Fixes: 2e315dc07df0 ("blk-mq: grab rq->refcount before calling ->fn in blk_mq_tagset_busy_iter")
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://patch.msgid.link/20261028164415.1262013-6-axboe@kernel.dk
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-flush.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/block/blk-flush.c b/block/blk-flush.c
index 53202eff545ef..0d09cd35888f4 100644
--- a/block/blk-flush.c
+++ b/block/blk-flush.c
@@ -230,7 +230,13 @@ static enum rq_end_io_ret flush_end_io(struct request *flush_rq,
 	spin_lock_irqsave(&fq->mq_flush_lock, flags);
 
 	if (!req_ref_put_and_test(flush_rq)) {
-		fq->rq_status = error;
+		/*
+		 * Remember the status of the flush for whoever drops the last
+		 * reference. blk_mq_put_rq_ref() gets here with BLK_STS_OK and
+		 * must not wipe it out.
+		 */
+		if (error != BLK_STS_OK)
+			fq->rq_status = error;
 		spin_unlock_irqrestore(&fq->mq_flush_lock, flags);
 		return RQ_END_IO_NONE;
 	}
-- 
2.53.0



