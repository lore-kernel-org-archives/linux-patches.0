Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4715205ACF;
	Thu, 12 Dec 2024 15:26:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017189; cv=none; b=mgbeb/DJg16WSnfiZYn/Mggwz8YSqABp7lqLR9rKEBdcs9gbbWvPnz3bAYEqwU83P0l8zhNU+enJvomfXwmPXRUOybbtxJzSb5FsTMGSnPFPD7OtFqwqhcTgS5mIXR1xPgegXsCoO/ThnP/Z5TAmTsY1vJM+KuwG2/+v31SjYkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017189; c=relaxed/simple;
	bh=QDsRv+XrhfM2F7MkihohpiJYoRJPIeth5jFFycUwQAw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jDzfDALIc/YO/ZUgXB3eitqd695TnNMZmbKVb3HCdN5SjNs0mtdomjgMipdC+MgpXPdKLsLl1Uf7hiyw0ExRssKAb+4bK/q7cJzj2hXKTITGMbJzqnQ6AY8MDbhzHEogquWmqbLwc9aVY8Zytp0fCElJjDO02cyjEf+5ti8WvCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I0klOgmd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I0klOgmd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28AE0C4CECE;
	Thu, 12 Dec 2024 15:26:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017189;
	bh=QDsRv+XrhfM2F7MkihohpiJYoRJPIeth5jFFycUwQAw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I0klOgmdXDq/j8Do4x/5u+BC+ZWBbCyyNRCtA1IP8NmNVnQZeLtZC07VvqoSdcwA6
	 uJ1X03D0LaB1GRZuCoIjJ+/ZnZ3/WddBPQklSLhALa4cJ2WJCK21QTYpSOgkfGJYDt
	 MNBv/ab3OHnAa/wUNCW9f7bebNxkMZeOuoUP119I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jarkko Nikula <jarkko.nikula@linux.intel.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 390/466] i3c: mipi-i3c-hci: Mask ring interrupts before ring stop request
Date: Thu, 12 Dec 2024 15:59:19 +0100
Message-ID: <20241212144322.180238116@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jarkko Nikula <jarkko.nikula@linux.intel.com>

[ Upstream commit 6ca2738174e4ee44edb2ab2d86ce74f015a0cc32 ]

Bus cleanup path in DMA mode may trigger a RING_OP_STAT interrupt when
the ring is being stopped. Depending on timing between ring stop request
completion, interrupt handler removal and code execution this may lead
to a NULL pointer dereference in hci_dma_irq_handler() if it gets to run
after the io_data pointer is set to NULL in hci_dma_cleanup().

Prevent this my masking the ring interrupts before ring stop request.

Signed-off-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Link: https://lore.kernel.org/r/20240920144432.62370-2-jarkko.nikula@linux.intel.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master/mipi-i3c-hci/dma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i3c/master/mipi-i3c-hci/dma.c b/drivers/i3c/master/mipi-i3c-hci/dma.c
index a918e96b21fdd..13adc58400942 100644
--- a/drivers/i3c/master/mipi-i3c-hci/dma.c
+++ b/drivers/i3c/master/mipi-i3c-hci/dma.c
@@ -159,10 +159,10 @@ static void hci_dma_cleanup(struct i3c_hci *hci)
 	for (i = 0; i < rings->total; i++) {
 		rh = &rings->headers[i];
 
+		rh_reg_write(INTR_SIGNAL_ENABLE, 0);
 		rh_reg_write(RING_CONTROL, 0);
 		rh_reg_write(CR_SETUP, 0);
 		rh_reg_write(IBI_SETUP, 0);
-		rh_reg_write(INTR_SIGNAL_ENABLE, 0);
 
 		if (rh->xfer)
 			dma_free_coherent(&hci->master.dev,
-- 
2.43.0



