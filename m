Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6C9B12D1F1;
	Tue, 30 Apr 2024 11:15:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475701; cv=none; b=KkuRjo8Bt/q7NbPgJJqtxgjIamLCHkAFk5lSpOdqQaCAlUd30u8Drdp309Atujwlupgxro5AQgJgfntN7QQmi+Ksqz9S76z/+NfhLCF48F7Rt2dIz3JR3b5RFNCEg4/tzZxmQ/2mVnPR02QU32VzP3vS23jjZ1FCZkoZ4vZ26SE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475701; c=relaxed/simple;
	bh=j1zC3fxSRM/0u6BDBimoylFMx4H/dIV7Hyf1pc8duYQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lli9hQ1zZh4MWtwu7404UiAibhx5xDzLnOLMU9hJ/+CxndY7xtcso/Lik8GATzQAlauh2fwzmzzM9avD3ziKqxT9Dh91WoUL9W9TzCsGIch/F/fo9JgezHiHPstyddU1cmSsy0sste8zWF1RPbp5V0JBC+RVK6NQbfdEpvfYoIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PTBZld3g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PTBZld3g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34E1BC2BBFC;
	Tue, 30 Apr 2024 11:15:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475701;
	bh=j1zC3fxSRM/0u6BDBimoylFMx4H/dIV7Hyf1pc8duYQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PTBZld3gKBKrT+12AYs9sGK3UhvUVXSZ24TszyUWN00zpHJw+gxfYYSscxlWoXrhu
	 UfOc6fyshY0oNc5zk3RrCSuiEaSWkg55awqH98jLd3FrQ15GvVVddhzUBgh4YFiYQs
	 JOFhg91uUQLDMaqK4jl7byeQepdEmyHGEwVXYNow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 160/186] idma64: Dont try to serve interrupts when device is powered off
Date: Tue, 30 Apr 2024 12:40:12 +0200
Message-ID: <20240430103102.678198444@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103058.010791820@linuxfoundation.org>
References: <20240430103058.010791820@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 9140ce47872bfd89fca888c2f992faa51d20c2bc ]

When iDMA 64-bit device is powered off, the IRQ status register
is all 1:s. This is never happen in real case and signalling that
the device is simply powered off. Don't try to serve interrupts
that are not ours.

Fixes: 667dfed98615 ("dmaengine: add a driver for Intel integrated DMA 64-bit")
Reported-by: Heiner Kallweit <hkallweit1@gmail.com>
Closes: https://lore.kernel.org/r/700bbb84-90e1-4505-8ff0-3f17ea8bc631@gmail.com
Tested-by: Heiner Kallweit <hkallweit1@gmail.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20240321120453.1360138-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/idma64.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/dma/idma64.c b/drivers/dma/idma64.c
index 0ac634a51c5e3..f86939fa33b95 100644
--- a/drivers/dma/idma64.c
+++ b/drivers/dma/idma64.c
@@ -171,6 +171,10 @@ static irqreturn_t idma64_irq(int irq, void *dev)
 	u32 status_err;
 	unsigned short i;
 
+	/* Since IRQ may be shared, check if DMA controller is powered on */
+	if (status == GENMASK(31, 0))
+		return IRQ_NONE;
+
 	dev_vdbg(idma64->dma.dev, "%s: status=%#x\n", __func__, status);
 
 	/* Check if we have any interrupt from the DMA controller */
-- 
2.43.0



