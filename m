Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30E033B47C9;
	Mon, 23 Mar 2026 16:28:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774283337; cv=none; b=NrGs45fcraMn3NdwPGvPmfvqZodJBtT/cMQL2Db1TJLlVirfIEYlbsYSbKkZJrIqVYH8VXeJiHdvYW9HdchX5uX9kRm5hohboeJ8EVsbHSFAzm8ZUjrkD0DC8bg6dYKdAQy7RKSnBoE8hj+3uEZWVvrISko6oMIU0chfKSZoTXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774283337; c=relaxed/simple;
	bh=iKtjEPY9L9IXoeE547y84K3kKyeWO3aapxTdGG7xx8U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h06ggh4tI4X7pTPJTcsq6BmuG4c7EAkZO+LTLVzn+qi0pYyiRVgi0X+qdYK72XzzXK+R/7RLXhYQGpOfJdNPDBLx+PLtphjwpRUMVXaNIfIcBhNO7F75o1oh6UB5t1u8J2axceZfEvApGte9X0fLpjd8WTmQeM8IOBY/PXwFkiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jmix2qZW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jmix2qZW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 509B6C4CEF7;
	Mon, 23 Mar 2026 16:28:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774283336;
	bh=iKtjEPY9L9IXoeE547y84K3kKyeWO3aapxTdGG7xx8U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jmix2qZWxRPkFn/wtO5INMkqL06jTae8neZDRZpzFVdV3wUJZcjKOpY80Vr+1/0hU
	 pyQZbGhCgq4qNVdiECv9OKNKbF6O/JWC6A67T6CSecgKaNAL5dFMzqDs9DjLkMNFAV
	 YmdmKkHH9hTtECwFkXw1fvjc/NgCmZhlaXUXm2w4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zqiang <qiang.zhang1211@gmail.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	"Neeraj Upadhyay (AMD)" <neeraj.upadhyay@kernel.org>,
	Jianqiang kang <jianqkang@sina.cn>
Subject: [PATCH 6.1 466/481] rcu/nocb: Fix possible invalid rdps->nocb_cb_kthread pointer access
Date: Mon, 23 Mar 2026 14:47:28 +0100
Message-ID: <20260323134536.570791934@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1112,7 +1112,6 @@ static long rcu_nocb_rdp_offload(void *a
 	struct rcu_segcblist *cblist = &rdp->cblist;
 	unsigned long flags;
 	int wake_gp;
-	struct rcu_data *rdp_gp = rdp->nocb_gp_rdp;
 
 	WARN_ON_ONCE(rdp->cpu != raw_smp_processor_id());
 	/*
@@ -1122,7 +1121,7 @@ static long rcu_nocb_rdp_offload(void *a
 	if (!rdp->nocb_gp_rdp)
 		return -EINVAL;
 
-	if (WARN_ON_ONCE(!rdp_gp->nocb_gp_kthread))
+	if (WARN_ON_ONCE(!rdp->nocb_gp_kthread))
 		return -EINVAL;
 
 	pr_info("Offloading %d\n", rdp->cpu);
@@ -1151,7 +1150,7 @@ static long rcu_nocb_rdp_offload(void *a
 	 */
 	wake_gp = rdp_offload_toggle(rdp, true, flags);
 	if (wake_gp)
-		wake_up_process(rdp_gp->nocb_gp_kthread);
+		wake_up_process(rdp->nocb_gp_kthread);
 	swait_event_exclusive(rdp->nocb_state_wq,
 			      rcu_segcblist_test_flags(cblist, SEGCBLIST_KTHREAD_CB) &&
 			      rcu_segcblist_test_flags(cblist, SEGCBLIST_KTHREAD_GP));


