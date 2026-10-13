Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E5864FD289;
	Tue, 13 Oct 2026 12:20:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894011; cv=none; b=JPJJ8HAwoD2k5B/g1kcFOOStC1yQu2LS9l1QpbSDbROYOuU8lW2BzkpTDUrOzeT8ZiZScBHVi7Uy1CMI2c7CxR7XbgzEy3SLQZiM77i7FiunPowW08u7HCc8RbOuKlHd6wCaMs8FbkbDMqABu/oG2mR09kvpXyHkcS2/AHOBgAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894011; c=relaxed/simple;
	bh=H1hZFMXyO7rAS2L842OZvLH2NPcKyf9QkZ4Lfb/nUxw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PnKD/1/afbDsrk6LbbxApxd11DfknOHtYpuybpZ1nqv+oTK3igWer+J4GhV67n8wF+ptRaOHnE8/riK+qGxEsOPN9Sx9Gd9qOOaAlqPMfwE780rPYO+ALCNvUrvO2cX1MF2Rh4QzL5XOgo33Qj9mZFYOO8+VcRvPzHUFLCTLCIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=abpuIK4D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="abpuIK4D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A846F1F00893;
	Tue, 13 Oct 2026 12:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894010;
	bh=5s4IvZOl9qtg8qD9vPT3Yits4JhuYrhpiCUhaFXuGYE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=abpuIK4D88szTX32kDLIIwmkSf2uMtRmJomvwidodkG2cJ2743sMIglevNLwf6fE7
	 Li3tl6ygyaStQLqLlAU0I04NkGrHELMexmTdFMoT1bFXxANS5yIF89t4RcW0RxOQpT
	 qBMHMS1YXT+cadP71tFymKcQzRH7nywTBjVckOv4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Usama Arif <usama.arif@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 417/621] blk-iocost: clear delay state when freeing policy data
Date: Tue, 13 Oct 2026 13:36:52 +0200
Message-ID: <20261013112930.731445085@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

From: Usama Arif <usama.arif@linux.dev>

[ Upstream commit 97cb95d2148835ae86ff916b145aef332d40439d ]

iocg_kick_delay() turns sufficiently large debt into an explicit
block-cgroup delay with blkcg_set_delay(), setting blkg->use_delay to
-1 and incrementing blkcg->congestion_count.  Clearing it again depends
on iocg_kick_delay() running from the period timer, the waitq timer or
the issue path.

ioc_pd_free() removes the iocg from active_iocgs and cancels its waitq
timer, and no further bios can arrive, so once it has run nothing is
left which can reduce the debt and clear the delay.  The blkcg stays
marked congested for the rest of its life.

blk_cgroup_congested() then returns true for every task in that cgroup
and its descendants: page_cache_sync_ra() cuts readahead to a single
page, page_cache_async_ra() skips it altogether, and
__folio_throttle_swaprate() takes swap_avail_lock and schedules a
throttle on anonymous folio allocation.

Clear it explicitly, after the list removal and the synchronous
hrtimer_cancel() so that neither timer processing nor an I/O path can
re-arm it.  The free callback can also see policy data which was never
attached to a blkg, hence the pd->blkg check.

Fixes: 7caa47151ab2 ("blkcg: implement blk-iocost")
Signed-off-by: Usama Arif <usama.arif@linux.dev>
Acked-by: Tejun Heo <tj@kernel.org>
Link: https://patch.msgid.link/20260814165712.510132-3-usama.arif@linux.dev
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-iocost.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index e1901c98c4af5..d0b13580c6b62 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -3030,6 +3030,7 @@ static void iocg_release(struct rcu_head *rcu)
 static void ioc_pd_free(struct blkg_policy_data *pd)
 {
 	struct ioc_gq *iocg = pd_to_iocg(pd);
+	struct blkcg_gq *blkg = pd_to_blkg(pd);
 	struct ioc *ioc = iocg->ioc;
 	unsigned long flags;
 
@@ -3052,6 +3053,12 @@ static void ioc_pd_free(struct blkg_policy_data *pd)
 		hrtimer_cancel(&iocg->waitq_timer);
 	}
 
+	/* off ->active_iocgs and timer gone, so nothing can re-arm the delay */
+	iocg->delay = 0;
+	iocg->indelay_since = 0;
+	if (blkg)
+		blkcg_clear_delay(blkg);
+
 	call_rcu(&pd->rcu_head, iocg_release);
 }
 
-- 
2.53.0



