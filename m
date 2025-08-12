Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8D5B1A9F9B;
	Tue, 12 Aug 2025 18:30:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023409; cv=none; b=e7s4/BMCnGbBcaCrbaHfoP91i5eF2KcAeA6oXE2tx5FnbUMPRG4nxNsksAMh0I853ZsflqnIne4pOHZmsOH5aYAfxA1DKQfm3DEb4fXz5Hig/ie9BkLaTX7MrVpUWjfEHPTGioa1JgHXfLtnKzcMAFU234lyAw2iec5my+Sk7Lk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023409; c=relaxed/simple;
	bh=fl/4GkvEPBdxd1ub4dFcpsYUCvH53O+j4SMrWEoSZj0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qosNdemv4Kxgreul9S4h+sZkH44mSnQt/dpSCZxLeu1zpbJuc5FFFT9MRwk4zMs/AnGxtVTDwUX+TeRpBFsh+MtHOtBI+s1x4cPf/oiah2F6kCLqB0ecD8uOXIrMayZ9ue9tk4GqeFxzgufgFNGej24jk4623q3nUphtw0lS8r4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y60MtRhI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y60MtRhI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39F34C4CEF0;
	Tue, 12 Aug 2025 18:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023409;
	bh=fl/4GkvEPBdxd1ub4dFcpsYUCvH53O+j4SMrWEoSZj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y60MtRhIVDi1LM5uU+peXoWa1Sv8tn63u2F+rI/iYUy8gLzvJz9/onRPpdifVE5Cv
	 tcD3Jw+ANrPrcvKltoS5GibErk5bXmO9KKw5thtmAjRYWhoJMECi7Rxvvowq0crgcp
	 sPakFHoWUFdl9Wlw1khY9xIlHKdt2L315FSTOXg8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hansg@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 072/627] mei: vsc: Fix "BUG: Invalid wait context" lockdep error
Date: Tue, 12 Aug 2025 19:26:07 +0200
Message-ID: <20250812173422.049883369@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hansg@kernel.org>

[ Upstream commit cee3dba7b7416c02ff3cd27489f82859cc852532 ]

Kernels build with CONFIG_PROVE_RAW_LOCK_NESTING report the following
tp-vsc lockdep error:

=============================
 [ BUG: Invalid wait context ]
 ...
 swapper/10/0 is trying to lock:
 ffff88819c271888 (&tp->xfer_wait){....}-{3:3},
  at: __wake_up (kernel/sched/wait.c:106 kernel/sched/wait.c:127)
 ...
 Call Trace:
 <IRQ>
 ...
 __raw_spin_lock_irqsave (./include/linux/spinlock_api_smp.h:111)
 __wake_up (kernel/sched/wait.c:106 kernel/sched/wait.c:127)
 vsc_tp_isr (drivers/misc/mei/vsc-tp.c:110) mei_vsc_hw
 __handle_irq_event_percpu (kernel/irq/handle.c:158)
 handle_irq_event (kernel/irq/handle.c:195 kernel/irq/handle.c:210)
 handle_edge_irq (kernel/irq/chip.c:833)
 ...
 </IRQ>

The root-cause of this is the IRQF_NO_THREAD flag used by the intel-pinctrl
code. Setting IRQF_NO_THREAD requires all interrupt handlers for GPIO ISRs
to use raw-spinlocks only since normal spinlocks can sleep in PREEMPT-RT
kernels and with IRQF_NO_THREAD the interrupt handlers will always run in
an atomic context [1].

vsc_tp_isr() calls wake_up(&tp->xfer_wait), which uses a regular spinlock,
breaking the raw-spinlocks only rule for Intel GPIO ISRs.

Make vsc_tp_isr() run as threaded ISR instead of as hard ISR to fix this.

Fixes: 566f5ca97680 ("mei: Add transport driver for IVSC device")
Link: https://lore.kernel.org/linux-gpio/18ab52bd-9171-4667-a600-0f52ab7017ac@kernel.org/ [1]
Signed-off-by: Hans de Goede <hansg@kernel.org>
Link: https://lore.kernel.org/r/20250623085052.12347-10-hansg@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/mei/vsc-tp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/misc/mei/vsc-tp.c b/drivers/misc/mei/vsc-tp.c
index b654ea59f305..0de5acc33b74 100644
--- a/drivers/misc/mei/vsc-tp.c
+++ b/drivers/misc/mei/vsc-tp.c
@@ -497,7 +497,7 @@ static int vsc_tp_probe(struct spi_device *spi)
 	tp->spi = spi;
 
 	irq_set_status_flags(spi->irq, IRQ_DISABLE_UNLAZY);
-	ret = request_threaded_irq(spi->irq, vsc_tp_isr, NULL,
+	ret = request_threaded_irq(spi->irq, NULL, vsc_tp_isr,
 				   IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
 				   dev_name(dev), tp);
 	if (ret)
-- 
2.39.5



