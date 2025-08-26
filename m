Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD2662E267D;
	Tue, 26 Aug 2025 11:35:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208136; cv=none; b=ZmrE+rRdminA6F6QQ4bNNfYLGz2J1Tco9f+J6yYTqu0HPpM7lK+N5pIEj/MfjV+Kb4zr2KIGHbcipmTIJEFJHstA1VwBiemdAsS7x1IjsbKtk4FNlSeFtauJKzrLdApr+VMKfb8G3V0Z8ww6vUT0aBNK01XxAFURN8BFV1pxX/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208136; c=relaxed/simple;
	bh=0gpWJfKG4V8DCOhfTbIYXyp/MG3C9nc0S4lotQ2lrbo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nJl9tC27PL0++H6bGt5bSf1E+THDoR0LTAiFywsiCYupKxCwwS2BSbKQYf60hKywms8JnZMkyvZNsc5WshKzvZXuZmOo7gnBl+UH8ndDjzx2pe/ed2uYH82HdZ7LsRUF6XNLgeRaec4XQYF9MFSRgkje6rYFhBG8Fd9IW6uoGZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RutMwOQB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RutMwOQB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C3C9C4CEF1;
	Tue, 26 Aug 2025 11:35:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208136;
	bh=0gpWJfKG4V8DCOhfTbIYXyp/MG3C9nc0S4lotQ2lrbo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RutMwOQB+ampU4lS33lxEPNKcDZksBp2vdzJzXUTmjMbZhnV4wZvqscCdcsmsy9jQ
	 CfsU8GgKFO3j+/7OTOyjEe4duEku0AZY5WWjUx7Rv8DLY0/5pAkpXBq38N/e/w040E
	 X0Z2h4LNMT0qWrlTPO23bMbOifRrR+RjOC07fWqE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Parthiban Veerasooran <parthiban.veerasooran@microchip.com>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 421/457] microchip: lan865x: fix missing Timer Increment config for Rev.B0/B1
Date: Tue, 26 Aug 2025 13:11:45 +0200
Message-ID: <20250826110947.697811153@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Parthiban Veerasooran <parthiban.veerasooran@microchip.com>

[ Upstream commit 2cd58fec912acec273cb155911ab8f06ddbb131a ]

Fix missing configuration for LAN865x silicon revisions B0 and B1 as per
Microchip Application Note AN1760 (Rev F, June 2024).

The Timer Increment register was not being set, which is required for
accurate timestamping. As per the application note, configure the MAC to
set timestamping at the end of the Start of Frame Delimiter (SFD), and
set the Timer Increment register to 40 ns (corresponding to a 25 MHz
internal clock).

Link: https://www.microchip.com/en-us/application-notes/an1760

Fixes: 5cd2340cb6a3 ("microchip: lan865x: add driver support for Microchip's LAN865X MAC-PHY")
Signed-off-by: Parthiban Veerasooran <parthiban.veerasooran@microchip.com>
Reviewed-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Link: https://patch.msgid.link/20250818060514.52795-3-parthiban.veerasooran@microchip.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/microchip/lan865x/lan865x.c  | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/net/ethernet/microchip/lan865x/lan865x.c b/drivers/net/ethernet/microchip/lan865x/lan865x.c
index d03f5a8de58d..84c41f193561 100644
--- a/drivers/net/ethernet/microchip/lan865x/lan865x.c
+++ b/drivers/net/ethernet/microchip/lan865x/lan865x.c
@@ -32,6 +32,10 @@
 /* MAC Specific Addr 1 Top Reg */
 #define LAN865X_REG_MAC_H_SADDR1	0x00010023
 
+/* MAC TSU Timer Increment Register */
+#define LAN865X_REG_MAC_TSU_TIMER_INCR		0x00010077
+#define MAC_TSU_TIMER_INCR_COUNT_NANOSECONDS	0x0028
+
 struct lan865x_priv {
 	struct work_struct multicast_work;
 	struct net_device *netdev;
@@ -346,6 +350,21 @@ static int lan865x_probe(struct spi_device *spi)
 		goto free_netdev;
 	}
 
+	/* LAN865x Rev.B0/B1 configuration parameters from AN1760
+	 * As per the Configuration Application Note AN1760 published in the
+	 * link, https://www.microchip.com/en-us/application-notes/an1760
+	 * Revision F (DS60001760G - June 2024), configure the MAC to set time
+	 * stamping at the end of the Start of Frame Delimiter (SFD) and set the
+	 * Timer Increment reg to 40 ns to be used as a 25 MHz internal clock.
+	 */
+	ret = oa_tc6_write_register(priv->tc6, LAN865X_REG_MAC_TSU_TIMER_INCR,
+				    MAC_TSU_TIMER_INCR_COUNT_NANOSECONDS);
+	if (ret) {
+		dev_err(&spi->dev, "Failed to config TSU Timer Incr reg: %d\n",
+			ret);
+		goto oa_tc6_exit;
+	}
+
 	/* As per the point s3 in the below errata, SPI receive Ethernet frame
 	 * transfer may halt when starting the next frame in the same data block
 	 * (chunk) as the end of a previous frame. The RFA field should be
-- 
2.50.1



