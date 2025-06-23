Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A6D64C6E;
	Mon, 23 Jun 2025 13:31:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685481; cv=none; b=cEx1LyYtnycMunjzdiLEwkhIqJrwzLRiI+M6XN+Qbu7lEkx+hvOVHjyxu/HcY2vvQuVnfI2UUO5/xPVB3GoLT5G8hdyZ1enawQBVbs70QMikU5E/JhNQHS/g/apBFbt0Oq8O6dLa3VjObJNt/qaIixWwpcG0EUHKrlSSRh/qGB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685481; c=relaxed/simple;
	bh=dMSa/kFwN/iI0VdMhn0G64rvMvPc+wts/SIWBDdEP4I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Knmy5d91NCm2I1vUUqtcnEEM+t9X7Pzwn1uOfaVgVpnTRhbGP0FfDlUAgQ5Y8glPFgyZTnVl1Gs+6VxEcrm63LH6DQkN7+pJdzPQEA9kjcBEzvGVy+puiv8kWLcnrM97nU+flF1ubA8NtQCot50IabZ1D6SvNdYGvm2pBZS5kng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1iP2St2s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1iP2St2s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E54DC4CEF0;
	Mon, 23 Jun 2025 13:31:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685480;
	bh=dMSa/kFwN/iI0VdMhn0G64rvMvPc+wts/SIWBDdEP4I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1iP2St2sDq1C9brcYk1AiY78hF5L0EkwMhTk7DefBAvJKQxpRyZZn1vAICt3U6C6f
	 6XZLfUrmT0m1LghZf6pB8ejaBp/Mj56clk7ieOjsgMDxYoOZ3FeRzQ6aQWIYvBCSlb
	 MtqIFTXQbLa3tdXyf6+8EdD3CLdI1vkDBvgsi/2c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Kodanev <aleksei.kodanev@bell-sw.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 061/411] wifi: rtw88: fix the para buffer size to avoid reading out of bounds
Date: Mon, 23 Jun 2025 15:03:25 +0200
Message-ID: <20250623130634.820789377@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 347fc36068edb..a37c963146a26 100644
--- a/drivers/net/wireless/realtek/rtw88/coex.c
+++ b/drivers/net/wireless/realtek/rtw88/coex.c
@@ -305,7 +305,7 @@ static void rtw_coex_tdma_timer_base(struct rtw_dev *rtwdev, u8 type)
 {
 	struct rtw_coex *coex = &rtwdev->coex;
 	struct rtw_coex_stat *coex_stat = &coex->stat;
-	u8 para[2] = {0};
+	u8 para[6] = {};
 	u8 times;
 	u16 tbtt_interval = coex_stat->wl_beacon_interval;
 
-- 
2.39.5



