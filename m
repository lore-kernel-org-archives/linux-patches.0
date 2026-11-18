Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028227;
	b=l43YyU6GD5E5aPv4EbWauq8MPeTRvPQvXfehsuebq2AXdE0XwdHNIZX2pPUGE5SUnsgz
	 lzm+LT1a/YI+npENP2afdMfc/zJf/FaKDBg5+GlQPQCoF4dBfFNdB7y47mxI3Qnhc1iNK
	 iz2beABw5BsHFUC98g3fSmaiaJdaia5MQFEq0AW4PmAjdh8cgpaZ/UOTo6VNH2pK0fmsb
	 wytsgI7Tmbrth2cATe+9xAay1kLUaZnq6K9o+00DB3kMHz7bA7UmvEhEA6V3jc7mEHI6t
	 r7i3cE3lXpyc1vBBRgtmMkQ6GjRTZIX3NPtbDoiwsevgxJ8Qgk6HDMfs3TZJuAYcN2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028227;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zSOawWZYM39xn47DRo4aC2gsxVN1vh7dC3t1JB8yfNE=;
	b=UqBq0EpyrxcKdPILJNMlrVN2JThANSBJ6bh88xrDM2UTr9WvInlvQC/JD25P0hJdOzZR
	 BBlV1MPvy1hpyKVoQjfvDmisop9kDR+M1UrgB53VAPb9z6khvCTdZ6LcjifCpqwI5TPfq
	 cfigZ5IDhbSVbCkBw6j8n7d2XNdzPOP39qnotsiHawCIlmOo8WuyRVVR94MvwfvFHxhuf
	 tikzsNQ/5OD9xDpiwCxL8he44v54rgso9+LMf48AYbsh5KGM0De7H4XG2auRA8zRO8qNc
	 HfDLMSHixkcPa1tRXmnxASvylGsvuUIqm4z0ieiYcXwpPwghbJPRfheKIFHi+zrG/MQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zrBiA8VC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C1AB606A320;
	Wed, 18 Nov 2026 18:57:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zrBiA8VC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8056A1F000C4;
	Wed, 18 Nov 2026 18:57:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028227;
	bh=zSOawWZYM39xn47DRo4aC2gsxVN1vh7dC3t1JB8yfNE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zrBiA8VCeSJ0RBwboU8AL6+P6lWRSpLa6YaDp3vgCowZUPRifI6ksI/B8fTVGgUBb
	 5HqxlO4xjKQAFyA9LzFSKoTJyN5vOFPFzn6kbXwk0vd2L4xsjlx4JCEF2B57Rgfcqo
	 NZ2C+CdRqdsnhIJZRmDDxu/gkqplVmYZI3wg/jQM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 2070/2151] block: dont lose the status of a failed flush request
Date: Wed, 18 Nov 2026 16:03:25 +0100
Message-ID: <20261118150237.122968367@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 43d6152897a42..bffdf3fa9c1ca 100644
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



