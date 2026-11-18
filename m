Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033163;
	b=zHzz9b/6q89SxuN9n1RIzNxdqJ4Qqm2DeIUX292/BxDhm9S3Rh9qNYdqrKiBZ3bmQPC/
	 rJ3r+FYDBa3UOXTYFvSpz7w7+9Ur9B76HygX4NDAGx5VxUnoE+YWyQMklcBxkLqhTvT/C
	 RfwsNEbPsM4gwihkf1iXcH9/5rp9KpEfQ6Oja8RnK1uCSZliZq5lKhzaszu0SqVaDZFQ2
	 TxBA5ff+GHl7b5lScrDoiy/zd2vNBfVJ0DfeVJ95kFk8tJIVDth0M31TNuxNsAv1XLZR5
	 b0dxdGd4nvr8HAo6yteZzdSl+UWW2f7mpXynq/MOe4jDysyXgMX1hXHKMD3VHKln+cg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033163;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FaqV6CP08LDqz5gQLbG4tD/KBC/o/kxbmYmbboj6wp4=;
	b=oPBUYTjLLf1VKD0vEnOa1mosKlps3QYjbbZ0ge/83Y1JN3WaHanijjQLYX8myflgdeyF
	 8GwCJdTS4+Tl9ViGVNqOxG69YPFIGGo4pFpJXlqp3q5SCVaG++korUlYNuFwF1++bVN43
	 J4BfPkebuGKdjcDv1gd371Rq4xiSBnhzHa9f87+CnI0IreZrosfJ45fGuqveZXEer2oj7
	 toAxb8PyrrMYWFtRKznwpCnbvrX0qTMMF/kvJDrDv/rV56OreyEAFotzpa1GpuMft0049
	 VNB+uGpj/uA1T2Fapn3SAY2pek+mD873nk+bI4FxykIH4NCK88AUZ08boYD6+DSoI7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zyaBYxzS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4721606A31C;
	Wed, 18 Nov 2026 20:19:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zyaBYxzS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F312B1F000C4;
	Wed, 18 Nov 2026 20:19:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033163;
	bh=FaqV6CP08LDqz5gQLbG4tD/KBC/o/kxbmYmbboj6wp4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zyaBYxzS4EuGVaWL1Dx/99iA4jnC25CdONP7gbeCBjgitDRBT7kIXOgaf68mjNbO5
	 DokdVWkvrntbQEMIkLIrbGtWvd2etglwadPS2HyB92UnqG3IPVQ49XAc6Vxak9JrNQ
	 ONOjLiz96qfVCiFDYUB09y3pmdcfCyE66nTmTEQA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1670/1756] block: dont lose the status of a failed flush request
Date: Wed, 18 Nov 2026 16:03:17 +0100
Message-ID: <20261118150116.179445475@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index a72e2a83d075f..86d064c0958fc 100644
--- a/block/blk-flush.c
+++ b/block/blk-flush.c
@@ -211,7 +211,13 @@ static enum rq_end_io_ret flush_end_io(struct request *flush_rq,
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



