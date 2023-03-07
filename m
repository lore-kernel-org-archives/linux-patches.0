Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BBABBA46
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:06:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4C59C433D2;
	Tue,  7 Mar 2023 18:06:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678212362;
	bh=h/INin/ag10OW4uhSKg4KQHV+iAyBhKa8ikwEI21Cq8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ykq+kEE13hbBz6KY1jkfUH181BedkRnHcBuxisGTht9nplkIn95Ym17i7AXUu0mcD
	 JPzayFOxs9usNJXw3awdGVzSDhH0NfKyZUj+h1uRCH59RB2m/9IR6me0aSwwxXcLI4
	 aqWpnk+oGwRWmevk3MBAt4/C74NPTW8ld1VlQurU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zong-Zhe Yang <kevin_yang@realtek.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 162/885] wifi: rtw89: fix potential leak in rtw89_append_probe_req_ie()
Date: Tue,  7 Mar 2023 17:51:36 +0100
Message-Id: <20230307170008.962548633@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
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
index d57e3610fb88e..1d57a8c5e97df 100644
--- a/drivers/net/wireless/realtek/rtw89/fw.c
+++ b/drivers/net/wireless/realtek/rtw89/fw.c
@@ -2525,8 +2525,10 @@ static int rtw89_append_probe_req_ie(struct rtw89_dev *rtwdev,
 
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



