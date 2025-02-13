Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 411B9143736;
	Thu, 13 Feb 2025 15:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460508; cv=none; b=NS+RsXSNgQtyNJ8t8oPxWkNhKXeo62CXAZsRFrOjAxvkh4rRQ8SQLlLbUxAviC/PEbeJxorqXBNXGj10UvAudrTHxU5jO7qh1d//d7CiX2GEYdNK5yOs+UZusT73JZvMlHKzWSVZYyb5ySuNF3/qqebjXuZ8zcPxcyvd2ELiPQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460508; c=relaxed/simple;
	bh=FHLB7LhYEZZvuxl3nRi67BUCWjwv5GvxtXaD9zQKy08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QXbgjPhnctpixyAYSrwQ2B1mWGSh45v0kcEgKrYB1JUgM12DW3127Jtbbi1uEYUfH6IjxeZi3q4VxoURGwoVrxjp2ekUazrkg0vN8f8QlmFsZAELvdjwL5WDBCx9JV0BFRQ8RPpe/kQQDFwwTLZupJkdZtDf8jyi3Yuhgh+yg+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=boF+D4jg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="boF+D4jg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 987C4C4CED1;
	Thu, 13 Feb 2025 15:28:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460508;
	bh=FHLB7LhYEZZvuxl3nRi67BUCWjwv5GvxtXaD9zQKy08=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=boF+D4jgrGVPbpeRZR8W5Jzo3S30zAOTu62EGCPVcDClEpjmM1NMoVGa2GhU+Yu0j
	 HK5XxbeLqGPVfhOdfRJZHoCDcJH/i6Y7SI3Rg8rnsxUPl0PQtBTbBczZYminKoqhpq
	 g/rzXt8Vke9pTR6u5FxlCSeTQVsYR5RjaOuow93g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fiona Klute <fiona.klute@gmx.de>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Vasily Khoruzhick <anarsoul@gmail.com>
Subject: [PATCH 6.6 130/273] wifi: rtw88: sdio: Fix disconnection after beacon loss
Date: Thu, 13 Feb 2025 15:28:22 +0100
Message-ID: <20250213142412.477448043@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fiona Klute <fiona.klute@gmx.de>

commit fb2fcfbe5eef9ae26b0425978435ae1308951e51 upstream.

This is the equivalent of commit 28818b4d871b ("wifi: rtw88: usb: Fix
disconnection after beacon loss") for SDIO chips.
Tested on Pinephone (RTL8723CS), random disconnections became rare,
instead of a frequent nuisance.

Cc: stable@vger.kernel.org
Signed-off-by: Fiona Klute <fiona.klute@gmx.de>
Tested-by: Vasily Khoruzhick <anarsoul@gmail.com> # Tested on Pinebook
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20250106135434.35936-1-fiona.klute@gmx.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/realtek/rtw88/sdio.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/wireless/realtek/rtw88/sdio.c
+++ b/drivers/net/wireless/realtek/rtw88/sdio.c
@@ -1191,6 +1191,8 @@ static void rtw_sdio_indicate_tx_status(
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_hw *hw = rtwdev->hw;
 
+	skb_pull(skb, rtwdev->chip->tx_pkt_desc_sz);
+
 	/* enqueue to wait for tx report */
 	if (info->flags & IEEE80211_TX_CTL_REQ_TX_STATUS) {
 		rtw_tx_report_enqueue(rtwdev, skb, tx_data->sn);


