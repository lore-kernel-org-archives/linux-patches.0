Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BA89276051;
	Tue, 27 May 2025 17:04:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365452; cv=none; b=elQehLVBZEebjr841dMYdeutrKXzOPG0uOKusk21Vc2ZOGdAGeOTJiPWxcaxWcCof77TVqcJzk9O8SV252pKz8cpetDVhKqCg2LkpCkzCQCdXeeHwTyAh4bo1UYLw6nbWVl90K2XwQ84alHJrqWsYJv6JgDxe/qoGuSAODOD/II=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365452; c=relaxed/simple;
	bh=fM3qcjB17DBFeIHDM77BXtqWi0LMPW3D0rqDwaZak14=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HGW9ACV0GxqN3A4eM60B1jZH02wEVUpyb2+2M0+QpR+0eFUk2NtvLle+hfhty58o2sfwJ8LrWFVVK7aWfB54l5Ddur5Q3tqdagdZ/65U/e7VkSkz78Tx8pOSRO1XLs7SCh+occJRsPkFccJPJHK8jDf59JeB4bfl1rKwPcs8L0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MO0vgQOw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MO0vgQOw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FE94C4CEE9;
	Tue, 27 May 2025 17:04:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365452;
	bh=fM3qcjB17DBFeIHDM77BXtqWi0LMPW3D0rqDwaZak14=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MO0vgQOwBwpHVhquq2fHjWZB2+TBTpTJ7guodASPa+aA3iVW7wEcIw4V2HRbu5KIs
	 Q3rVeaNmqbWQAdg4trtLmLAwUkb0AsePde6gBZ49c4s0CI+OAiIbaD7niyHKopqiNw
	 40iOuLoVjRCSeoykW/OLU/wSNaDlRbLx1LYHIJWg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 350/626] hrtimers: Replace hrtimer_clock_to_base_table with switch-case
Date: Tue, 27 May 2025 18:24:03 +0200
Message-ID: <20250527162459.238484656@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 4441b976dfeff0d3579e8da3c0283300c618a553 ]

Clang and GCC complain about overlapped initialisers in the
hrtimer_clock_to_base_table definition. With `make W=1` and CONFIG_WERROR=y
(which is default nowadays) this breaks the build:

  CC      kernel/time/hrtimer.o
kernel/time/hrtimer.c:124:21: error: initializer overrides prior initialization of this subobject [-Werror,-Winitializer-overrides]
  124 |         [CLOCK_REALTIME]        = HRTIMER_BASE_REALTIME,

kernel/time/hrtimer.c:122:27: note: previous initialization is here
  122 |         [0 ... MAX_CLOCKS - 1]  = HRTIMER_MAX_CLOCK_BASES,

(and similar for CLOCK_MONOTONIC, CLOCK_BOOTTIME, and CLOCK_TAI).

hrtimer_clockid_to_base(), which uses the table, is only used in
__hrtimer_init(), which is not a hotpath.

Therefore replace the table lookup with a switch case in
hrtimer_clockid_to_base() to avoid this warning.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/all/20250214134424.3367619-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/time/hrtimer.c | 29 ++++++++++++-----------------
 1 file changed, 12 insertions(+), 17 deletions(-)

diff --git a/kernel/time/hrtimer.c b/kernel/time/hrtimer.c
index db9c06bb23116..06fbc226341fd 100644
--- a/kernel/time/hrtimer.c
+++ b/kernel/time/hrtimer.c
@@ -117,16 +117,6 @@ DEFINE_PER_CPU(struct hrtimer_cpu_base, hrtimer_bases) =
 	.csd = CSD_INIT(retrigger_next_event, NULL)
 };
 
-static const int hrtimer_clock_to_base_table[MAX_CLOCKS] = {
-	/* Make sure we catch unsupported clockids */
-	[0 ... MAX_CLOCKS - 1]	= HRTIMER_MAX_CLOCK_BASES,
-
-	[CLOCK_REALTIME]	= HRTIMER_BASE_REALTIME,
-	[CLOCK_MONOTONIC]	= HRTIMER_BASE_MONOTONIC,
-	[CLOCK_BOOTTIME]	= HRTIMER_BASE_BOOTTIME,
-	[CLOCK_TAI]		= HRTIMER_BASE_TAI,
-};
-
 static inline bool hrtimer_base_is_online(struct hrtimer_cpu_base *base)
 {
 	if (!IS_ENABLED(CONFIG_HOTPLUG_CPU))
@@ -1597,14 +1587,19 @@ u64 hrtimer_next_event_without(const struct hrtimer *exclude)
 
 static inline int hrtimer_clockid_to_base(clockid_t clock_id)
 {
-	if (likely(clock_id < MAX_CLOCKS)) {
-		int base = hrtimer_clock_to_base_table[clock_id];
-
-		if (likely(base != HRTIMER_MAX_CLOCK_BASES))
-			return base;
+	switch (clock_id) {
+	case CLOCK_REALTIME:
+		return HRTIMER_BASE_REALTIME;
+	case CLOCK_MONOTONIC:
+		return HRTIMER_BASE_MONOTONIC;
+	case CLOCK_BOOTTIME:
+		return HRTIMER_BASE_BOOTTIME;
+	case CLOCK_TAI:
+		return HRTIMER_BASE_TAI;
+	default:
+		WARN(1, "Invalid clockid %d. Using MONOTONIC\n", clock_id);
+		return HRTIMER_BASE_MONOTONIC;
 	}
-	WARN(1, "Invalid clockid %d. Using MONOTONIC\n", clock_id);
-	return HRTIMER_BASE_MONOTONIC;
 }
 
 static void __hrtimer_init(struct hrtimer *timer, clockid_t clock_id,
-- 
2.39.5



