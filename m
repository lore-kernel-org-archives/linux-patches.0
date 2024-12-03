Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AAF21F8902;
	Tue,  3 Dec 2024 15:50:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241020; cv=none; b=RrER80PvyoENivMgmNb9tn+fwSXMtRCBs4KOUcmDcwrQtlantL4ssmv8zanD/hBKMDl41OaDVaUvaoPnGB0Gd7JTooPc3TObQnVa6qiByADMkZieSNfEMJsx1oEtKKjjG+n6mGnhZN4B90hHJzRMdHHDTyBxwVs/9p8fdB7W52A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241020; c=relaxed/simple;
	bh=WuTuaKkpfFtqTnjkL1aYjZKvasMBfDNp6M78DyWlArI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WSPYHQEeqmnOquRhFBA0GrkjXY9ht6CeOnxrT+Go8WfxCPzSff+HZsdyj81mCaQ1HhVyBqAKQo0MGB4x2DAjSwiBZqOPORYpZCTjfcfsONdi43qSksD/EcbNe2syzbTuKiZi2kN4q9dTzmO4qEBgz1olmXH5NIQ6qmrWYmrtFvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DPYfvpNy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DPYfvpNy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC400C4CECF;
	Tue,  3 Dec 2024 15:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241020;
	bh=WuTuaKkpfFtqTnjkL1aYjZKvasMBfDNp6M78DyWlArI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DPYfvpNyXXttx4443ol7UNjVI96DYw3MrPZTOzbrNDTqkJNdEE6wviLEWZcXcaC0E
	 P7W9/SNMsx04X/IPk5AifyPNHdp/tkT9kuIhMivynrxD8jCw1+N/2LpWELXHRJZMS1
	 j5MhYjbzYbCelJZigKzuBd3qPlH6k7HO3Bd+Ggyw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Po-Hao Huang <phhuang@realtek.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 274/826] wifi: rtw89: Fix TX fail with A2DP after scanning
Date: Tue,  3 Dec 2024 15:40:01 +0100
Message-ID: <20241203144754.465448837@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Po-Hao Huang <phhuang@realtek.com>

[ Upstream commit f16c40acd31901ad0ba2554b60e0e2b0c7b59cde ]

There might be some racing between BT and WiFi after scan. Since
one of the TX related register will be modified by both FW and
rtw89_set_channel() in driver, which could cause Tx fail. Reorder
the calling sequence to only notify coexistence mechanism after
rtw89_set_channel() is called, so that there are no concurrent
operations.

Fixes: 5f499ce69b8d ("wifi: rtw89: pause/proceed MCC for ROC and HW scan")
Signed-off-by: Po-Hao Huang <phhuang@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20241021063219.22613-1-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/fw.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/fw.c b/drivers/net/wireless/realtek/rtw89/fw.c
index 37f931e887917..13a7c39ceb6f5 100644
--- a/drivers/net/wireless/realtek/rtw89/fw.c
+++ b/drivers/net/wireless/realtek/rtw89/fw.c
@@ -6648,6 +6648,8 @@ void rtw89_hw_scan_complete(struct rtw89_dev *rtwdev,
 	if (!rtwvif_link)
 		return;
 
+	rtw89_chanctx_proceed(rtwdev);
+
 	rtwvif = rtwvif_link->rtwvif;
 
 	rtw89_write32_mask(rtwdev,
@@ -6667,8 +6669,6 @@ void rtw89_hw_scan_complete(struct rtw89_dev *rtwdev,
 	scan_info->last_chan_idx = 0;
 	scan_info->scanning_vif = NULL;
 	scan_info->abort = false;
-
-	rtw89_chanctx_proceed(rtwdev);
 }
 
 void rtw89_hw_scan_abort(struct rtw89_dev *rtwdev,
-- 
2.43.0



