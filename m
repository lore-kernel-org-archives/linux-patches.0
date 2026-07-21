Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2D25352029;
	Tue, 21 Jul 2026 21:41:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670096; cv=none; b=obnMBTDVaEnR/uRmUNLp/1Z57D6m1jQZTM7hpoQpgt26cNgQ8JYwZhCa4D3tzIXnqwojq0AQ5vZVO+DM4RLuNA0N+D6socWxb+tEAjneYCDN9XOJ9u9L9s5JhxtVT93VsoRYaCeuzKVbPY68VF/kA9imCDo5RyGwi4c4t0c718k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670096; c=relaxed/simple;
	bh=D2K8iSl0TQx2kHImPSQVHi4P9t4TblfC6yYSBsUJIV8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vGb8Hg+M8r722ABdhZD6kmYP8/oFYNwnyWoQO/vMqIMK4PoUbKzIVKVjwEdelmj9c1l5gH2HqsOFsVKT126Cto+yweFH+KudC/O/SdxGyTRpSgq+UDFHMS8uD5nz+osQzOJr8F0BlrvwRCYWjtsZWTYN5v9hV2DMSXutS/DSWII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KehOAOUE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KehOAOUE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 641791F000E9;
	Tue, 21 Jul 2026 21:41:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670094;
	bh=epZEm2SCh5gkk0LoT2QAGZltMWznIWYBDzDjqDbJjEE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KehOAOUENCHzCeNeOuk5rwZ30yNRk21H6mNkE/IoI+UyckpvYPylbQzNab0lRasCO
	 GpOQyTKodhwEZeBy52qByb9pqRJYBwAHqCSkTvqDieF00KJhmRSizO6hqvZVxetFbW
	 2JvA8Wo2tdeSmyg2w3Xz+Dzqy4nPRgs+LJny1IEk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bastien Curutchet <bastien.curutchet@bootlin.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.1 0804/1067] mtd: rawnand: pl353: fix probe resource allocation
Date: Tue, 21 Jul 2026 17:23:25 +0200
Message-ID: <20260721152442.547136359@linuxfoundation.org>
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
 


