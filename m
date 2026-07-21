Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D1FF369D71;
	Tue, 21 Jul 2026 17:40:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655658; cv=none; b=BcI9XsSFs9XHj9HxCMd4lWP4c35aktGU/0lyLQFI0LwsqYF8K1gziNFecUIg186OE6L+juolh8XHLWigajYaPOrBEknQSLzTiaDQ6JGCS2G2DJ3FRDmyDeYSTKZAKqwP0dSDJmjK43Yj3UwCWwBGKzjaBPCmxUv66oTiZbAQjbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655658; c=relaxed/simple;
	bh=nDwZFccglUamHQWB68Hf6pk8EiaHZnmSTnVp7tYpR38=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LrmgftGlfb5T2o34CKIFUnNO5Y0I8eHnuwJQS16iwWBTYt/3QkriRDgBDB5cM1hUkWJmG2ktRnSWfHcLtf2PpwXnK6ELdNAY2lTzmkQ7SOuO/AWllNsd1VcBmF1z+oNn4BMkUfWHGZg8+5hPTkItCab6d3JeXikWbxnMrC5h7mk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zX1PwubN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zX1PwubN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D493E1F000E9;
	Tue, 21 Jul 2026 17:40:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655657;
	bh=Cilg4TKWLWA2z59Ok6+RFrLrX9YdHDJ4VBAoNOp0jik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zX1PwubNhDaK2MtCrDEO7fF+2ezSz/WQGoNVM7nfBTKRQuJwKDWIqHncr3tOYVb7A
	 reCHfT/ycv6wVoBJaoo6iFETGNuiP+2A3AQwmDk2lORYpdaT4hpjRG7vq7E2iz9RCS
	 9iCQzAoeT0uUHjoJwYcEkCqsvgpto7Hls1eod+wI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tristan Madani <tristan@talencesecurity.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0090/1611] wifi: rtw89: add bounds check on firmware mac_id in link lookup
Date: Tue, 21 Jul 2026 17:03:26 +0200
Message-ID: <20260721152516.870156724@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tristan Madani <tristan@talencesecurity.com>

[ Upstream commit 6d88244bb129755acca696f9227200f4a2d106a6 ]

The mac_id field in RX descriptors is 8 bits wide (0-255), but
assoc_link_on_macid[] has only RTW89_MAX_MAC_ID_NUM (128) entries.
While the driver currently assigns mac_id values below 128, the
descriptor value comes from firmware and is not validated before use
as an array index. Add a defensive bounds check in
rtw89_assoc_link_rcu_dereference() to guard against out-of-range
firmware values.

Fixes: 144c6cd24b35 ("wifi: rtw89: 8922a: configure AP_LINK_PS if FW supports")
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20260421111442.3395411-1-tristmd@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/core.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw89/core.h b/drivers/net/wireless/realtek/rtw89/core.h
index c3839d49f4420a..e146fd082f21a7 100644
--- a/drivers/net/wireless/realtek/rtw89/core.h
+++ b/drivers/net/wireless/realtek/rtw89/core.h
@@ -6254,6 +6254,9 @@ static inline void rtw89_assoc_link_clr(struct rtw89_sta_link *rtwsta_link)
 static inline struct rtw89_sta_link *
 rtw89_assoc_link_rcu_dereference(struct rtw89_dev *rtwdev, u8 macid)
 {
+	if (unlikely(macid >= RTW89_MAX_MAC_ID_NUM))
+		return NULL;
+
 	return rcu_dereference(rtwdev->assoc_link_on_macid[macid]);
 }
 
-- 
2.53.0



