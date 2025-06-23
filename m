Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C3EE3FD4;
	Mon, 23 Jun 2025 21:48:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715299; cv=none; b=c2ErFHHoxJ9EFg4Eb2lKBDBk62D5p81pjwQPpEJpvfZ+2VrgdGvldBPYmaI2X0bXH8Hmg3fBFi5WfJ2majxQ0ZcDOAr9p0yHTp8ESl+GufzyuM+XGR9D4ULr7Y0810ABhr3nHo4tPNJuetQ6hhKgkIlKt82dWEO0mcXhkkoeQy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715299; c=relaxed/simple;
	bh=KqlS5jY20I5MniU4NRv0+jrp4itH56OON1BIUAqo0is=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rZC/ohSufTo5r035ufJ6BBUYorzTQNGwBHoFUhTq/2ePxCkM/8TA+FmpRovIEeRiFSRDbP+uFkLm5JO8FPPni3mr/DFc2tK9vCSHFr1SZh85Qf+wJU5nnCrhcDwSVxISi8sDvQkmbrFjryr3xgpcqLLNzMzoOZLCMfvuWIauJFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fPdQw5eq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fPdQw5eq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 124DAC4CEEA;
	Mon, 23 Jun 2025 21:48:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715299;
	bh=KqlS5jY20I5MniU4NRv0+jrp4itH56OON1BIUAqo0is=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fPdQw5eq0o+TDdlbZ6NmIvmBuv4+rwx43z9F6qT9ZGjaEnpIDxmi1sOcIeAKRF21n
	 HV8BP8L/ZeupH6Qg+eFy1gMqRKr4ZZi67DQJsWqLQ1MVurcecGaarenwTyhV+R1nD4
	 aFzAR2a4pFokn3ovusTEdHpITx3DUxN/f2shvaMc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.15 244/411] mtd: nand: sunxi: Add randomizer configuration before randomizer enable
Date: Mon, 23 Jun 2025 15:06:28 +0200
Message-ID: <20250623130639.796390663@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -829,6 +829,7 @@ static int sunxi_nfc_hw_ecc_read_chunk(s
 	if (ret)
 		return ret;
 
+	sunxi_nfc_randomizer_config(nand, page, false);
 	sunxi_nfc_randomizer_enable(nand);
 	writel(NFC_DATA_TRANS | NFC_DATA_SWAP_METHOD | NFC_ECC_OP,
 	       nfc->regs + NFC_REG_CMD);


