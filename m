Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7345B3A8746;
	Tue, 16 Jun 2026 16:07:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781626031; cv=none; b=WDktOhpqNHMHbnkA0KtiSaPpnyNzz7Ran+BI4Eu69wyD7T7OyjAAzsiCzgZqvWFm2YPod4ay5lLLCKf2Fdp6gtflXF1KfDtE5xXXFON9J9NWcs0BAA1jQNNyeA4h5mNAoyATAifEvhdXboUfADJb0OPCKlttqW/4oppL0x6bwlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781626031; c=relaxed/simple;
	bh=m2niFnxl6FuSUucQoPdInz6UfWhW687IA40aqmftt3I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fWMb5LjDPkpZTbg6AlhtHfTcQjIXyAp/bdYtLxbebMUZeO54xEUgqGElkl0DxCPVY+6m096eNTRN1Zqogoq3sZX0NlJxFSmB77pYDRN2IVG4wBhoTMGAqd8lRVrMr1932HpbW4rY5axomF9cmMpPonJCSkNOXpHADi6clC9VSQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NsSae9oV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NsSae9oV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B6321F000E9;
	Tue, 16 Jun 2026 16:07:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781626030;
	bh=AvLY8b+D+JpC8J827mgstjUswC5ffm+B0ncUoCG2/KA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NsSae9oV6F4m2QZREdksr7AYCKCbq+UQ6QEjVE2j+yrb7jLqlDp+F6LKmMhAMzrMP
	 5vtYyowPfAGyJLLFlOpcAAgzKzAHER3Le2FRR1FsiCmFNLpMZWf6Os05B1PBu/DV9J
	 nQeCWkmja6qJBbUOJp/ZrB70Cf60bij8ctAZ8lUw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Judith Mendez <jm@ti.com>,
	Linus Walleij <linusw@kernel.org>
Subject: [PATCH 6.18 246/325] pinctrl: mcp23s08: Read spi-present-mask as u8 not u32
Date: Tue, 16 Jun 2026 20:30:42 +0530
Message-ID: <20260616145110.746911814@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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

From: Judith Mendez <jm@ti.com>

commit b0c13ec17438577f90b379d448dfed1233e2c0a4 upstream.

The binding (microchip,mcp23s08) specifies microchip,spi-present-mask
as uint8, but driver would read u32, causing type mismatch. Use
device_property_read_u8 to match binding spec, hardware (8 chips max),
& prevent probe failure.

Cc: stable@vger.kernel.org
Fixes: 3ad8d3ec6d87 ("dt-bindings: pinctrl: convert pinctrl-mcp23s08.txt to yaml format")
Signed-off-by: Judith Mendez <jm@ti.com>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pinctrl/pinctrl-mcp23s08_spi.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/pinctrl/pinctrl-mcp23s08_spi.c
+++ b/drivers/pinctrl/pinctrl-mcp23s08_spi.c
@@ -143,13 +143,13 @@ static int mcp23s08_probe(struct spi_dev
 	unsigned int addr;
 	int chips;
 	int ret;
-	u32 v;
+	u8 v;
 
 	info = spi_get_device_match_data(spi);
 
-	ret = device_property_read_u32(dev, "microchip,spi-present-mask", &v);
+	ret = device_property_read_u8(dev, "microchip,spi-present-mask", &v);
 	if (ret) {
-		ret = device_property_read_u32(dev, "mcp,spi-present-mask", &v);
+		ret = device_property_read_u8(dev, "mcp,spi-present-mask", &v);
 		if (ret) {
 			dev_err(dev, "missing spi-present-mask");
 			return ret;


