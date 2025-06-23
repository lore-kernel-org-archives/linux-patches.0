Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D67819CC11;
	Mon, 23 Jun 2025 21:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714667; cv=none; b=d708TahMOu7K1QhrF5w2YSfjLdjAb5wG+ZeL6wRbkz7gJlgLb4a0V45dUlAEFwnFPdRtM4NB+8Ufa1HVH3i6og58fC5skhYIL3Xsfq2cfrmQNhCSUB3g3J85vbhPQzqSYQ0QUFyYK+8LV/YAejT7mTSQt/uQp34TtG5la6WtLMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714667; c=relaxed/simple;
	bh=/qSccqiN5/++vvqwg0yMtgx0ozK9GNDAD5JkySrhU1Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l46/9jDTlzFaZVYeqIUfJ9Ud8Yk3OlrX9xlorR4sNWss2ZwOwXjfhiFmWf5r0zvdUXFVRnoZkk1I5ElZf7pVEugbNr/PT9q9Krexqb1pTcmlkEko4e3eO4fag5AFbxGZ7bAaOIYF0lCgsCxJe2nKxX5y/cDt2Q+eTGZD1H37J+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cj7b4P81; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cj7b4P81"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C70A1C4CEEA;
	Mon, 23 Jun 2025 21:37:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714667;
	bh=/qSccqiN5/++vvqwg0yMtgx0ozK9GNDAD5JkySrhU1Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cj7b4P81dIIKUztdpFJpJla5h8WwIYr6NmDTaQkI8mAZKYobnNdVa68A/+UqAlufy
	 UeFFQT2GXtmbiO0SpUIBOhM/t2L5P4nA4RKVv9xWkTmXevkMOmYvntW2HwasTaC3i9
	 73I5Kz+e7yHo37n7FlbXeBh9W882+O9SnFzEaK4w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dian-Syuan Yang <dian_syuan0116@realtek.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 151/290] wifi: rtw89: leave idle mode when setting WEP encryption for AP mode
Date: Mon, 23 Jun 2025 15:06:52 +0200
Message-ID: <20250623130631.438098383@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.910356556@linuxfoundation.org>
References: <20250623130626.910356556@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dian-Syuan Yang <dian_syuan0116@realtek.com>

[ Upstream commit d105652b33245162867ac769bea336976e67efb8 ]

Due to mac80211 triggering the hardware to enter idle mode, it fails
to install WEP key causing connected station can't ping successfully.
Currently, it forces the hardware to leave idle mode before driver
adding WEP keys.

Signed-off-by: Dian-Syuan Yang <dian_syuan0116@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20250507031203.8256-1-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/cam.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw89/cam.c b/drivers/net/wireless/realtek/rtw89/cam.c
index f5301c2bbf133..9a0ffaddb8360 100644
--- a/drivers/net/wireless/realtek/rtw89/cam.c
+++ b/drivers/net/wireless/realtek/rtw89/cam.c
@@ -6,6 +6,7 @@
 #include "debug.h"
 #include "fw.h"
 #include "mac.h"
+#include "ps.h"
 
 static struct sk_buff *
 rtw89_cam_get_sec_key_cmd(struct rtw89_dev *rtwdev,
@@ -333,9 +334,11 @@ int rtw89_cam_sec_key_add(struct rtw89_dev *rtwdev,
 
 	switch (key->cipher) {
 	case WLAN_CIPHER_SUITE_WEP40:
+		rtw89_leave_ips_by_hwflags(rtwdev);
 		hw_key_type = RTW89_SEC_KEY_TYPE_WEP40;
 		break;
 	case WLAN_CIPHER_SUITE_WEP104:
+		rtw89_leave_ips_by_hwflags(rtwdev);
 		hw_key_type = RTW89_SEC_KEY_TYPE_WEP104;
 		break;
 	case WLAN_CIPHER_SUITE_CCMP:
-- 
2.39.5



