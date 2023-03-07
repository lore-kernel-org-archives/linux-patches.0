Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02026BA3E
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:41:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77733C433EF;
	Tue,  7 Mar 2023 17:41:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678210872;
	bh=cBy2a3clAtFIOYuOERbn68hxXLJAGatYM12N2YmujXg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lcW4zmAiavbZqJ4CMIjalWG47JoL12uu5pW7l/WK90lXGEzqlHZiuUx2xnBeKYv+l
	 zSh1Mk3jZwlGUBcMUXd107GZDytSqBS21F4QMoY3FUtnXFHNLaxsICHcmFGT2FSQHn
	 modZPcHys9O5h0XhbUkAc1lMZoukqTp09MQW/fc0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zong-Zhe Yang <kevin_yang@realtek.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0681/1001] wifi: rtw89: debug: avoid invalid access on RTW89_DBG_SEL_MAC_30
Date: Tue,  7 Mar 2023 17:57:33 +0100
Message-Id: <20230307170051.154223282@linuxfoundation.org>
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

[ Upstream commit c074da21dd346e0cfef5d08b0715078d7aea7f8d ]

Only 8852C chip has valid pages on RTW89_DBG_SEL_MAC_30. To other chips,
this section is an address hole. It will lead to crash if trying to access
this section on chips except for 8852C. So, we avoid that.

Signed-off-by: Zong-Zhe Yang <kevin_yang@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20230119063529.61563-2-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/debug.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw89/debug.c b/drivers/net/wireless/realtek/rtw89/debug.c
index 8297e35bfa52b..6730eea930ece 100644
--- a/drivers/net/wireless/realtek/rtw89/debug.c
+++ b/drivers/net/wireless/realtek/rtw89/debug.c
@@ -615,6 +615,7 @@ rtw89_debug_priv_mac_reg_dump_select(struct file *filp,
 	struct seq_file *m = (struct seq_file *)filp->private_data;
 	struct rtw89_debugfs_priv *debugfs_priv = m->private;
 	struct rtw89_dev *rtwdev = debugfs_priv->rtwdev;
+	const struct rtw89_chip_info *chip = rtwdev->chip;
 	char buf[32];
 	size_t buf_size;
 	int sel;
@@ -634,6 +635,12 @@ rtw89_debug_priv_mac_reg_dump_select(struct file *filp,
 		return -EINVAL;
 	}
 
+	if (sel == RTW89_DBG_SEL_MAC_30 && chip->chip_id != RTL8852C) {
+		rtw89_info(rtwdev, "sel %d is address hole on chip %d\n", sel,
+			   chip->chip_id);
+		return -EINVAL;
+	}
+
 	debugfs_priv->cb_data = sel;
 	rtw89_info(rtwdev, "select mac page dump %d\n", debugfs_priv->cb_data);
 
-- 
2.39.2



