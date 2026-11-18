Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021794;
	b=1TcBpN/fsgre2tHiWC1CKSkJ5rDfCrPAMiRklt6kGTOLKtvMsPzQRyXUIqZcp25l2bml
	 F37nLbHjP+psTQbn1P7Coq5jg5ewpP/4bBt2M4G9u2fsM+IuHHeXrnG08qRflu32zDgBh
	 kaDkjC7e6a6JvTHiMuRNOqumXVM2QeMkct9FUNNyKe/9UXKIg1xbqb2gNAW+4mLfgSdwj
	 wtE2QRUgA4obK8WrOT0TydSVMunObsAz41YXJ0JFjEDqK7gd5y3noRO9RE1xMxg2rB6I0
	 znPyKA/uxChvflDLiDCodU+FLexc3H6sZl6cUJe4Un8iQiSApezTquP/PF2JaVnmEPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021794;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Fb1QZOmmsmuKmLikBFJC5SbCrkkXO/u7J8hUQvGmJeA=;
	b=aQojyHXBMTqjMyDb27qX/zTtow/3yefV+pyjW7Eyw9hUL920KQVr2i+02+J7+BKdw0ja
	 6IeWg0czG1t9m2FsDetLYBERa8gAHg8Na4z38YIQOGrqTsiAEyvIAkskt4mSTG3pPIULz
	 jq03FfDFu0XUQ5nBsqYPI5jBYuKhlK8AXg5vs1ifdhKPQNlWslyo8CaIGvqgdnuEed2vh
	 Sw88ewHf6F6l8d/jjogxC+mvW+cQ6HSO5ApHL72zZTRUihYl9okaWU9qEsOCCXJmk6LwP
	 RL/BcNyCEt0G+itxTKi2B7nulok7zT91gUsQ9KQg/1V+Tz+2bU2THF+ro558pYl4F7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q9bK3g0c;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A806606A33B;
	Wed, 18 Nov 2026 17:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q9bK3g0c
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CF7B1F000C4;
	Wed, 18 Nov 2026 17:09:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021794;
	bh=Fb1QZOmmsmuKmLikBFJC5SbCrkkXO/u7J8hUQvGmJeA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q9bK3g0cy9BcR7etIpsHrwRaimoFF7+gQ1qf7NT1rDOKG4D2euDnJtIq+rBE/XqlC
	 N4wjJXmEpf9+TJGxKpO3gEl0lVQ2OkOC4lejwgNqSdwKRefLCiLCy6UqyUviuIU2qR
	 3LNoTq+vScdlJotucCL9sGQp92Zfclx3C4BYt5+w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hui Su <sh_def@163.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2406/2651] hrtimer: Add cleanup class for on-stack timers
Date: Wed, 18 Nov 2026 16:00:46 +0100
Message-ID: <20261118150411.945024649@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hui Su <sh_def@163.com>

[ Upstream commit 064bcd117e8a1a266bb92b840f63862999b7cb87 ]

hrtimer_setup_on_stack() requires callers to destroy the timer before its
backing stack storage goes out of scope, but the setup interface does not
encode the required teardown pairing.

Add an hrtimer_on_stack cleanup class that pairs on-stack setup with
destroy_hrtimer_on_stack(). Document the existing setup API's lifetime
requirement.

The cleanup class provides debug-object teardown, not timer
cancellation. Callers must ensure that no hrtimer operation can still
access the timer before the scope ends; in particular, the timer must
no longer be queued and any running callback must have completed.

Signed-off-by: Hui Su <sh_def@163.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Link: https://patch.msgid.link/5f48c32490d19f51035e4209174f9cfe44472c71.1792083743.git.sh_def@163.com
Stable-dep-of: bd091346971c ("sched/idle: Use hrtimer cleanup class in play_idle_precise()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/hrtimer.h | 24 ++++++++++++++++++++++++
 kernel/time/hrtimer.c   |  8 ++++++--
 2 files changed, 30 insertions(+), 2 deletions(-)

diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
index 29072d89e5cb3..1877beb81d5c2 100644
--- a/include/linux/hrtimer.h
+++ b/include/linux/hrtimer.h
@@ -12,6 +12,7 @@
 #ifndef _LINUX_HRTIMER_H
 #define _LINUX_HRTIMER_H
 
+#include <linux/cleanup.h>
 #include <linux/hrtimer_rearm.h>
 #include <linux/hrtimer_types.h>
 #include <linux/init.h>
@@ -201,6 +202,29 @@ extern void destroy_hrtimer_on_stack(struct hrtimer *timer);
 static inline void destroy_hrtimer_on_stack(struct hrtimer *timer) { }
 #endif
 
+/*
+ * The cleanup class pairs on-stack setup with debug-object teardown. Callers
+ * using it must not call destroy_hrtimer_on_stack() manually.
+ *
+ * This class provides debug-object teardown, not timer cancellation. Callers
+ * must ensure that no hrtimer operation can still access the timer before
+ * leaving the scope. In particular, the timer must no longer be queued and
+ * any running callback must have completed.
+ *
+ * Callers using hrtimer_setup_on_stack() without this class retain
+ * responsibility for destroying the timer before its backing storage leaves
+ * scope.
+ */
+DEFINE_CLASS(hrtimer_on_stack, struct hrtimer *,
+	     destroy_hrtimer_on_stack(_T),
+	     ({
+		hrtimer_setup_on_stack(timer, function, clock_id, mode);
+		timer;
+	     }),
+	     struct hrtimer *timer,
+	     enum hrtimer_restart (*function)(struct hrtimer *),
+	     clockid_t clock_id, enum hrtimer_mode mode)
+
 /* Basic timer operations: */
 extern void hrtimer_start_range_ns(struct hrtimer *timer, ktime_t tim,
 				   u64 range_ns, const enum hrtimer_mode mode);
diff --git a/kernel/time/hrtimer.c b/kernel/time/hrtimer.c
index cbf1693c86b38..12e136d5691f4 100644
--- a/kernel/time/hrtimer.c
+++ b/kernel/time/hrtimer.c
@@ -1975,8 +1975,12 @@ EXPORT_SYMBOL_GPL(hrtimer_setup);
  * @clock_id:	The clock to be used
  * @mode:       The timer mode
  *
- * Similar to hrtimer_setup(), except that this one must be used if struct hrtimer is in stack
- * memory.
+ * Similar to hrtimer_setup(), except that this one must be used if struct
+ * hrtimer is in stack memory.
+ *
+ * Callers that do not use the hrtimer_on_stack cleanup class must call
+ * destroy_hrtimer_on_stack() before the stack storage goes out of scope. The
+ * cleanup class pairs setup and destruction automatically.
  */
 void hrtimer_setup_on_stack(struct hrtimer *timer,
 			    enum hrtimer_restart (*function)(struct hrtimer *),
-- 
2.53.0



