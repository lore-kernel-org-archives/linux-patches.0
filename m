Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FA2B38AC92;
	Sat, 12 Sep 2026 09:02:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203768; cv=none; b=muocD46+cIZkaX9tXP3bw0OPcT6mwOJkFcJJ+/JuAPr4T3CVWi/zqA13EGAl7ghI/hvx1FA6uTgTQY+JVKaCNQkboEWJWJZVocPKOztHxeAS+K61qhobJ+MvqkrST2K6BBc/jQDPP8LyBK47t+ZbNtnJ4T4DwGsye/dA2vIl0Dg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203768; c=relaxed/simple;
	bh=wwFVbA9YuDMTFUDskUafBgoMgQWH1+PoGNbFbT90k3A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MZet8izqQb3du0NjihHcSz/84Pv4F+W3L6GDiNWlXiW4XlFNFBfcMsASGSr4Wo0lHl1S/JBoIgd3cGoo8sWTuw/GaS7VtfGgCXn5KR/2P+6REx8mUG1g8SHX94aghNaq6iHjOajLr7+nxqcV7Z3utB5tH0a+oQHQSpwoNQXhNFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NMP34WcZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NMP34WcZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 753D31F000FF;
	Sat, 12 Sep 2026 09:02:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203767;
	bh=mRn/RTLR0NztPxGWeZizNXrEE2l/DBhCoFS3+dh6400=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NMP34WcZjBhs7tHaR48t3lNTRSV5qHFtyJ905TfWGSBdf73dOLsfQtwSI6uSGWCwL
	 pMn3sbBLeEVWE4qM1FCV6msq4PptmTEKmKyVYaozHmPKTZP8Lr9NFwBjLZIQqGViZS
	 Q2CMkKVn2uNQA9nxGmeogAnp6+YPy4nz0acS1/Fo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jia Yang <jia.yang@oss.qualcomm.com>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1476/1815] mailbox: qcom-cpucp: fix PREEMPT_RT self-deadlock in IRQ handler
Date: Sat, 12 Sep 2026 08:53:46 +0200
Message-ID: <20260912065723.657946318@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jia Yang <jia.yang@oss.qualcomm.com>

[ Upstream commit 3690aaa6d18f6775c3e7932fb8af8c5bf6a6b69c ]

qcom_cpucp_mbox_irq_fn() calls mbox_chan_received_data() while holding
chan->lock. Under PREEMPT_RT, spin_lock_irqsave() is converted to an
rt_spinlock (rtmutex-based), which tracks ownership and can sleep.

The callback chain triggered by mbox_chan_received_data() eventually
reaches mailbox_clear_channel() -> mbox_send_message() -> add_to_rbuf(),
which attempts to re-acquire the same chan->lock. Since rtmutex detects
the re-entrant lock attempt by the same owner, the thread blocks waiting
for a lock it already holds, causing a permanent deadlock.

This deadlock manifests as 'irq/N-apss_cpucp_mbox' stuck in D state
with the following call trace:
  rt_spin_lock -> mbox_send_message -> mailbox_clear_channel ->
  scmi_rx_callback -> mbox_chan_received_data [<- held chan->lock here]

Fix by saving chan->cl locally and clearing the HW interrupt register
inside the lock, then invoking mbox_chan_received_data() after releasing
the lock. This preserves the mutual exclusion for chan->cl access while
avoiding the lock re-entrancy that causes the PREEMPT_RT deadlock.

Fixes: 0e2a9a03106c ("mailbox: Add support for QTI CPUCP mailbox controller")
Signed-off-by: Jia Yang <jia.yang@oss.qualcomm.com>
Signed-off-by: Jassi Brar <jassisinghbrar@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/qcom-cpucp-mbox.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/mailbox/qcom-cpucp-mbox.c b/drivers/mailbox/qcom-cpucp-mbox.c
index 862e45e8fbd58..0f7fe189e8b1f 100644
--- a/drivers/mailbox/qcom-cpucp-mbox.c
+++ b/drivers/mailbox/qcom-cpucp-mbox.c
@@ -63,14 +63,25 @@ static irqreturn_t qcom_cpucp_mbox_irq_fn(int irq, void *data)
 	for_each_set_bit(i, (unsigned long *)&status, cpucp->mbox.num_chans) {
 		u32 val = readl(cpucp->rx_base + APSS_CPUCP_RX_MBOX_CMD(i) + APSS_CPUCP_MBOX_CMD_OFF);
 		struct mbox_chan *chan = &cpucp->chans[i];
+		struct mbox_client *cl;
 		unsigned long flags;
 
-		/* Provide mutual exclusion with changes to chan->cl */
+		/*
+		 * Provide mutual exclusion with changes to chan->cl.
+		 * Save cl locally and clear the HW interrupt inside the lock,
+		 * then invoke mbox_chan_received_data() outside the lock to
+		 * avoid a PREEMPT_RT self-deadlock: mbox_chan_received_data()
+		 * can call back into mbox_send_message() via scmi_rx_callback()
+		 * -> mailbox_clear_channel(), which re-acquires chan->lock
+		 * (converted to an rt_spinlock under PREEMPT_RT).
+		 */
 		spin_lock_irqsave(&chan->lock, flags);
-		if (chan->cl)
-			mbox_chan_received_data(chan, &val);
+		cl = chan->cl;
 		writeq(BIT(i), cpucp->rx_base + APSS_CPUCP_RX_MBOX_CLEAR);
 		spin_unlock_irqrestore(&chan->lock, flags);
+
+		if (cl)
+			mbox_chan_received_data(chan, &val);
 	}
 
 	return IRQ_HANDLED;
-- 
2.53.0



