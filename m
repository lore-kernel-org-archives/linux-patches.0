Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92632335BA1;
	Mon, 18 Aug 2025 13:27:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523633; cv=none; b=k1VHjaX/QKEuIFqON09YQ0fVs6hPdGmHBzky5+WmyJPx2fQtbd3tJ1nJEs2vWTYLHyfPw9JnxT1YR1EVCBJY2PbVxlDtBKRY4GjUCZuBMOO0n+SjyPEV/KmeeCONyCeToBZWnjAIRoyBpSfBTv0z0bEF65brF/NZ0oY1Mrabky4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523633; c=relaxed/simple;
	bh=4QK+ZDky9iShKO6RUk7kT8b4mTmEA441++/punGYfCk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BgSNpAAQRMNTEvSsJJ04/f0B6XQ06qCxkKm10PSUuaoX9FBRLflGQlP2G03DkdKEvVdUdOw0YvTEbO6HV3D3vq05vdnJ/nd1B/tBQuvnuKpflNTd5cPKHhMDQ5ZLUnW6GLG8N3+G7S/2bcF6ktjlexFtL0ykhDOQCtB748jHf5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jXuY0V/X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jXuY0V/X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B666C113D0;
	Mon, 18 Aug 2025 13:27:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523633;
	bh=4QK+ZDky9iShKO6RUk7kT8b4mTmEA441++/punGYfCk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jXuY0V/X0ZOZuE2SxEdgi60Ij4H7fV2eEL35n7MAUGbML1OwJGvjMrwfFRrMK20DF
	 I0Cj2V2LiSlcycTuWlBJ7JNr+9pZ7Gsx3V5b7IYhKD1clnDgv5ZbkNUkerDQ/ZTDCA
	 LJZL0Z4b735rFLSGG6kLDPcVbnvePh98PDgm3o7s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marcel Ziswiler <marcel.ziswiler@codethink.co.uk>,
	Juri Lelli <juri.lelli@redhat.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 232/515] sched/deadline: Fix accounting after global limits change
Date: Mon, 18 Aug 2025 14:43:38 +0200
Message-ID: <20250818124507.306825638@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

From: Juri Lelli <juri.lelli@redhat.com>

[ Upstream commit 440989c10f4e32620e9e2717ca52c3ed7ae11048 ]

A global limits change (sched_rt_handler() logic) currently leaves stale
and/or incorrect values in variables related to accounting (e.g.
extra_bw).

Properly clean up per runqueue variables before implementing the change
and rebuild scheduling domains (so that accounting is also properly
restored) after such a change is complete.

Reported-by: Marcel Ziswiler <marcel.ziswiler@codethink.co.uk>
Signed-off-by: Juri Lelli <juri.lelli@redhat.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Tested-by: Marcel Ziswiler <marcel.ziswiler@codethink.co.uk> # nuc & rock5b
Link: https://lore.kernel.org/r/20250627115118.438797-4-juri.lelli@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/deadline.c | 4 +++-
 kernel/sched/rt.c       | 6 ++++++
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 65f3b2cc891d..d86b211f2c14 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -3249,6 +3249,9 @@ void sched_dl_do_global(void)
 	if (global_rt_runtime() != RUNTIME_INF)
 		new_bw = to_ratio(global_rt_period(), global_rt_runtime());
 
+	for_each_possible_cpu(cpu)
+		init_dl_rq_bw_ratio(&cpu_rq(cpu)->dl);
+
 	for_each_possible_cpu(cpu) {
 		rcu_read_lock_sched();
 
@@ -3264,7 +3267,6 @@ void sched_dl_do_global(void)
 		raw_spin_unlock_irqrestore(&dl_b->lock, flags);
 
 		rcu_read_unlock_sched();
-		init_dl_rq_bw_ratio(&cpu_rq(cpu)->dl);
 	}
 }
 
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index bfcb8b0a1e2c..41a216fec3ce 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -2936,6 +2936,12 @@ static int sched_rt_handler(const struct ctl_table *table, int write, void *buff
 	sched_domains_mutex_unlock();
 	mutex_unlock(&mutex);
 
+	/*
+	 * After changing maximum available bandwidth for DEADLINE, we need to
+	 * recompute per root domain and per cpus variables accordingly.
+	 */
+	rebuild_sched_domains();
+
 	return ret;
 }
 
-- 
2.39.5



