Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EE671D0487;
	Wed,  2 Oct 2024 14:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879561; cv=none; b=U8sibBTYRPlMng6cmS5M07a91LIpAsJ5SxtAgN1i5qXuESJEWZg4cD9DBWU6aKmyPmMULLvu3BOw4YOCOOSDIgOOB9jkAOWQ3mwcf14ycOYDs4WgkIWjiL0oEp1sNk+ghGVqg+RsYKRH5JaEsT4nJUr036ri5eBzndgyYnqLV2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879561; c=relaxed/simple;
	bh=UnNGZL4dOuw/jLlKBmvoe1g3dxTw79DpGvR9I2gHV7k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=e2vOSPdlwI7pkLNjgfXjAK9c13NDHY9pI4Nzk/IuxVxsavMc4p7PmEd3+R/GBk7knNqKPzsyOTGHNoP9wOaxP2daEdADsKse5bhJ2egzAvem5Vl0Ccd8xjLXFPQlnrh6uT8fh6yCRVEXdZ0S3Wbv/PiusKIEHxEwsHH7wdpWYHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ru/gezyU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ru/gezyU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2566AC4CEC2;
	Wed,  2 Oct 2024 14:32:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879561;
	bh=UnNGZL4dOuw/jLlKBmvoe1g3dxTw79DpGvR9I2gHV7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ru/gezyUz+On9eMvt/78DTOLcYfiCB/bEP6DQOVYoJJuKASyX8NbVH+t/8KuNMv1E
	 tbCq7cOP2LL4E/fVLmIzrC5wFSRmrkx5U/z7CqaftPZuZtCkhV+i3TB1LaWyDtS6ZM
	 SnnS9qPAg8evwNOkJJs6PMxKoZBvp2bsEN0NCzgI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Cheng-Jui=20Wang=20 ?= <Cheng-Jui.Wang@mediatek.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 130/538] rcu/nocb: Fix RT throttling hrtimer armed from offline CPU
Date: Wed,  2 Oct 2024 14:56:09 +0200
Message-ID: <20241002125757.373570874@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frederic Weisbecker <frederic@kernel.org>

[ Upstream commit 9139f93209d1ffd7f489ab19dee01b7c3a1a43d2 ]

After a CPU is marked offline and until it reaches its final trip to
idle, rcuo has several opportunities to be woken up, either because
a callback has been queued in the meantime or because
rcutree_report_cpu_dead() has issued the final deferred NOCB wake up.

If RCU-boosting is enabled, RCU kthreads are set to SCHED_FIFO policy.
And if RT-bandwidth is enabled, the related hrtimer might be armed.
However this then happens after hrtimers have been migrated at the
CPUHP_AP_HRTIMERS_DYING stage, which is broken as reported by the
following warning:

 Call trace:
  enqueue_hrtimer+0x7c/0xf8
  hrtimer_start_range_ns+0x2b8/0x300
  enqueue_task_rt+0x298/0x3f0
  enqueue_task+0x94/0x188
  ttwu_do_activate+0xb4/0x27c
  try_to_wake_up+0x2d8/0x79c
  wake_up_process+0x18/0x28
  __wake_nocb_gp+0x80/0x1a0
  do_nocb_deferred_wakeup_common+0x3c/0xcc
  rcu_report_dead+0x68/0x1ac
  cpuhp_report_idle_dead+0x48/0x9c
  do_idle+0x288/0x294
  cpu_startup_entry+0x34/0x3c
  secondary_start_kernel+0x138/0x158

Fix this with waking up rcuo using an IPI if necessary. Since the
existing API to deal with this situation only handles swait queue, rcuo
is only woken up from offline CPUs if it's not already waiting on a
grace period. In the worst case some callbacks will just wait for a
grace period to complete before being assigned to a subsequent one.

Reported-by: "Cheng-Jui Wang (王正睿)" <Cheng-Jui.Wang@mediatek.com>
Fixes: 5c0930ccaad5 ("hrtimers: Push pending hrtimers away from outgoing CPU earlier")
Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Signed-off-by: Neeraj Upadhyay <neeraj.upadhyay@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/rcu/tree_nocb.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/kernel/rcu/tree_nocb.h b/kernel/rcu/tree_nocb.h
index 30b34f215ca35..e019f166daa61 100644
--- a/kernel/rcu/tree_nocb.h
+++ b/kernel/rcu/tree_nocb.h
@@ -220,7 +220,10 @@ static bool __wake_nocb_gp(struct rcu_data *rdp_gp,
 	raw_spin_unlock_irqrestore(&rdp_gp->nocb_gp_lock, flags);
 	if (needwake) {
 		trace_rcu_nocb_wake(rcu_state.name, rdp->cpu, TPS("DoWake"));
-		wake_up_process(rdp_gp->nocb_gp_kthread);
+		if (cpu_is_offline(raw_smp_processor_id()))
+			swake_up_one_online(&rdp_gp->nocb_gp_wq);
+		else
+			wake_up_process(rdp_gp->nocb_gp_kthread);
 	}
 
 	return needwake;
-- 
2.43.0



