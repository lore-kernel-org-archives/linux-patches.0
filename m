Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D14DF152E19;
	Wed,  3 Apr 2024 17:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712166987; cv=none; b=WERANhO7i5J1NvLDQjPVNjXP1rvcl5YZeCx5dh27oRPF8tmuKzSCVli78RHD65geMAs9K2lmRB5UVUX2JK13v3c8CdgL7l/Nk3ZlLdYXlpNPxuBmt30dXfT4HOcqVX85HxfoPJFQSKFl++KBaUK451MtlptYioaHPelDJ4eWzbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712166987; c=relaxed/simple;
	bh=4+zCsyajXuIQElnq7N8EPGVBFQZg6DdTccglLnTlQog=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OVbHqyX0Y6rR/VT6wFJl9C44I2QTO+ljF/TTYq1cQ4xxXvivZaLeOB/Sh4qOcPKqJJytCgysHDNM/U5hPBFnexMhB8oNjPARgzK3yKmqKF7MIMF/lW8uwraULquxVqv9aPp90EL7VAmx76OZN9z2yeg1vNyFvrf/2kF3cD1sd1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O7IouaKS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O7IouaKS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD897C43390;
	Wed,  3 Apr 2024 17:56:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712166987;
	bh=4+zCsyajXuIQElnq7N8EPGVBFQZg6DdTccglLnTlQog=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O7IouaKSE8GAAKM7Yw+dcAF20aGZRB2qomHlwNvTxudgUC2rcTryiNax4dbh32vvQ
	 P+1FPGPl/GwVx2X3DgDJBou0tJDP7otDmNR+/wssL3CpR9ZmkyMdaNEPhnYGBc5m/A
	 B0EPBEsGZ6RejfiYM5e7huILE69ISg/+0idXoa40=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Leemhuis <regressions@leemhuis.info>,
	Tejun Heo <tj@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Audra Mitchell <audra@redhat.com>
Subject: [PATCH 6.8 08/11] Revert "workqueue: Replace pwq_activate_inactive_work() with [__]pwq_activate_work()"
Date: Wed,  3 Apr 2024 19:55:47 +0200
Message-ID: <20240403175126.045427976@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240403175125.754099419@linuxfoundation.org>
References: <20240403175125.754099419@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit f4505c2033ad25839f6fd9be6fc474b8306c44eb which is commit
4c6380305d21e36581b451f7337a36c93b64e050 upstream.

The workqueue patches backported to 6.8.y caused some reported
regressions, so revert them for now.

Reported-by: Thorsten Leemhuis <regressions@leemhuis.info>
Cc: Tejun Heo <tj@kernel.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Sasha Levin <sashal@kernel.org>
Cc: Audra Mitchell <audra@redhat.com>
Link: https://lore.kernel.org/all/ce4c2f67-c298-48a0-87a3-f933d646c73b@leemhuis.info/
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/workqueue.c |   31 ++++++-------------------------
 1 file changed, 6 insertions(+), 25 deletions(-)

--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1461,36 +1461,16 @@ static bool pwq_is_empty(struct pool_wor
 	return !pwq->nr_active && list_empty(&pwq->inactive_works);
 }
 
-static void __pwq_activate_work(struct pool_workqueue *pwq,
-				struct work_struct *work)
+static void pwq_activate_inactive_work(struct work_struct *work)
 {
+	struct pool_workqueue *pwq = get_work_pwq(work);
+
 	trace_workqueue_activate_work(work);
 	if (list_empty(&pwq->pool->worklist))
 		pwq->pool->watchdog_ts = jiffies;
 	move_linked_works(work, &pwq->pool->worklist, NULL);
 	__clear_bit(WORK_STRUCT_INACTIVE_BIT, work_data_bits(work));
-}
-
-/**
- * pwq_activate_work - Activate a work item if inactive
- * @pwq: pool_workqueue @work belongs to
- * @work: work item to activate
- *
- * Returns %true if activated. %false if already active.
- */
-static bool pwq_activate_work(struct pool_workqueue *pwq,
-			      struct work_struct *work)
-{
-	struct worker_pool *pool = pwq->pool;
-
-	lockdep_assert_held(&pool->lock);
-
-	if (!(*work_data_bits(work) & WORK_STRUCT_INACTIVE))
-		return false;
-
 	pwq->nr_active++;
-	__pwq_activate_work(pwq, work);
-	return true;
 }
 
 static void pwq_activate_first_inactive(struct pool_workqueue *pwq)
@@ -1498,7 +1478,7 @@ static void pwq_activate_first_inactive(
 	struct work_struct *work = list_first_entry(&pwq->inactive_works,
 						    struct work_struct, entry);
 
-	pwq_activate_work(pwq, work);
+	pwq_activate_inactive_work(work);
 }
 
 /**
@@ -1636,7 +1616,8 @@ static int try_to_grab_pending(struct wo
 		 * management later on and cause stall.  Make sure the work
 		 * item is activated before grabbing.
 		 */
-		pwq_activate_work(pwq, work);
+		if (*work_data_bits(work) & WORK_STRUCT_INACTIVE)
+			pwq_activate_inactive_work(work);
 
 		list_del_init(&work->entry);
 		pwq_dec_nr_in_flight(pwq, *work_data_bits(work));


