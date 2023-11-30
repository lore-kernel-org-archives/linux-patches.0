Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEB3B3D382;
	Thu, 30 Nov 2023 16:31:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AOv5X513"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59662C433C7;
	Thu, 30 Nov 2023 16:31:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701361867;
	bh=CxN44Pf+UR6lFQBEbnQfbxMQNF/oGyXSE0wuwBHWLLU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AOv5X513IwcTilYA43IkssjKlPEIRlngUPqTg0qT6/Q+W9Xh1XD2pXv+J+7CLc0YO
	 Fm+pl95qxNQjHZpTdHQJKTUqW5457kk3goROYrYtLQiOKmdexOaQPIncbfOM+fITRv
	 tf5hEqQZN1WCpp9Fe4AHxIp2pcZ2KW6VlRi+4FfI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>,
	Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 6.1 55/82] arm64: dts: imx8mn-var-som: add 20ms delay to ethernet regulator enable
Date: Thu, 30 Nov 2023 16:22:26 +0000
Message-ID: <20231130162137.710815623@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231130162135.977485944@linuxfoundation.org>
References: <20231130162135.977485944@linuxfoundation.org>
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

From: Hugo Villeneuve <hvilleneuve@dimonoff.com>

commit 26ca44bdbd13edbe6cbe0dc63327c3316ce01bae upstream.

This commit is taken from Variscite linux kernel public git repository.
Original patch author: Nate Drude <nate.d@variscite.com>
See: https://github.com/varigit/linux-imx/blob/5.15-2.0.x-imx_var01/drivers/net/ethernet/freescale/fec_main.c#L3993-L4050

The ethernet phy reset was moved from the fec controller to the
mdio bus, see for example: 0e825b32c033e1998d0ebaf247f5dab3c340e3bf

When the fec driver managed the reset, the regulator had time to
settle during the fec phy reset before calling of_mdiobus_register,
which probes the mii bus for the phy id to match the correct driver.

Now that the mdio bus controls the reset, the fec driver no longer has
any delay between enabling the regulator and calling of_mdiobus_register.
If the regulator voltage has not settled, the phy id will not be read
correctly and the generic phy driver will be used.

The following call tree explains in more detail:

fec_probe
  fec_reset_phy                               <- no longer introduces delay after migration to mdio reset
  fec_enet_mii_init
    of_mdiobus_register
      of_mdiobus_register_phy
        fwnode_mdiobus_register_phy
          get_phy_device                      <- mii probe for phy id to match driver happens here
          ...
          fwnode_mdiobus_phy_device_register
            phy_device_register
              mdiobus_register_device
                mdio_device_reset             <- mdio reset assert / deassert delay happens here

Add a 20ms enable delay to the regulator to fix the issue.

Signed-off-by: Hugo Villeneuve <hvilleneuve@dimonoff.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/freescale/imx8mn-var-som.dtsi |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm64/boot/dts/freescale/imx8mn-var-som.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mn-var-som.dtsi
@@ -27,6 +27,7 @@
 		regulator-name = "eth_phy_pwr";
 		regulator-min-microvolt = <3300000>;
 		regulator-max-microvolt = <3300000>;
+		regulator-enable-ramp-delay = <20000>;
 		gpio = <&gpio2 9 GPIO_ACTIVE_HIGH>;
 		enable-active-high;
 	};


