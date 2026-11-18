Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022255;
	b=daHqI0QMM/x6JInnsuiE1gvdGuTwujWMGquli4I72SVhERJK8uaIKx6twQCKkytDB9pV
	 PECxUVZiKw5RhTdAFbNMnCT4u1QFMWmVQEo/bAvqb7L3PQxf6p9mhMmGBzblC0AGgIRbP
	 EqqbDHxfoHpu0bnBSAQj12Gh6xQT8LgJe6bJl32Y/rttawNwlEXCRPPeDZFEoN2PXoOU3
	 XUqfXNrLV3P+/wYeLw1Vm10L4zhNBr7tYVpJBES/lbmsfo1JxVvs+c2Y0DovtO5y5X2jP
	 pgh4JpF1/rMIi/6H4Cbu6bf6LYPn56yhmTkssy4DCwiICxGHeInGYGJMZI22Oey7zHg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022255;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=E/g/5RBOR61c10eWQNi4fPfABb357o4s3Ft9iRhRPeA=;
	b=IsP7W6mHbLkd4IfETIwpZTA5HLVTBEDap6wK1rrSTNP70huCV7LwAJ2ig1lzFbdnY3Ni
	 MYO8P6cMFjpCpCxvj1evJQ+lO/ENDN8mKRIW2fkw01GNFPjtfYPYw+67P2XXjHli/mx3x
	 cQe5vw/oHCRmbtcTngmdCVyJt6niopRUQOtxlOZblpps527QJPKvNqdEcqBlTPhtQxU80
	 WD1dmR0KxLyK0uU/k/dqJUy8NES7sFKhzYzZmG8SMjVgcyiJvaYVvFckqoZCP2C+SFFF+
	 uLXCTnrhOW2ibKCO4P+KNB6mSTylSn6PRFlzUkOMoP5tK7SRn68tOMVut38uM9cvc1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k2AepKOj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8CB1606A325;
	Wed, 18 Nov 2026 17:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k2AepKOj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 236951F000C4;
	Wed, 18 Nov 2026 17:17:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022255;
	bh=E/g/5RBOR61c10eWQNi4fPfABb357o4s3Ft9iRhRPeA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k2AepKOjPTp/McncgnspKr+TIO23udsARzTI5LIiWCvxhlUOb/Ieq7sw6vtzMLaCt
	 rF9wR731L7wnBxGrFHa+eUpxjRi7uP6lDbZeYijEWopiqpf0/rx41i3OcpwbvHHQnI
	 ZuKrAh8t3E0OurVbDvUNVvaHnSZftDqH0FAssJkQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2580/2651] block: dont lose the status of a failed flush request
Date: Wed, 18 Nov 2026 16:03:40 +0100
Message-ID: <20261118150417.210858898@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 403a46c864117..38bd4ae5d9e71 100644
--- a/block/blk-flush.c
+++ b/block/blk-flush.c
@@ -212,7 +212,13 @@ static enum rq_end_io_ret flush_end_io(struct request *flush_rq,
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



