Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA78B3AC0EB;
	Mon, 23 Mar 2026 15:14:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278857; cv=none; b=BaFxdQyOXLfG7n7P6R6TYHsj0vjtkGPFE7ryjss5OyzyoSMytec0XimFXXCa7KDgVyiTQv0uZ94kk4L4um33HrW0RBsYeZg2H16xvaBNDAxmmybpIKBFNV+S1I9s6JCJ+CZ+aVHq3WmKRBRm4HuUSlVhAEkAmNjVWt7YH6u56P0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278857; c=relaxed/simple;
	bh=swgZ750nisCCA9k5TCjend08luBlZdmoXC3268bJbd4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fop4na5YA4D+jCEgDeh1pRY1h/KF2xeo1vJcqdJOYyhk0IzGsR+dpzGqin1FKhjyKR2EI7l5tPhmp+MeqN78joY4toISLnjuwBmCUa4yxq8Jyxll8OC1kMoAhGl5YKWG9Ke27ALk7kG0AcKJ3rX1z9YUdi0nUW73WpZ+VM3qWkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZQBybggh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZQBybggh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D6F3C2BC9E;
	Mon, 23 Mar 2026 15:14:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774278856;
	bh=swgZ750nisCCA9k5TCjend08luBlZdmoXC3268bJbd4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZQBybgghg4h3F5VV8PkTAxvtLSoOgvlE+bDRHbreaV9lWQZ5y/HTQ+8JJYguUQZz7
	 qvhbeniM3E5ShR/e0AzXIB9lBhCtntFx3KjE9b7/PQI7NPVlyTJiWrdJ+omfmRbArg
	 17uahOzbmnynI+F2WN0+Yr2QQxOTD3GDM+LclK18=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zqiang <qiang.zhang1211@gmail.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	"Neeraj Upadhyay (AMD)" <neeraj.upadhyay@kernel.org>,
	Jianqiang kang <jianqkang@sina.cn>
Subject: [PATCH 6.6 441/567] rcu/nocb: Fix possible invalid rdps->nocb_cb_kthread pointer access
Date: Mon, 23 Mar 2026 14:46:01 +0100
Message-ID: <20260323134544.865160413@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zqiang <qiang.zhang1211@gmail.com>

[ Upstream commit 1bba3900ca18bdae28d1b9fa10f16a8f8cb2ada1 ]

In the preparation stage of CPU online, if the corresponding
the rdp's->nocb_cb_kthread does not exist, will be created,
there is a situation where the rdp's rcuop kthreads creation fails,
and then de-offload this CPU's rdp, does not assign this CPU's
rdp->nocb_cb_kthread pointer, but this rdp's->nocb_gp_rdp and
rdp's->rdp_gp->nocb_gp_kthread is still valid.

This will cause the subsequent re-offload operation of this offline
CPU, which will pass the conditional check and the kthread_unpark()
will access invalid rdp's->nocb_cb_kthread pointer.

This commit therefore use rdp's->nocb_gp_kthread instead of
rdp_gp's->nocb_gp_kthread for safety check.

Signed-off-by: Zqiang <qiang.zhang1211@gmail.com>
Reviewed-by: Frederic Weisbecker <frederic@kernel.org>
Signed-off-by: Neeraj Upadhyay (AMD) <neeraj.upadhyay@kernel.org>
[ Minor conflict resolved. ]
Signed-off-by: Jianqiang kang <jianqkang@sina.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/rcu/tree_nocb.h |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/kernel/rcu/tree_nocb.h
+++ b/kernel/rcu/tree_nocb.h
@@ -1221,7 +1221,6 @@ static long rcu_nocb_rdp_offload(void *a
 	struct rcu_segcblist *cblist = &rdp->cblist;
 	unsigned long flags;
 	int wake_gp;
-	struct rcu_data *rdp_gp = rdp->nocb_gp_rdp;
 
 	WARN_ON_ONCE(rdp->cpu != raw_smp_processor_id());
 	/*
@@ -1231,7 +1230,7 @@ static long rcu_nocb_rdp_offload(void *a
 	if (!rdp->nocb_gp_rdp)
 		return -EINVAL;
 
-	if (WARN_ON_ONCE(!rdp_gp->nocb_gp_kthread))
+	if (WARN_ON_ONCE(!rdp->nocb_gp_kthread))
 		return -EINVAL;
 
 	pr_info("Offloading %d\n", rdp->cpu);
@@ -1260,7 +1259,7 @@ static long rcu_nocb_rdp_offload(void *a
 	 */
 	wake_gp = rdp_offload_toggle(rdp, true, flags);
 	if (wake_gp)
-		wake_up_process(rdp_gp->nocb_gp_kthread);
+		wake_up_process(rdp->nocb_gp_kthread);
 	swait_event_exclusive(rdp->nocb_state_wq,
 			      rcu_segcblist_test_flags(cblist, SEGCBLIST_KTHREAD_CB) &&
 			      rcu_segcblist_test_flags(cblist, SEGCBLIST_KTHREAD_GP));


