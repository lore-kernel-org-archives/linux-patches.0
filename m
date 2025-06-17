Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DF5E20F090;
	Tue, 17 Jun 2025 15:41:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174912; cv=none; b=V0O3RlCn7SF9f55IvhhGaAnGL+2extpV4kXhMjpqjl5y1j1XtttJrTxk40eb2aXDH87VIzMNKMU000ypP0SO83Ui2Z23ljGt6Ugkr3r3zKmIfIi99XhId5f9V0iHOCtCBmpbO5wU/GIDS95b2UV/YbvalZFY0WM5Bi6F1phcVJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174912; c=relaxed/simple;
	bh=G/XF/m5gXBTR1Ntll8TwETQPOUfMzZwTo+BaregvOqI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H5RcZ+gQytICFtki7nm1jvv7i6mFQqkA69BuFPiJ/4oV2NlVB2HoTTB0M3mzr5JQuUytguWuKg1ra2jAKAGCHjHIUoaN2mta5FmIUGqsW+ECdvYw4iTKzMeIvRHFPZIufsB2QJS3ZnL67MoEGVnldPZaxLkQkXJfbx40nwnw0GM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AD9Ln6i+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AD9Ln6i+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66683C4CEE3;
	Tue, 17 Jun 2025 15:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174911;
	bh=G/XF/m5gXBTR1Ntll8TwETQPOUfMzZwTo+BaregvOqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AD9Ln6i+EBCd6j+OfQVGIN7U4fokJ39hF4Yi3ubZgmqCIw9EBXg3O+p35f1S0GRg0
	 5juUkbA2/lFcCL+nyjU2TTDOwfNdSzsxQ0KvAO1g796aCwL5w1/rOUmMGnV0DGK4Yg
	 zUzfhJUFJlfpstSSxIwN6VKClR/UBJ9oKPWgRhyg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Kodanev <aleksei.kodanev@bell-sw.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 125/356] wifi: rtw88: fix the para buffer size to avoid reading out of bounds
Date: Tue, 17 Jun 2025 17:24:00 +0200
Message-ID: <20250617152343.261884983@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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

From: Alexey Kodanev <aleksei.kodanev@bell-sw.com>

[ Upstream commit 4c2c372de2e108319236203cce6de44d70ae15cd ]

Set the size to 6 instead of 2, since 'para' array is passed to
'rtw_fw_bt_wifi_control(rtwdev, para[0], &para[1])', which reads
5 bytes:

void rtw_fw_bt_wifi_control(struct rtw_dev *rtwdev, u8 op_code, u8 *data)
{
    ...
    SET_BT_WIFI_CONTROL_DATA1(h2c_pkt, *data);
    SET_BT_WIFI_CONTROL_DATA2(h2c_pkt, *(data + 1));
    ...
    SET_BT_WIFI_CONTROL_DATA5(h2c_pkt, *(data + 4));

Detected using the static analysis tool - Svace.
Fixes: 4136214f7c46 ("rtw88: add BT co-existence support")
Signed-off-by: Alexey Kodanev <aleksei.kodanev@bell-sw.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20250513121304.124141-1-aleksei.kodanev@bell-sw.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw88/coex.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw88/coex.c b/drivers/net/wireless/realtek/rtw88/coex.c
index d35f26919806a..c45c7b596ffe9 100644
--- a/drivers/net/wireless/realtek/rtw88/coex.c
+++ b/drivers/net/wireless/realtek/rtw88/coex.c
@@ -309,7 +309,7 @@ static void rtw_coex_tdma_timer_base(struct rtw_dev *rtwdev, u8 type)
 {
 	struct rtw_coex *coex = &rtwdev->coex;
 	struct rtw_coex_stat *coex_stat = &coex->stat;
-	u8 para[2] = {0};
+	u8 para[6] = {};
 	u8 times;
 	u16 tbtt_interval = coex_stat->wl_beacon_interval;
 
-- 
2.39.5



