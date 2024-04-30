Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB89612C47A;
	Tue, 30 Apr 2024 10:44:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714473883; cv=none; b=OT2x//CrkixxXEo1YL1IwrgcB6WBK9Ihzt6ca4ThVZM3qggN7XhWy6qyBSfoBLcEWW3mgR0ox0Dzk1hhTY5lrQ/Xe/rdcSmdrk5urIcLjZ8NKE53ZzsN1WI8afHKjuYmUA8BQezzKNIlWx8fjwQiV6DBG9L2GBbgXJ2HK9Zoh7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714473883; c=relaxed/simple;
	bh=LSgtHiTVy1r4DHM3bC86e4XAHL2SF1qgK61lD2IXvME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bEvwhg8Xe8b1eYI6EXxdDUAnYhO3smrKaDkbgQiQq6I7ZAMVer441DzJTyTPR2w78s4BJV24S4FDIsyuaU1qQgjboFIbx9vP/99xKGip75YmlY5rtgII2zth1/hcFuXXfqxcpzEyZVAdSyW4K4+wb2MmfgEE2s2uRQl6af9WUao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dn0Z//Gm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dn0Z//Gm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DF4EC2BBFC;
	Tue, 30 Apr 2024 10:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714473883;
	bh=LSgtHiTVy1r4DHM3bC86e4XAHL2SF1qgK61lD2IXvME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dn0Z//GmiCHkPsYrIYUXcNuC4Q9T8VrXbHtuniHJcZCl+r0ze7fxaY6nWBDvdAAgm
	 BtbnDwbYDp7soT0UI0SR3pU6sMuPvxu5mUhvYQjCWrqSggZVX5gcy62hhXBtkiqy6+
	 IzbiX33vMSOcTfnVkTRC/r6Q3WxKqNf8wWI33EGU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 71/77] idma64: Dont try to serve interrupts when device is powered off
Date: Tue, 30 Apr 2024 12:39:50 +0200
Message-ID: <20240430103043.235435483@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103041.111219002@linuxfoundation.org>
References: <20240430103041.111219002@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 89c5e5b460687..920e98dc7113e 100644
--- a/drivers/dma/idma64.c
+++ b/drivers/dma/idma64.c
@@ -172,6 +172,10 @@ static irqreturn_t idma64_irq(int irq, void *dev)
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



