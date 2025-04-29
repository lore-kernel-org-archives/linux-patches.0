Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47AA1250C0C;
	Tue, 29 Apr 2025 18:15:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950557; cv=none; b=qUdsRpftiawhpbl1TzlXUlJig/EgmsI2VP66C2E2Yahexcb6vZbVhZDNB3WlzZd11PpjzvqUBs7yo+e5agOGN660fzqOe414qxpuflsip0EnxiuAPI5BNFY1zQo1SjHY8pBJ3e9n0bj6VPijt/d6SZ6vj9801LTAYu40HN9pzmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950557; c=relaxed/simple;
	bh=viNFcOG2mWY/gNlJtrXmMBBDZkv4I5gipnfOVVR/z5k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZKCS8N9SFnfbdcd4DteMiuOKYas7ZZdkuEpCzrsljNTu9GoVlTtzCEihjCk6ZPfi+WLDmwu4kkmg47EjQ2qvYMny0ppUI2K/BHWqodTZ5caeOi3e0q/8Jiw8SGyUa1Pz/rg6aZqOEEsxH34l2q9kW0wZV93VL/sUvDwYwkFLx68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PPGXhJqP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PPGXhJqP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0CF8C4CEE3;
	Tue, 29 Apr 2025 18:15:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950557;
	bh=viNFcOG2mWY/gNlJtrXmMBBDZkv4I5gipnfOVVR/z5k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PPGXhJqPUAPvhJg3GnKCTCGXXupslZjzM9yDfqQM9nVUXDKVU/EhAEpdhb1QbPCle
	 gJV2KoQz0pMfZzlcvwsoGsRAHYo4vKdVjV8cwnHDB5Wuz1L6DPN0wX2Z6neSdQyK78
	 sUNkPIrFVyoH3RgAbQj/0v/RnO/sX3L7Fgt4Iv8E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Ralph Siemsen <ralph.siemsen@linaro.org>,
	Peter Chen <peter.chen@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 6.6 103/204] usb: cdns3: Fix deadlock when using NCM gadget
Date: Tue, 29 Apr 2025 18:43:11 +0200
Message-ID: <20250429161103.644510395@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161059.396852607@linuxfoundation.org>
References: <20250429161059.396852607@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1962,6 +1962,7 @@ static irqreturn_t cdns3_device_thread_i
 	unsigned int bit;
 	unsigned long reg;
 
+	local_bh_disable();
 	spin_lock_irqsave(&priv_dev->lock, flags);
 
 	reg = readl(&priv_dev->regs->usb_ists);
@@ -2003,6 +2004,7 @@ static irqreturn_t cdns3_device_thread_i
 irqend:
 	writel(~0, &priv_dev->regs->ep_ien);
 	spin_unlock_irqrestore(&priv_dev->lock, flags);
+	local_bh_enable();
 
 	return ret;
 }


