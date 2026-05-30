Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6394A17555;
	Sat, 30 May 2026 18:18:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165091; cv=none; b=rFJG7BlmTVw1uFQgx9sOuukI+EbQOpbjF6mKAD+RuaiaTDVVs5ruRtW1klee9ttNsM8HbVCBNK0ptcVmi/wRwpOk3xL1VXB/tVQJSoTmWEsG50IU4oDR35DZx2vvxnu3zs3Ds4C1uxV1RF05O/C6nqUJ3dE4eOxA79/3f+uNBrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165091; c=relaxed/simple;
	bh=SfMxFhxnpIOxF/O/fr1IqdAeGN5kYYm2LUpdqto7Kf8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=h8/Oe2j4sbcsj42iEqTFaS9k3BQTNe0KVKrV4RstaHVowZ/Gi6jfbiKiKsaV6k5iNNxr6Z6cTQlurwWIgUGbhxrk/b4jpCgF4nuvOO9QXdkbB4hIHwFw6Ezkep7vPAz1KqFktbeoGHwUDh7nOJjDl73ApMVI1c9fPp8HvpKvokw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aeUf290G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aeUf290G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5F451F00893;
	Sat, 30 May 2026 18:18:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165090;
	bh=l/RrxdHM04W9lCvoQuAWePregifV0Th/gXRzQRAHIko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aeUf290GRe444+JaRDldyMwAtULtbLnVs5SihE4p6cCD5Os1ncCrkKz/A6i1NtmkT
	 KxVqQ+VWKQ7TShkYa0JWOPGClOpqgfzqMGV67nSIS0eXtgLy0kPlmF59HC6hGzFjuy
	 9m+bkVPtFANYaah7IJBba9O75thmLu4j22MsEGOQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabor Juhos <j4g8y7@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 746/776] phy: marvell: mvebu-a3700-utmi: fix incorrect USB2_PHY_CTRL register access
Date: Sat, 30 May 2026 18:07:40 +0200
Message-ID: <20260530160259.057161073@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gabor Juhos <j4g8y7@gmail.com>

[ Upstream commit 91ddf6f722084383fb05be731c0107814b055c0c ]

The mvebu_a3700_utmi_phy_power_off() function tries to modify the
USB2_PHY_CTRL register by using the IO address of the PHY IP block along
with the readl/writel IO accessors. However, the register exist in the
USB miscellaneous register space, and as such it must be accessed via
regmap like it is done in the mvebu_a3700_utmi_phy_power_on() function.

Change the code to use regmap_update_bits() for modífying the register
to fix this.

Fixes: cc8b7a0ae866 ("phy: add A3700 UTMI PHY driver")
Signed-off-by: Gabor Juhos <j4g8y7@gmail.com>
Reviewed-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://patch.msgid.link/20260321-a3700-utmi-fix-usb2_phy_ctrl-access-v1-1-6005ff4b5058@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/marvell/phy-mvebu-a3700-utmi.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/phy/marvell/phy-mvebu-a3700-utmi.c b/drivers/phy/marvell/phy-mvebu-a3700-utmi.c
index 8834436bc9dbc..e3a9278c06842 100644
--- a/drivers/phy/marvell/phy-mvebu-a3700-utmi.c
+++ b/drivers/phy/marvell/phy-mvebu-a3700-utmi.c
@@ -168,9 +168,8 @@ static int mvebu_a3700_utmi_phy_power_off(struct phy *phy)
 	u32 reg;
 
 	/* Disable PHY pull-up and enable USB2 suspend */
-	reg = readl(utmi->regs + USB2_PHY_CTRL(usb32));
-	reg &= ~(RB_USB2PHY_PU | RB_USB2PHY_SUSPM(usb32));
-	writel(reg, utmi->regs + USB2_PHY_CTRL(usb32));
+	regmap_update_bits(utmi->usb_misc, USB2_PHY_CTRL(usb32),
+			   RB_USB2PHY_PU | RB_USB2PHY_SUSPM(usb32), 0);
 
 	/* Power down OTG module */
 	if (usb32) {
-- 
2.53.0



