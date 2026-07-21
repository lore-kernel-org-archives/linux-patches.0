Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 171A4442FC3;
	Tue, 21 Jul 2026 22:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672720; cv=none; b=EkxPCwxrI0Em23Xvq2fLrm62//8Gk4k3qGMhhayxoojB+BNx1pMnhqsKf41AkNvmXLEEYrOtckg0HX6zLLDq5jJ7vTxIuHH931jlW7d+yaMoAapSWlzBlgXycZFvMZ9yPPtVxfBnLfG0bYUUYv9lRdwMdNRL6I6It1jH07WHElE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672720; c=relaxed/simple;
	bh=4w7HFeDigUEA97oC649tSaPk3v51CNHWd4BXBthSFAA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uhEARhIAbG0xhbxWNokJriLOEn16uDU63fzi/G+vG9yNrwYUyK0iBqF02Xm44hT0z3N5Oi5fFCiT7MSe8pjSGokntrG9s1d6KNQ6HCF9eOzoHC1rV10jNDL/ndOiDQOo6xmnUBXQoLy7F6Ip94RAMTQpkpvDIw/v8I3fUDd+90M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UbMnBX6I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UbMnBX6I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DB101F000E9;
	Tue, 21 Jul 2026 22:25:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672718;
	bh=yUtBAyqhURc50I0l4BYKg9ipIUn2tD726iY1Lta8j/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UbMnBX6Iu8B9yP5h457Co0vMt8Qn5AxaqVYoreGl20ebV0Fl4dkIi3KpNSdKTXc43
	 sjR0zC5HuDUhE3HSrr8maXDD0sUd4/qtciSDtl9ImSRHCvIK+4p6u0vsaEJWMg7gwH
	 r4oTazwYs5Li6wGV4OPdYwZo+wDU+/Vr2A93vEK4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.15 724/843] mtd: onenand: samsung: report DMA completion timeouts
Date: Tue, 21 Jul 2026 17:25:59 +0200
Message-ID: <20260721152422.328990356@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


