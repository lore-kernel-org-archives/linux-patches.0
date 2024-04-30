Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05FD2128816;
	Tue, 30 Apr 2024 11:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714476692; cv=none; b=oxhgTJuO25G2vzHf8Vy2O/Op6npxtmeiTozN0JGDwEcKkmrFahRKirKnSkOidHiM3FXJnJSlrYb1oEVWb0TGS8Wy5aB2jW6xG+kvhF5cKlMVZUJwNUze1AU22+M+CVPe6731Og4yBEU3Bh3NSTVFRLfwMmNFn/TnzdeEFc3WUvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714476692; c=relaxed/simple;
	bh=VOKaXg9Hd3LpT9zaUvNjps+63zC373L8vgndq35OTTA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bNre2+fxPM6YNja6vxYbCe1vMclYeQYPv7qwUrhkLJKjP5XPtwGhKb3NaZLCmNJKhMmRc3fDUiW2mGJ6OasHKL7+x7WhJdVtK2D8Ow0cZRZTsS3EtKuBp764bO33JnB/BoWQE6d7VR14oN+Xb2G2Z4FT9eMMuku0DfNNZNvBuYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=khZFmd33; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="khZFmd33"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B07FC2BBFC;
	Tue, 30 Apr 2024 11:31:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714476691;
	bh=VOKaXg9Hd3LpT9zaUvNjps+63zC373L8vgndq35OTTA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=khZFmd33mpXaFDbACvciTMO5GtRnBETlDlD2901wBNCV864kQ9ZrXFNv9T9I+z1UQ
	 0FvQvCmb9YajZTgia8JCTd0R0fprTu9HFYXhEL7zcc/EKpnBH4BdHcKa7xyvq/5LEF
	 JUVoQvUUxBGqspy9Q/VcA9M3WUSUFJzPmbbcDWl8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 094/110] idma64: Dont try to serve interrupts when device is powered off
Date: Tue, 30 Apr 2024 12:41:03 +0200
Message-ID: <20240430103050.346742614@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103047.561802595@linuxfoundation.org>
References: <20240430103047.561802595@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index f4c07ad3be15b..af8777a1ec2e3 100644
--- a/drivers/dma/idma64.c
+++ b/drivers/dma/idma64.c
@@ -167,6 +167,10 @@ static irqreturn_t idma64_irq(int irq, void *dev)
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



