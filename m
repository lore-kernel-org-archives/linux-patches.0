Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CAB62517BE;
	Tue, 29 Apr 2025 18:04:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949872; cv=none; b=mcoYm/gHFnpe6zdOmKZPGVOlsmUTSg1S3YJsYQkXS/3oX2y0kVXwWIi5YA86Oa1UPO8wE9zoL4PYFNvYX78JzpA4wXpmGv+03L+20a4Sd8CfGt9wZpGZB87HxOH3aLza/PF5OZoBOBnfFHkrNkcz3YYLLVF/bPym/pkp7ANLaEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949872; c=relaxed/simple;
	bh=Ii9nqpvq64Pi7tMHCCS4/fk3f1qEspuX8067h99F528=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=muyZL4rCMihQcs9yIIoKyt4wfgQXoxlxc5wWeX0qczfDC8FDV5mvKFcLXLGH01rZupRfRguMECMyZx2WQoM8UfK5w9s6JinRc22pCTNCl3GqXUlyH2lo94HgQTAGdsmigjSAWaFQvfzfVgLXwnc3qYNC5FgZOQqwfN5cMb1IHss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xc4R71Zm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xc4R71Zm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66ED8C4CEE3;
	Tue, 29 Apr 2025 18:04:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949871;
	bh=Ii9nqpvq64Pi7tMHCCS4/fk3f1qEspuX8067h99F528=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xc4R71ZmPF/lDf/ofqAWeHlFM8M/M2Fl4dUsawMiXYybN17mV3W3aIn7e/YBKwm11
	 LJyb0Xz+pFXo6o2sYe06l4XA9QHARhIpz2WMb7XPlWoQud3c871cgvOckKwI9euCxL
	 A20/GIID5yF3J/L8Oi/fDXN//qSFn2ivznmopuvo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Ralph Siemsen <ralph.siemsen@linaro.org>,
	Peter Chen <peter.chen@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 6.1 083/167] usb: cdns3: Fix deadlock when using NCM gadget
Date: Tue, 29 Apr 2025 18:43:11 +0200
Message-ID: <20250429161055.118328734@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161051.743239894@linuxfoundation.org>
References: <20250429161051.743239894@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ralph Siemsen <ralph.siemsen@linaro.org>

commit a1059896f2bfdcebcdc7153c3be2307ea319501f upstream.

The cdns3 driver has the same NCM deadlock as fixed in cdnsp by commit
58f2fcb3a845 ("usb: cdnsp: Fix deadlock issue during using NCM gadget").

Under PREEMPT_RT the deadlock can be readily triggered by heavy network
traffic, for example using "iperf --bidir" over NCM ethernet link.

The deadlock occurs because the threaded interrupt handler gets
preempted by a softirq, but both are protected by the same spinlock.
Prevent deadlock by disabling softirq during threaded irq handler.

Cc: stable <stable@kernel.org>
Fixes: 7733f6c32e36 ("usb: cdns3: Add Cadence USB3 DRD Driver")
Signed-off-by: Ralph Siemsen <ralph.siemsen@linaro.org>
Acked-by: Peter Chen <peter.chen@kernel.org>
Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Link: https://lore.kernel.org/r/20250318-rfs-cdns3-deadlock-v2-1-bfd9cfcee732@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/cdns3/cdns3-gadget.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/cdns3/cdns3-gadget.c
+++ b/drivers/usb/cdns3/cdns3-gadget.c
@@ -1960,6 +1960,7 @@ static irqreturn_t cdns3_device_thread_i
 	unsigned int bit;
 	unsigned long reg;
 
+	local_bh_disable();
 	spin_lock_irqsave(&priv_dev->lock, flags);
 
 	reg = readl(&priv_dev->regs->usb_ists);
@@ -2001,6 +2002,7 @@ static irqreturn_t cdns3_device_thread_i
 irqend:
 	writel(~0, &priv_dev->regs->ep_ien);
 	spin_unlock_irqrestore(&priv_dev->lock, flags);
+	local_bh_enable();
 
 	return ret;
 }


