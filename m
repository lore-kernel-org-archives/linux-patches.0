Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8D2E202983;
	Mon, 23 Jun 2025 21:13:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713229; cv=none; b=UEC+601AS5slMDurm/81m9spJprACZirqHZTIhhtJb6M1VxYwDm4p5Vk/6a+xEINFGX7FCQkBtf+KMMQP+Mb14j/nkQJrLKL//+LvzdGor8/yEzdjUQw38uYJd7exS3jHFmBt22+owgK+Z+z7uqzBVLT7HHxc+KcpA7VmcXgep8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713229; c=relaxed/simple;
	bh=6Yep8TWqonM1mZ4XERMCmf6wSqMKox9w4Dvu33Q2Msk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m2G84cUDM0Rom+eaVnVbvztL9Z0e2hI5WWs5wmHIBnwzW0VTmh8rIk5u5AIibtcVejirItfTGOsGbclRQSRZNIst+BhtJdu61XomCoUkImf9rNCnFNG/3dZxvVtFIG+xx1/CRDIwxDwjnioipltrvrENNqJfSilVz7FHaQIhS2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PHoUIZ2K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PHoUIZ2K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80239C4CEEA;
	Mon, 23 Jun 2025 21:13:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713228;
	bh=6Yep8TWqonM1mZ4XERMCmf6wSqMKox9w4Dvu33Q2Msk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PHoUIZ2KUCU2r3KhEgiJZJ5Gpw7rcnqEgfsyjX8p1joEKW2bBAliZRlFh+tNyyvad
	 QREtT0JeZEdnrLZpWJBHnMC1ogRaSVV4KMy152QnmKt1/93hFGFEDhFZPXvBk7apCc
	 t8illerfZzoH9nbwhxgFUdf9EPQg7XV5XG7otDUc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Kodanev <aleksei.kodanev@bell-sw.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 085/508] wifi: rtw88: fix the para buffer size to avoid reading out of bounds
Date: Mon, 23 Jun 2025 15:02:10 +0200
Message-ID: <20250623130647.334496794@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 8627ab0ce3bdf..1a9336c595c12 100644
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



