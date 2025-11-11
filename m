Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6EAD2DC79D;
	Tue, 11 Nov 2025 01:14:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823682; cv=none; b=RvLe07v8ZKEe5bO7DinoMzeyQxWlg02K0J77CixjrMc3d11CHgDM/EVknKutfmXeHwV/SBMZ+AM5RhOJg2PwKjrp8/8fJc3yMf8Dh3l59ScmU0MU/W9i2S0M//3DsumsxKON79IERGGJ3C5ubIUjL7ObkkMANhi08iDNs6NfgvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823682; c=relaxed/simple;
	bh=sRgnQnqO5NT70cLdDKIV/wFJdy4G/XwEuAcw7B5R7ls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lAbJw4WwAcHSRjNZ4xCf4jS6gLdrowRwpCwTHOErPcOBzYvsiiDmBNWEQ8BcUEc7upRR3XXpBRLJw3eg9C59Prc5t6XTl03KTSlT1LYhVfpi/7ed6v3qs+wjh+GyfcUfMekjAqw7P+++kOdX44zu0qdhXRGV61s/9AuCKPoi2Ss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2I3CGSiU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2I3CGSiU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67A77C19424;
	Tue, 11 Nov 2025 01:14:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823682;
	bh=sRgnQnqO5NT70cLdDKIV/wFJdy4G/XwEuAcw7B5R7ls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2I3CGSiUT8kNEA1q4n5Eee9lBoEn+qcwKvuHMDNm9tLeFjYQg8wH+A79Y2xFMYkJN
	 OS734Z9ZS7HEaLUNaSPij7DGGREUS1fpy1LNxHjXn5tHZMuHmqm5P/UWfLYmZKRQax
	 MQfC+EY2nyuQMzmNnHk61Ucr82eOe73qT3s9ZtOg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuan-Chung Chen <damon.chen@realtek.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 327/849] wifi: rtw89: wow: remove notify during WoWLAN net-detect
Date: Tue, 11 Nov 2025 09:38:17 +0900
Message-ID: <20251111004544.324098027@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuan-Chung Chen <damon.chen@realtek.com>

[ Upstream commit 38846585f9df9af1f7261d85134a5510fc079458 ]

In WoWLAN net-detect mode, the firmware periodically performs scans
and sends scan reports via C2H, which driver does not need. These
unnecessary C2H events cause firmware watchdog timeout, leading
to unexpected wakeups and SER 0x2599 on 8922AE.

Signed-off-by: Kuan-Chung Chen <damon.chen@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20250811123744.15361-4-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/fw.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/fw.c b/drivers/net/wireless/realtek/rtw89/fw.c
index 16e59a4a486e6..e6f8fab799fc1 100644
--- a/drivers/net/wireless/realtek/rtw89/fw.c
+++ b/drivers/net/wireless/realtek/rtw89/fw.c
@@ -7123,7 +7123,6 @@ static void rtw89_pno_scan_add_chan_ax(struct rtw89_dev *rtwdev,
 	struct rtw89_pktofld_info *info;
 	u8 probe_count = 0;
 
-	ch_info->notify_action = RTW89_SCANOFLD_DEBUG_MASK;
 	ch_info->dfs_ch = chan_type == RTW89_CHAN_DFS;
 	ch_info->bw = RTW89_SCAN_WIDTH;
 	ch_info->tx_pkt = true;
@@ -7264,7 +7263,6 @@ static void rtw89_pno_scan_add_chan_be(struct rtw89_dev *rtwdev, int chan_type,
 	struct rtw89_pktofld_info *info;
 	u8 probe_count = 0, i;
 
-	ch_info->notify_action = RTW89_SCANOFLD_DEBUG_MASK;
 	ch_info->dfs_ch = chan_type == RTW89_CHAN_DFS;
 	ch_info->bw = RTW89_SCAN_WIDTH;
 	ch_info->tx_null = false;
-- 
2.51.0



