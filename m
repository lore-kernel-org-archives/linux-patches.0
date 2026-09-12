Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30AD047D93B;
	Sat, 12 Sep 2026 13:07:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789218435; cv=none; b=J3ZslLQWtrn7Qy+LtLEP6ueDtv1EqM0VK/eT7S5/g8bLKLqM50L9GfnoglpGoXgy+79eVaP3U4pWn8I+1aQ9aeCWOapWX2Dw2Lx4tR2xSqUo31zmPFuasJtbQaA3F/tgh2HtHkdrtt53j9nn6GE9HH4FEGT4WMj4bbmRekbgor8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789218435; c=relaxed/simple;
	bh=c7CpkO87U8V/7aDLMNCtxdVKkd1SCd/h41IdgrrD+dk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h+rI7CV5nm7+xPqXSSjxBtYtP/QCB1VSfB7D8+X/Vk2DYuC8tixkJyYy/Brp1zZi/xAJImtgZxs9y7/6oDH+R57AiK6DcfDdL7zS4q0MX1FL1G9rJZtC75VtXfv2Z3IZNaP7ZeRjyzBGimCneI4LOl2LW0NObTEM/7vBg4wVhBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MGVS8Ng8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MGVS8Ng8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E04871F000FF;
	Sat, 12 Sep 2026 13:07:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789218434;
	bh=3pMZ1xyc58hHjS/t3zAVLsPqq+iBlB4Dq1N+n9U67j0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MGVS8Ng8KjraXhBflnB8nQv3XZJPjd0Q152y6HLXlbMnpSkCl2yXg5nWAE4g5PfdL
	 opoLV3bfMUSvOJ9pvqEHjU7x0HAyr5HMYUQZA9nYphRcVcWXldF4CMyn2pNW6lyekD
	 R4hEQr8cAcjKolbmX+OgEK7apqIxyiKPG1jPYEuw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jia Yang <jia.yang@oss.qualcomm.com>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1143/1376] mailbox: qcom-cpucp: fix PREEMPT_RT self-deadlock in IRQ handler
Date: Sat, 12 Sep 2026 08:59:29 +0200
Message-ID: <20260912065633.031881281@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 44f4ed15f8184..f68298b2a1912 100644
--- a/drivers/mailbox/qcom-cpucp-mbox.c
+++ b/drivers/mailbox/qcom-cpucp-mbox.c
@@ -56,14 +56,25 @@ static irqreturn_t qcom_cpucp_mbox_irq_fn(int irq, void *data)
 	for_each_set_bit(i, (unsigned long *)&status, APSS_CPUCP_IPC_CHAN_SUPPORTED) {
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



