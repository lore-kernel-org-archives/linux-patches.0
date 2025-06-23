Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63F0E1EEA3C;
	Mon, 23 Jun 2025 21:21:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713719; cv=none; b=cypMiq1gpOTLRjqw68EZl2uqVoDb8flGFd/meSChnLg18siAzcjlQhgZfvzCnDfyg25ttRtkAyKC0Q2wf/iyGgfhm6wGvub96rG/8lqtilhJAdj9XN2IELs4kzbB/ciMc0iubn+ArpqaR7QHz02eFYiT/uYJGuRcM0pzV+TzaJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713719; c=relaxed/simple;
	bh=VQR7TkmWa8GoMvx1FDk0k1t+wKA8ux731QKlviIl9ss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LgaVToQpjVG+3iscdKkdeTWLUtGqERDW41mEJBptxKsRr3Mqs0N7onr6asrOora9C1P0wACe3pC8uNDediAoIxdcSvN7kgkyMJ3EqMyPu2l/rfxDM8XNV+f8W7X2ebptKy+x/Vu9kInDlNajO761sFf/2q8BqS5M+wBKi1RAxuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gvghKf/c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gvghKf/c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF1B6C4CEEA;
	Mon, 23 Jun 2025 21:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713719;
	bh=VQR7TkmWa8GoMvx1FDk0k1t+wKA8ux731QKlviIl9ss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gvghKf/cvxyF1yJOmL+WU1o4qTFjJxt4l7zblboBG2bst4fhJMfyQvXz9ogyM7N9Q
	 DAfaTzzbUnC+XaHAkpqOZ3HXMT7E+0zkpFQrkUw/zo4HopmYQrE84nTTlaARoixgP7
	 9MqmvbBDprTklBV9tU/TokLmGsffuSv1Fp9wKP0A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dian-Syuan Yang <dian_syuan0116@realtek.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 343/592] wifi: rtw89: leave idle mode when setting WEP encryption for AP mode
Date: Mon, 23 Jun 2025 15:05:01 +0200
Message-ID: <20250623130708.609488486@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index eca3d767ff603..bc6f799e291e8 100644
--- a/drivers/net/wireless/realtek/rtw89/cam.c
+++ b/drivers/net/wireless/realtek/rtw89/cam.c
@@ -6,6 +6,7 @@
 #include "debug.h"
 #include "fw.h"
 #include "mac.h"
+#include "ps.h"
 
 static struct sk_buff *
 rtw89_cam_get_sec_key_cmd(struct rtw89_dev *rtwdev,
@@ -471,9 +472,11 @@ int rtw89_cam_sec_key_add(struct rtw89_dev *rtwdev,
 
 	switch (key->cipher) {
 	case WLAN_CIPHER_SUITE_WEP40:
+		rtw89_leave_ips_by_hwflags(rtwdev);
 		hw_key_type = RTW89_SEC_KEY_TYPE_WEP40;
 		break;
 	case WLAN_CIPHER_SUITE_WEP104:
+		rtw89_leave_ips_by_hwflags(rtwdev);
 		hw_key_type = RTW89_SEC_KEY_TYPE_WEP104;
 		break;
 	case WLAN_CIPHER_SUITE_TKIP:
-- 
2.39.5



