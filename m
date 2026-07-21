Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37A68364959;
	Tue, 21 Jul 2026 18:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659384; cv=none; b=Nf9q6v0qqu8Ra4veYwCaoyQ2Lo13Xgo+RSEXrUnC9ZlL1IH87gxSuD00wyTgXmiPFDwWO720TtrDPWjk5TQmy/PHNmIlP1zEltg1Z1PHaYH6+Mrr8ODZtFFcYB88UT9ERuMSMMFzpPiP89t2ucOBoIvgVV2KxjP+TID2yEYiyXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659384; c=relaxed/simple;
	bh=CKhii8wII3z9QpdOKBZZL80I9BQyTQtwl7QbFerbjV0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qvKFXLdvquMPLBSP1oJk0+iGPbqn88uVXrLmc67C8D6BoiqMar65ZVM98IMyOoO+DS8B/khuNU8gWtxWTBZFYdTj2DSs2hH5rkL9ofXKxKmdUAA/uUCTO3WJ3T41nfp/FAQz+LDtGLu4CV2OIyOBsiw8XyzHvkU9ebmX6gazuWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bnFV0lg7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bnFV0lg7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C8F11F000E9;
	Tue, 21 Jul 2026 18:43:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659383;
	bh=XTs/Mkd/HZYYf51OkH9qoLkFmsClG330yMjJWhaBqk4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bnFV0lg7+/8tDN67EioExuKj4YurufVO5bNmGBR7lupcpFPOQUtIzR8V0KYCGjrsc
	 cyyeH/xeYS5yUfhuHQGYfq0ZQ3qoSDgEDvM26VzLkeN76jQmYF1H51rcGYyMrdlEhU
	 4JBgFT2R1/Xk3unXaXVoA0uTD2WQ/1A2DfQNAWCg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.18 1501/1611] mtd: mchp23k256: use SPI match data for chip caps
Date: Tue, 21 Jul 2026 17:26:57 +0200
Message-ID: <20260721152549.204103088@linuxfoundation.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

commit d322e40f4edf92bf0ca329e5aa4ae1c0316feb38 upstream.

The driver stores chip capacity information in both the OF match table
and the SPI id table. Probe currently uses of_device_get_match_data(),
so a non-OF SPI modalias match falls back to mchp23k256_caps even when
the SPI id table selected a different part.

Use spi_get_device_match_data() so SPI id-table driver_data is consumed
when OF match data is absent. This keeps the existing default fallback
while avoiding the wrong MTD geometry for id-table-only matches.

Fixes: 4379075a870b ("mtd: mchp23k256: Add support for mchp23lcv1024")
Cc: stable@vger.kernel.org
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/devices/mchp23k256.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mtd/devices/mchp23k256.c
+++ b/drivers/mtd/devices/mchp23k256.c
@@ -188,7 +188,7 @@ static int mchp23k256_probe(struct spi_d
 
 	data = dev_get_platdata(&spi->dev);
 
-	flash->caps = of_device_get_match_data(&spi->dev);
+	flash->caps = spi_get_device_match_data(spi);
 	if (!flash->caps)
 		flash->caps = &mchp23k256_caps;
 


