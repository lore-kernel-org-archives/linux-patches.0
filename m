Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51ED41D6B6
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:36:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WX5u1l7q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C75B0C433C7;
	Wed,  4 Oct 2023 18:36:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696444591;
	bh=wbwfJ0itzcuIv3JZd0SIsq69uqbZ0e6SLW4akD8yyKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WX5u1l7qP4/cx8+qB9ccsr883x6SlPOfzm7qeRfvZg6zflO840u4ZRHxEr6ct08Z8
	 2Uw5U4o7uC6h9+GBOEEtBsHaoTpAZe3Pws/Xkzu0s/ccJyOpTWnbRD+0EH+CXHgDzs
	 iWccf1m+BqwE7GruqQgUVdNt4kI7F51WaRtztcwM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frederic Weisbecker <frederic@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	"Joel Fernandes (Google)" <joel@joelfernandes.org>
Subject: [PATCH 6.5 276/321] timers: Tag (hr)timer softirq as hotplug safe
Date: Wed,  4 Oct 2023 19:57:01 +0200
Message-ID: <20231004175242.075544293@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175229.211487444@linuxfoundation.org>
References: <20231004175229.211487444@linuxfoundation.org>
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

From: Frederic Weisbecker <frederic@kernel.org>

commit 1a6a464774947920dcedcf7409be62495c7cedd0 upstream.

Specific stress involving frequent CPU-hotplug operations, such as
running rcutorture for example, may trigger the following message:

  NOHZ tick-stop error: local softirq work is pending, handler #02!!!"

This happens in the CPU-down hotplug process, after
CPUHP_AP_SMPBOOT_THREADS whose teardown callback parks ksoftirqd, and
before the target CPU shuts down through CPUHP_AP_IDLE_DEAD. In this
fragile intermediate state, softirqs waiting for threaded handling may be
forever ignored and eventually reported by the idle task as in the above
example.

However some vectors are known to be safe as long as the corresponding
subsystems have teardown callbacks handling the migration of their
events. The above error message reports pending timers softirq although
this vector can be considered as hotplug safe because the
CPUHP_TIMERS_PREPARE teardown callback performs the necessary migration
of timers after the death of the CPU. Hrtimers also have a similar
hotplug handling.

Therefore this error message, as far as (hr-)timers are concerned, can
be considered spurious and the relevant softirq vectors can be marked as
hotplug safe.

Fixes: 0345691b24c0 ("tick/rcu: Stop allowing RCU_SOFTIRQ in idle")
Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Joel Fernandes (Google) <joel@joelfernandes.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20230912104406.312185-6-frederic@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/interrupt.h |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -569,8 +569,12 @@ enum
  * 	2) rcu_report_dead() reports the final quiescent states.
  *
  * _ IRQ_POLL: irq_poll_cpu_dead() migrates the queue
+ *
+ * _ (HR)TIMER_SOFTIRQ: (hr)timers_dead_cpu() migrates the queue
  */
-#define SOFTIRQ_HOTPLUG_SAFE_MASK (BIT(RCU_SOFTIRQ) | BIT(IRQ_POLL_SOFTIRQ))
+#define SOFTIRQ_HOTPLUG_SAFE_MASK (BIT(TIMER_SOFTIRQ) | BIT(IRQ_POLL_SOFTIRQ) |\
+				   BIT(HRTIMER_SOFTIRQ) | BIT(RCU_SOFTIRQ))
+
 
 /* map softirq index to softirq name. update 'softirq_to_name' in
  * kernel/softirq.c when adding a new softirq.


