Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56C2411706
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 15:04:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA482C433C7;
	Mon, 11 Sep 2023 15:04:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694444674;
	bh=39KNOggVsQHWFyqABh5e17qDIXWjeTGHld7zpcC0a3s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e/3gn60uCUw+pzD2qmzDBkN3OX1wYEh1OBR3flNvTxl/vS+qvnTMxEiKJEkk7YEYF
	 65KCaxBDZtVY7rjyj/uWWOg26tlpIZ+TBH8rLPgUdJnyKNUmLdmJ3bWjXt3KKhIe3Z
	 OlA+xasO61BRlruUx0C3fVLkrORGlcmh+IIGFsBI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josua Mayer <josua@solid-run.com>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 075/600] net: sfp: handle 100G/25G active optical cables in sfp_parse_support
Date: Mon, 11 Sep 2023 15:41:48 +0200
Message-ID: <20230911134635.831122635@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134633.619970489@linuxfoundation.org>
References: <20230911134633.619970489@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Josua Mayer <josua@solid-run.com>

[ Upstream commit db1a6ad77c180efc7242d7204b9a0c72c8a5a1bb ]

Handle extended compliance code 0x1 (SFF8024_ECC_100G_25GAUI_C2M_AOC)
for active optical cables supporting 25G and 100G speeds.

Since the specification makes no statement about transmitter range, and
as the specific sfp module that had been tested features only 2m fiber -
short-range (SR) modes are selected.

The 100G speed is irrelevant because it would require multiple fibers /
multiple SFP28 modules combined under one netdev.
sfp-bus.c only handles a single module per netdev, so only 25Gbps modes
are selected.

sfp_parse_support already handles SFF8024_ECC_100GBASE_SR4_25GBASE_SR
with compatible properties, however that entry is a contradiction in
itself since with SFP(28) 100GBASE_SR4 is impossible - that would likely
be a mode for qsfp modules only.

Add a case for SFF8024_ECC_100G_25GAUI_C2M_AOC selecting 25gbase-r
interface mode and 25000baseSR link mode.
Also enforce SFP28 bitrate limits on the values read from sfp eeprom as
requested by Russell King.

Tested with fs.com S28-AO02 AOC SFP28 module.

Signed-off-by: Josua Mayer <josua@solid-run.com>
Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/sfp-bus.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/phy/sfp-bus.c b/drivers/net/phy/sfp-bus.c
index daac293e8edec..1865e3dbdfad0 100644
--- a/drivers/net/phy/sfp-bus.c
+++ b/drivers/net/phy/sfp-bus.c
@@ -254,6 +254,16 @@ void sfp_parse_support(struct sfp_bus *bus, const struct sfp_eeprom_id *id,
 	switch (id->base.extended_cc) {
 	case SFF8024_ECC_UNSPEC:
 		break;
+	case SFF8024_ECC_100G_25GAUI_C2M_AOC:
+		if (br_min <= 28000 && br_max >= 25000) {
+			/* 25GBASE-R, possibly with FEC */
+			__set_bit(PHY_INTERFACE_MODE_25GBASER, interfaces);
+			/* There is currently no link mode for 25000base
+			 * with unspecified range, reuse SR.
+			 */
+			phylink_set(modes, 25000baseSR_Full);
+		}
+		break;
 	case SFF8024_ECC_100GBASE_SR4_25GBASE_SR:
 		phylink_set(modes, 100000baseSR4_Full);
 		phylink_set(modes, 25000baseSR_Full);
-- 
2.40.1



