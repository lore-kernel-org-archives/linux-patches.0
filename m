Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4D2E168AD
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:03:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31848C433D2;
	Mon,  8 May 2023 10:03:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683540224;
	bh=xV3p6K65EfQRQrtHRLkzwRKYBbPo1Cy0iglTIRevToM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k5gDO6VI7yEW6R54UjNQKhrA5NaqNZRp/o5SNtGfkZzi9rmYWXiippXRjDcRN8OHl
	 fkggc/YzgVct9tA/7H0UcqQpGhtJeHIEd767CO5R0LOhXuBrXyUMotGqhpZGdxnwzh
	 96CWPp7PU19325hJbk06FRXq1FUU2J62BvdwqB1w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 276/611] wifi: rtw88: mac: Return the original error from rtw_mac_power_switch()
Date: Mon,  8 May 2023 11:41:58 +0200
Message-Id: <20230508094431.353535197@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094421.513073170@linuxfoundation.org>
References: <20230508094421.513073170@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

[ Upstream commit 15c8e267dfa62f207ee1db666c822324e3362b84 ]

rtw_mac_power_switch() calls rtw_pwr_seq_parser() which can return
-EINVAL, -EBUSY or 0. Propagate the original error code instead of
unconditionally returning -EINVAL in case of an error.

Fixes: e3037485c68e ("rtw88: new Realtek 802.11ac driver")
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Reviewed-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20230226221004.138331-3-martin.blumenstingl@googlemail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw88/mac.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/mac.c b/drivers/net/wireless/realtek/rtw88/mac.c
index 498f156553699..589caeff2033a 100644
--- a/drivers/net/wireless/realtek/rtw88/mac.c
+++ b/drivers/net/wireless/realtek/rtw88/mac.c
@@ -247,6 +247,7 @@ static int rtw_mac_power_switch(struct rtw_dev *rtwdev, bool pwr_on)
 	const struct rtw_pwr_seq_cmd **pwr_seq;
 	u8 rpwm;
 	bool cur_pwr;
+	int ret;
 
 	if (rtw_chip_wcpu_11ac(rtwdev)) {
 		rpwm = rtw_read8(rtwdev, rtwdev->hci.rpwm_addr);
@@ -270,8 +271,9 @@ static int rtw_mac_power_switch(struct rtw_dev *rtwdev, bool pwr_on)
 		return -EALREADY;
 
 	pwr_seq = pwr_on ? chip->pwr_on_seq : chip->pwr_off_seq;
-	if (rtw_pwr_seq_parser(rtwdev, pwr_seq))
-		return -EINVAL;
+	ret = rtw_pwr_seq_parser(rtwdev, pwr_seq);
+	if (ret)
+		return ret;
 
 	if (pwr_on)
 		set_bit(RTW_FLAG_POWERON, rtwdev->flags);
-- 
2.39.2



