Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB8F0BA32
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:16:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37AD6C433EF;
	Tue,  7 Mar 2023 17:16:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678209377;
	bh=YJvzSjrF4kDl10elFRx9/GYSXjb1b9aiHDAE4N9u23Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PC5UkAuRzeeyi7l2eDII1dXOlVjEpviS4YzF8aiU7fJedoH9GBuJ7R/acpqa1ke+D
	 9eORA6xAcr1laip6cMpNDRhY0mA3AYBOfXvOOCS2/982/g2ga9nmmh09BJ4y4iyJBw
	 YzHbppAiKuBYdA02RNHZSHKTyGD9yxP87imr2ZDU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zong-Zhe Yang <kevin_yang@realtek.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0200/1001] wifi: rtw89: fix potential leak in rtw89_append_probe_req_ie()
Date: Tue,  7 Mar 2023 17:49:32 +0100
Message-Id: <20230307170030.589762382@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zong-Zhe Yang <kevin_yang@realtek.com>

[ Upstream commit 4a0e218cc9c42d1903ade8b5a371dcf48cf918c5 ]

Do `kfree_skb(new)` before `goto out` to prevent potential leak.

Fixes: 895907779752 ("rtw89: 8852a: add ieee80211_ops::hw_scan")
Signed-off-by: Zong-Zhe Yang <kevin_yang@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20230103141054.17372-1-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/fw.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw89/fw.c b/drivers/net/wireless/realtek/rtw89/fw.c
index de1f23779fc62..3b7af8faca505 100644
--- a/drivers/net/wireless/realtek/rtw89/fw.c
+++ b/drivers/net/wireless/realtek/rtw89/fw.c
@@ -2665,8 +2665,10 @@ static int rtw89_append_probe_req_ie(struct rtw89_dev *rtwdev,
 
 		list_add_tail(&info->list, &scan_info->pkt_list[band]);
 		ret = rtw89_fw_h2c_add_pkt_offload(rtwdev, &info->id, new);
-		if (ret)
+		if (ret) {
+			kfree_skb(new);
 			goto out;
+		}
 
 		kfree_skb(new);
 	}
-- 
2.39.2



