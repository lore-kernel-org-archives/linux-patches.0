Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05DED1C3318;
	Thu, 28 May 2026 20:28:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000128; cv=none; b=Hlxq3R2RjnoKsiDcxwd6QqIDP/+j3S123oZeLE5eIr6c9pK26R7lRpyp5sTBRMH6frpzpdCbtnqTsiFqVLABKo+bXFi0XMh/QS5jB3K9zsXsCyOkluocPiYE2fxI1QMxSuP05D1U2B/xMoTP37esvBJpb+e26a7Q+gE8iiexb1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000128; c=relaxed/simple;
	bh=VvzhCBqzQwcY1NeACeJW6pHU8eEsvB1257RfITwpmHk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V9/zeLwtvRo55NFZtDZqX+7ZIKi8/In4ujPVJl/y/Vu+gwWs20w8dPfFScAIRrc5HQfOBLqcUa5318NxWLn6M1F1J/tfu4nDiMEOvOacJnW6bfa4vss98mr8BzwqmxXqwr2JlE+lND9InfgnWpxJJnGhQ0H7z1y+GwzMcoR4UVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lRFlSp1Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lRFlSp1Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63BB51F000E9;
	Thu, 28 May 2026 20:28:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000126;
	bh=Vw3Jz0kmkHgXYMLSCh2DR/mUDlvZGjXtZQv8T7tt/44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lRFlSp1ZupfYdNKHnaaLtxmDsFmQ/ObN20ZINpzXrnc3d3/lh1PbnqQZY2HXeehbm
	 qEzaMdDRl8yulgL6RHQJ2BCOqQ7aMt9JJrViJy7f33+w3826RXfOZmzOxWpzFKFMOO
	 pVrWlax9ZmMxLOQEal4moykn+4cF99Tp37GbOva4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 275/377] x86/mce: Restore MCA polling interval halving
Date: Thu, 28 May 2026 21:48:33 +0200
Message-ID: <20260528194646.324473420@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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

From: Borislav Petkov (AMD) <bp@alien8.de>

[ Upstream commit ea324444ece9f301b5c4ff71b258cc68990c4d61 ]

RongQing reported that the MCA polling interval doesn't halve when an
error gets logged. It was traced down to the commit in Fixes:, because:

  mce_timer_fn()
  |-> mce_poll_banks()
  |-> machine_check_poll()
  |-> mce_log()

which will queue the work and return.

Now, back in mce_timer_fn():

        /*
         * Alert userspace if needed. If we logged an MCE, reduce the polling
         * interval, otherwise increase the polling interval.
         */
        if (mce_notify_irq())

<--- here we haven't ran the notifier chain yet so mce_need_notify is
not set yet so this won't hit and we won't halve the interval iv.

Now the notifier chain runs. mce_early_notifier() sets the bit, does
mce_notify_irq(), that clears the bit and then the notifier chain
a little later logs the error.

So this is a silly timing issue.

But, that's all unnecessary.

All it needs to happen here is, the "should we notify of a logged MCE"
mce_notify_irq() asks, should be simply a question to the mce gen pool:
"Are you empty?"

And that then turns into a simple yes or no answer and it all
JustWorks(tm).

So do that and also distribute the functionality where it belongs:
 - Print that MCE events have been logged in mce_log()
 - Trigger the mcelog tool specific work in the first notifier

As a result, mce_notify_irq() can go now.

Fixes: 011d82611172 ("RAS: Add a Corrected Errors Collector")
Reported-by: Li RongQing <lirongqing@baidu.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Tested-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Link: https://lore.kernel.org/r/20260112082747.2842-1-lirongqing@baidu.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/mce/core.c | 33 +++++----------------------------
 1 file changed, 5 insertions(+), 28 deletions(-)

diff --git a/arch/x86/kernel/cpu/mce/core.c b/arch/x86/kernel/cpu/mce/core.c
index 460e90a1a0b17..c8b112c6c5492 100644
--- a/arch/x86/kernel/cpu/mce/core.c
+++ b/arch/x86/kernel/cpu/mce/core.c
@@ -89,7 +89,6 @@ struct mca_config mca_cfg __read_mostly = {
 };
 
 static DEFINE_PER_CPU(struct mce_hw_err, hw_errs_seen);
-static unsigned long mce_need_notify;
 
 /*
  * MCA banks polled by the period polling timer for corrected events.
@@ -151,8 +150,10 @@ EXPORT_PER_CPU_SYMBOL_GPL(injectm);
 
 void mce_log(struct mce_hw_err *err)
 {
-	if (mce_gen_pool_add(err))
+	if (mce_gen_pool_add(err)) {
+		pr_info(HW_ERR "Machine check events logged\n");
 		irq_work_queue(&mce_irq_work);
+	}
 }
 EXPORT_SYMBOL_GPL(mce_log);
 
@@ -584,28 +585,6 @@ bool mce_is_correctable(struct mce *m)
 }
 EXPORT_SYMBOL_GPL(mce_is_correctable);
 
-/*
- * Notify the user(s) about new machine check events.
- * Can be called from interrupt context, but not from machine check/NMI
- * context.
- */
-static bool mce_notify_irq(void)
-{
-	/* Not more than two messages every minute */
-	static DEFINE_RATELIMIT_STATE(ratelimit, 60*HZ, 2);
-
-	if (test_and_clear_bit(0, &mce_need_notify)) {
-		mce_work_trigger();
-
-		if (__ratelimit(&ratelimit))
-			pr_info(HW_ERR "Machine check events logged\n");
-
-		return true;
-	}
-
-	return false;
-}
-
 static int mce_early_notifier(struct notifier_block *nb, unsigned long val,
 			      void *data)
 {
@@ -617,9 +596,7 @@ static int mce_early_notifier(struct notifier_block *nb, unsigned long val,
 	/* Emit the trace record: */
 	trace_mce_record(err);
 
-	set_bit(0, &mce_need_notify);
-
-	mce_notify_irq();
+	mce_work_trigger();
 
 	return NOTIFY_DONE;
 }
@@ -1771,7 +1748,7 @@ static void mce_timer_fn(struct timer_list *t)
 	 * Alert userspace if needed. If we logged an MCE, reduce the polling
 	 * interval, otherwise increase the polling interval.
 	 */
-	if (mce_notify_irq())
+	if (!mce_gen_pool_empty())
 		iv = max(iv / 2, (unsigned long) HZ/100);
 	else
 		iv = min(iv * 2, round_jiffies_relative(check_interval * HZ));
-- 
2.53.0



