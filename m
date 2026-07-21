Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06CD03C73F6;
	Tue, 21 Jul 2026 22:55:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674523; cv=none; b=svHwCBpPQBAb5LCI9BbKoMupqki8s4z3F0OeLGDDv5QjnUlsaePii+2sr5Tm2rhfSOHFiSNgDHp7PMX5Y+K3nszW1r63JR4uEWFoj4CbvMqDLaNMmIfMSh7NY54gc0fZD3SpYIKOL+zrqgp9S2UEbPURG1/YznWjdKel4DkKrXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674523; c=relaxed/simple;
	bh=l65DT4XA2OXGUuSN+my+XuDu5jk2z7tQtyIxVsfdyvo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mInkvoB6CyWUL9fZqmaVTd4oaV3AvOe6Edr2G5AU8pirgmYLEfz2F7CiiMr3x8e4O0Izsik4NTClbacRVOMREDwgbomewrzlzzmNlRu+eNGWHlTKdTf8rbP2y8js6v6z/+3jJGtGkR4TEA5hR1rwWFttbwtUs74MDvfthzdfus4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B+NZcOs7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B+NZcOs7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D0671F000E9;
	Tue, 21 Jul 2026 22:55:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674521;
	bh=qJAIw0ceIZ30t0k7k8kUIJxuIT3ktPJIaEX2TiS7a6g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B+NZcOs7M6Nec5xxHKzEf/w4baz+Dksdtsxxl9lLjkHu1AGqs6DN6IVF5sNlNKxFe
	 jTNz6ELnvSBB5POeaRF33NFrECDUG4kgFIJXQkyYmJodNtmW/WlJoRJ34Pp5mysIEH
	 wxL+wTS8lkLbPBpEj8x1Dy3ZjbKGj+cSGDIfpYys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.10 572/699] mtd: onenand: samsung: report DMA completion timeouts
Date: Tue, 21 Jul 2026 17:25:31 +0200
Message-ID: <20260721152408.612890987@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -553,6 +553,9 @@ static int s5pc110_dma_poll(dma_addr_t d
 	} while (!(status & S5PC110_DMA_TRANS_STATUS_TD) &&
 		time_before(jiffies, timeout));
 
+	if (!(status & S5PC110_DMA_TRANS_STATUS_TD))
+		return -ETIMEDOUT;
+
 	writel(S5PC110_DMA_TRANS_CMD_TDC, base + S5PC110_DMA_TRANS_CMD);
 
 	return 0;
@@ -607,7 +610,9 @@ static int s5pc110_dma_irq(dma_addr_t ds
 
 	writel(S5PC110_DMA_TRANS_CMD_TR, base + S5PC110_DMA_TRANS_CMD);
 
-	wait_for_completion_timeout(&onenand->complete, msecs_to_jiffies(20));
+	if (!wait_for_completion_timeout(&onenand->complete,
+					 msecs_to_jiffies(20)))
+		return -ETIMEDOUT;
 
 	return 0;
 }


