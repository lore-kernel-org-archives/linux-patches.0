Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00FB21DB34C;
	Tue, 27 May 2025 17:27:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366867; cv=none; b=WelR9fXm/+OKFIGsVyAuHaCFHah8KXFLE07GZX8JVCnWkmarqhPrNIErDwQTKubNEP1kpyybrPWUy6ZnCMzcQr5DmIbjaRGchH1A8l7YQ39aN7zGaMR7BcyPeCfyR6qupI435CO55lwgHMwDQuIt454Wc0qgunsStESZgablMNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366867; c=relaxed/simple;
	bh=e8lnrbpW7QxsIJJt5vE1N7ydSyvNBJq/yGDIb/9kaSQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Le/9t2u8TWqUmDzjKW9MqSKZjMnnDvTx5wQ2tvMC8GfXmHm/NOzWZXBqMv/icGChziWN2S7K9SFTJxHT11P94rtR8TrXrU2tH2mIzNkaEqKMSDU7DltTHFCNyGPxrVM3x60eZWk9lpAJSmugdUOtKi6KrVas0BqMkndVGAT/gI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qC8rgBtn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qC8rgBtn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A6ECC4CEE9;
	Tue, 27 May 2025 17:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366866;
	bh=e8lnrbpW7QxsIJJt5vE1N7ydSyvNBJq/yGDIb/9kaSQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qC8rgBtnYigRl5WgH7HRthOdut4crnAvNDXG5UJ6tTgQ7vOvppn/tNuPmF6uAmuky
	 TgKdsrxPtd5qzKsXgat4j1lvYKD0Fh2ODGfDlOlqBvqffwfhXKgqAMGLjZb0hWtAyv
	 zS8DlBHWasnH6PpF8Y2EF1Edlt8GNHZodIcF95J8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ching-Te Ku <ku920601@realtek.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 202/783] wifi: rtw89: coex: Fix coexistence report not show as expected
Date: Tue, 27 May 2025 18:19:59 +0200
Message-ID: <20250527162521.372412465@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ching-Te Ku <ku920601@realtek.com>

[ Upstream commit a36230aa5f5efceaf5f81682673732a921b91518 ]

This report will feedback some basic information from firmware(PTA counter,
report counter, mailbox counter etc). And the report version need to match
driver & firmware both side. The original logic break the switch case logic
before driver update the report version. It made the report can not be
parsed correctly. Delete the break at the version 7 and 8.
Add logic to count C2H event report.

Signed-off-by: Ching-Te Ku <ku920601@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20250308025832.10400-3-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/coex.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/coex.c b/drivers/net/wireless/realtek/rtw89/coex.c
index 68316d44b2043..9e06cc36a75e2 100644
--- a/drivers/net/wireless/realtek/rtw89/coex.c
+++ b/drivers/net/wireless/realtek/rtw89/coex.c
@@ -1372,11 +1372,9 @@ static u32 _chk_btc_report(struct rtw89_dev *rtwdev,
 		} else if (ver->fcxbtcrpt == 8) {
 			pfinfo = &pfwinfo->rpt_ctrl.finfo.v8;
 			pcinfo->req_len = sizeof(pfwinfo->rpt_ctrl.finfo.v8);
-			break;
 		} else if (ver->fcxbtcrpt == 7) {
 			pfinfo = &pfwinfo->rpt_ctrl.finfo.v7;
 			pcinfo->req_len = sizeof(pfwinfo->rpt_ctrl.finfo.v7);
-			break;
 		} else {
 			goto err;
 		}
@@ -8115,6 +8113,7 @@ void rtw89_btc_c2h_handle(struct rtw89_dev *rtwdev, struct sk_buff *skb,
 		return;
 
 	func = rtw89_btc_c2h_get_index_by_ver(rtwdev, func);
+	pfwinfo->cnt_c2h++;
 
 	switch (func) {
 	case BTF_EVNT_BUF_OVERFLOW:
-- 
2.39.5



