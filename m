Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5E4A2EF2B6;
	Tue, 17 Jun 2025 15:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175886; cv=none; b=n4mFkldjj2K5W17HNx4zNE5Bua665bju6Qg2eEMwbMzzDm6q5TwnnamSBiAWn/B96d5lOM4rgad7DfuVfe2+ed26xexRQx7IpzvOyAW8jTu7ZnKnn+WjfSENj7fgPtNsxOzRR5QQpEqpamQzJ3dD5GBcP+dTiZq9CWVHqIJv0PU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175886; c=relaxed/simple;
	bh=BzRdBWEAG2VvzGn2XQlg3fq6FkvdxY8Q96vCKTRaJCM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=powfGGsJ4cDYuCjLu8f9tLgR21Ae6U9RHOFntBLEaauV4LD9a603vmlHfHvZD35hNFAm4obG0VV8aMI06xciD5Fg8ttWni8b2YS2WaY9YbDPyM1BjHJrE59scIPUtPm1zkrLEtW9URb9SOxKBkpymNmgWnBMatAg8SAf9dzAocc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VqZvrv1l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VqZvrv1l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 638B7C4CEE7;
	Tue, 17 Jun 2025 15:58:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175886;
	bh=BzRdBWEAG2VvzGn2XQlg3fq6FkvdxY8Q96vCKTRaJCM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VqZvrv1lkSixHxuGbMHd/FI4QUsZ5xwYyHTuOb3x08Zo9rXpiClvbEO72Mc+bhzbF
	 XliIYV9wBrz82RUbayg1tICQ2CCtsHr1zlBb1m04IkHDLauH2S4Iq6K+EZfImdt0+E
	 DmgJD1vu6lolaoC0uhIOG7lavWconE24ItrxI1kg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Kodanev <aleksei.kodanev@bell-sw.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 172/512] wifi: rtw88: fix the para buffer size to avoid reading out of bounds
Date: Tue, 17 Jun 2025 17:22:18 +0200
Message-ID: <20250617152426.587802975@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index a99776af56c27..c476e65c4d71e 100644
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



