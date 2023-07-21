Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 604ED1F941
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 16:15:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB095C433C7;
	Fri, 21 Jul 2023 16:15:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689956111;
	bh=+ampKYm3aV2fj0B6rG+bxpPlnfy7eGpcDMff2CrdSik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G6oTwrTDnzeWgVAsKbug4cQZPExMgCC8XjIYVhbQaWr228I2tbsdqFtLawjmweSam
	 4DYcCEhj4TPYxHoZk0mzvtfSUDpeXO0MxzeuYk6Nf6DS74+LyuBdLv35N3Rq8Wz4cQ
	 A9I8LiVPm7JQy2Y3COAWtbYqcvflDSM1VxVodTXw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Shurong <zhang_shurong@foxmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 104/292] wifi: rtw89: debug: fix error code in rtw89_debug_priv_send_h2c_set()
Date: Fri, 21 Jul 2023 18:03:33 +0200
Message-ID: <20230721160533.259181132@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160528.800311148@linuxfoundation.org>
References: <20230721160528.800311148@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zhang Shurong <zhang_shurong@foxmail.com>

[ Upstream commit 4f4626cd049576af1276c7568d5b44eb3f7bb1b1 ]

If there is a failure during rtw89_fw_h2c_raw() rtw89_debug_priv_send_h2c
should return negative error code instead of a positive value count.
Fix this bug by returning correct error code.

Fixes: e3ec7017f6a2 ("rtw89: add Realtek 802.11ax driver")
Signed-off-by: Zhang Shurong <zhang_shurong@foxmail.com>
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://lore.kernel.org/r/tencent_AD09A61BC4DA92AD1EB0790F5C850E544D07@qq.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/debug.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/debug.c b/drivers/net/wireless/realtek/rtw89/debug.c
index 1e5b7a9987163..858494ddfb12e 100644
--- a/drivers/net/wireless/realtek/rtw89/debug.c
+++ b/drivers/net/wireless/realtek/rtw89/debug.c
@@ -2998,17 +2998,18 @@ static ssize_t rtw89_debug_priv_send_h2c_set(struct file *filp,
 	struct rtw89_debugfs_priv *debugfs_priv = filp->private_data;
 	struct rtw89_dev *rtwdev = debugfs_priv->rtwdev;
 	u8 *h2c;
+	int ret;
 	u16 h2c_len = count / 2;
 
 	h2c = rtw89_hex2bin_user(rtwdev, user_buf, count);
 	if (IS_ERR(h2c))
 		return -EFAULT;
 
-	rtw89_fw_h2c_raw(rtwdev, h2c, h2c_len);
+	ret = rtw89_fw_h2c_raw(rtwdev, h2c, h2c_len);
 
 	kfree(h2c);
 
-	return count;
+	return ret ? ret : count;
 }
 
 static int
-- 
2.39.2



