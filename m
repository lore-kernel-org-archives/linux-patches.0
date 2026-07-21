Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 806F53C276E;
	Tue, 21 Jul 2026 17:37:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655431; cv=none; b=iNi6EFrNVc+ee988Pi8xCuUD7H/mheO4j8F6tgIE33WM0JtMS17sy62rQ1Vrb9jbMRepQHK+w4jU1OdUUuPyMayY2BWwiDEkw/hwqeLFcJf9wmafdJ7IHWUllY1tKs1j81quCCMl1m440x1PFHBxMmUnw0J1YWgRR3kbmMmGsXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655431; c=relaxed/simple;
	bh=2PwqRLBlKz2NHU2nKX2/Soo+WdSeCliZveM6rVFEIJE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gT55J4io6tlaX06Vz03lJSDCFyozNlHLG61twpvm5jHBIgfKV2NU4TRd0h7yFmdStcMzj59dTnXUOPHSmfT05aGBUxL9fz6EA69DI7N3W9aqhr7dR+Jk/cSbPQZES3axpoV4zNlnR59NgacbqOiHl1g+9DEsEiYmUHTtJv8ai5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QGucFc7M; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QGucFc7M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E60DB1F000E9;
	Tue, 21 Jul 2026 17:37:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655430;
	bh=GgWQ2mL/jeyOPxJhogxazOSY3rwticLCv56riUnmrr0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QGucFc7MfOpMKvooFxfUHh4xe8z1gsU/FmFFbS/ulS8TFs4KlR/QEjI1YVKoocHvq
	 lB8uj1EAHlgRxmL5Y+fdoxwNtxKpGsEiFhMaEAjRwnzLn7STL5ABdEmfYLkO1FuhxW
	 TiDhdjmv3N4xhIOju7Q6IkkpO/fldzPL4zsLlQ+U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 7.1 2028/2077] mtd: onenand: samsung: report DMA completion timeouts
Date: Tue, 21 Jul 2026 17:28:21 +0200
Message-ID: <20260721152640.530780955@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

commit d03a19bd6c7f86b99ca8fb61a6ec2345cee1d9d6 upstream.

The S5PC110 OneNAND DMA helpers have bounded waits for transfer
completion. The polling helper falls out of its timeout loop and returns
success, and the IRQ helper ignores wait_for_completion_timeout().

Return -ETIMEDOUT when the DMA transfer-done bit or completion does not
arrive before the timeout so callers can treat the buffer transfer as
failed.

Fixes: e23abf4b7743 ("mtd: OneNAND: S5PC110: Implement DMA interrupt method")
Cc: stable@vger.kernel.org
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/onenand/onenand_samsung.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/mtd/nand/onenand/onenand_samsung.c
+++ b/drivers/mtd/nand/onenand/onenand_samsung.c
@@ -554,6 +554,9 @@ static int s5pc110_dma_poll(dma_addr_t d
 	} while (!(status & S5PC110_DMA_TRANS_STATUS_TD) &&
 		time_before(jiffies, timeout));
 
+	if (!(status & S5PC110_DMA_TRANS_STATUS_TD))
+		return -ETIMEDOUT;
+
 	writel(S5PC110_DMA_TRANS_CMD_TDC, base + S5PC110_DMA_TRANS_CMD);
 
 	return 0;
@@ -608,7 +611,9 @@ static int s5pc110_dma_irq(dma_addr_t ds
 
 	writel(S5PC110_DMA_TRANS_CMD_TR, base + S5PC110_DMA_TRANS_CMD);
 
-	wait_for_completion_timeout(&onenand->complete, msecs_to_jiffies(20));
+	if (!wait_for_completion_timeout(&onenand->complete,
+					 msecs_to_jiffies(20)))
+		return -ETIMEDOUT;
 
 	return 0;
 }


