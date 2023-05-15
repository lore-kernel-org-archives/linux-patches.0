Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 387C1E573
	for <patches@lists.linux.dev>; Mon, 15 May 2023 16:42:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 905C8C433D2;
	Mon, 15 May 2023 16:42:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684168934;
	bh=veYD+4PevfusWGxRwTuaB9iExzKQrbneJclZimclK68=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zr3BGCS6yYKCS020jgQINEk0Qby2OfwW/Yq3Wdu7sICr7mntQrs63Gn26wUDC9Wvz
	 AxuLRx9Mjw6tH8lc+JJviEiUnY+iRXYIxhR54tiAcS4/eFhf2+dnyZUxrImNXzkwjp
	 aEkCTnAjTeyRMr0Nhb41a+UK5X+A2xluSvuvhiOo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Kalle Valo <kvalo@codeaurora.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 059/191] rtlwifi: rtl_pci: Fix memory leak when hardware init fails
Date: Mon, 15 May 2023 18:24:56 +0200
Message-Id: <20230515161709.352046710@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161707.203549282@linuxfoundation.org>
References: <20230515161707.203549282@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Larry Finger <Larry.Finger@lwfinger.net>

[ Upstream commit 8cc782cd997dc4eb3ac183228d563727884ba874 ]

If the call to hw_init() fails for any of the drivers, the driver will
leak memory that was allocated in BT coexistence setup. Technically, each
of the drivers should have done this free; however placing it in rtl_pci
fixes all the drivers with only a single patch.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Stable-dep-of: 905a9241e4e8 ("wifi: rtlwifi: fix incorrect error codes in rtl_debugfs_set_write_rfreg()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtlwifi/pci.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/pci.c b/drivers/net/wireless/realtek/rtlwifi/pci.c
index 83749578fa8b3..8bda1104bda85 100644
--- a/drivers/net/wireless/realtek/rtlwifi/pci.c
+++ b/drivers/net/wireless/realtek/rtlwifi/pci.c
@@ -1817,6 +1817,8 @@ static int rtl_pci_start(struct ieee80211_hw *hw)
 	if (err) {
 		RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
 			 "Failed to config hardware!\n");
+		kfree(rtlpriv->btcoexist.btc_context);
+		kfree(rtlpriv->btcoexist.wifi_only_context);
 		return err;
 	}
 	rtlpriv->cfg->ops->set_hw_reg(hw, HW_VAR_RETRY_LIMIT,
-- 
2.39.2



