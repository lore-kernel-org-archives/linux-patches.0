Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20724265601;
	Tue, 25 Mar 2025 12:25:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905545; cv=none; b=flVxO7mkjIXQvoDwKceramvQQnQgwBLMsGKrN/SixXu7h28QJaef1Tz7gUtsGtSqKT3rK/XbSy8ep5eZcnoTLWqx3scVZZAt2swy9DXZgng0x2q3MuchiKMXjZUee/Kuer3B8l3eycqDPG/gaPnsBxuCovsSi0OTHh3MAd3g9g4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905545; c=relaxed/simple;
	bh=M/3KxLJXZZkk5zsWkFN5q6YuSPrcJhq1W6MW50a1yIo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CaLs0fKHLaoxz7PnScWQ82qDygHHg5SKq/wQj+q6nggFePQhLKQAxpynb6TWf4QBZ/sb/TDGZVWvYfqV+1M+N1UCDBhl49/p0RcnjD8cgeSA5HBsOBMGHXirG5/HLGRFyiRUmnI4FTMYtgdN/wciaWsNFZ8YAEcW2vyejO/QN5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qIqezQOk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qIqezQOk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C71A3C4CEE9;
	Tue, 25 Mar 2025 12:25:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905545;
	bh=M/3KxLJXZZkk5zsWkFN5q6YuSPrcJhq1W6MW50a1yIo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qIqezQOkQhi2Fa6i9BM4N5JqcSls7HAKnHvP6YEMkYotdGnTmk/lPycXbThNdPzz2
	 JPtcbJ+c4xKZS9RHuAQLUMN1SBjjKbtCQhU6UooyWL0FxB4G/hsr+NDvKaLDoHyUlX
	 MhgMpoyHFNUVRZ3xHk1r+SBAiC55EvTyOOriOyHM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 032/198] hrtimers: Mark is_migration_base() with __always_inline
Date: Tue, 25 Mar 2025 08:19:54 -0400
Message-ID: <20250325122157.484468808@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122156.633329074@linuxfoundation.org>
References: <20250325122156.633329074@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 27af31e44949fa85550176520ef7086a0d00fd7b ]

When is_migration_base() is unused, it prevents kernel builds
with clang, `make W=1` and CONFIG_WERROR=y:

kernel/time/hrtimer.c:156:20: error: unused function 'is_migration_base' [-Werror,-Wunused-function]
  156 | static inline bool is_migration_base(struct hrtimer_clock_base *base)
      |                    ^~~~~~~~~~~~~~~~~

Fix this by marking it with __always_inline.

[ tglx: Use __always_inline instead of __maybe_unused and move it into the
  	usage sites conditional ]

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/all/20250116160745.243358-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/time/hrtimer.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/kernel/time/hrtimer.c b/kernel/time/hrtimer.c
index f6d799646dd9c..e60863ab74b50 100644
--- a/kernel/time/hrtimer.c
+++ b/kernel/time/hrtimer.c
@@ -145,11 +145,6 @@ static struct hrtimer_cpu_base migration_cpu_base = {
 
 #define migration_base	migration_cpu_base.clock_base[0]
 
-static inline bool is_migration_base(struct hrtimer_clock_base *base)
-{
-	return base == &migration_base;
-}
-
 /*
  * We are using hashed locking: holding per_cpu(hrtimer_bases)[n].lock
  * means that all timers which are tied to this base via timer->base are
@@ -274,11 +269,6 @@ switch_hrtimer_base(struct hrtimer *timer, struct hrtimer_clock_base *base,
 
 #else /* CONFIG_SMP */
 
-static inline bool is_migration_base(struct hrtimer_clock_base *base)
-{
-	return false;
-}
-
 static inline struct hrtimer_clock_base *
 lock_hrtimer_base(const struct hrtimer *timer, unsigned long *flags)
 {
@@ -1378,6 +1368,18 @@ static void hrtimer_sync_wait_running(struct hrtimer_cpu_base *cpu_base,
 	}
 }
 
+#ifdef CONFIG_SMP
+static __always_inline bool is_migration_base(struct hrtimer_clock_base *base)
+{
+	return base == &migration_base;
+}
+#else
+static __always_inline bool is_migration_base(struct hrtimer_clock_base *base)
+{
+	return false;
+}
+#endif
+
 /*
  * This function is called on PREEMPT_RT kernels when the fast path
  * deletion of a timer failed because the timer callback function was
-- 
2.39.5



