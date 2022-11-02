Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB277629
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 03:24:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C173C433D6;
	Wed,  2 Nov 2022 03:24:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667359481;
	bh=2Q69VHV7Qs3astbh5E3nIqk+FeoMsKp+mDVKt46TVI8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vEDEW7SHv6zXdWokfjKpmL78DwdiIhVh0g5gmPB2JnQ+eidKIIhtUponvNsfr8P9s
	 T98X8QiLIicz6ESqVDyJlcnCkKGIKRUHnlLC4j7pROuvUHadbs2lgvt4WtXftSVxi4
	 cWpWk3YAg/bOLpqVrkG7rGOOfw/TepNopeAzdCMs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raju Rangoju <Raju.Rangoju@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 39/64] amd-xgbe: add the bit rate quirk for Molex cables
Date: Wed,  2 Nov 2022 03:34:05 +0100
Message-Id: <20221102022053.080101541@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022051.821538553@linuxfoundation.org>
References: <20221102022051.821538553@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Raju Rangoju <Raju.Rangoju@amd.com>

[ Upstream commit 170a9e341a3b02c0b2ea0df16ef14a33a4f41de8 ]

The offset 12 (bit-rate) of EEPROM SFP DAC (passive) cables is expected
to be in the range 0x64 to 0x68. However, the 5 meter and 7 meter Molex
passive cables have the rate ceiling 0x78 at offset 12.

Add a quirk for Molex passive cables to extend the rate ceiling to 0x78.

Fixes: abf0a1c2b26a ("amd-xgbe: Add support for SFP+ modules")
Signed-off-by: Raju Rangoju <Raju.Rangoju@amd.com>
Acked-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
index 5069ae164ecf..b76138cd0935 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
@@ -238,6 +238,7 @@ enum xgbe_sfp_speed {
 #define XGBE_SFP_BASE_BR_1GBE_MAX		0x0d
 #define XGBE_SFP_BASE_BR_10GBE_MIN		0x64
 #define XGBE_SFP_BASE_BR_10GBE_MAX		0x68
+#define XGBE_MOLEX_SFP_BASE_BR_10GBE_MAX	0x78
 
 #define XGBE_SFP_BASE_CU_CABLE_LEN		18
 
@@ -283,6 +284,8 @@ struct xgbe_sfp_eeprom {
 #define XGBE_BEL_FUSE_VENDOR	"BEL-FUSE        "
 #define XGBE_BEL_FUSE_PARTNO	"1GBT-SFP06      "
 
+#define XGBE_MOLEX_VENDOR	"Molex Inc.      "
+
 struct xgbe_sfp_ascii {
 	union {
 		char vendor[XGBE_SFP_BASE_VENDOR_NAME_LEN + 1];
@@ -833,7 +836,11 @@ static bool xgbe_phy_sfp_bit_rate(struct xgbe_sfp_eeprom *sfp_eeprom,
 		break;
 	case XGBE_SFP_SPEED_10000:
 		min = XGBE_SFP_BASE_BR_10GBE_MIN;
-		max = XGBE_SFP_BASE_BR_10GBE_MAX;
+		if (memcmp(&sfp_eeprom->base[XGBE_SFP_BASE_VENDOR_NAME],
+			   XGBE_MOLEX_VENDOR, XGBE_SFP_BASE_VENDOR_NAME_LEN) == 0)
+			max = XGBE_MOLEX_SFP_BASE_BR_10GBE_MAX;
+		else
+			max = XGBE_SFP_BASE_BR_10GBE_MAX;
 		break;
 	default:
 		return false;
-- 
2.35.1



