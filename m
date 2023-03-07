Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D41EBA32
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:14:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3EBEC4339B;
	Tue,  7 Mar 2023 17:14:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678209291;
	bh=7HH2XDgwJrAY4oC5piNukxwTtOSSCQ8UeNceIwipvGQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LYTpBmF9RSMsoxtc1E31RZAcuiALytV9KEECiaZMo9E7TtO8t2w4sSGIrZchlz4qU
	 kBT28Unrdy2djKnTaUv1X/+1vZropqvEtjsygm8KcFPkGB2909AqcFyMc8R21PQ1h7
	 MxrxHGE6TvaUCbsAmttpEQSPPjs3nRnX9+fw/G2A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0154/1001] wifi: rtl8xxxu: Fix assignment to bit field priv->pi_enabled
Date: Tue,  7 Mar 2023 17:48:46 +0100
Message-Id: <20230307170028.738244582@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Bitterblue Smith <rtl8821cerfe2@gmail.com>

[ Upstream commit 9e32b4a709f0f7b7adf5d9939c3bd47c78c4f003 ]

Just because priv->pi_enabled is only one bit doesn't mean it works
like a bool. The value assigned to it loses all bits except bit 0,
so only assign 0 or 1 to it.

This affects the RTL8188FU, but fixing the assignment didn't make
a difference for my device.

Fixes: c888183b21f3 ("wifi: rtl8xxxu: Support new chip RTL8188FU")
Signed-off-by: Bitterblue Smith <rtl8821cerfe2@gmail.com>
Reviewed-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/4368d585-11ec-d3c7-ec12-7f0afdcedfda@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8188f.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8188f.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8188f.c
index 2c4f403ba68f3..97e7ff7289fab 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8188f.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8188f.c
@@ -1122,7 +1122,7 @@ static void rtl8188fu_phy_iqcalibrate(struct rtl8xxxu_priv *priv,
 
 	if (t == 0) {
 		val32 = rtl8xxxu_read32(priv, REG_FPGA0_XA_HSSI_PARM1);
-		priv->pi_enabled = val32 & FPGA0_HSSI_PARM1_PI;
+		priv->pi_enabled = u32_get_bits(val32, FPGA0_HSSI_PARM1_PI);
 	}
 
 	/* save RF path */
-- 
2.39.2



