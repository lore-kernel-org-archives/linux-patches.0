Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E0CC30D3FF;
	Tue, 21 Jul 2026 20:54:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667277; cv=none; b=DDJjggtpS4K+/+CmjZ77cJkqXcu7wquOl/7qYZATEl/pxywpIGb4liA/Rxu2FmwOiuTbAg4FSQoboLGWDwMHZAZrBcHOEZY0/sJQDpvNf4uNjghmyMVCT8POrvcuZNVV6/Mp1HKXFYjwct8QK7pmW9tciKDwc22aaavqzi7pyBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667277; c=relaxed/simple;
	bh=ixqd1gnGZ0hEN+PbBo+VncgcBy4Tk3o5dIWgozCcuVw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EkxmVEQaUCMVngwYtSoq8XR89FqJgctIMghqXAyUPc0tjC+uhp1LiOOCu/PMBkmLo6sbLZEDoZHLVA1oEteB4VE0VIIutKFMo1HfZWMigITxT01xcNjl8Uw45rc0IbFcRqNlJWTicu1nX3LHuUJluvkvZZVSCbX5NIL6qkyzSjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uZnJ7pJX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uZnJ7pJX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 797F91F000E9;
	Tue, 21 Jul 2026 20:54:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667276;
	bh=Lr28oEC+LQpVUD4kWkoLAom/4Fk4K10EacY/fuXPWSk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uZnJ7pJXWDarRa51b3arJ1BKxJTE20GO7t42eg1kD6ayQROa9wU78xInurlvQt9i6
	 IKFci3sAVA2McyuyyQR+7cFsmXcX5FsZNYm9i0J439BKm8PGguZBI6CIIkHVR7Xrxg
	 Dfgy0BQaQ1+MrtLIkki5gVnwD2Z8sPGvkyVa0jlA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bastien Curutchet <bastien.curutchet@bootlin.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.6 0999/1266] mtd: rawnand: pl353: fix probe resource allocation
Date: Tue, 21 Jul 2026 17:23:56 +0200
Message-ID: <20260721152504.183985191@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1153,7 +1153,7 @@ static int pl35x_nand_probe(struct platf
 	nfc->controller.ops = &pl35x_nandc_ops;
 	INIT_LIST_HEAD(&nfc->chips);
 
-	nfc->conf_regs = devm_ioremap_resource(&smc_amba->dev, &smc_amba->res);
+	nfc->conf_regs = devm_ioremap_resource(nfc->dev, &smc_amba->res);
 	if (IS_ERR(nfc->conf_regs))
 		return PTR_ERR(nfc->conf_regs);
 


