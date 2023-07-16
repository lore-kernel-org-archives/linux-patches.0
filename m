Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 593F78F70
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 19:59:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1FF5C433CB;
	Sun, 16 Jul 2023 19:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689537577;
	bh=+8NbRT5L1KKxuEnQSd+1DyIIY1tjUC9/fc9jkMnayr4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hfWXXLZjgaO0uDu5bl7U32N5ac67SfUMCDcAG/Lwh58DL7wKng7jR0bd9PxVyLBxY
	 DT9HU24J73xWgcHmqX4Lsn1+Dp94fyN69nkvmWRvAbqrnfqj0y7LiqMNhvX4ufkhz+
	 o6cI0Gsn6KW2DuWKcaubTunpPMgcmyseebQbZayM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 116/800] wifi: rtw88: unlock on error path in rtw_ops_add_interface()
Date: Sun, 16 Jul 2023 21:39:29 +0200
Message-ID: <20230716194951.803430706@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit e2ff1181b3d48257aab26bfd2165f3c7d271499f ]

Call mutex_unlock(&rtwdev->mutex); before returning on this error path.

Fixes: f0e741e4ddbc ("wifi: rtw88: add bitmap for dynamic port settings")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/ddd10a74-5982-4f65-8c59-c1cca558d239@kili.mountain
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw88/mac80211.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw88/mac80211.c b/drivers/net/wireless/realtek/rtw88/mac80211.c
index 144618bb94c86..09bcc2345bb05 100644
--- a/drivers/net/wireless/realtek/rtw88/mac80211.c
+++ b/drivers/net/wireless/realtek/rtw88/mac80211.c
@@ -164,8 +164,10 @@ static int rtw_ops_add_interface(struct ieee80211_hw *hw,
 	mutex_lock(&rtwdev->mutex);
 
 	port = find_first_zero_bit(rtwdev->hw_port, RTW_PORT_NUM);
-	if (port >= RTW_PORT_NUM)
+	if (port >= RTW_PORT_NUM) {
+		mutex_unlock(&rtwdev->mutex);
 		return -EINVAL;
+	}
 	set_bit(port, rtwdev->hw_port);
 
 	rtwvif->port = port;
-- 
2.39.2



