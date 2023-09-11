Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EEA71170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 13:56:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E072EC433C8;
	Mon, 11 Sep 2023 13:56:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694440562;
	bh=0lOlsUM+16kaay35tGEYO3kg3POwwPd0Dfa5u/EjnvQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aGpobCDdFcqI8VH+4leToL5hLWPfLHKHuAGmod0JhJdPnvUsjHVz3Jd8z/ZxwJewO
	 oKBccNbBM4B4C41BylFDjKEjeJAE+2rI7Pc2m9lq0DJvx71xhL3rv+lT+T9Smslm8Z
	 Wp6Dp2cZCj/jZPkeIRvynRP/2ekcjXH/OxhjsrVs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Shurong <zhang_shurong@foxmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 079/739] wifi: rtw89: debug: Fix error handling in rtw89_debug_priv_btc_manual_set()
Date: Mon, 11 Sep 2023 15:37:58 +0200
Message-ID: <20230911134653.321237742@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Shurong <zhang_shurong@foxmail.com>

[ Upstream commit 59b4cc439f184c5eaa34161ec67af1e16ffabed4 ]

If there is a failure during kstrtobool_from_user()
rtw89_debug_priv_btc_manual_set should return a negative error code
instead of returning the count directly.

Fix this bug by returning an error code instead of a count after
a failed call of the function "kstrtobool_from_user". Moreover
I omitted the label "out" with this source code correction.

Fixes: e3ec7017f6a2 ("rtw89: add Realtek 802.11ax driver")
Signed-off-by: Zhang Shurong <zhang_shurong@foxmail.com>
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/tencent_1C09B99BD7DA9CAD18B00C8F0F050F540607@qq.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/debug.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/debug.c b/drivers/net/wireless/realtek/rtw89/debug.c
index a4bbac916e22b..ce5a9ac081457 100644
--- a/drivers/net/wireless/realtek/rtw89/debug.c
+++ b/drivers/net/wireless/realtek/rtw89/debug.c
@@ -3193,12 +3193,14 @@ static ssize_t rtw89_debug_priv_btc_manual_set(struct file *filp,
 	struct rtw89_dev *rtwdev = debugfs_priv->rtwdev;
 	struct rtw89_btc *btc = &rtwdev->btc;
 	bool btc_manual;
+	int ret;
 
-	if (kstrtobool_from_user(user_buf, count, &btc_manual))
-		goto out;
+	ret = kstrtobool_from_user(user_buf, count, &btc_manual);
+	if (ret)
+		return ret;
 
 	btc->ctrl.manual = btc_manual;
-out:
+
 	return count;
 }
 
-- 
2.40.1



