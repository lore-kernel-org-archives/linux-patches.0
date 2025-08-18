Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34BEB34AAE2;
	Mon, 18 Aug 2025 14:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525692; cv=none; b=qnfvkyyoZQ5NLD8g969HGC+jJjWy4nN6n7kcJlOco8OHwZwq7wBR1iv8+6fRUpNkUGvXWjeV0AEE4XAagwoKcEeDsPFtF6OO9WC0SSteIbUkF37eKk8fP348jLmCCEcxKZfUTAFWeS0Up000clUeVpSUYkeMjL/P5sN+p0oSOdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525692; c=relaxed/simple;
	bh=Hy1kX7nJhCMXcERJ/EpFy/BqoSxM3X2ChMdDqwuHL9E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h3I/9oCO2dCMFoAQVkqMrPVLh8ACA0ktu1NOfGFToml6fTT5FzN5hlKbYiR+rADUHigHBp8XqqgdBb9L5L2LhxIhnGKsV3jLR1TIpxGfOKcndiADnbkHlyioY6RZ0heTv3E4ZWLcZ8X0c+vajrQ4nL9TBCmcTllttoAayc+veck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r+5DDdPt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r+5DDdPt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD1AAC4CEEB;
	Mon, 18 Aug 2025 14:01:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525692;
	bh=Hy1kX7nJhCMXcERJ/EpFy/BqoSxM3X2ChMdDqwuHL9E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r+5DDdPtkxmSWrd1K4mR3R+kNeI3DwXyPaR/LIg8dhosc33bf6hXkFvDcz59JKWPo
	 V8VO8RgIRpKPLQE/svU7RdFPcHaDhUGHnECsw7lP+NQhCcagYOIrrdE5R8Ikp5i5vE
	 ca35AKkM6Yp9G97bvQM1tAmZ6fvhEibu1OaO1QnM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chih-Kang Chang <gary.chang@realtek.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 337/570] wifi: rtw89: scan abort when assign/unassign_vif
Date: Mon, 18 Aug 2025 14:45:24 +0200
Message-ID: <20250818124518.830452070@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chih-Kang Chang <gary.chang@realtek.com>

[ Upstream commit 3db8563bac6c34018cbb96b14549a95c368b0304 ]

If scan happen during start_ap, the register which control TX might be
turned off during scan. Additionally, if set_channel occurs during scan
will backup this register and set to firmware after set_channel done.
When scan complete, firmware will also set TX by this register, causing
TX to be disabled and beacon can't be TX. Therefore, in assign/unassign_vif
call scan abort before set_channel to avoid scan racing with set_channel.

Signed-off-by: Chih-Kang Chang <gary.chang@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20250610130034.14692-13-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/chan.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw89/chan.c b/drivers/net/wireless/realtek/rtw89/chan.c
index 806f42429a29..b18019b53181 100644
--- a/drivers/net/wireless/realtek/rtw89/chan.c
+++ b/drivers/net/wireless/realtek/rtw89/chan.c
@@ -2816,6 +2816,9 @@ int rtw89_chanctx_ops_assign_vif(struct rtw89_dev *rtwdev,
 	rtwvif_link->chanctx_assigned = true;
 	cfg->ref_count++;
 
+	if (rtwdev->scanning)
+		rtw89_hw_scan_abort(rtwdev, rtwdev->scan_info.scanning_vif);
+
 	if (list_empty(&rtwvif->mgnt_entry))
 		list_add_tail(&rtwvif->mgnt_entry, &mgnt->active_list);
 
@@ -2855,6 +2858,9 @@ void rtw89_chanctx_ops_unassign_vif(struct rtw89_dev *rtwdev,
 	rtwvif_link->chanctx_assigned = false;
 	cfg->ref_count--;
 
+	if (rtwdev->scanning)
+		rtw89_hw_scan_abort(rtwdev, rtwdev->scan_info.scanning_vif);
+
 	if (!rtw89_vif_is_active_role(rtwvif))
 		list_del_init(&rtwvif->mgnt_entry);
 
-- 
2.39.5



