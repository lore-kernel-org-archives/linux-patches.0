Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD90FBA32
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:16:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FDF2C4339B;
	Tue,  7 Mar 2023 17:16:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678209380;
	bh=zw876mn9ig6HaA6vXp11658Mz38ymTCQR0zqRvMkjoE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vxwccZDcg//nHflN7zH+azQ5AsFO4D7hDh95mE1+t2aOUsV6heVTuYIRnQYO7hCgD
	 G89JIGkZuE+Xxm8E+HB2uDNQwSb1KyKboYsMFYZvdKBDQNt5UIDS1e+jZjhAnMVCC4
	 o6HxNweHKwf0ULYPJdCoakX02NQTE6JGpFEh2QME=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiasheng Jiang <jiasheng@iscas.ac.cn>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0201/1001] wifi: rtw89: Add missing check for alloc_workqueue
Date: Tue,  7 Mar 2023 17:49:33 +0100
Message-Id: <20230307170030.629451472@linuxfoundation.org>
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

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

[ Upstream commit ed9e6166eb0984b718facb7ca59296098cc3aa64 ]

Add check for the return value of alloc_workqueue since it may return
NULL pointer.
Moreover, add destroy_workqueue when rtw89_load_firmware fails.

Fixes: e3ec7017f6a2 ("rtw89: add Realtek 802.11ax driver")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20230104142901.1611-1-jiasheng@iscas.ac.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw89/core.c b/drivers/net/wireless/realtek/rtw89/core.c
index 931aff8b5dc95..e99eccf11c762 100644
--- a/drivers/net/wireless/realtek/rtw89/core.c
+++ b/drivers/net/wireless/realtek/rtw89/core.c
@@ -3124,6 +3124,8 @@ int rtw89_core_init(struct rtw89_dev *rtwdev)
 	INIT_DELAYED_WORK(&rtwdev->cfo_track_work, rtw89_phy_cfo_track_work);
 	INIT_DELAYED_WORK(&rtwdev->forbid_ba_work, rtw89_forbid_ba_work);
 	rtwdev->txq_wq = alloc_workqueue("rtw89_tx_wq", WQ_UNBOUND | WQ_HIGHPRI, 0);
+	if (!rtwdev->txq_wq)
+		return -ENOMEM;
 	spin_lock_init(&rtwdev->ba_lock);
 	spin_lock_init(&rtwdev->rpwm_lock);
 	mutex_init(&rtwdev->mutex);
@@ -3149,6 +3151,7 @@ int rtw89_core_init(struct rtw89_dev *rtwdev)
 	ret = rtw89_load_firmware(rtwdev);
 	if (ret) {
 		rtw89_warn(rtwdev, "no firmware loaded\n");
+		destroy_workqueue(rtwdev->txq_wq);
 		return ret;
 	}
 	rtw89_ser_init(rtwdev);
-- 
2.39.2



