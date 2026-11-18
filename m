Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027146;
	b=FsZCL50zTfPeUihPzUCZdSc5J+yLY7NcfWG8QTiewoiLuN7IIhLEnhMEjB/iirK3zgTi
	 WhLHwway4eNjG81tR5Sjy9qEWilxIrqFLqqQt3mNdTHnOTmfyvOW62jAwtTPgOwapWrm1
	 wMvQ4CI1hr96v3Icbrojoz1wcUR/R+f5uZtk9+0zmWqZEgmAdbaqGaQmmgpOd/t/f32JJ
	 3zuTLWNz4DlT9F6tEsYOC5tM2oEioiUCH6gM9MaYk3B0dOE8Cvy4nyI6c3H+ih6G1LB5t
	 f2pdl56gPusulxbu+eEKBdoZvKyBmOJ5TLdaq1Sxk92lBiYNt/QbYba1cCFoWa67OKQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027146;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cK0Xt+2/l4Db6kbswesffzD/X58BqbeJ8PQGqbavWrM=;
	b=aIylLj8GGJCjZDDZCFAHQ2PWeeWD6bbYnw0BrXsv14T+3YzYTimF5YYR/mIiOk8CnHde
	 Ipq1Bvajt3iv76RcLqSOXzbE8qDgkvLik8+3K9WV74wLASdP/mZa9z0xAAAEMfhimqPq+
	 Un9MAwz3XuOuuT1C8ostnaxfGxP0yVjEJALAW9xgCanH0nBZuXCFXxEemuaYipXVIvwk0
	 /SOJjCEDbB4gKIZJWB9c0pazMEEVbFHb/MLk8E58p+wyIeG4jbCc6YVlD+qVNcJgRrBzg
	 heJiK+kqkwb8Hury+wszbDCYr4HL3frnYraChLUUFcszZh6mEsHWDw9mGlxB2v3WAjQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rOy2rrV1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E624606A332;
	Wed, 18 Nov 2026 18:39:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rOy2rrV1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 776881F000C4;
	Wed, 18 Nov 2026 18:39:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027146;
	bh=cK0Xt+2/l4Db6kbswesffzD/X58BqbeJ8PQGqbavWrM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rOy2rrV1QWtZSz63i8KFEiV/s3wTZxHkHiNgDBrS2AbzzqxgieC32XH1CjLQgYgtQ
	 3NXs1mDHg6KfTP4C+kPb3LJJsR1Kjc6MXg1HQkUaqGyWAeFhzAAXo/MBKixQDNh2tt
	 3PpNUNT4Vi4kVSEdyqw9cZYXfwA0zdw1/w+DK2fU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tao Cui <cuitao@kylinos.cn>,
	Tejun Heo <tj@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1684/2151] blk-iocost: charge zone appends as writes
Date: Wed, 18 Nov 2026 15:56:59 +0100
Message-ID: <20261118150223.174485115@linuxfoundation.org>
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
index 8c0214d48e3e6..7b7d6e8a60f5f 100644
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



