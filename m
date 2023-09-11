Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96E6F1170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:19:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18175C433C7;
	Mon, 11 Sep 2023 14:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694441940;
	bh=mghLdZhVXHiWOKJrjjWPBLyVbnl5BjhVdqA438YxjsE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=msiYY/JbIVxFWw+rwG6tnB2NS1+esCCB797ZeQbqX9x2tu6Bb77Mc+YDT5Fvedn+J
	 J4ToooboeUjIWyVCUTF+p+6hs8JKsi14Tgb+X8rl4U4Ecug+gxXltGcer/sbU3sk19
	 BF+osGA/chsLSbfMTr9Hcpu0cyP976MgHmlyVqSU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Gortmaker <paul.gortmaker@windriver.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ahmad Fatoum <a.fatoum@pengutronix.de>,
	Wen Yang <wenyang.linux@foxmail.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 590/739] tick/rcu: Fix false positive "softirq work is pending" messages
Date: Mon, 11 Sep 2023 15:46:29 +0200
Message-ID: <20230911134707.581318743@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Gortmaker <paul.gortmaker@windriver.com>

[ Upstream commit 96c1fa04f089a7e977a44e4e8fdc92e81be20bef ]

In commit 0345691b24c0 ("tick/rcu: Stop allowing RCU_SOFTIRQ in idle") the
new function report_idle_softirq() was created by breaking code out of the
existing can_stop_idle_tick() for kernels v5.18 and newer.

In doing so, the code essentially went from a one conditional:

	if (a && b && c)
		warn();

to a three conditional:

	if (!a)
		return;
	if (!b)
		return;
	if (!c)
		return;
	warn();

But that conversion got the condition for the RT specific
local_bh_blocked() wrong. The original condition was:

   	!local_bh_blocked()

but the conversion failed to negate it so it ended up as:

        if (!local_bh_blocked())
		return false;

This issue lay dormant until another fixup for the same commit was added
in commit a7e282c77785 ("tick/rcu: Fix bogus ratelimit condition").
This commit realized the ratelimit was essentially set to zero instead
of ten, and hence *no* softirq pending messages would ever be issued.

Once this commit was backported via linux-stable, both the v6.1 and v6.4
preempt-rt kernels started printing out 10 instances of this at boot:

  NOHZ tick-stop error: local softirq work is pending, handler #80!!!

Remove the negation and return when local_bh_blocked() evaluates to true to
bring the correct behaviour back.

Fixes: 0345691b24c0 ("tick/rcu: Stop allowing RCU_SOFTIRQ in idle")
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
Reviewed-by: Wen Yang <wenyang.linux@foxmail.com>
Acked-by: Frederic Weisbecker <frederic@kernel.org>
Link: https://lore.kernel.org/r/20230818200757.1808398-1-paul.gortmaker@windriver.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/time/tick-sched.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 4df14db4da490..87015e9deacc9 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -1045,7 +1045,7 @@ static bool report_idle_softirq(void)
 		return false;
 
 	/* On RT, softirqs handling may be waiting on some lock */
-	if (!local_bh_blocked())
+	if (local_bh_blocked())
 		return false;
 
 	pr_warn("NOHZ tick-stop error: local softirq work is pending, handler #%02x!!!\n",
-- 
2.40.1



