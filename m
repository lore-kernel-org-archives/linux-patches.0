Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB2BB14BFA2;
	Sun,  7 Sep 2025 20:18:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276281; cv=none; b=sm5N1ch2dWvrO7xAL+pVPkkyopQsHT1rt1FvGpSrOm1rEW2cgmmDGzSE9Sp+KrCCOUVitH31p9Dm+6Pvzg6r3QD0jcmLd9vthEdcR3ryXDZrr+db92kbnLxVXCLo3HygKsjixo4wA8lM0X09sGUp+0dFk0U79b8zukK6kAJdjQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276281; c=relaxed/simple;
	bh=r0PlFK3yMBJZ0aWhUfMrGeM0odUjROdkjUqnUShpftU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dfg4n/ilrOeY6QEXkd5paRyFCU2L1p0h1GBNUwqXwFooWzGnxz/4D2ID0IAXVZfcbITajIWaYmL4Twjl7z4NeW84I4dTTcxYNMUuvwjm8NURVD98fUZrWjhP14THFnEe3Ndhu1WWNwbrIhxDZ2ddklPsi/NIJGc89ZxOIaVRtOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ac2MTL3G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ac2MTL3G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40921C4CEF8;
	Sun,  7 Sep 2025 20:18:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276281;
	bh=r0PlFK3yMBJZ0aWhUfMrGeM0odUjROdkjUqnUShpftU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ac2MTL3GqzLMsRaA1AGds13zeXgyTtPgZt7gki69/W+jqpGepr5CGXM4m24CsPNQq
	 9TCGCyABk2smS4IwPywQG4+6Zk8WNbDfEwg2ZhVmbD1wWsEgthKnYEy85lj3W5+9Do
	 heWXg5P78gQpwizegBr7J/jWJilTEiHtjVtZV8g4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 053/104] net: pcs: rzn1-miic: Correct MODCTRL register offset
Date: Sun,  7 Sep 2025 21:58:10 +0200
Message-ID: <20250907195609.063418216@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195607.664912704@linuxfoundation.org>
References: <20250907195607.664912704@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

commit a7195a3d67dace056af7ca65144a11874df79562 upstream.

Correct the Mode Control Register (MODCTRL) offset for RZ/N MIIC.
According to the R-IN Engine and Ethernet Peripherals Manual (Rev.1.30)
[0], Table 10.1 "Ethernet Accessory Register List", MODCTRL is at offset
0x8, not 0x20 as previously defined.

Offset 0x20 actually maps to the Port Trigger Control Register (PTCTRL),
which controls PTP_MODE[3:0] and RGMII_CLKSEL[4]. Using this incorrect
definition prevented the driver from configuring the SW_MODE[4:0] bits
in MODCTRL, which control the internal connection of Ethernet ports. As
a result, the MIIC could not be switched into the correct mode, leading
to link setup failures and non-functional Ethernet ports on affected
systems.

[0] https://www.renesas.com/en/document/mah/rzn1d-group-rzn1s-group-rzn1l-group-users-manual-r-engine-and-ethernet-peripherals?r=1054571

Fixes: 7dc54d3b8d91 ("net: pcs: add Renesas MII converter driver")
Cc: stable@kernel.org
Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Reviewed-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Tested-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Link: https://patch.msgid.link/20250901112019.16278-1-prabhakar.mahadev-lad.rj@bp.renesas.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/pcs/pcs-rzn1-miic.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/pcs/pcs-rzn1-miic.c
+++ b/drivers/net/pcs/pcs-rzn1-miic.c
@@ -18,7 +18,7 @@
 #define MIIC_PRCMD			0x0
 #define MIIC_ESID_CODE			0x4
 
-#define MIIC_MODCTRL			0x20
+#define MIIC_MODCTRL			0x8
 #define MIIC_MODCTRL_SW_MODE		GENMASK(4, 0)
 
 #define MIIC_CONVCTRL(port)		(0x100 + (port) * 4)


