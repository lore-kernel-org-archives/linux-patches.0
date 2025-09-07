Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0E59189BB0;
	Sun,  7 Sep 2025 20:24:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276658; cv=none; b=Q0HJePSwGwTso2kWjaEuJdjDHjyI7VamYzXPZ8QxKj7qqgouuBhI7C7Uz8kQrvccLNWevzDN55M0wNkOIoPUDTiMlOA542Cj1mg6HrTOpmToDnzkyeiq/Jk6ma0EwIH/Imhkdwyd5j2LebnFrw4BxhYG/B4QLapxhyZFXuQB5Ok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276658; c=relaxed/simple;
	bh=PLqXK+C6bjuG2q1uUfP3kFtuXHZTS5YvUJoetDNGzmE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=anvDcBFLOA848IVLmpHG9wXsraNy7OVm/vc4gttugWC83BkYWlo4pNbnZZkH8Zz3tRbOw8Bsv7ihvZpj35colYYYDSysp3/K+70gAD89ipuYHbSHbOQywwpfIaVsz/2nq+bNg4ICng8tSlQn5ngWw/gQ6Pe0TTOXaWpu5G2D8Ek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IKN+Lm/o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IKN+Lm/o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EC1BC4CEF0;
	Sun,  7 Sep 2025 20:24:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276657;
	bh=PLqXK+C6bjuG2q1uUfP3kFtuXHZTS5YvUJoetDNGzmE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IKN+Lm/oMVq8lwDXfQUBYqPmMDHIy1HjPLRKgweDImxOXkh50Z/bvRw5U1UE85HR5
	 y/dSGVir1j4B1KeETAZYkH3MORMHNJQxSIc3gEL/ZbjSsbn8SEuc7aDr943nY/3kIy
	 EcaA907VHnm1Jro+2A156HyGralyqSljzlkzkzSI=
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
Subject: [PATCH 6.6 069/121] net: pcs: rzn1-miic: Correct MODCTRL register offset
Date: Sun,  7 Sep 2025 21:58:25 +0200
Message-ID: <20250907195611.608672903@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195609.817339617@linuxfoundation.org>
References: <20250907195609.817339617@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -19,7 +19,7 @@
 #define MIIC_PRCMD			0x0
 #define MIIC_ESID_CODE			0x4
 
-#define MIIC_MODCTRL			0x20
+#define MIIC_MODCTRL			0x8
 #define MIIC_MODCTRL_SW_MODE		GENMASK(4, 0)
 
 #define MIIC_CONVCTRL(port)		(0x100 + (port) * 4)


