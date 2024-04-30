Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36A5117592;
	Tue, 30 Apr 2024 11:25:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714476314; cv=none; b=iRm0iIb8V4K2RDRnX0xEhFRJ8VenS42iStNmgZCMVuZvAnct5c9KoDypvjL1dw9Ljif1cUrTKCWdAVF9CHnAgs0RXYnQ4/75faNUlPdRReXXKIj3Co9bA7hv77azw/eOEicUfX8qQy7wUhV23JvjUwhXkY0wOTCKOF8PAtJZy44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714476314; c=relaxed/simple;
	bh=M04xv42Nv4K763mCt2nSlhL3svezRtXZ71+3aN/yK2s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fEvZ0uIXhx+zviADFyMCsdeROKf2JVeJF1LrIQvPiXVdvBxGEFwynUdX85nanzUM+gH1xrHtjYbJjop/zR8uYh7TJ0N8UJVft24jJs6TmNcP7m3WHfMPEvn50UGX3vFdx5IfFATQjtEHLzD70I7jgMKBRgpag1fPKQOJD7bKdig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SZCsAtpO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SZCsAtpO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F938C2BBFC;
	Tue, 30 Apr 2024 11:25:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714476314;
	bh=M04xv42Nv4K763mCt2nSlhL3svezRtXZ71+3aN/yK2s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SZCsAtpOVdlwYeBr2rOpM6nnFb0/2GYAnl9dmq9WgWsGFPiP1DkfTNPsK19kElSm2
	 OR6Wjm2/V6N/CSG8NEUzKV9OGXfmB3BLFcQ1C5Rv5Ln/rHxDxMH6+RX/IpW9P0M0XH
	 2jIkJD2ECuHkNOCd0FIf9RZ5p+8xGM8dZ9vvey+4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 101/107] idma64: Dont try to serve interrupts when device is powered off
Date: Tue, 30 Apr 2024 12:41:01 +0200
Message-ID: <20240430103047.638890682@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103044.655968143@linuxfoundation.org>
References: <20240430103044.655968143@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index f5a84c8463945..db506e1f7ef4e 100644
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



