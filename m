Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EF68325710
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:49:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772300967; cv=none; b=cPEtNG3GheIpfxArt05wohGFh7nNnddUlz3xqdvUrMs1f4DKXRRSAsortd7z5wBoG7UZF3PGhN7C7aS0fLFJrRrAVMoMsmiClIqbK3RkZzQ3mG3QfCYYO86Mz7uhrDnR60v6HvAEA6fEGUuiV4D78CcI1BQo6IITD/pPxFHQUEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772300967; c=relaxed/simple;
	bh=qmhSjwrAXFUSiHBCb2qH3lHoG/iFuO65+VBFT9ezRaI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kp3PhH+3l7A66qQXK+oZpsJqZeKwfG2SIQoA++YgLfu4r01Ns3G39JpfIdl++GBnL07Fbi1b1yCq0/iTygvPevYJe7dX9u1XTPZFv924df+OQo0kl2ep/NSl7vGBd67Nksz81J8kS4kN7zxugJoRmPX3zj3rrajk2cMY1GmfMRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RmrwPeo8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RmrwPeo8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8262FC19425;
	Sat, 28 Feb 2026 17:49:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772300967;
	bh=qmhSjwrAXFUSiHBCb2qH3lHoG/iFuO65+VBFT9ezRaI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RmrwPeo871E/QM5H6whxD3bbAKG7dMkd3I+ULnVNRpLJEgbeYz8m+1+yz2AEIbiab
	 p/9OVi8MFKdY4z6TfWqxfiXYKfDKrmIo+GebLubsLuo3fUeFkG0ZbXvUYKUVzAB/ag
	 k/vBuNw9d+rDUsThS5oO1NokEXJUJrt77CZq7VHJhqK6aW/izEqNCiQbEgSICvbFbN
	 etmH9shiWxHqTqHHzQHKdwcNS3tXlDb9VDRFV+NhhT2NIqtWuEUmUAud3L7QVBqFK+
	 QjpQiEMWIlJO6nLBLTCX4AbaCLxquRxobye2XlsH1yU3gdKQ3lMI4TYSUeKdZbYO9L
	 eR3ydYeqtrHGQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 093/752] mailbox: bcm-ferxrm-mailbox: Use default primary handler
Date: Sat, 28 Feb 2026 12:36:44 -0500
Message-ID: <20260228174750.1542406-93-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

[ Upstream commit 03843d95a4a4e0ba22ad4fcda65ccf21822b104c ]

request_threaded_irq() is invoked with a primary and a secondary handler
and no flags are passed. The primary handler is the same as
irq_default_primary_handler() so there is no need to have an identical
copy.

The lack of the IRQF_ONESHOT flag can be dangerous because the interrupt
source is not masked while the threaded handler is active. This means,
especially on LEVEL typed interrupt lines, the interrupt can fire again
before the threaded handler had a chance to run.

Use the default primary interrupt handler by specifying NULL and set
IRQF_ONESHOT so the interrupt source is masked until the secondary handler
is done.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Link: https://patch.msgid.link/20260128095540.863589-5-bigeasy@linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/bcm-flexrm-mailbox.c | 14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

diff --git a/drivers/mailbox/bcm-flexrm-mailbox.c b/drivers/mailbox/bcm-flexrm-mailbox.c
index 41f79e51d9e5a..4255fefc3a5a0 100644
--- a/drivers/mailbox/bcm-flexrm-mailbox.c
+++ b/drivers/mailbox/bcm-flexrm-mailbox.c
@@ -1173,14 +1173,6 @@ static int flexrm_debugfs_stats_show(struct seq_file *file, void *offset)
 
 /* ====== FlexRM interrupt handler ===== */
 
-static irqreturn_t flexrm_irq_event(int irq, void *dev_id)
-{
-	/* We only have MSI for completions so just wakeup IRQ thread */
-	/* Ring related errors will be informed via completion descriptors */
-
-	return IRQ_WAKE_THREAD;
-}
-
 static irqreturn_t flexrm_irq_thread(int irq, void *dev_id)
 {
 	flexrm_process_completions(dev_id);
@@ -1271,10 +1263,8 @@ static int flexrm_startup(struct mbox_chan *chan)
 		ret = -ENODEV;
 		goto fail_free_cmpl_memory;
 	}
-	ret = request_threaded_irq(ring->irq,
-				   flexrm_irq_event,
-				   flexrm_irq_thread,
-				   0, dev_name(ring->mbox->dev), ring);
+	ret = request_threaded_irq(ring->irq, NULL, flexrm_irq_thread,
+				   IRQF_ONESHOT, dev_name(ring->mbox->dev), ring);
 	if (ret) {
 		dev_err(ring->mbox->dev,
 			"failed to request ring%d IRQ\n", ring->num);
-- 
2.51.0

