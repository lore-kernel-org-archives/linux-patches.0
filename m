Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AEA433C198;
	Sat, 12 Sep 2026 10:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209650; cv=none; b=EUkCPBvwxgNIS6lQhKhmaIiTRIj/hZmr5AyZSVBIkKE/Xka2s0HXsQ7NAnOQ2/csN6gK/3VyalmMtwBK8cvKTaeChcvTpe9SDJ4aDdlfCKJ0YLF3w4/+0rp/rIYK2mLDmRBeF4fyTjEhKQK9n1lbafOW4X/08f+fuZfjuZ/aBkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209650; c=relaxed/simple;
	bh=WF+OHcBsWiLy0vzaUDSdzK22+4BWAMk2qxSSKuivaQU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A059yuoIS4tYtEB8ankuH+lH7pO9poLatCgOlt0g2t2woh7Gtn7ok8Ba7fsReU2mTwZlti2NIz5smvZbq4WIYon8/FSpSkF+wJs3KiqQnLCVUQRVH4v4e4dv4emlrifKvlZd2B+CMpf8UKzhOzql5fuSxRqOI0LodMofA0dMIHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rjAE2n0O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rjAE2n0O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 878B81F000FF;
	Sat, 12 Sep 2026 10:40:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209648;
	bh=y2ykYq0e8WFfR89n37+jJ4uWhzsxS53v7xTS5+jTGc0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rjAE2n0Oy2pX+4P1E4Ncg0k+vPC94RAe4wQpzm2NQr3vzY6TQ9DuHE5QNxexIxCMl
	 iFHLGfLHq0OodkIsrTdAbXt17mjym7kzgzM/cOZKPXNDihUzPD11omaLOZ6XGXdIRH
	 kM+378DyLUpWMokmB2XgItjRzDHVpF85VHX/a3nY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tao Cui <cuitao@kylinos.cn>,
	Yu Kuai <yukuai@fygo.io>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0863/1518] block/blk-iocost: collect per-cpu latency stats over possible CPUs
Date: Sat, 12 Sep 2026 08:50:32 +0200
Message-ID: <20260912065642.971791123@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 5bfd70311359c..ecf4969125050 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -1603,7 +1603,7 @@ static void ioc_lat_stat(struct ioc *ioc, u32 *missed_ppm_ar, u32 *rq_wait_pct_p
 	u64 rq_wait_ns = 0;
 	int cpu, rw;
 
-	for_each_online_cpu(cpu) {
+	for_each_possible_cpu(cpu) {
 		struct ioc_pcpu_stat *stat = per_cpu_ptr(ioc->pcpu_stat, cpu);
 		u64 this_rq_wait_ns;
 
-- 
2.53.0



