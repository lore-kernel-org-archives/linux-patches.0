Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 822773A48E3;
	Sat, 17 Oct 2026 16:36:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254989; cv=none; b=axgFSO6dOBFEAvxxoWvOpFV+NuqZgjH8AMpebCjPo3ELSfjjN8NQ8DAyrvDSVNVsWY0J9oGQdlFsPYldpxls/0AmAz+3fG6c/vdHp+GcqZ2NDwf74gs2yi0PpDEezkcmUS4sSW6pRUmPN3W+YhCgmEBuGv+KeKQv2WWgMecCsgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254989; c=relaxed/simple;
	bh=f8DEyWbBu9X6GmKg6Y5n4oI3fMd1DNr/Q8S86C8RESM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=enRLUDnT+f5nIs1/Qkao6FZ//lpin+iJb6YGmZ2k50t35ztuLQYVJO+La859pTHcF4GpcGJasps4m7J1Gc8N5sUa+jHvYMiIy2E4t5c37Xb+oSK4YqpnwvcJPK/5m4pwczjnab3ucJMK12G3ZfLdD7JfiY5d/bu89VrjbJ32aGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OA0LhUA8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OA0LhUA8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D87251F000C4;
	Sat, 17 Oct 2026 16:36:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254988;
	bh=0gZedJC9tlq2fdRoqdY3lSM66eBvhEveGU7DgcLhC8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OA0LhUA8pWYUfGuwlcMhyfOKT9pHCDuiQQgQhXne4hliNbVri8W3wJYkQUnR0CjXo
	 aHcSNV+p0pkzxGM7eaPm0chelsFV36rBGulcOJIgr66nAgubNcQkDxpncJaNqoLJwm
	 k+w2XwRylToV/v7WBmUUwfJsD/M1OWZ+PEi0VyAs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Usama Arif <usama.arif@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 628/869] blk-iocost: clear delay state when freeing policy data
Date: Sat, 17 Oct 2026 17:57:49 +0200
Message-ID: <20261017160053.128327379@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index b48f9c63ca063..8b775dd95ba57 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -3032,6 +3032,7 @@ static void iocg_release(struct rcu_head *rcu)
 static void ioc_pd_free(struct blkg_policy_data *pd)
 {
 	struct ioc_gq *iocg = pd_to_iocg(pd);
+	struct blkcg_gq *blkg = pd_to_blkg(pd);
 	struct ioc *ioc = iocg->ioc;
 	unsigned long flags;
 
@@ -3054,6 +3055,12 @@ static void ioc_pd_free(struct blkg_policy_data *pd)
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



