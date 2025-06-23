Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C58E224DCFD;
	Mon, 23 Jun 2025 13:36:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685771; cv=none; b=AjOyNflXhMPOVcnZXGK2K8rcQJcefkRqcbN5Qfg+W13aAM0Dkns9jLgEyXDlk+Or2zqrTscrw7ZekSw5M76NBnZoIE04Hgu+w1qvfSOLa2qWpmZsN+8xjQdRa76SodwbkyRVJF5Dj3fep4QgC07HmNv6BLCeuNW6er5lceoYGdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685771; c=relaxed/simple;
	bh=1mzXIfs/r8hKQdOEGh/as36SD0MBm1n1pTw68vUe0II=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tAJqlDfLLxILOX74YCa799u+HzjLDkVeTFdHhKp8r5epFKPM5JHxUkAT0tZYfx3/65fJeLT2A798825w/gmwp+yZfaA108t3Q7/nxx0vbGlQ89TnITQi/A7eTVMuEPGsivGI16eaTAvsHja/TVyqXHzt6R9/yMUbiHzuA7PDdkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cR1Ayh1n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cR1Ayh1n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ADA8C4CEEA;
	Mon, 23 Jun 2025 13:36:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685771;
	bh=1mzXIfs/r8hKQdOEGh/as36SD0MBm1n1pTw68vUe0II=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cR1Ayh1nMyPF2+WqXqlVmVRM9ZqUQy2hAxB9zyY+Z8/ihjZnal5gWT5sduXB5CTMB
	 yND3QWt2GUQRNDxE/AOYQ86mfLcMXvguGgKSiR0P3XEecHg71jejYidEADiJj2ldRN
	 hjqfWjUzYLDLmFS+K7SZuFx0U+aLqQBb9QvVXPps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.4 124/222] mtd: nand: sunxi: Add randomizer configuration before randomizer enable
Date: Mon, 23 Jun 2025 15:07:39 +0200
Message-ID: <20250623130615.829038369@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130611.896514667@linuxfoundation.org>
References: <20250623130611.896514667@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

commit 4a5a99bc79cdc4be63933653682b0261a67a0c9f upstream.

In sunxi_nfc_hw_ecc_read_chunk(), the sunxi_nfc_randomizer_enable() is
called without the config of randomizer. A proper implementation can be
found in sunxi_nfc_hw_ecc_read_chunks_dma().

Add sunxi_nfc_randomizer_config() before the start of randomization.

Fixes: 4be4e03efc7f ("mtd: nand: sunxi: add randomizer support")
Cc: stable@vger.kernel.org # v4.6
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/raw/sunxi_nand.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/mtd/nand/raw/sunxi_nand.c
+++ b/drivers/mtd/nand/raw/sunxi_nand.c
@@ -818,6 +818,7 @@ static int sunxi_nfc_hw_ecc_read_chunk(s
 	if (ret)
 		return ret;
 
+	sunxi_nfc_randomizer_config(nand, page, false);
 	sunxi_nfc_randomizer_enable(nand);
 	writel(NFC_DATA_TRANS | NFC_DATA_SWAP_METHOD | NFC_ECC_OP,
 	       nfc->regs + NFC_REG_CMD);


