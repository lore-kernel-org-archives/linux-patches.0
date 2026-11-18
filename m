Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042044;
	b=V1OUBSgZaPSr7rSfQj1/4qOmb/ewXQbFF0xiGzpQxy+gMr9clW01WuU5x8VS/5fFEzKz
	 HdbC0ms2P9Mb1EIzdFUkBcUCBgvGNV10HZ8++5/XdogKsTC+zeKuJkUw7PBqGLaLry91E
	 kj0CVnF51NzcSVzIzuLYGYyNA6zQW6lnkNZRvQ2Vear/15yB9kqcWwCJ8HzZEAFidkb4L
	 1TmazFWysUceKKuGV1HNc3LDlqev7wUnV5pq0UjOlIutpb+NFUZmSpVnl+A2NiZtjx1vK
	 mTBU83SEFQ1D0MINSB4tch1cm8aed1AcCQiRuOUEGOtZCRUsiJDRl5GH12fvr+IniPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042044;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UbKAc9PKquHVGGzTnL8c+spBODUA+NsrTbhfzZI+/kU=;
	b=MNMJp1P08EGAgdt/SyNyIWOzxR2EP57Tn1iIlfEwagF/y5bMG0TLiPc2gWgnycX65Yz0
	 FLkNqMuCe1emjxtrhhmAJyO+bNGqq2Da1GgWAWkV6OxAP5ckyKmDrMHOuz7SNlVISuypV
	 lT/IAXacjdRNhDy/nQvEMEo2BFjXihZ046ExDpuvW4btYa0IprjZw1Bnpq4IFLKNGujFB
	 fX4omS8ozlqJSeFc/pSl5xd9XGlheMKxbXOZDJW9QGB6kMLvtku4R4FqJd04mgXE7HJJY
	 ucM1fGH0FOKRDSTOoCJqavIDZ9Q+earX3PK6aoBlezQJOu2vHcdH8zcqxzaTbwN5bSw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DCsFfDy3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D90D606A31C;
	Wed, 18 Nov 2026 22:47:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DCsFfDy3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAD231F000C4;
	Wed, 18 Nov 2026 22:47:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042044;
	bh=UbKAc9PKquHVGGzTnL8c+spBODUA+NsrTbhfzZI+/kU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DCsFfDy3MM/ZIQy9FqNsD27FlnWTS+/pH2B1kaaXzFtCVUyMx3slAvRNt94sW0+CH
	 4M7MrtSZu8JZp/90ehYZ0p9OhpJkPG10clwuodY7pnNH8Ylh7d/b/tHAYMAlPj5Sbe
	 GOPqAHdepD20ur2emYD4p/V0catGMb1W2UhDa/xc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tao Cui <cuitao@kylinos.cn>,
	Tejun Heo <tj@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2979/3318] blk-iocost: charge zone appends as writes
Date: Wed, 18 Nov 2026 16:00:01 +0100
Message-ID: <20261118150449.646153187@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 874618b6e1769..6e3082cb90dab 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -2548,6 +2548,7 @@ static void calc_vtime_cost_builtin(struct bio *bio, struct ioc_gq *iocg,
 		coef_randio	= ioc->params.lcoefs[LCOEF_RRANDIO];
 		coef_page	= ioc->params.lcoefs[LCOEF_RPAGE];
 		break;
+	case REQ_OP_ZONE_APPEND:
 	case REQ_OP_WRITE:
 		coef_seqio	= ioc->params.lcoefs[LCOEF_WSEQIO];
 		coef_randio	= ioc->params.lcoefs[LCOEF_WRANDIO];
-- 
2.53.0



