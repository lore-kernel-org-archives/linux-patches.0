Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 397D9415F1C;
	Tue, 21 Jul 2026 21:47:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670456; cv=none; b=Sr784YeOU4w8U4Va29nkldg8syNbnRaUlKxk0LcDO+X2Ga362SX8Fvrojvr60MXGiVMg6/OYuZxJEPqQxZr4gl9Tx9S806HqL1swQX7jLAG+KTOQgJ9VbO3DQGQA9w6HhVrF/8leVlrZra1Te+StQeYQgRDTDx96CQLDFBzRst4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670456; c=relaxed/simple;
	bh=o6YBTWaZU/Zc1NQLEk7F7Ut/ciuY8MvkKv5+SKXvO7M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EWg7e14rg6lVd7WDJw4yHifvavuDfgBd3UKty388kp2GKUdhX8Anghh69wlZ+U2fm+SKrIDDn0mHQgqTNzhuMCSnOmEuiS0XoYoEgHkS8hfPyDh2q/nq3VLWLRrz2TYSpNxFBQej8bh4VgwyLBQo9Hsn8gkBPOL44QTLv68p/xg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BsKVK2GH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BsKVK2GH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A023A1F000E9;
	Tue, 21 Jul 2026 21:47:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670455;
	bh=5PjJ33/Y1rBMk39PWQ67lITq/ncHG3u/rbGfo/hEtIE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BsKVK2GHSxKFCd1KeaTW6AVF6RMAL1dF+wsZJ9RynbpzBy3vtHowF4qktsvYqmjpT
	 tiT4YIGfin7zb8TXPbXuYRC4fsP0tSIhkMiyJohhR66BHDup/2D75L27RHq0YO9RUD
	 X8hMeGC2CezJeDGjErELOZFljYSX1Zh0/IEvglCs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.1 0932/1067] mtd: onenand: samsung: report DMA completion timeouts
Date: Tue, 21 Jul 2026 17:25:33 +0200
Message-ID: <20260721152445.380051520@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


