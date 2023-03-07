Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E45A8BA32
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:16:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BFF1C4339B;
	Tue,  7 Mar 2023 17:16:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678209389;
	bh=JhooWYk/J3Y118O0aO4yLRUF+YLG4SyaBxOq+BmC2lg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sfWHyxCOV8Yb+vQom1mf/9yjb73Hhtx43b/hjXDAU+W5nwco0CTxx1gL5ex6NBODw
	 JsCV5MdTVCwDjfz5+FbQOVdwSeewXE2RwXRhURjJQyDkgmK3rSzePhxXTCytkGSqQB
	 JQJM3TdoZrYWKnk3lz08AROPBBroaeJUNQiPAB7Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0204/1001] wifi: rtw88: Use rtw_iterate_vifs() for rtw_vif_watch_dog_iter()
Date: Tue,  7 Mar 2023 17:49:36 +0100
Message-Id: <20230307170030.748301451@linuxfoundation.org>
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

From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

[ Upstream commit 313f6dc7c5ed723d0c5691553eff4c0090f16bb8 ]

USB and (upcoming) SDIO support may sleep in the read/write handlers.
Make rtw_watch_dog_work() use rtw_iterate_vifs() to prevent "scheduling
while atomic" or "Voluntary context switch within RCU read-side
critical section!" warnings when accessing the registers using an SDIO
card (which is where this issue has been spotted in the real world but
it also affects USB cards).

Fixes: 78d5bf925f30 ("wifi: rtw88: iterate over vif/sta list non-atomically")
Suggested-by: Ping-Ke Shih <pkshih@realtek.com>
Reviewed-by: Ping-Ke Shih <pkshih@realtek.com>
Tested-by: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20230108211324.442823-3-martin.blumenstingl@googlemail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw88/main.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/main.c b/drivers/net/wireless/realtek/rtw88/main.c
index 888427cf3bdf9..b2e78737bd5d0 100644
--- a/drivers/net/wireless/realtek/rtw88/main.c
+++ b/drivers/net/wireless/realtek/rtw88/main.c
@@ -241,8 +241,10 @@ static void rtw_watch_dog_work(struct work_struct *work)
 	rtw_phy_dynamic_mechanism(rtwdev);
 
 	data.rtwdev = rtwdev;
-	/* use atomic version to avoid taking local->iflist_mtx mutex */
-	rtw_iterate_vifs_atomic(rtwdev, rtw_vif_watch_dog_iter, &data);
+	/* rtw_iterate_vifs internally uses an atomic iterator which is needed
+	 * to avoid taking local->iflist_mtx mutex
+	 */
+	rtw_iterate_vifs(rtwdev, rtw_vif_watch_dog_iter, &data);
 
 	/* fw supports only one station associated to enter lps, if there are
 	 * more than two stations associated to the AP, then we can not enter
-- 
2.39.2



