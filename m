Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BDF64B7A55;
	Thu, 17 Sep 2026 17:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667229; cv=none; b=pW/4dADB27sZVhHHG6F2MxqUU8dgMjnEOcCkb5ArZHVfECFF5OcxMipiEiI+9rN2QRfxHPcZt9KFZ6sIhMcgHSNdN5UCN0i4ttMs3O90AfyWDhCuwyD3CtVX7BLLklRnzGEX7pD7lDnMM2bqY/PTQPHzCXdzEpLkt3GWz3GmF50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667229; c=relaxed/simple;
	bh=J32f8svJJL4SDPlMoXXO+8bwTPBMwytrdhEBR8RzKsc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dc+2/pEJSSRRuuE651mch9q9DCzcVATPCy8BeAjf3hbT2eOOfVD9smreWrNl3sZwpYuRMw4ZW2Ub9j8QfCbF80rv63hqM9tkZ2faFclAcSMcH4V+0BGzf17l3hNUwzP2K/yq20/gHHNLbq/uc/PzATQfFdchxcYqnwsJA5CNjbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s5JLHxgg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s5JLHxgg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D575D1F000FF;
	Thu, 17 Sep 2026 17:47:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667228;
	bh=gpBsegsXYZFEi96STKrITfZOS8c2+fNOFj6vbURDsm8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s5JLHxggvFp5Z+MiIgVcbUsX445uouIGtaROsJq7F2n2mtrySdlzO0VxrQ9bDV7zq
	 GmTQPCj5Ge//eUmOym8my9hTkScRd8XjcBk5+itxW95ELNVsP/EU/jqEA8rcrIJFk1
	 JP4YbrhH/iDiqepFUK4hsE0mpwSNIvsgGmiPfI78=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dian-Syuan Yang <dian_syuan0116@realtek.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0023/1102] wifi: rtw89: disable CSI STBC for VHT 160MHz
Date: Thu, 17 Sep 2026 15:59:26 +0100
Message-ID: <20260917151540.012951456@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dian-Syuan Yang <dian_syuan0116@realtek.com>

[ Upstream commit d1fba55228685a7a237681be739683eaf698b9bc ]

Fix interoperability problem where CSI feedback with STBC enabled at
VHT 160MHz BW cannot be properly decoded by certain APs, causing CSI
reports to be rejected. This problem is specific to Wi-Fi 7 chips,
as Wi-Fi 6 defaults to 20MHz CSI BW. Therefore, disable STBC encoding
for CSI transmission in VHT 160MHz mode to ensure CSI feedback is
accepted by these APs and maintain smooth throughput.

Signed-off-by: Dian-Syuan Yang <dian_syuan0116@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20260424072552.59220-4-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/mac_be.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw89/mac_be.c b/drivers/net/wireless/realtek/rtw89/mac_be.c
index 2896abce94a3c..4d180f7723d43 100644
--- a/drivers/net/wireless/realtek/rtw89/mac_be.c
+++ b/drivers/net/wireless/realtek/rtw89/mac_be.c
@@ -2131,6 +2131,10 @@ static int rtw89_mac_set_csi_para_reg_be(struct rtw89_dev *rtwdev,
 		sound_dim = min(sound_dim, t);
 	}
 
+	/* Disable stbc_en in VHT 160MHz to avoid IOT issues with certain APs */
+	if (link_sta->vht_cap.cap & IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160MHZ)
+		stbc_en = 0;
+
 	nc = min(nc, sound_dim);
 	nr = min(nr, sound_dim);
 
-- 
2.53.0



