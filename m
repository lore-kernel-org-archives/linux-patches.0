Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 960E51A3159;
	Tue, 27 May 2025 17:37:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367473; cv=none; b=ia9p59uXhIzT6y5TMzVEUeHL0HVJg0Rz5uEhAGr9ev2plgNkaZc09FWV4iV6CVTdLjMgEyWCLaxp3IcEDV+jMCEV2gwiN06dY/gGcF46pcbCtxevUCA1OjhDz3239CiU25ey8p0HWtPFDSxs1hwXChZ45RzcpV2zQO/EVD6IBFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367473; c=relaxed/simple;
	bh=m6uS7jiEE+lkNpMeXcGXDztKBDFd0J0tWaH9VRN/Zmw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HPOHLAd/JPK8wPn5GrH4Urjie7mG45SVGBH3GHwLU8j2v3i+ikh+UVVhsZT7uUSLQ68eexNvYmyNPv/8BcbFTa/eVCPnNLIfwbNxqdtw+w/VhsTad+tEmMG1P0ptL/Bo6XXSq0BiXDpe3AqmGTc0yGdtCfsHugc1qV/ejIeUX54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vt8ZOVZn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vt8ZOVZn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27DE1C4CEE9;
	Tue, 27 May 2025 17:37:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367473;
	bh=m6uS7jiEE+lkNpMeXcGXDztKBDFd0J0tWaH9VRN/Zmw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vt8ZOVZn9Mtv1OIr4/MJ7zExa7Wdwpof8/BSaNbDDT+JZ+eOJ7sB3+LGKDYQQeLvJ
	 qeIPdSYu4NT/m0sXeFwi3Gi593y2uJfs40Agx6u/A3oSxQIAt4yH8Hi15qzkYRT023
	 aA6w2d09+CLr1r+BulrnMOhbXYX62fXisXaZYSAc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuan-Chung Chen <damon.chen@realtek.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 399/783] wifi: rtw89: 8922a: fix incorrect STA-ID in EHT MU PPDU
Date: Tue, 27 May 2025 18:23:16 +0200
Message-ID: <20250527162529.342758470@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuan-Chung Chen <damon.chen@realtek.com>

[ Upstream commit bdce0574243b43b3bb2064f609c0c326df44c4c6 ]

EHT MU PPDU contains user field of EHT-SIG field with STA-ID that
must match AID subfield in the Associate Response. Add a necessary
setting to prevent these from being inconsistent.

Signed-off-by: Kuan-Chung Chen <damon.chen@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20250217061235.32031-1-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/fw.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/fw.c b/drivers/net/wireless/realtek/rtw89/fw.c
index 92e6bc05cbf66..f4b3438615541 100644
--- a/drivers/net/wireless/realtek/rtw89/fw.c
+++ b/drivers/net/wireless/realtek/rtw89/fw.c
@@ -3329,9 +3329,10 @@ int rtw89_fw_h2c_assoc_cmac_tbl_g7(struct rtw89_dev *rtwdev,
 			      CCTLINFO_G7_W5_NOMINAL_PKT_PADDING3 |
 			      CCTLINFO_G7_W5_NOMINAL_PKT_PADDING4);
 
-	h2c->w6 = le32_encode_bits(vif->type == NL80211_IFTYPE_STATION ? 1 : 0,
+	h2c->w6 = le32_encode_bits(vif->cfg.aid, CCTLINFO_G7_W6_AID12_PAID) |
+		  le32_encode_bits(vif->type == NL80211_IFTYPE_STATION ? 1 : 0,
 				   CCTLINFO_G7_W6_ULDL);
-	h2c->m6 = cpu_to_le32(CCTLINFO_G7_W6_ULDL);
+	h2c->m6 = cpu_to_le32(CCTLINFO_G7_W6_AID12_PAID | CCTLINFO_G7_W6_ULDL);
 
 	if (rtwsta_link) {
 		h2c->w8 = le32_encode_bits(link_sta->he_cap.has_he,
-- 
2.39.5



