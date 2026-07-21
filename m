Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 194EA3F12CE;
	Tue, 21 Jul 2026 17:22:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654553; cv=none; b=LeW5PkQM8+D+THH6krRhsT1VD7I3slzLD5Nmy+TmLuBMpZ9KU2/UW8QD/+Xe+kodsQ12bujN6FmOlrVv8A+eleQCUA4f2kvQd9/s7SoK4RdD/5+MdU0F04zKtgcV99QXb2HMzg9a4gjQeJY/39EVu9zP1kQmOn4FWQ5hclW26/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654553; c=relaxed/simple;
	bh=BqmBMYxIYqN7oGOKRZlmKVkArqmFthbu825G6UwpJ6w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WuJ0HhpDDjcbhQ7MgBjOHQGcr93vGu7oZhc+x5a6VNHyx4QJYabJIi+IAWwUMJCa6lurIb4/YgcQA5BB2tZMhyRRPABkYVh3H2zET9v7KSofUTUGUVqgtNiZA2eucD8mIhMRTyInBOZGFWw/pZ24KoQ1fGcAnrZorUZRYsBCxv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EZ63Uuwg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EZ63Uuwg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B40D1F000E9;
	Tue, 21 Jul 2026 17:22:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654552;
	bh=5pLizeemwqJerRYNAUyt5WsHpsFzPcp5B1eznrWDAco=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EZ63UuwgD1Nliiu1OAX6h8/MeYuQAsLO2CgqR/bNx58UEXo7XK0lrVf9JqKlFDwaQ
	 MaihVJ5tFzXxDljouLwzcBWPpgO0DaRzyPvexuxvO1Q2gt07GAULTj8F+gYVDWY4QU
	 L61vK4fc/ZE1JucRCdl9L27+VLW714/fOGnAT6SE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bastien Curutchet <bastien.curutchet@bootlin.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 7.1 1746/2077] mtd: rawnand: pl353: fix probe resource allocation
Date: Tue, 21 Jul 2026 17:23:39 +0200
Message-ID: <20260721152633.928811520@linuxfoundation.org>
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
 


