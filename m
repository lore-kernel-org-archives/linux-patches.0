Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 638544582FE;
	Tue, 21 Jul 2026 22:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672445; cv=none; b=gGVPDsDjM1Il51BdDtTUlzvOTCFTEP8rTjiaF+24jYfwHMUo72ujXWzX6AOvkdEOabHrkJOgmF3HVVT0hyjUwx68hxR9v0+rhXI0OwPG5Kf9+X8S1K9RAaQxfzsBs2/IOIGzHyfuOxAR5GFk0nRUYdT3p7EHitE5YjILfak52uw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672445; c=relaxed/simple;
	bh=lhI7fLuBqLLVSKzpkBHaVwlCsE6CuKi37kdnC7SEbmU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RXcFY1hS9bAchs/x+4we7oRQDI3fCrI5POcKPAx3/sOpbOEiatvXzgFB4RoHuFfpPStM79T/TVPxU8ynfcImT7hS1L2WYA+2d9P/FW06Lsbg0pc2Nj/TAbnhOsue8PCXJ6QEuE6pwBJdL0PFFgyOiXoPEZwWoZB6v8o6SjAEo34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QBCVWL/3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QBCVWL/3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C842A1F000E9;
	Tue, 21 Jul 2026 22:20:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672444;
	bh=CXJfsSEDghDsf6YwpgKoZRFB9PmmMKThUVnQyItlh3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QBCVWL/3jSW4PnBglXvOu177MaGyGgSSBB/QK6jyFLqPfitZZRYs/tGD59Uwy2uhv
	 C3gCAThUJ2MYdM9qDZq/ql1H0eNB6Xl135vQjQkQNUinTJu2jHObRoP2NQhK9yhs1l
	 o2iunXYzKGXBig3I6wDrzDvlRoPHOoRxBU3m0CBk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bastien Curutchet <bastien.curutchet@bootlin.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.15 625/843] mtd: rawnand: pl353: fix probe resource allocation
Date: Tue, 21 Jul 2026 17:24:20 +0200
Message-ID: <20260721152420.119921800@linuxfoundation.org>
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

From: Bastien Curutchet <bastien.curutchet@bootlin.com>

commit 19ed11aee966d91beebdef9d32ce926474872f79 upstream.

During probe(), the devm_ioremap() is called with the parent device
instead of the current one. So when the module is unloaded, the register
area isn't released.

Target the pl35x device in the devm_ioremap() instead of its parent.

Cc: stable@vger.kernel.org
Fixes: 08d8c62164a3 ("mtd: rawnand: pl353: Add support for the ARM PL353 SMC NAND controller")
Signed-off-by: Bastien Curutchet <bastien.curutchet@bootlin.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/raw/pl35x-nand-controller.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mtd/nand/raw/pl35x-nand-controller.c
+++ b/drivers/mtd/nand/raw/pl35x-nand-controller.c
@@ -1155,7 +1155,7 @@ static int pl35x_nand_probe(struct platf
 	nfc->controller.ops = &pl35x_nandc_ops;
 	INIT_LIST_HEAD(&nfc->chips);
 
-	nfc->conf_regs = devm_ioremap_resource(&smc_amba->dev, &smc_amba->res);
+	nfc->conf_regs = devm_ioremap_resource(nfc->dev, &smc_amba->res);
 	if (IS_ERR(nfc->conf_regs))
 		return PTR_ERR(nfc->conf_regs);
 


