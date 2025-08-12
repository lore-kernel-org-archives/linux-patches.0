Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ABEA2F5E;
	Tue, 12 Aug 2025 18:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021866; cv=none; b=lXNoXP8vtISqowhE275MsZ8jcUQkMrQjlYf6wV74sTik9wFtjmhTZigTAs3XGptcJqZZP3YuC6Ae+RfpirIIiixbOZvf4IB5hu4aeZRgHwrWxZP2gnG3Qgmowv12A78FIz4L6sQyrTPivOOsCEyb2rdnUh+luZHKsDzA4r6A+fg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021866; c=relaxed/simple;
	bh=tiL0Hoe2XcpC0Ph1/nF3+9bYaqClixfj07DYERSBeYQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C8Lr0DRqdR6QE8GybyvsVdzNtCSeKjWJdd8ejKFfQ94+OSPRzLfto1na9h8ildYOsP4YsNOuvF8UJ5LcMuG/4kjhPoXL1Moq6NjXG/w3e20Xnb3PNIVuWGPP8uZYIrwl/ziSxqPwZ5e54sUd/Wu6yNUrKjew9Q0X1kkD8zTAgDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZlpFuJSO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZlpFuJSO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BE86C4CEF0;
	Tue, 12 Aug 2025 18:04:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021866;
	bh=tiL0Hoe2XcpC0Ph1/nF3+9bYaqClixfj07DYERSBeYQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZlpFuJSOLijN6C+jjKdH6kpV6sYAx+npn9xNh5BGXCraBCU88KGDRjpN1g0YzQoXQ
	 oO0wIpaoH4g3I+5et3oM7aYgd+0vvujC8Rd5AHKT85dUT4CTa+DqTabvG2QHiwriaA
	 O3w8S9uLwHXtxFvmTtwdPBpt/wuQsS62jSR+8uN0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Elliot Berman <quic_eberman@quicinc.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>,
	Chen Ridong <chenridong@huawei.com>
Subject: [PATCH 6.6 248/262] sched/core: Remove ifdeffery for saved_state
Date: Tue, 12 Aug 2025 19:30:36 +0200
Message-ID: <20250812173003.711890431@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172952.959106058@linuxfoundation.org>
References: <20250812172952.959106058@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Elliot Berman <quic_eberman@quicinc.com>

commit fbaa6a181a4b1886cbf4214abdf9a2df68471510 upstream.

In preparation for freezer to also use saved_state, remove the
CONFIG_PREEMPT_RT compilation guard around saved_state.

On the arm64 platform I tested which did not have CONFIG_PREEMPT_RT,
there was no statistically significant deviation by applying this patch.

Test methodology:

perf bench sched message -g 40 -l 40

Signed-off-by: Elliot Berman <quic_eberman@quicinc.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Chen Ridong <chenridong@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/sched.h |    2 --
 kernel/sched/core.c   |   10 ++--------
 2 files changed, 2 insertions(+), 10 deletions(-)

--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -753,10 +753,8 @@ struct task_struct {
 #endif
 	unsigned int			__state;
 
-#ifdef CONFIG_PREEMPT_RT
 	/* saved state for "spinlock sleepers" */
 	unsigned int			saved_state;
-#endif
 
 	/*
 	 * This begins the randomizable portion of task_struct. Only
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2238,17 +2238,15 @@ int __task_state_match(struct task_struc
 	if (READ_ONCE(p->__state) & state)
 		return 1;
 
-#ifdef CONFIG_PREEMPT_RT
 	if (READ_ONCE(p->saved_state) & state)
 		return -1;
-#endif
+
 	return 0;
 }
 
 static __always_inline
 int task_state_match(struct task_struct *p, unsigned int state)
 {
-#ifdef CONFIG_PREEMPT_RT
 	int match;
 
 	/*
@@ -2260,9 +2258,6 @@ int task_state_match(struct task_struct
 	raw_spin_unlock_irq(&p->pi_lock);
 
 	return match;
-#else
-	return __task_state_match(p, state);
-#endif
 }
 
 /*
@@ -4059,7 +4054,6 @@ bool ttwu_state_match(struct task_struct
 
 	*success = !!(match = __task_state_match(p, state));
 
-#ifdef CONFIG_PREEMPT_RT
 	/*
 	 * Saved state preserves the task state across blocking on
 	 * an RT lock.  If the state matches, set p::saved_state to
@@ -4075,7 +4069,7 @@ bool ttwu_state_match(struct task_struct
 	 */
 	if (match < 0)
 		p->saved_state = TASK_RUNNING;
-#endif
+
 	return match > 0;
 }
 


