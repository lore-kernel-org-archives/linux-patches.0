Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 730A646EC82;
	Tue, 21 Jul 2026 18:32:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658761; cv=none; b=q2NoHZTRYUe2iEOaTmJoeB7Hu9Z4cDB0v8eMJF9t/DRPJCHfI23zmud9/0XRvTBQKbj6rzRJNcbNF70rLQZVjX3G+SWq6Nw0ORC+Ogy13XFd6CPT0UnNylmUyuSt0ft/WP1NkBS96aYE3ez1f3y4RVPXcEY/feRcU0FbBaOeNY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658761; c=relaxed/simple;
	bh=YJ2756e1P3EWAJTq6sLVyze+t+fphE/omgyuNLnx65w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DFXzapiCgVcfG4qOrNbeOQCGCayURHgUMw5lholwypHIDm50U7z+LylKiD5BYA2Z0zD3qAlYcUGkJlBkuBOn0XSesBUzlGet25DbiVEr3RT65o9aizvvdsz2Z+svI2YnCltT4fJUmszga6b+KJj4g1KQw7sIzkHCHe/ZI6zgw6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=osd6pALQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="osd6pALQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AEB41F000E9;
	Tue, 21 Jul 2026 18:32:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658760;
	bh=GNLq5WWM/wtY1aLz1Nqn1EkaV5nyTlWfBHymdTRfSdA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=osd6pALQ2/6oPfAPzHvZ/UG2Db5z9LG6bd3zkB90gk8TXDFJEtM/bRh4X7LZx3hDx
	 qG49NWM1b9lwW9XOyJuDRPA7lXUhHyTX+j0RHwTPd+mqbjsPt+IUv++mvvfcTVKv+V
	 Zofhw1VRaYliaSQh1L+LVMXxdC1Ph73U778Ikb48=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bastien Curutchet <bastien.curutchet@bootlin.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.18 1266/1611] mtd: rawnand: pl353: fix probe resource allocation
Date: Tue, 21 Jul 2026 17:23:02 +0200
Message-ID: <20260721152543.924803724@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1152,7 +1152,7 @@ static int pl35x_nand_probe(struct platf
 	nfc->controller.ops = &pl35x_nandc_ops;
 	INIT_LIST_HEAD(&nfc->chips);
 
-	nfc->conf_regs = devm_ioremap_resource(&smc_amba->dev, &smc_amba->res);
+	nfc->conf_regs = devm_ioremap_resource(nfc->dev, &smc_amba->res);
 	if (IS_ERR(nfc->conf_regs))
 		return PTR_ERR(nfc->conf_regs);
 


