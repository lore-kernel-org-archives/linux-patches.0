Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061802;
	b=n+KC6Qtls/I0DNQ9ktarTanZLfYjxwdG9Sfxxcqy3uLHL2/z86P3aee8ktT78PUAPacX
	 Ayy6M8HqCQspSqyG5p5m991qps1Jj9//SUUGeA6HrMEZO/wybTNTyfcwvCIIUmOVBkeS3
	 p81Q9L2ELElv+g539ttwrD70Blu1XBYebyfowq9omHTohcBoWOinTcDxd2+M1U+1wdCwo
	 VCg+hc1BiKo9e6jpY4MLzpjOOZQHpXcEO1n//p4+0TVnIGo/iqsk+udYpULRx5oR+UkAD
	 lh8Unze3Q++GJzZTGGL2qAEFEjHiS6WUa4zUt5s08T3++n/rlpw3H070hETIFZIHPVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061802;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=T5Bx3FJ5chww1U795wS2ynxkVNsg7IeaLzIyql78Euo=;
	b=NW8Bgv4RJC/f2Aj3h1NgO3w4FExWCUNpATYEz0BLu/H5lFm3oKqvQdqngEaOpylXAgB/
	 JYNVU1yuqRrrRNusNWMwGSjD4lwYM8/xh6gZvs0sqVz392Esx5Yg6WqM8LClTye7+MLWQ
	 ItV1nCtzrPp7Ya1zfrih2WnIx+jmp7AzuqrB4/2EHindnzx5xzWmGF6iLU+7LxjGnRJd7
	 fcr2gJ52+HzX95vACPgEgDdf3EHY1S+kF3Js/aLhtynJXDNgYQWiPk/sx9UTpTreeFtq8
	 B5kx40hLTjeUlu0UKsK8cs/Bp5YS24NNHXTOWeuL5haclH16aCmdh5TkB3UAEfehmnQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Gb8w0kMb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9485A606A325;
	Thu, 19 Nov 2026 04:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Gb8w0kMb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA5C81F000C4;
	Thu, 19 Nov 2026 04:16:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061802;
	bh=T5Bx3FJ5chww1U795wS2ynxkVNsg7IeaLzIyql78Euo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Gb8w0kMbnPWMLQLN5NiTnmDoqjRFrHtYh0Wc0qSgH1MhHnpMaHOx7suUT3lRZx+GX
	 RK+ZznEsCPS3OQmzLSlxb9enpowPgJh2lG3A7fUjwYAni8w73KMUAh32rhNdL/Jeq2
	 4X4wfExHPnpDlR71Pvivw0qMA+URP2Ub2rd1oB3M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tao Cui <cuitao@kylinos.cn>,
	Tejun Heo <tj@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1681/1848] blk-iocost: charge zone appends as writes
Date: Wed, 18 Nov 2026 16:01:59 +0100
Message-ID: <20261118150030.154405191@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tao Cui <cuitao@kylinos.cn>

[ Upstream commit febdbf5682fa7e8f325b07a2c115e7632c4252bd ]

Zone append is a primary write operation for zoned devices; zoned xfs
and btrfs use it for data writes.  It is priced at zero, so the zone
append portion of zoned workloads runs outside the controller: a
1%-weight cgroup issued 16000 appends at zero cost on a zoned null_blk.

Treat REQ_OP_ZONE_APPEND the same as REQ_OP_WRITE so it goes through
the existing seq/rand classification and charging.

Fixes: 0512a75b98f8 ("block: Introduce REQ_OP_ZONE_APPEND")
Signed-off-by: Tao Cui <cuitao@kylinos.cn>
Acked-by: Tejun Heo <tj@kernel.org>
Link: https://patch.msgid.link/20260922043856.2020116-3-cui.tao@linux.dev
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-iocost.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index e5f7f1edc3b6f..57cf12ed2e15d 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -2515,6 +2515,7 @@ static void calc_vtime_cost_builtin(struct bio *bio, struct ioc_gq *iocg,
 		coef_randio	= ioc->params.lcoefs[LCOEF_RRANDIO];
 		coef_page	= ioc->params.lcoefs[LCOEF_RPAGE];
 		break;
+	case REQ_OP_ZONE_APPEND:
 	case REQ_OP_WRITE:
 		coef_seqio	= ioc->params.lcoefs[LCOEF_WSEQIO];
 		coef_randio	= ioc->params.lcoefs[LCOEF_WRANDIO];
-- 
2.53.0



