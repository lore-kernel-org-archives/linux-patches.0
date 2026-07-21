Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4077F470447;
	Tue, 21 Jul 2026 17:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656269; cv=none; b=FLMpsx5P/UqxDty+I5Uz/JHTHXud4Eca7V3hPqeXjvV4eHE+39XjjKYo8K19RXqwukGhSOrOEDqHAwmDxJAvGDpN8fT8C1UnB9XmDyaZKGG9lv6p6B9gt/jmoyR6MKAmKaI/q2Mvk7vU/yisX5Xz0Tha/3lzw8yVIf5LRx9qXts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656269; c=relaxed/simple;
	bh=HQK2FXuC6HeQlhHsWFLdkZvI/4IbQh1jQsFwWoya/Ro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ODRDT62ZsB2PKDljXw0uA8t5Z/4q5Vlm6WQC0Efzxq+0/n/IVuOFk6cCgkn0kTqQVOzFhWU0EI06nxNQ6VJCOqneAWJbpefgR2IOL6Fo7OtWo3V6tmRY1Wdb5rBbMhEamIZXc65w6VJi2M/YejPW9SfQVjdu8A3OoBqX/Br4aIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WZIB7ufv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WZIB7ufv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6F6B1F00A3A;
	Tue, 21 Jul 2026 17:51:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656268;
	bh=qK2PTuhxWhG5i0sIArVBaRxAd2WZ5FZR8uKi4u2ko+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WZIB7ufvxzTPWpl7eENyMCoYRF9Iqtk+BN2ECz6qvuANPWcb/KW0dwZv//BVj1Ots
	 TT+pKFk10LRY2eqWb3O/eYtsRp0eX3eGIku1KC0Ls0rcmhpIDFSLNCVvb5+4TMaGDo
	 2RLL8LXri2NhEGkeLUFqKUsS4TFo32rOMumPrvdo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0321/1611] lockdep/selftests: Restore sched_rt_mutex state on PREEMPT_RT
Date: Tue, 21 Jul 2026 17:07:17 +0200
Message-ID: <20260721152522.306200231@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 06961d60a0e410bf8df69ccff7eb1bd824912b8f ]

The WW-mutex selftests deliberately exercise failing lock paths. On
PREEMPT_RT, some of those paths enter the RT-mutex scheduler helpers.

The change referenced by the Fixes tag made those helpers track RT-mutex
scheduling state in current->sched_rt_mutex. The bit is normally cleared by
the matching post-schedule helper, but some WW-mutex selftests disable
the runtime debug_locks flag before that happens. With debug_locks cleared,
lockdep_assert() does not evaluate the expression that clears the bit,
leaving stale state for the next testcase.

With CONFIG_PREEMPT_RT=y and CONFIG_DEBUG_LOCKING_API_SELFTESTS=y, that
stale state produces warnings such as:

  WARNING: kernel/sched/core.c:7557 at rt_mutex_pre_schedule+0x26/0x2d
  RIP: 0010:rt_mutex_pre_schedule+0x26/0x2d

Save and restore current->sched_rt_mutex around each testcase, matching the
existing PREEMPT_RT cleanup for task-local migration and RCU state.

Fixes: d14f9e930b90 ("locking/rtmutex: Use rt_mutex specific scheduler helpers")
Assisted-by: Codex:gpt-5
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Link: https://patch.msgid.link/20260523185123.17482-3-kmehltretter@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/locking-selftest.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/lib/locking-selftest.c b/lib/locking-selftest.c
index 7605a0da4eb613..7f74e0549c32f1 100644
--- a/lib/locking-selftest.c
+++ b/lib/locking-selftest.c
@@ -1433,6 +1433,7 @@ static void dotest(void (*testcase_fn)(void), int expected, int lockclass_mask)
 #ifdef CONFIG_PREEMPT_RT
 	int saved_mgd_count = current->migration_disabled;
 	int saved_rcu_count = current->rcu_read_lock_nesting;
+	int saved_sched_rt_mutex = current->sched_rt_mutex;
 #endif
 
 	WARN_ON(irqs_disabled());
@@ -1469,6 +1470,8 @@ static void dotest(void (*testcase_fn)(void), int expected, int lockclass_mask)
 	preempt_count_set(saved_preempt_count);
 
 #ifdef CONFIG_PREEMPT_RT
+	current->sched_rt_mutex = saved_sched_rt_mutex;
+
 	while (current->migration_disabled > saved_mgd_count)
 		migrate_enable();
 
-- 
2.53.0



