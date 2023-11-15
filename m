Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A54843AA6
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 20:44:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VyHUzVyr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACF3DC433C8;
	Wed, 15 Nov 2023 20:44:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700081095;
	bh=SndGfGahLPO5WuLXyoWY4uu3z9nYk5vadnWI1okKXPY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VyHUzVyrsLaqc94v/IB8zkM+JmjBCv0Nn0IBgTTZko3n6k9mFahv2ETWcnIYgtYPu
	 Wh4EpN0oFwiUZvxbNySTI6gMc4z5LND8PH+mHkAREYcRGSnHnUPNK3g89IWxngZb/8
	 adE4qZrzSrTeLrzwZatQ9zjo43DwDeybkjDlHG1A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 36/88] sched/rt: Provide migrate_disable/enable() inlines
Date: Wed, 15 Nov 2023 15:35:48 -0500
Message-ID: <20231115191428.349184183@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191426.221330369@linuxfoundation.org>
References: <20231115191426.221330369@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

[ Upstream commit 66630058e56b26b3a9cf2625e250a8c592dd0207 ]

Code which solely needs to prevent migration of a task uses
preempt_disable()/enable() pairs. This is the only reliable way to do so
as setting the task affinity to a single CPU can be undone by a
setaffinity operation from a different task/process.

RT provides a seperate migrate_disable/enable() mechanism which does not
disable preemption to achieve the semantic requirements of a (almost) fully
preemptible kernel.

As it is unclear from looking at a given code path whether the intention is
to disable preemption or migration, introduce migrate_disable/enable()
inline functions which can be used to annotate code which merely needs to
disable migration. Map them to preempt_disable/enable() for now. The RT
substitution will be provided later.

Code which is annotated that way documents that it has no requirement to
protect against reentrancy of a preempting task. Either this is not
required at all or the call sites are already serialized by other means.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ben Segall <bsegall@google.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Link: https://lore.kernel.org/r/878slclv1u.fsf@nanos.tec.linutronix.de
Stable-dep-of: 36c75ce3bd29 ("nd_btt: Make BTT lanes preemptible")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/preempt.h | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/include/linux/preempt.h b/include/linux/preempt.h
index c01813c3fbe93..abeec72b4d359 100644
--- a/include/linux/preempt.h
+++ b/include/linux/preempt.h
@@ -325,4 +325,34 @@ static inline void preempt_notifier_init(struct preempt_notifier *notifier,
 
 #endif
 
+/**
+ * migrate_disable - Prevent migration of the current task
+ *
+ * Maps to preempt_disable() which also disables preemption. Use
+ * migrate_disable() to annotate that the intent is to prevent migration,
+ * but not necessarily preemption.
+ *
+ * Can be invoked nested like preempt_disable() and needs the corresponding
+ * number of migrate_enable() invocations.
+ */
+static __always_inline void migrate_disable(void)
+{
+	preempt_disable();
+}
+
+/**
+ * migrate_enable - Allow migration of the current task
+ *
+ * Counterpart to migrate_disable().
+ *
+ * As migrate_disable() can be invoked nested, only the outermost invocation
+ * reenables migration.
+ *
+ * Currently mapped to preempt_enable().
+ */
+static __always_inline void migrate_enable(void)
+{
+	preempt_enable();
+}
+
 #endif /* __LINUX_PREEMPT_H */
-- 
2.42.0



