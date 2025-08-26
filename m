Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67626350820;
	Tue, 26 Aug 2025 13:53:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216394; cv=none; b=qhzSXWicKHWA5iN6QivarFBzGVhiBIYY9vDViqRZNrWbc6vqqhBNxfYIAHxlxn6U076snSV//i7IIGZjgVeVToOGUFPAZn/T6ypEpPQ60elTFpXB0DDkBfnKfO7mZF3XKYQj/UNG551cQdAr9+GAOCmuPqTNpFt7YSM+tOZkXRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216394; c=relaxed/simple;
	bh=vYCvYM6KMa3Uw/kbhgHZ6ty6khDEjT7RN79eAzQmgFY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IxaYrEGXWMLbFzStg686aiPBWnP7Xng0LQzck+HW8aMWJszBWYz6ku9MKyxbTuGMQBHvIVrD6Cc8pYB9gCwgO7iQXuRFrj7GnUsmeDAUhvRZF7740iXWQUtAwFICtXnD3eHDqLLmDe/i8TAvGPd4/KPwCHz9qWVrmVt9Y+x3veU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Txnm0KcB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Txnm0KcB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED3F5C4CEF1;
	Tue, 26 Aug 2025 13:53:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216394;
	bh=vYCvYM6KMa3Uw/kbhgHZ6ty6khDEjT7RN79eAzQmgFY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Txnm0KcBUQMutUHfqdvIZuqrlMJ9R0ipG7JbghcDIHQ0kirzojjPTsVXTpkJj1qyX
	 htEM4L7EBcqVKiZBokoR7Pgks/lMnzuWruoWKA31RLkWnuCLQfj8E0antLElC9XkZu
	 86I638DBdjc98L7z+H3jPWu8CHJ0sL8h5M+yy5G8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marcel Ziswiler <marcel.ziswiler@codethink.co.uk>,
	Juri Lelli <juri.lelli@redhat.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 351/644] sched/deadline: Fix accounting after global limits change
Date: Tue, 26 Aug 2025 13:07:22 +0200
Message-ID: <20250826110955.096261203@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 66eb68c59f0b..708c3960bd06 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -2661,6 +2661,9 @@ void sched_dl_do_global(void)
 	if (global_rt_runtime() != RUNTIME_INF)
 		new_bw = to_ratio(global_rt_period(), global_rt_runtime());
 
+	for_each_possible_cpu(cpu)
+		init_dl_rq_bw_ratio(&cpu_rq(cpu)->dl);
+
 	for_each_possible_cpu(cpu) {
 		rcu_read_lock_sched();
 
@@ -2676,7 +2679,6 @@ void sched_dl_do_global(void)
 		raw_spin_unlock_irqrestore(&dl_b->lock, flags);
 
 		rcu_read_unlock_sched();
-		init_dl_rq_bw_ratio(&cpu_rq(cpu)->dl);
 	}
 }
 
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 5fc99dce5145..9720b3c19ab9 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -2861,6 +2861,12 @@ int sched_rt_handler(struct ctl_table *table, int write, void *buffer,
 	}
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



