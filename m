Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 980FF4F391B;
	Thu, 17 Sep 2026 16:04:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789661087; cv=none; b=oZvLgK3UOpi5FW/ErEOkieTCBwasAHY9UjzBbnFCzNHZrcexfB++HpeYAbgsGUz+Een3pyL/Y2rtMHsT9bjXRtInHxt4mkUySDQQUs/1wRh3smDgWEBb+6YEbdrEbvLi1nthzjL9yTBGDjBECaUE7x2Ei8Upzc+LvmStIVf72xk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789661087; c=relaxed/simple;
	bh=WWrVte9Eh+GIMmJMItnEcVyLs1yKcR4Fy/oHRt0oGZg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mN6qVMaBPBu5ETFCY+hKhQTMZwSGJKZXYYx4zPV+wy8ZSsD9QD9f6f10WvO8amWZDVP5Hjmx/+ikmZKU5yUpfWF9tQBLT8wslVxcFz7glGY3MILWak5mXcMblb/YxvjHnmTfkvUeYRZ56h/8zmnxdFjku8ils5W7eNtUttABWJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PTlBqnna; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PTlBqnna"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6B221F00893;
	Thu, 17 Sep 2026 16:04:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789661086;
	bh=zQNjpT8bmJiPVndwWP2bI+c5cO4oxMUucsvIA6suGBo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PTlBqnnazmG+0TzANuY/T5EtiRe+e8swRNcfAiLagUTSayMiE3mRnneiWgSvQ+U+q
	 F2dV1vGAauuBkLC3ba4+IYRe+bUINx5Psy0EqehfX64KdKApfjKG8GdqNL3loXKu4r
	 wBG84frPWUDWWduh1GdVMsFvON68Q9736dA1GD8g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dian-Syuan Yang <dian_syuan0116@realtek.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0037/1250] wifi: rtw89: disable CSI STBC for VHT 160MHz
Date: Thu, 17 Sep 2026 15:57:12 +0100
Message-ID: <20260917151552.941246288@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index e5a61c628b731..b03392612f252 100644
--- a/drivers/net/wireless/realtek/rtw89/mac_be.c
+++ b/drivers/net/wireless/realtek/rtw89/mac_be.c
@@ -2147,6 +2147,10 @@ static int rtw89_mac_set_csi_para_reg_be(struct rtw89_dev *rtwdev,
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



