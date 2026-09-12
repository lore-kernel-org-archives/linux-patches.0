Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41EC0471266;
	Sat, 12 Sep 2026 10:50:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789210234; cv=none; b=frQ3xZqZJ4aaJSFIXCePS2bHwAwIqtAl1KPDnDGx685ad5NYgiZefTPwpNh53GZBXboquOD+ZJ7ZRJVWhWpMhDREraJlH3qZzH0O2nXORTAMKAMIiZ1mcYjlQg+VTTrbJXI3TkYCGiUlWrMZsXK5Ch8Vf2k/aiiU2m3+SxnQAq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789210234; c=relaxed/simple;
	bh=5GGi8KhdZzZw8D35wxoxQXxkgc6avpTxxBezLeiU1zo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TUF+yZBlor0owoseoFMwrMHr8gUbhmauRzOiMfN52QMy7zc6vHh9+Svq59HaQ+5cwlYRlgxSIntsvl43p7bkGPQdp9zeL8WQ7S+wa69PzX864vg7HidRr0nhC5STqzszTsObm4el15CHhombaSx6pjc6pBQvtnnj0w58B6yrOTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2KiEnL3K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2KiEnL3K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 356AA1F000FF;
	Sat, 12 Sep 2026 10:50:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789210227;
	bh=2VLlydG29u1XEgF7/XHxUaSTJqeusg0QrnCRidKLh0U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2KiEnL3K0yA0pc/HWXHRPOVgORGC2xDNbFdKV+GaneZh4EY1j9X0BIAKljj4JJvQv
	 5dZjyUDJ0XnneKgwjK8DOAsd4AaIUwZs1t7lu6pGFGemNMD1mXm4YcfG/ePgS/wr3j
	 IYU7Ae17Np//+UaYADrdWZT3YpTcJPApVZHfBHeg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Yu <yu.c.chen@intel.com>,
	Ricardo Neri <ricardo.neri-calderon@linux.intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Christian Loehle <christian.loehle@arm.com>,
	Andrea Righi <arighi@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0983/1518] sched/fair: Also gate overloaded status update for SD_ASYM_CPUCAPACITY
Date: Sat, 12 Sep 2026 08:52:32 +0200
Message-ID: <20260912065645.695379459@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Ricardo Neri <ricardo.neri-calderon@linux.intel.com>

[ Upstream commit 6060d61d13a10da8c90da4eadf4a421825149883 ]

The argument sg_overloaded of update_sg_lb_stats() is only consumed when
balancing at the root domain. It only makes sense to update it in such a
case. Commit 3229adbe7875 ("sched/fair: Do not compute overloaded status
unnecessarily during lb") updated the logic accordingly but missed the case
in which the root domain has the SD_ASYM_CPUCAPACITY flag. Fix this.

Fixes: 3229adbe7875 ("sched/fair: Do not compute overloaded status unnecessarily during lb")
Reported-by: Chen Yu <yu.c.chen@intel.com>
Signed-off-by: Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Vincent Guittot <vincent.guittot@linaro.org>
Tested-by: Christian Loehle <christian.loehle@arm.com>
Tested-by: Andrea Righi <arighi@nvidia.com>
Link: https://patch.msgid.link/20260720-rneri-fix-cas-clusters-v6-2-bb500bf4afd4@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 30ebe2823d238..5620c8d3a99a6 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -10680,7 +10680,9 @@ static inline void update_sg_lb_stats(struct lb_env *env,
 			/* Check for a misfit task on the cpu */
 			if (sgs->group_misfit_task_load < rq->misfit_task_load) {
 				sgs->group_misfit_task_load = rq->misfit_task_load;
-				*sg_overloaded = 1;
+
+				if (balancing_at_rd)
+					*sg_overloaded = 1;
 			}
 		} else if (env->idle && sched_reduced_capacity(rq, env->sd)) {
 			/* Check for a task running on a CPU with reduced capacity */
-- 
2.53.0



