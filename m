Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B823482C60;
	Tue, 29 Apr 2025 17:33:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948011; cv=none; b=NEWRekcZmr0mFK0j7vxmpGlm3xFKot6qQq/oRowKdjGw7pMgHNgMZYsnhvItQ+3bwLkkavIWleypo/Y56sRI/XWg5uyonqWRUYgK8JogfWz0RFmlwMLm0Eryrv8m4UIrIdScQMGtR/5DclTJ+JSX5XV7vKsZhnvITM06oqhkI+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948011; c=relaxed/simple;
	bh=LLTJ8PpbUiw6abML2TjdVj2tsqsxR0wep9bgKUkmNqg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZXdkxutbWLNTDs0zBvZF0KK1UbYG3wfMuoyGfs/2E6U7a/DK8Nok5q3x+xq7l/ny6ssJX2BfC3UelWdA9euAvUcVU6YDrrSkToHBhDCiTZ2h0sX5R5p5m2AS8mn8X76fAPcqFOfPg3Yip9ri/vSi5T+0zgdrGm6osAMNekSM4Lw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wR9lL7M/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wR9lL7M/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49F0CC4CEE3;
	Tue, 29 Apr 2025 17:33:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948011;
	bh=LLTJ8PpbUiw6abML2TjdVj2tsqsxR0wep9bgKUkmNqg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wR9lL7M/MXJuKFELOVc4o9HPUeaPk9c3qHK+kjEsY4UyQ0H3l7whqNBSwuTmBh9vX
	 nPTs9lLH/0b7v/HJaLL7eYDehJYIpN+hUEdfHpvmUfOtYsUlP73ifWWAI9mmR58O92
	 USJCt7rmcWpDG9qE4vsm2+H0S+SijPg2HLmMJ76w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Ralph Siemsen <ralph.siemsen@linaro.org>,
	Peter Chen <peter.chen@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 6.12 138/280] usb: cdns3: Fix deadlock when using NCM gadget
Date: Tue, 29 Apr 2025 18:41:19 +0200
Message-ID: <20250429161120.774217600@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
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
@@ -1963,6 +1963,7 @@ static irqreturn_t cdns3_device_thread_i
 	unsigned int bit;
 	unsigned long reg;
 
+	local_bh_disable();
 	spin_lock_irqsave(&priv_dev->lock, flags);
 
 	reg = readl(&priv_dev->regs->usb_ists);
@@ -2004,6 +2005,7 @@ static irqreturn_t cdns3_device_thread_i
 irqend:
 	writel(~0, &priv_dev->regs->ep_ien);
 	spin_unlock_irqrestore(&priv_dev->lock, flags);
+	local_bh_enable();
 
 	return ret;
 }


