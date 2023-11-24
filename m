Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B2212C1A2;
	Fri, 24 Nov 2023 19:05:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jXzkb91h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE0CEC433C8;
	Fri, 24 Nov 2023 19:05:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700852745;
	bh=s37iXUcM/2RXLZSxuTPAUAGDSSh5Ylb+2BZqUpmip/w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jXzkb91hkfRW2Rcxt9Rc4I/mn8PEwWom3UoHfJkMOevI4Sp5Dvjs2yy7OE1W9a/i/
	 LVQV0+ORTLiy5oxksVvDK5Ndiqo2bN8D+oF9prezY4HcBMcyvxdGYCjn5zSVmPWjXa
	 IvJriFwpWVMr2an5cG9sdahfi+C/ChJFQx9rEKEs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krister Johansen <kjlx@templeofstupid.com>,
	Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH 5.10 105/193] watchdog: move softlockup_panic back to early_param
Date: Fri, 24 Nov 2023 17:53:52 +0000
Message-ID: <20231124171951.444128737@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124171947.127438872@linuxfoundation.org>
References: <20231124171947.127438872@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krister Johansen <kjlx@templeofstupid.com>

commit 8b793bcda61f6c3ed4f5b2ded7530ef6749580cb upstream.

Setting softlockup_panic from do_sysctl_args() causes it to take effect
later in boot.  The lockup detector is enabled before SMP is brought
online, but do_sysctl_args runs afterwards.  If a user wants to set
softlockup_panic on boot and have it trigger should a softlockup occur
during onlining of the non-boot processors, they could do this prior to
commit f117955a2255 ("kernel/watchdog.c: convert {soft/hard}lockup boot
parameters to sysctl aliases").  However, after this commit the value
of softlockup_panic is set too late to be of help for this type of
problem.  Restore the prior behavior.

Signed-off-by: Krister Johansen <kjlx@templeofstupid.com>
Cc: stable@vger.kernel.org
Fixes: f117955a2255 ("kernel/watchdog.c: convert {soft/hard}lockup boot parameters to sysctl aliases")
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/proc/proc_sysctl.c |    1 -
 kernel/watchdog.c     |    7 +++++++
 2 files changed, 7 insertions(+), 1 deletion(-)

--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -1767,7 +1767,6 @@ static const struct sysctl_alias sysctl_
 	{"hung_task_panic",			"kernel.hung_task_panic" },
 	{"numa_zonelist_order",			"vm.numa_zonelist_order" },
 	{"softlockup_all_cpu_backtrace",	"kernel.softlockup_all_cpu_backtrace" },
-	{"softlockup_panic",			"kernel.softlockup_panic" },
 	{ }
 };
 
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -176,6 +176,13 @@ static DEFINE_PER_CPU(unsigned long, hrt
 static DEFINE_PER_CPU(unsigned long, hrtimer_interrupts_saved);
 static unsigned long soft_lockup_nmi_warn;
 
+static int __init softlockup_panic_setup(char *str)
+{
+	softlockup_panic = simple_strtoul(str, NULL, 0);
+	return 1;
+}
+__setup("softlockup_panic=", softlockup_panic_setup);
+
 static int __init nowatchdog_setup(char *str)
 {
 	watchdog_user_enabled = 0;


