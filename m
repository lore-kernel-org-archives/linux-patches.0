Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19DC98F74
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:01:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90B6FC433C7;
	Sun, 16 Jul 2023 20:01:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689537694;
	bh=aTLESNbkRoZX2Rd0l2zF0DiOZiaJga7dPSpsHpocv0w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uLN8qCs5887bz47hLEuLOM0xPCP/oXog96l4Y2O1lgGncU2qdCBgQ2vJ76Ny/h2Ut
	 OaWjbKih/WJx6i4Nw+609hpwjsORrH/ODK0YfSh0f/4bFf3TaMTlsWbnQh6b/GLbiC
	 Qa0jW5OlrB1rlRaGby3PQnzSu6NXJ7hXtmRHnvoU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Douglas Anderson <dianders@chromium.org>,
	Petr Mladek <pmladek@suse.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	"David S. Miller" <davem@davemloft.net>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 188/800] watchdog/hardlockup: keep kernel.nmi_watchdog sysctl as 0444 if probe fails
Date: Sun, 16 Jul 2023 21:40:41 +0200
Message-ID: <20230716194953.471837938@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Douglas Anderson <dianders@chromium.org>

[ Upstream commit 9ec272c586b07d1abf73438524bd12b1df9c5f9b ]

Patch series "watchdog: Cleanup / fixes after buddy series v5 reviews".

This patch series attempts to finish resolving the feedback received
from Petr Mladek on the v5 series I posted.

Probably the only thing that wasn't fully as clean as Petr requested was
the Kconfig stuff.  I couldn't find a better way to express it without a
more major overhaul.  In the very least, I renamed "NON_ARCH" to
"PERF_OR_BUDDY" in the hopes that will make it marginally better.

Nothing in this series is terribly critical and even the bugfixes are
small.  However, it does cleanup a few things that were pointed out in
review.

This patch (of 10):

The permissions for the kernel.nmi_watchdog sysctl have always been set at
compile time despite the fact that a watchdog can fail to probe.  Let's
fix this and set the permissions based on whether the hardlockup detector
actually probed.

Link: https://lkml.kernel.org/r/20230527014153.2793931-1-dianders@chromium.org
Link: https://lkml.kernel.org/r/20230526184139.1.I0d75971cc52a7283f495aac0bd5c3041aadc734e@changeid
Fixes: a994a3147e4c ("watchdog/hardlockup/perf: Implement init time detection of perf")
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Reported-by: Petr Mladek <pmladek@suse.com>
Closes: https://lore.kernel.org/r/ZHCn4hNxFpY5-9Ki@alley
Reviewed-by: Petr Mladek <pmladek@suse.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/nmi.h |  6 ------
 kernel/watchdog.c   | 30 ++++++++++++++++++++----------
 2 files changed, 20 insertions(+), 16 deletions(-)

diff --git a/include/linux/nmi.h b/include/linux/nmi.h
index c4f58baf7ccb2..d54b9ba9c8247 100644
--- a/include/linux/nmi.h
+++ b/include/linux/nmi.h
@@ -91,12 +91,6 @@ static inline void hardlockup_detector_disable(void) {}
 void watchdog_hardlockup_check(struct pt_regs *regs);
 #endif
 
-#if defined(CONFIG_HAVE_NMI_WATCHDOG) || defined(CONFIG_HARDLOCKUP_DETECTOR)
-# define NMI_WATCHDOG_SYSCTL_PERM	0644
-#else
-# define NMI_WATCHDOG_SYSCTL_PERM	0444
-#endif
-
 #if defined(CONFIG_HARDLOCKUP_DETECTOR_PERF)
 extern void arch_touch_nmi_watchdog(void);
 extern void hardlockup_detector_perf_stop(void);
diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index f2e991894af62..6b1754e8b6e96 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -830,15 +830,6 @@ static struct ctl_table watchdog_sysctls[] = {
 		.extra1		= SYSCTL_ZERO,
 		.extra2		= (void *)&sixty,
 	},
-	{
-		.procname       = "nmi_watchdog",
-		.data		= &watchdog_hardlockup_user_enabled,
-		.maxlen		= sizeof(int),
-		.mode		= NMI_WATCHDOG_SYSCTL_PERM,
-		.proc_handler   = proc_nmi_watchdog,
-		.extra1		= SYSCTL_ZERO,
-		.extra2		= SYSCTL_ONE,
-	},
 	{
 		.procname	= "watchdog_cpumask",
 		.data		= &watchdog_cpumask_bits,
@@ -902,10 +893,28 @@ static struct ctl_table watchdog_sysctls[] = {
 	{}
 };
 
+static struct ctl_table watchdog_hardlockup_sysctl[] = {
+	{
+		.procname       = "nmi_watchdog",
+		.data		= &watchdog_hardlockup_user_enabled,
+		.maxlen		= sizeof(int),
+		.mode		= 0444,
+		.proc_handler   = proc_nmi_watchdog,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_ONE,
+	},
+	{}
+};
+
 static void __init watchdog_sysctl_init(void)
 {
 	register_sysctl_init("kernel", watchdog_sysctls);
+
+	if (watchdog_hardlockup_available)
+		watchdog_hardlockup_sysctl[0].mode = 0644;
+	register_sysctl_init("kernel", watchdog_hardlockup_sysctl);
 }
+
 #else
 #define watchdog_sysctl_init() do { } while (0)
 #endif /* CONFIG_SYSCTL */
@@ -961,6 +970,8 @@ static int __init lockup_detector_check(void)
 	/* Make sure no work is pending. */
 	flush_work(&detector_work);
 
+	watchdog_sysctl_init();
+
 	return 0;
 
 }
@@ -980,5 +991,4 @@ void __init lockup_detector_init(void)
 		allow_lockup_detector_init_retry = true;
 
 	lockup_detector_setup();
-	watchdog_sysctl_init();
 }
-- 
2.39.2



