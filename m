Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 201902F2366;
	Tue, 17 Jun 2025 15:51:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175460; cv=none; b=TzID4yhRsszfaDb87UkZ3yz36JOa2Ohvr/462tBl3ORYx3yCbNztgRIxydWfSAkeANIZpmjPcfy0XQ4+ORyZYo30nJxNMQWsBwIArkj5jagh3+lSkUjGkatOE/5GLCu27ZogBwgN8Zxi6HZxW9LLepFTGCf0plUWSIxZJCQuL/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175460; c=relaxed/simple;
	bh=RMd96hefkEZpm1N898ws95um0nj94TUujc8ihRxytg8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ucpT8zlfldJwYK2BjHpkxY2zjTLDM5VZkAvW7N/nzQ2Xy9ZoUQuM9yUPa8UKyhO7FgP84oZWvFlfd14Pc8L/Fh+CRaMRdOAU+XYipbISulrQs69edYXrIsQbuYCPEkSyXnb0v31RGiGud2dt/lTa9MTWopO4GlwrXvipDcBo5ao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2Oa/1ded; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2Oa/1ded"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 737BBC4CEE3;
	Tue, 17 Jun 2025 15:50:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175459;
	bh=RMd96hefkEZpm1N898ws95um0nj94TUujc8ihRxytg8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2Oa/1dedEEX+8D6tHEVRScIxoTYbPEHlpZaFXSI107ZRoZMAOio+/TmUk7DBTPZqt
	 oDHCB63L8kN5IjLD9ISR1g5J7Rq6pMNMwlbPCnwfNIez532Wg1U29AJ7LFbUSy7LVa
	 MK4v5H52qHv5LYq34LOWpm+plsUcqPj3uHDNlPdw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhen XIN <zhen.xin@nokia-sbell.com>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 128/512] wifi: rtw88: sdio: call rtw_sdio_indicate_tx_status unconditionally
Date: Tue, 17 Jun 2025 17:21:34 +0200
Message-ID: <20250617152424.776514473@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhen XIN <zhen.xin@nokia-sbell.com>

[ Upstream commit fc5f5a0ec463ae6a07850428bd3082947e01d276 ]

The rtw88-sdio do not work in AP mode due to the lack of TX status report
for management frames.

Make the invocation of rtw_sdio_indicate_tx_status unconditional and cover
all packet queues

Tested-on: rtl8723ds

Fixes: 65371a3f14e7 ("wifi: rtw88: sdio: Add HCI implementation for SDIO based chipsets")
Signed-off-by: Zhen XIN <zhen.xin@nokia-sbell.com>
Reviewed-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20250410154217.1849977-2-zhen.xin@nokia-sbell.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw88/sdio.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/sdio.c b/drivers/net/wireless/realtek/rtw88/sdio.c
index 0316a0bec96e2..5b8e88c9759d1 100644
--- a/drivers/net/wireless/realtek/rtw88/sdio.c
+++ b/drivers/net/wireless/realtek/rtw88/sdio.c
@@ -1225,10 +1225,7 @@ static void rtw_sdio_process_tx_queue(struct rtw_dev *rtwdev,
 		return;
 	}
 
-	if (queue <= RTW_TX_QUEUE_VO)
-		rtw_sdio_indicate_tx_status(rtwdev, skb);
-	else
-		dev_kfree_skb_any(skb);
+	rtw_sdio_indicate_tx_status(rtwdev, skb);
 }
 
 static void rtw_sdio_tx_handler(struct work_struct *work)
-- 
2.39.5



