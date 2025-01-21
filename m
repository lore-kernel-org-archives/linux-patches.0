Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 044F81F4275;
	Tue, 21 Jan 2025 18:03:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482592; cv=none; b=U7dJZxbDds7VGxYNDLwYNNoAkflvt5pXwJv3DUpnhqQtavjaMAgwQp4HyRIKX/uTDzSdMm4hRIaNLG6ADgP7F+1KXdlOb9bnTDIEgtAFgo7y6g/L+C+cXWmgBQd4gRmPqLEClbvznBVqHMtCF9Zwi2XgrhK/itRDvE4zkjBBQu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482592; c=relaxed/simple;
	bh=HuAwQqCjBxPjnqafluIV/yDNARuGzgcq3/aEjc5lrQI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KcwJEuOlLzCGuhji6yb3osQr/PPph7EF1PiC7vdyZR8FW4IbxPuYD01INrpjqSx4LtVINkoL26egEippPD5LpWpJ7Zc0HRx6RblRnwNH7dp/Z7qZalgzQqrxpMAEb5CqMFOhHmSNbnXM9emSdg8wqaaakUiFcdPfT7Pq9Gn2ZTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Er6vwevO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Er6vwevO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73D61C4CEDF;
	Tue, 21 Jan 2025 18:03:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482591;
	bh=HuAwQqCjBxPjnqafluIV/yDNARuGzgcq3/aEjc5lrQI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Er6vwevOknHsDPzmTuh7Ot+ABJJ6xMFv/L+RDolE8NjMI76ROGEeusMXCIOv99CbQ
	 NeX2Rdb4EhXxR6jmsG9zSDWa0lEpO/1qGVCH2fH5QlbBEu1SDABVlZ9IlpYaMwFSl6
	 GPznY4hRm4otPQn4uL5FVE1A7fTdR745xMPrtrxc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yogesh Lal <quic_ylal@quicinc.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 6.12 104/122] irqchip/gic-v3: Handle CPU_PM_ENTER_FAILED correctly
Date: Tue, 21 Jan 2025 18:52:32 +0100
Message-ID: <20250121174537.048718499@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174532.991109301@linuxfoundation.org>
References: <20250121174532.991109301@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Yogesh Lal <quic_ylal@quicinc.com>

commit 0d62a49ab55c99e8deb4593b8d9f923de1ab5c18 upstream.

When a CPU attempts to enter low power mode, it disables the redistributor
and Group 1 interrupts and reinitializes the system registers upon wakeup.

If the transition into low power mode fails, then the CPU_PM framework
invokes the PM notifier callback with CPU_PM_ENTER_FAILED to allow the
drivers to undo the state changes.

The GIC V3 driver ignores CPU_PM_ENTER_FAILED, which leaves the GIC in
disabled state.

Handle CPU_PM_ENTER_FAILED in the same way as CPU_PM_EXIT to restore normal
operation.

[ tglx: Massage change log, add Fixes tag ]

Fixes: 3708d52fc6bb ("irqchip: gic-v3: Implement CPU PM notifier")
Signed-off-by: Yogesh Lal <quic_ylal@quicinc.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/all/20241220093907.2747601-1-quic_ylal@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/irqchip/irq-gic-v3.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/irqchip/irq-gic-v3.c
+++ b/drivers/irqchip/irq-gic-v3.c
@@ -1522,7 +1522,7 @@ static int gic_retrigger(struct irq_data
 static int gic_cpu_pm_notifier(struct notifier_block *self,
 			       unsigned long cmd, void *v)
 {
-	if (cmd == CPU_PM_EXIT) {
+	if (cmd == CPU_PM_EXIT || cmd == CPU_PM_ENTER_FAILED) {
 		if (gic_dist_security_disabled())
 			gic_enable_redist(true);
 		gic_cpu_sys_reg_enable();


