Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E51D62F260C;
	Thu, 28 May 2026 20:06:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998804; cv=none; b=ee79MaSFtMUpjHP29A/Lt2vuslwKAvFvp3jYBbqyPc42/seFpq29crReQigKIBsdBTveSgXmBI9A3gH/pFdYBqmiMO+nIn61FIistMXr16NY2aQ2LfgMSot/bp8W4rstsZDYYxJTKXKylHcXsKWmrd9tyBYpfkiyamd+O6cMrjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998804; c=relaxed/simple;
	bh=+QIgEQZXJmGhPa/RQaZG7oNkaWWIRIpTG8grnK1uYqc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iEXrn5qgGJfC5CPEpQeUMG3tEKdqR5w5KnekK+jkJnAwcWm9tYM8sKXkLY8OL1ovpTEQU7gE7US7jzaofs0aSbOOK67RIGVJrONkIuG1K8WaAW2TAtbh9hitdNTCLYxhL64N1JphW+FGudR/BrMpxVuWL3xEJOIkY+F1Z3wILV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=owACfsh+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="owACfsh+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E9011F000E9;
	Thu, 28 May 2026 20:06:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998802;
	bh=c56OjHFlmSaCLMxkcq4uIQT7uwXK54jOekbpNKrPAEo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=owACfsh+98lxoLifae7K0FoEfkZo8H/8jNsexBAstpZH2X8DtWUxqpShp6mM/dBTn
	 +imMGYDbtBSdzVNe16KVaSqXjjZ/Ile4HO/XB7Fy4SvA53cGROxQWNtK5KivkGclN0
	 /xbv9df4T48aFdhJSw5d+GwgRA2i13YItY0LEVD4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 302/461] x86/mce: Restore MCA polling interval halving
Date: Thu, 28 May 2026 21:47:11 +0200
Message-ID: <20260528194655.987083809@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index 8dd424ac5de8a..f3a793e3a6c8f 100644
--- a/arch/x86/kernel/cpu/mce/core.c
+++ b/arch/x86/kernel/cpu/mce/core.c
@@ -90,7 +90,6 @@ struct mca_config mca_cfg __read_mostly = {
 };
 
 static DEFINE_PER_CPU(struct mce_hw_err, hw_errs_seen);
-static unsigned long mce_need_notify;
 
 /*
  * MCA banks polled by the period polling timer for corrected events.
@@ -152,8 +151,10 @@ EXPORT_PER_CPU_SYMBOL_GPL(injectm);
 
 void mce_log(struct mce_hw_err *err)
 {
-	if (mce_gen_pool_add(err))
+	if (mce_gen_pool_add(err)) {
+		pr_info(HW_ERR "Machine check events logged\n");
 		irq_work_queue(&mce_irq_work);
+	}
 }
 EXPORT_SYMBOL_GPL(mce_log);
 
@@ -585,28 +586,6 @@ bool mce_is_correctable(struct mce *m)
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
@@ -618,9 +597,7 @@ static int mce_early_notifier(struct notifier_block *nb, unsigned long val,
 	/* Emit the trace record: */
 	trace_mce_record(err);
 
-	set_bit(0, &mce_need_notify);
-
-	mce_notify_irq();
+	mce_work_trigger();
 
 	return NOTIFY_DONE;
 }
@@ -1804,7 +1781,7 @@ static void mce_timer_fn(struct timer_list *t)
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



