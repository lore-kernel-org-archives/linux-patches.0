Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C871132B116;
	Thu, 30 Jul 2026 15:00:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423655; cv=none; b=eSo0hiK2GtUZlZr/GDbFnzV6JauCqgQAXfGDRPbkp6i0DWcfftYj/Pn6y8U0ULJ1ZVf+hGd/P/hNQWPoDQUTS5fXbarJd05qFC5VatdzZHE6MEF87yMmmDaZ6DH1PHumpi/JfbhHQr/u6OR4PIBrUapG5xJ1dEjoV990hTvuJG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423655; c=relaxed/simple;
	bh=9QeVthUg6greStmAJ3OpkdQU8KncjGHGpBe+mi6qKow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qw109XbJs0jDNNgg3l1SD2b142N+6Ifx4op1jislF76BCF1CmXAQi9POflpVFBUBOT4jCqKttdyFYy98GLURDQZi7tUndb/+SXsKMpB6b1El8OPJcqZcmZ2T08txsUfGcwpHxRu7UuwKxIoj78ExRtao0PugDQI2eIGh8JZr32o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZWfGtz7L; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZWfGtz7L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3001E1F000E9;
	Thu, 30 Jul 2026 15:00:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423654;
	bh=m36cWsgS84vL6sX4hTzCsh1Ovw5iZvoTbtuKENuQ9jc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZWfGtz7Lh6IovDAAvZ4MYvoH6VzrCjBFD5G1YukgYptQfmylnGZml3XshI8l8Mql9
	 RgtkhNyLw3EN0jYNoruoYbaJoXZ5NqmZu5xtD982h1z3/L4fg/neJUDHIctw0biz3P
	 KNsuq0Q3zm7uFEaursjDnrpukN5c6/kZikiza83I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 118/675] powerpc/vtime: Initialize starttime at boot for native accounting
Date: Thu, 30 Jul 2026 16:07:28 +0200
Message-ID: <20260730141447.652509857@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

From: Shrikanth Hegde <sshegde@linux.ibm.com>

[ Upstream commit c1c1ffa490fc33591e90852ed0d38804dd20bc36 ]

It was observed that /proc/stat had very large value for one ore more
CPUs. It was more visible after recent code simplifications around
cpustats.

System has 240 CPUs.

cat /proc/uptime;
194.18 46500.55
cat /proc/stat
cpu  5966 39 837032887 4650070 164 185 100 0 0 0
cpu0 108 0 837030890 19109 24 4 23 0 0 0

Since uptime is 194s, system time of each CPU can't be more than 19400.
Sum of system time  of all CPUs can't be more than 19400*240 4656000.
In fact huge value is close to mftb(). Note mftb doesn't reset on powerVM
when the LPAR restart. It only resets when whole system resets. The same
issue exists for kexec too.

This happens since starttime is not setup at init time. Once it is set
then subsequent vtime_delta will return the right delta.

Fix it by initializing the starttime during CPU initialization. This
fixes the large times seen.

cat /proc/uptime; cat /proc/stat
15.78 3694.63
cpu  6035 35 1347 369479 23 144 49 0 0 0
cpu0 19 0 38 1508 0 1 14 0 0 0

Now, system time is reported as expected.

Fixes: cf9efce0ce31 ("powerpc: Account time using timebase rather  than PURR")
Reviewed-by: Christophe Leroy (CS GROUP) <chleroy@kernel.org>
Suggested-by: Christophe Leroy (CS GROUP) <chleroy@kernel.org>
Signed-off-by: Shrikanth Hegde <sshegde@linux.ibm.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20260605124329.377533-1-sshegde@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/time.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/time.c b/arch/powerpc/kernel/time.c
index 3460d1a5a97c2a..11145c40183dd1 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -377,7 +377,6 @@ void vtime_task_switch(struct task_struct *prev)
 	}
 }
 
-#ifdef CONFIG_NO_HZ_COMMON
 /**
  * vtime_reset - Fast forward vtime entry clocks
  *
@@ -394,6 +393,7 @@ void vtime_reset(void)
 #endif
 }
 
+#ifdef CONFIG_NO_HZ_COMMON
 /**
  * vtime_dyntick_start - Inform vtime about entry to idle-dynticks
  *
@@ -933,6 +933,7 @@ static void __init set_decrementer_max(void)
 static void __init init_decrementer_clockevent(void)
 {
 	register_decrementer_clockevent(smp_processor_id());
+	vtime_reset();
 }
 
 void secondary_cpu_time_init(void)
@@ -948,6 +949,7 @@ void secondary_cpu_time_init(void)
 	/* FIME: Should make unrelated change to move snapshot_timebase
 	 * call here ! */
 	register_decrementer_clockevent(smp_processor_id());
+	vtime_reset();
 }
 
 /*
-- 
2.53.0



