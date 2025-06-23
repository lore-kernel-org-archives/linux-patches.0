Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 023892505A9;
	Mon, 23 Jun 2025 13:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684323; cv=none; b=llxRVppH7M7DNctSodcrrswugRVruAgDLZGUkqVtOzZ23NJPmobfiWP2PwKG2IIliSxFGCCkG7ziPiWgqm4Ghd5T8AHtOWcqcgq87bSGjXsV3Keu/m6SStPcMXQQGgP62wfJjKuSl6mnKcm1Sxf+ARRUtW2RJulYRjEvcCiudgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684323; c=relaxed/simple;
	bh=jr5yjePQPJy7wfXyvhpgnBF46K/3dITjbHiZ9RE0pZ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jXaDf/JEkFspEbJDhG1BPJkKxUhSj6d6N4SBFeI9F/zaZ4svUq1tM+Vj6+uYkB50uVFd8MJiJnanv0lS6zG8DlKMhdg3rMVFlkuIMd2YsEg06wJAMoo8VjoPSyz8sSBtLtQ5Eml0rUgHVS3wi52yAha6uSi2FegFlLcORZ/Xr2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GF1+WHdd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GF1+WHdd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CB12C4CEEA;
	Mon, 23 Jun 2025 13:12:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684322;
	bh=jr5yjePQPJy7wfXyvhpgnBF46K/3dITjbHiZ9RE0pZ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GF1+WHddYD9qrs0UdhkTrlEADpcRg6YZylMkSYdMrGv4avvtFP6KBWpB/ebdReh2e
	 wt3xk0lF12Y/33lmvb3X7XUdAXzMX0L7BFQJTlUkhtLqakntjShz/Kkxl8/26fX1iq
	 9LB/LPy42LoqqT7xAHsIGtGvc+d/681qSNpBOimI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Mike Galbraith <efault@gmx.de>
Subject: [PATCH 6.15 006/592] sched/fair: Adhere to place_entity() constraints
Date: Mon, 23 Jun 2025 14:59:24 +0200
Message-ID: <20250623130700.371632874@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Zijlstra <peterz@infradead.org>

commit c70fc32f44431bb30f9025ce753ba8be25acbba3 upstream.

Mike reports that commit 6d71a9c61604 ("sched/fair: Fix EEVDF entity
placement bug causing scheduling lag") relies on commit 4423af84b297
("sched/fair: optimize the PLACE_LAG when se->vlag is zero") to not
trip a WARN in place_entity().

What happens is that the lag of the very last entity is 0 per
definition -- the average of one element matches the value of that
element. Therefore place_entity() will match the condition skipping
the lag adjustment:

  if (sched_feat(PLACE_LAG) && cfs_rq->nr_queued && se->vlag) {

Without the 'se->vlag' condition -- it will attempt to adjust the zero
lag even though we're inserting into an empty tree.

Notably, we should have failed the 'cfs_rq->nr_queued' condition, but
don't because they didn't get updated.

Additionally, move update_load_add() after placement() as is
consistent with other place_entity() users -- this change is
non-functional, place_entity() does not use cfs_rq->load.

Fixes: 6d71a9c61604 ("sched/fair: Fix EEVDF entity placement bug causing scheduling lag")
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reported-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: "Peter Zijlstra (Intel)" <peterz@infradead.org>
Signed-off-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/c216eb4ef0e0e0029c600aefc69d56681cee5581.camel@gmx.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/fair.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3795,6 +3795,7 @@ static void reweight_entity(struct cfs_r
 		update_entity_lag(cfs_rq, se);
 		se->deadline -= se->vruntime;
 		se->rel_deadline = 1;
+		cfs_rq->nr_queued--;
 		if (!curr)
 			__dequeue_entity(cfs_rq, se);
 		update_load_sub(&cfs_rq->load, se->load.weight);
@@ -3821,10 +3822,11 @@ static void reweight_entity(struct cfs_r
 
 	enqueue_load_avg(cfs_rq, se);
 	if (se->on_rq) {
-		update_load_add(&cfs_rq->load, se->load.weight);
 		place_entity(cfs_rq, se, 0);
+		update_load_add(&cfs_rq->load, se->load.weight);
 		if (!curr)
 			__enqueue_entity(cfs_rq, se);
+		cfs_rq->nr_queued++;
 
 		/*
 		 * The entity's vruntime has been adjusted, so let's check


