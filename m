Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEE76379C35;
	Wed, 30 Sep 2026 15:57:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783829; cv=none; b=nE7xnfUVzjOe7rH760GvL0xStF3KpU8v0XwT4CIhfaVO6pnju0X72/disOlayyM3iA1k67pjimqMxLiyBL64KOzh1fhkx3aurQ5TyY8EeGeleW6onbhS5W4mnAig/ADEuabzEgbDrFcNplstVm0zyMIwOLblwa+G375O7dysMFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783829; c=relaxed/simple;
	bh=wu+0PuOyE7zH733FtLvzRLOmjmaJDh8KQNkQ1x168lo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iFpuBc3HUZew5AS32Mv9iIFzMtdLk2NXqtKWqwv1x/xwcClonnqmDF27jK6Xc4bSgueQSZ0qjHGX4+RHh+Eq/IHuor7hUD2ZSU9tUs2tpjZA1wgar80TQFLXBP5vvmFveLUhSosrQ/ulHTEA5bUleoPT+hmSwhoLNP3GVxldX+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U6d6ESOR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U6d6ESOR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BA301F00893;
	Wed, 30 Sep 2026 15:57:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783824;
	bh=ZvfSmXqC3YZ8rv9Avv6SzqgMIIt76vRIeOfxObWdpUs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U6d6ESORy0e4TZu1VMyEfOkhT82aHhMIGNAgv/Ci6ZzucPrRT6z9ClaLOrv85jaSd
	 y0WTSJSv/26zh6n1OdKMBwTARUY5SeglBiti0JCn7UQ1vViy4Lv1Bp+9kEr8YhoP8H
	 CSRThMVluzzw1KcpMzaz2DFPS04QfyOuMIAfE6E0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nam Cao <namcao@linutronix.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 534/595] hrtimers: Introduce hrtimer_setup() to replace hrtimer_init()
Date: Wed, 30 Sep 2026 17:27:07 +0200
Message-ID: <20260930152359.193155183@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nam Cao <namcao@linutronix.de>

[ Upstream commit 908a1d775422ba2e27a5e33d0c130b522419e121 ]

To initialize hrtimer, hrtimer_init() needs to be called and also
hrtimer::function must be set. This is error-prone and awkward to use.

Introduce hrtimer_setup() which does both of these things, so that users of
hrtimer can be simplified.

The new setup function also has a sanity check for the provided function
pointer. If NULL, a warning is emitted and a dummy callback installed.

hrtimer_init() will be removed as soon as all of its users have been
converted to the new function.

Signed-off-by: Nam Cao <namcao@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/all/5057c1ddbfd4b92033cd93d37fe38e6b069d5ba6.1730386209.git.namcao@linutronix.de
Stable-dep-of: cfa165cbfbed ("net/sched: act_gate: budget the per-entry list in get_fill_size")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/hrtimer.h |  2 ++
 kernel/time/hrtimer.c   | 38 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 40 insertions(+)

diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
index 2623294e25fbd..88b5348596fbe 100644
--- a/include/linux/hrtimer.h
+++ b/include/linux/hrtimer.h
@@ -372,6 +372,8 @@ static inline void hrtimer_cancel_wait_running(struct hrtimer *timer)
 /* Initialize timers: */
 extern void hrtimer_init(struct hrtimer *timer, clockid_t which_clock,
 			 enum hrtimer_mode mode);
+extern void hrtimer_setup(struct hrtimer *timer, enum hrtimer_restart (*function)(struct hrtimer *),
+			  clockid_t clock_id, enum hrtimer_mode mode);
 extern void hrtimer_init_on_stack(struct hrtimer *timer, clockid_t which_clock,
 				  enum hrtimer_mode mode);
 extern void hrtimer_init_sleeper_on_stack(struct hrtimer_sleeper *sl,
diff --git a/kernel/time/hrtimer.c b/kernel/time/hrtimer.c
index 51cea4af249ee..cf6c62cb6b9b0 100644
--- a/kernel/time/hrtimer.c
+++ b/kernel/time/hrtimer.c
@@ -1432,6 +1432,11 @@ static inline int hrtimer_clockid_to_base(clockid_t clock_id)
 	return HRTIMER_BASE_MONOTONIC;
 }
 
+static enum hrtimer_restart hrtimer_dummy_timeout(struct hrtimer *unused)
+{
+	return HRTIMER_NORESTART;
+}
+
 static void __hrtimer_init(struct hrtimer *timer, clockid_t clock_id,
 			   enum hrtimer_mode mode)
 {
@@ -1468,6 +1473,18 @@ static void __hrtimer_init(struct hrtimer *timer, clockid_t clock_id,
 	timerqueue_init(&timer->node);
 }
 
+static void __hrtimer_setup(struct hrtimer *timer,
+			    enum hrtimer_restart (*function)(struct hrtimer *),
+			    clockid_t clock_id, enum hrtimer_mode mode)
+{
+	__hrtimer_init(timer, clock_id, mode);
+
+	if (WARN_ON_ONCE(!function))
+		timer->function = hrtimer_dummy_timeout;
+	else
+		timer->function = function;
+}
+
 /**
  * hrtimer_init - initialize a timer to the given clock
  * @timer:	the timer to be initialized
@@ -1488,6 +1505,27 @@ void hrtimer_init(struct hrtimer *timer, clockid_t clock_id,
 }
 EXPORT_SYMBOL_GPL(hrtimer_init);
 
+/**
+ * hrtimer_setup - initialize a timer to the given clock
+ * @timer:	the timer to be initialized
+ * @function:	the callback function
+ * @clock_id:	the clock to be used
+ * @mode:       The modes which are relevant for initialization:
+ *              HRTIMER_MODE_ABS, HRTIMER_MODE_REL, HRTIMER_MODE_ABS_SOFT,
+ *              HRTIMER_MODE_REL_SOFT
+ *
+ *              The PINNED variants of the above can be handed in,
+ *              but the PINNED bit is ignored as pinning happens
+ *              when the hrtimer is started
+ */
+void hrtimer_setup(struct hrtimer *timer, enum hrtimer_restart (*function)(struct hrtimer *),
+		   clockid_t clock_id, enum hrtimer_mode mode)
+{
+	debug_init(timer, clock_id, mode);
+	__hrtimer_setup(timer, function, clock_id, mode);
+}
+EXPORT_SYMBOL_GPL(hrtimer_setup);
+
 /**
  * hrtimer_init_on_stack - initialize a timer in stack memory
  * @timer:	The timer to be initialized
-- 
2.53.0



