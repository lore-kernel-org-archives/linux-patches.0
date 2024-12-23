Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A9017E0FF;
	Mon, 23 Dec 2024 16:00:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734969644; cv=none; b=LgJ0Y9smRKXA9eIo/+Jbbq9wGH4K2XDf/2vq0a56l/g3W3TNqjQPOgSJGioBlwA7DP/TDaxMJSpDQ+PcE3GH3MSCdewJI5j444786AdxVQpfioOPFDyKQwDmZVPpKHpjtq7M0cA5dRcIgCaE5j7ZVT/L/VIvBhmF4t/2TBk1gR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734969644; c=relaxed/simple;
	bh=94KQ7euNj0yJyTiobq+U7bpQbFaTgfbdsZCL7JyuFVM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QUOIQXtuE4w6B4LtKDcZoaPn1x7Y3FfbrJTLU4VdBzjY4pK5vovyMRGRpdcEPoBhHl/Wwd+nBwJv6E8O/pC5/fTrzLtlMFfIt7OTtv8dUu+Tv9tht1UqfUTbJZDlS/L92qz2kpR+59QR37NeyHOxt2TqJNgW+W1G0xVrI9CCRZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zus7FdCE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zus7FdCE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 873B3C4CED4;
	Mon, 23 Dec 2024 16:00:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734969644;
	bh=94KQ7euNj0yJyTiobq+U7bpQbFaTgfbdsZCL7JyuFVM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zus7FdCE3O2YjZ9vuV5W/nG4gpWNkV7gmjCc780ag7Ykevd8ljbmvTBUzX16QGioB
	 h2dycV/rPpyk/huOCnYIDaqBwBbsoXptgh/Dhh9HKZLCzDGvwJ0qoXe56FxziNFX0P
	 GA3Qa2qtbcAnjJEUV4I3OZGdtxOyKhmoK+br2zR4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adam Li <adamli@os.amperecomputing.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 006/160] sched/fair: Fix NEXT_BUDDY
Date: Mon, 23 Dec 2024 16:56:57 +0100
Message-ID: <20241223155408.871892223@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155408.598780301@linuxfoundation.org>
References: <20241223155408.598780301@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: K Prateek Nayak <kprateek.nayak@amd.com>

[ Upstream commit 493afbd187c4c9cc1642792c0d9ba400c3d6d90d ]

Adam reports that enabling NEXT_BUDDY insta triggers a WARN in
pick_next_entity().

Moving clear_buddies() up before the delayed dequeue bits ensures
no ->next buddy becomes delayed. Further ensure no new ->next buddy
ever starts as delayed.

Fixes: 152e11f6df29 ("sched/fair: Implement delayed dequeue")
Reported-by: Adam Li <adamli@os.amperecomputing.com>
Signed-off-by: K Prateek Nayak <kprateek.nayak@amd.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Tested-by: Adam Li <adamli@os.amperecomputing.com>
Link: https://lkml.kernel.org/r/670a0d54-e398-4b1f-8a6e-90784e2fdf89@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 782ce70ebd1b..c467e389cd6f 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5484,6 +5484,7 @@ dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
 	bool sleep = flags & DEQUEUE_SLEEP;
 
 	update_curr(cfs_rq);
+	clear_buddies(cfs_rq, se);
 
 	if (flags & DEQUEUE_DELAYED) {
 		SCHED_WARN_ON(!se->sched_delayed);
@@ -5500,8 +5501,6 @@ dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
 
 		if (sched_feat(DELAY_DEQUEUE) && delay &&
 		    !entity_eligible(cfs_rq, se)) {
-			if (cfs_rq->next == se)
-				cfs_rq->next = NULL;
 			update_load_avg(cfs_rq, se, 0);
 			se->sched_delayed = 1;
 			return false;
@@ -5526,8 +5525,6 @@ dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
 
 	update_stats_dequeue_fair(cfs_rq, se, flags);
 
-	clear_buddies(cfs_rq, se);
-
 	update_entity_lag(cfs_rq, se);
 	if (sched_feat(PLACE_REL_DEADLINE) && !sleep) {
 		se->deadline -= se->vruntime;
@@ -8786,7 +8783,7 @@ static void check_preempt_wakeup_fair(struct rq *rq, struct task_struct *p, int
 	if (unlikely(throttled_hierarchy(cfs_rq_of(pse))))
 		return;
 
-	if (sched_feat(NEXT_BUDDY) && !(wake_flags & WF_FORK)) {
+	if (sched_feat(NEXT_BUDDY) && !(wake_flags & WF_FORK) && !pse->sched_delayed) {
 		set_next_buddy(pse);
 	}
 
-- 
2.39.5



