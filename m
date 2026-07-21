Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F9A7430CDC;
	Tue, 21 Jul 2026 19:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663754; cv=none; b=X0ivq+DuwIamApTqbHJcRJK7Ylv/Ufhe6MBCX7Y7U1jnI66QsMF8oN9G4Y3ZkkRXbJFVoF1IAdtwk436dlQSS6gQNMxwxwbfbUEVjrXrvr0bhW9X55xsH/rDTbBk0XC0C6juH5KZHCsB0blnGYA1TFL+caOWn+982lpLHVDjdHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663754; c=relaxed/simple;
	bh=nrJqohUQS0tZunLkOCNSRAF3yQE2OGIR72zzBkOHmlg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BBdNQrzyG7umOyRFb7e0/fPisEJJC9rmaiNbFVqFCuKHrQW/aJIeJF0FpfbHgvqM9y+O+gt+yzbS2zh3TVnApnh9JYB0FzUIW3dgMfDKqOtm5QLhSGqSjik6GLjMFOWupLn+oPir/RK02E3wAhO8q9fVATw4HJ4IeR6228GZCn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YZi74Tfd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YZi74Tfd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A07121F00A3A;
	Tue, 21 Jul 2026 19:55:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663753;
	bh=VrPVBnT4K0wK4ZdkvmEKN/yAiw8wGjn+SqqtYaU4nnk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YZi74Tfd+HiU9tsF1mpqehZv93Y9GhMmMHEJbYqCmdAm2nrB1BSMpaY+CXaTUYj9n
	 ssGzBbWXADNGXDkn45lq4o8LmUGXDFWcgBaR220WoJf//6C2rXqzypn0lsQMkG7ON+
	 yrr+1UlYri5D1Z5W6Yia0bg36UXo2rQkUdgHV9t0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bastien Curutchet <bastien.curutchet@bootlin.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.12 0942/1276] mtd: rawnand: pl353: fix probe resource allocation
Date: Tue, 21 Jul 2026 17:23:05 +0200
Message-ID: <20260721152507.113687169@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 


