Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAF3E1F1534;
	Sat, 12 Sep 2026 08:26:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201617; cv=none; b=VStjfWlvzShQtuc6PByrsSsljYJE8Dt5XTEEzFDsdDAshtEAGZuYyCBg53BdJwTxya5ZHvu4Oe4WjcWlj2XCScbAsenFDWxjVN4Zi8DnuAh/MGS4QnCmAKZS5rMvqLlaur6oeh6kD1LyEwzCiVeUZLw++QC7OhQE+aJhHV+yhHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201617; c=relaxed/simple;
	bh=Sjj4hHlfS/FUKxRQGcSQEJGRT8B3m6fafCsv0qrlxAU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TODqTJnFEdflgQ7UCbBo/7eOyzJ/svuMAOl9FSlMgIIvlBI9ilbEa7lZfNCxej+/DNVQC62CMjMJlsF7lhJvFucpLzmxji5+Y6v8+V7NM6Jd4TW2bM436gEf3gB/1Uj6m2t84Ac1pVoUNCodr1h1pMy1k9H4nc7lMPXGCt2QnEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ewRMWkj2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ewRMWkj2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE0691F000FF;
	Sat, 12 Sep 2026 08:26:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201615;
	bh=TPZWLqsJ5fEA9cb1CkFCTNeeu+w8dpfBjdN9SEuD1K4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ewRMWkj2B4hbsQs7p4eqXOu8gQdsjEjBebys3YB7LLOF0uzX1+f66UdKZizB/El9D
	 J0+jRI5BuqjNP3RZ20+3jn+LOBM05eZL0mlyycfXD+lwP1wq86lGTrzxj1lDClXyed
	 QsYuVNIkocWoib8tQyAXYlPuTRb/u7ct1oTkixrY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tao Cui <cuitao@kylinos.cn>,
	Yu Kuai <yukuai@fygo.io>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1032/1815] block/blk-iocost: collect per-cpu latency stats over possible CPUs
Date: Sat, 12 Sep 2026 08:46:22 +0200
Message-ID: <20260912065713.246704592@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 8b2aeba2e1e39..b60625613e095 100644
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



