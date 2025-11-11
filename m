Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C6F934403D;
	Tue, 11 Nov 2025 01:12:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823579; cv=none; b=E5pC3l1p3Vnk4Nszu89LQ5hza5G4c7F4DiJxinJmUU0Lv6jDUz/st1Wh0DphrOSYJ9kRIdyuZAwO8xwM+dsI8Sh4TfB6tADZb6g/qVq1T4hiHg4XLnBW+ICioPDMyU/TGvjZiJiMjN7YI+593sgkiPRSuiEwm8arpJLGfbiwY3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823579; c=relaxed/simple;
	bh=m3IJ1Od+IZb+CkV9b/hKLINLgwlUw5Ue9twy0CqRD/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KahfbE/c7E8JXBHmzClZmuviel48yCIaWFiGxqwLInL7V8WdsGOzb/w95zbHdDJ5jX9aLd2kPtT2xj5W72mc2RPqqmdggDVhbdk/6y/dIabgse0nl3QFFb3VO7RJfPqxWKSgcl62IVWYUNhvv6AwPSIVvuTq7YUhyjzTU+DH3V0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NcfBD2D5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NcfBD2D5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C03EAC19424;
	Tue, 11 Nov 2025 01:12:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823579;
	bh=m3IJ1Od+IZb+CkV9b/hKLINLgwlUw5Ue9twy0CqRD/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NcfBD2D5ALIZlbJzOiHSg7F7JXzaHsZWD51w8UXt6SdpJp5OYp7zjsQEUVZeoyX3U
	 2ClHtEs3uEH3alNi8Q5gb0fZU6vgIOwR86+IPgKSLFRuC/kX16/WZ79gAq8ZJ98zdE
	 3lR+EzUCw+FjfeKNdRQZdKUDyZgJZsZT8zT7FcuE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuan-Chung Chen <damon.chen@realtek.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 230/565] wifi: rtw89: wow: remove notify during WoWLAN net-detect
Date: Tue, 11 Nov 2025 09:41:26 +0900
Message-ID: <20251111004532.090434341@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 10a3a66a9981d..7894e1a569a2c 100644
--- a/drivers/net/wireless/realtek/rtw89/fw.c
+++ b/drivers/net/wireless/realtek/rtw89/fw.c
@@ -6212,7 +6212,6 @@ static void rtw89_pno_scan_add_chan_ax(struct rtw89_dev *rtwdev,
 	struct rtw89_pktofld_info *info;
 	u8 probe_count = 0;
 
-	ch_info->notify_action = RTW89_SCANOFLD_DEBUG_MASK;
 	ch_info->dfs_ch = chan_type == RTW89_CHAN_DFS;
 	ch_info->bw = RTW89_SCAN_WIDTH;
 	ch_info->tx_pkt = true;
@@ -6341,7 +6340,6 @@ static void rtw89_pno_scan_add_chan_be(struct rtw89_dev *rtwdev, int chan_type,
 	struct rtw89_pktofld_info *info;
 	u8 probe_count = 0, i;
 
-	ch_info->notify_action = RTW89_SCANOFLD_DEBUG_MASK;
 	ch_info->dfs_ch = chan_type == RTW89_CHAN_DFS;
 	ch_info->bw = RTW89_SCAN_WIDTH;
 	ch_info->tx_null = false;
-- 
2.51.0



