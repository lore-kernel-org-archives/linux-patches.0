Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BAAFFBF6
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:56:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 125B1C4339B;
	Mon, 15 May 2023 17:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684173391;
	bh=/Uh98s5Dkcs1xs6RH/lx9E66JVp5GZxSv4+t0wJNBUc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=faPjOzC0Xnk1/MWNyulE+Bx3SsX813KS7WmYJG8syNkvO/KRK1MUeYlIpepeKYbsk
	 IGqmQ8FcgxLSVflrSlz6tEXNnD+KDYlqWAXI8ai5jYh+OzkhxhX7qrKtEqwZeq9jvU
	 udg86HcXcHsfwBlhLFuWoJ1rrizCmquHX77XnLYw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 080/282] wifi: rtw88: mac: Return the original error from rtw_mac_power_switch()
Date: Mon, 15 May 2023 18:27:38 +0200
Message-Id: <20230515161724.640113130@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161722.146344674@linuxfoundation.org>
References: <20230515161722.146344674@linuxfoundation.org>
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
index 9a50984fa06c9..94e69e97d5f5f 100644
--- a/drivers/net/wireless/realtek/rtw88/mac.c
+++ b/drivers/net/wireless/realtek/rtw88/mac.c
@@ -224,6 +224,7 @@ static int rtw_mac_power_switch(struct rtw_dev *rtwdev, bool pwr_on)
 	struct rtw_pwr_seq_cmd **pwr_seq;
 	u8 rpwm;
 	bool cur_pwr;
+	int ret;
 
 	rpwm = rtw_read8(rtwdev, rtwdev->hci.rpwm_addr);
 
@@ -245,8 +246,9 @@ static int rtw_mac_power_switch(struct rtw_dev *rtwdev, bool pwr_on)
 		return -EALREADY;
 
 	pwr_seq = pwr_on ? chip->pwr_on_seq : chip->pwr_off_seq;
-	if (rtw_pwr_seq_parser(rtwdev, pwr_seq))
-		return -EINVAL;
+	ret = rtw_pwr_seq_parser(rtwdev, pwr_seq);
+	if (ret)
+		return ret;
 
 	return 0;
 }
-- 
2.39.2



