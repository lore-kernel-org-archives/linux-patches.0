Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0D9E1C5799;
	Sat, 12 Sep 2026 18:59:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789239545; cv=none; b=rRN4TxkqJD+7evZ5EET4lgR0Ylaq0QPBpWvXqRgdz7Q79g0cl0oDukwCXu8jJ0PjB9tzI1ligN8rPCoVkrCkn5slLqYW+iPwDQFDwIebnub/0gF+/MdgqaWcgTy6GF3rDq2LnmYbN73WxxBgqPy6pLzyTEy2FpNlSZ/U2fs/GEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789239545; c=relaxed/simple;
	bh=6CwnJScJmH3ytq8ZVVbKYdAqqaCGRNvTof25FjCcFcg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CVLkbpFaGv4Pb6CbKYP/dMLKvid2PoJkv3ksp2qgJaMw86YP3RWDKopknRfUt5IkfEvS55mtKReBD3l5FXgh2kLyQGTLYDrmMZwwfBAlld76xS6te2hWSOIpgwkL2bE0aLONrGsXqD3+lV6BMTBaAeekxSqj3HUbi5WSyrl9+7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AgOJQXt1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AgOJQXt1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BC711F000FF;
	Sat, 12 Sep 2026 18:59:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789239544;
	bh=JUkmpKZ+96JKnUt3UaR/VSB7Mr3vcaoE0rAzOkXJbtc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AgOJQXt1w3F7WLYZc7kIteyNq1N0dbfo2slpzh7d4TG5nM9Pee5l9EbcRaDB6PoZ7
	 nomtHQE2WIfRieacuMNpmTF0KruFkejolVZUaogePdl1tdWN9aXK5VWmbh5Q6VFtMU
	 Zegb9hdryxbwr0wbgB9so5yBIVWSPBizV/1KqZg4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tao Cui <cuitao@kylinos.cn>,
	Yu Kuai <yukuai@fygo.io>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 687/935] block/blk-iocost: collect per-cpu latency stats over possible CPUs
Date: Sat, 12 Sep 2026 09:01:57 +0200
Message-ID: <20260912065542.597637570@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tao Cui <cuitao@kylinos.cn>

[ Upstream commit 4e050c5b92c1600415b2cd452583e543036f3d73 ]

ioc_lat_stat() walks ioc->pcpu_stat with for_each_online_cpu() to
compute missed-ppm and rq_wait deltas.  An offlined CPU is skipped, so
its delta is dropped from the period and its last_* watermark is not
advanced; on re-online the next collection sees a delta spanning the
whole offline interval, corrupting the latency/vrate picture.

Fixes: 7caa47151ab2 ("blkcg: implement blk-iocost")
Signed-off-by: Tao Cui <cuitao@kylinos.cn>
Reviewed-by: Yu Kuai <yukuai@fygo.io>
Link: https://patch.msgid.link/20260720093726.28965-4-cui.tao@linux.dev
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-iocost.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index 08d397f063f36..cec885e805100 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -1592,7 +1592,7 @@ static void ioc_lat_stat(struct ioc *ioc, u32 *missed_ppm_ar, u32 *rq_wait_pct_p
 	u64 rq_wait_ns = 0;
 	int cpu, rw;
 
-	for_each_online_cpu(cpu) {
+	for_each_possible_cpu(cpu) {
 		struct ioc_pcpu_stat *stat = per_cpu_ptr(ioc->pcpu_stat, cpu);
 		u64 this_rq_wait_ns;
 
-- 
2.53.0



