Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1A701C08
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:31:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74CF2C433D2;
	Wed, 28 Dec 2022 16:31:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672245074;
	bh=OO/IKjdkhfzXgaba/1sSlehygQc52J/jkKERn6B57+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XS0ADVPzOqacbQyPZoQKmfMjXNzxgM6SVPlumnDNB6aXiT7g3nunsnXb9BERvDnxa
	 2Akr0fT/ZVSEEMS7K4hFeKyh3tsplKxncBcT17zqZNoq96AaJwOq2o4WOQHYAXa5bt
	 ZMYb/3IrSAE4Vt3U08Oj6KAnmcqd3KY0ezpdeFfU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0792/1146] phy: marvell: phy-mvebu-a3700-comphy: Reset COMPHY registers before USB 3.0 power on
Date: Wed, 28 Dec 2022 15:38:51 +0100
Message-Id: <20221228144351.660712528@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Pali Rohár <pali@kernel.org>

[ Upstream commit b01d622d76134e9401970ffd3fbbb9a7051f976a ]

Turris MOX board with older ARM Trusted Firmware version v1.5 is not able
to detect any USB 3.0 device connected to USB-A port on Mox-A module after
commit 0a6fc70d76bd ("phy: marvell: phy-mvebu-a3700-comphy: Remove broken
reset support"). On the other hand USB 2.0 devices connected to the same
USB-A port are working fine.

It looks as if the older firmware configures COMPHY registers for USB 3.0
somehow incompatibly for kernel driver. Experiments show that resetting
COMPHY registers via setting SFT_RST auto-clearing bit in COMPHY_SFT_RESET
register fixes this issue.

Reset the COMPHY in mvebu_a3700_comphy_usb3_power_on() function as a first
step after selecting COMPHY lane and USB 3.0 function. With this change
Turris MOX board can successfully detect USB 3.0 devices again.

Before the above mentioned commit this reset was implemented in PHY reset
method, so this is the reason why there was no issue with older firmware
version then.

Fixes: 0a6fc70d76bd ("phy: marvell: phy-mvebu-a3700-comphy: Remove broken reset support")
Reported-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Pali Rohár <pali@kernel.org>
Tested-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Link: https://lore.kernel.org/r/20220920121154.30115-1-pali@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/marvell/phy-mvebu-a3700-comphy.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/phy/marvell/phy-mvebu-a3700-comphy.c b/drivers/phy/marvell/phy-mvebu-a3700-comphy.c
index 67712c77d806..d641b345afa3 100644
--- a/drivers/phy/marvell/phy-mvebu-a3700-comphy.c
+++ b/drivers/phy/marvell/phy-mvebu-a3700-comphy.c
@@ -826,6 +826,9 @@ mvebu_a3700_comphy_usb3_power_on(struct mvebu_a3700_comphy_lane *lane)
 	if (ret)
 		return ret;
 
+	/* COMPHY register reset (cleared automatically) */
+	comphy_lane_reg_set(lane, COMPHY_SFT_RESET, SFT_RST, SFT_RST);
+
 	/*
 	 * 0. Set PHY OTG Control(0x5d034), bit 4, Power up OTG module The
 	 * register belong to UTMI module, so it is set in UTMI phy driver.
-- 
2.35.1



