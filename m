Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D5D98BE0
	for <patches@lists.linux.dev>; Tue, 28 Mar 2023 15:09:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24B9AC433D2;
	Tue, 28 Mar 2023 15:09:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680016194;
	bh=bi/be8Q5qAxoSaDo4VTQmTpZr1Y/FUdfULkl/EQS38M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n9essiE8Qk9StB45Q3Ax5E0xBCNabcVZ4Hb1c0dfjAeeDOouRq3KwYQCkJo8zW+9Y
	 Z83GPx9Lck+cpsJm/QbvISMxrJoaU+kR0sm92dzkUr7L0NXPtBdqIvqsAiK2IbINSD
	 /36CR+mzvvrWzlSEhayC78mQUD7y4E61ZRy2huSY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Rutland <mark.rutland@arm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 069/146] entry: Snapshot thread flags
Date: Tue, 28 Mar 2023 16:42:38 +0200
Message-Id: <20230328142605.595981420@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142602.660084725@linuxfoundation.org>
References: <20230328142602.660084725@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mark Rutland <mark.rutland@arm.com>

[ Upstream commit 6ce895128b3bff738fe8d9dd74747a03e319e466 ]

Some thread flags can be set remotely, and so even when IRQs are disabled,
the flags can change under our feet. Generally this is unlikely to cause a
problem in practice, but it is somewhat unsound, and KCSAN will
legitimately warn that there is a data race.

To avoid such issues, a snapshot of the flags has to be taken prior to
using them. Some places already use READ_ONCE() for that, others do not.

Convert them all to the new flag accessor helpers.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Paul E. McKenney <paulmck@kernel.org>
Link: https://lore.kernel.org/r/20211129130653.2037928-3-mark.rutland@arm.com
Stable-dep-of: b41651405481 ("entry/rcu: Check TIF_RESCHED _after_ delayed RCU wake-up")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/entry-kvm.h | 2 +-
 kernel/entry/common.c     | 4 ++--
 kernel/entry/kvm.c        | 4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/linux/entry-kvm.h b/include/linux/entry-kvm.h
index 0d7865a0731ce..07c878d6e323e 100644
--- a/include/linux/entry-kvm.h
+++ b/include/linux/entry-kvm.h
@@ -75,7 +75,7 @@ static inline void xfer_to_guest_mode_prepare(void)
  */
 static inline bool __xfer_to_guest_mode_work_pending(void)
 {
-	unsigned long ti_work = READ_ONCE(current_thread_info()->flags);
+	unsigned long ti_work = read_thread_flags();
 
 	return !!(ti_work & XFER_TO_GUEST_MODE_WORK);
 }
diff --git a/kernel/entry/common.c b/kernel/entry/common.c
index 998bdb7b8bf7f..3ce3a0a6c762e 100644
--- a/kernel/entry/common.c
+++ b/kernel/entry/common.c
@@ -187,7 +187,7 @@ static unsigned long exit_to_user_mode_loop(struct pt_regs *regs,
 		/* Check if any of the above work has queued a deferred wakeup */
 		tick_nohz_user_enter_prepare();
 
-		ti_work = READ_ONCE(current_thread_info()->flags);
+		ti_work = read_thread_flags();
 	}
 
 	/* Return the latest work state for arch_exit_to_user_mode() */
@@ -196,7 +196,7 @@ static unsigned long exit_to_user_mode_loop(struct pt_regs *regs,
 
 static void exit_to_user_mode_prepare(struct pt_regs *regs)
 {
-	unsigned long ti_work = READ_ONCE(current_thread_info()->flags);
+	unsigned long ti_work = read_thread_flags();
 
 	lockdep_assert_irqs_disabled();
 
diff --git a/kernel/entry/kvm.c b/kernel/entry/kvm.c
index 49972ee99aff6..96d476e06c777 100644
--- a/kernel/entry/kvm.c
+++ b/kernel/entry/kvm.c
@@ -26,7 +26,7 @@ static int xfer_to_guest_mode_work(struct kvm_vcpu *vcpu, unsigned long ti_work)
 		if (ret)
 			return ret;
 
-		ti_work = READ_ONCE(current_thread_info()->flags);
+		ti_work = read_thread_flags();
 	} while (ti_work & XFER_TO_GUEST_MODE_WORK || need_resched());
 	return 0;
 }
@@ -43,7 +43,7 @@ int xfer_to_guest_mode_handle_work(struct kvm_vcpu *vcpu)
 	 * disabled in the inner loop before going into guest mode. No need
 	 * to disable interrupts here.
 	 */
-	ti_work = READ_ONCE(current_thread_info()->flags);
+	ti_work = read_thread_flags();
 	if (!(ti_work & XFER_TO_GUEST_MODE_WORK))
 		return 0;
 
-- 
2.39.2



