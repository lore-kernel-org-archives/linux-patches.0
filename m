Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF9E5212B0F;
	Thu, 12 Dec 2024 15:19:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016783; cv=none; b=JhWwWA3dU/AKClTa2fqJMaejShBZ1+vLvwp2OVBZzNzhKblHCMT6cj+dwx2aO2GSe8jYg0xt1NepwvO9BN+fBlo6xms30SZHhawTvVeWBk3TXYOoRbsgiGn8KPTn+iFKqYlXcfEXRgV/WTvj9pt66SEuUuaLE/VH+CYjZtbsTxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016783; c=relaxed/simple;
	bh=sGDn3iKuQAotg/XRykcXU6R4Tyik4Uun5GKIxygQ4ys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B5ik3r8Pxq1wTN3jXidhgQi5lM4Rl+5Cp5qoNBNGD+Kfb3fnzboTTuNXewyS7juyKRfEZ0t9iS+mPYNKWK7M1Q7+WSeI8VDBK100DOdkL91ajdncRb0QPeA0WJDUrcTgzJq0NwfkIRnoFla4S2W/4/IneewAamHF6zarWRS37RA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P6xQfEF2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P6xQfEF2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E37F4C4CECE;
	Thu, 12 Dec 2024 15:19:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016783;
	bh=sGDn3iKuQAotg/XRykcXU6R4Tyik4Uun5GKIxygQ4ys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P6xQfEF2uFhzgC9I41aU2qHMfUSxIquz/2LeifhDHp3eWm5c7T20Gcxiy/SuxTlfQ
	 EQjlqOwOjCoLtDEoHgFnAZMkYitF9u4Z3mUTtyvVE97ffjY28ca9vcmNXwFxv1voSh
	 H2xNuT4gbQpAKHFKg9yXsKN7D9+d5AyZagtCRX38=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 265/466] wifi: rtw89: check return value of ieee80211_probereq_get() for RNR
Date: Thu, 12 Dec 2024 15:57:14 +0100
Message-ID: <20241212144317.265521393@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

From: Ping-Ke Shih <pkshih@realtek.com>

[ Upstream commit 630d5d8f2bf6b340202b6bc2c05d794bbd8e4c1c ]

The return value of ieee80211_probereq_get() might be NULL, so check it
before using to avoid NULL pointer access.

Addresses-Coverity-ID: 1529805 ("Dereference null return value")

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20240919081216.28505-2-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/fw.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw89/fw.c b/drivers/net/wireless/realtek/rtw89/fw.c
index 13a7c39ceb6f5..e6bceef691e9b 100644
--- a/drivers/net/wireless/realtek/rtw89/fw.c
+++ b/drivers/net/wireless/realtek/rtw89/fw.c
@@ -6074,6 +6074,9 @@ static int rtw89_update_6ghz_rnr_chan(struct rtw89_dev *rtwdev,
 
 		skb = ieee80211_probereq_get(rtwdev->hw, rtwvif_link->mac_addr,
 					     NULL, 0, req->ie_len);
+		if (!skb)
+			return -ENOMEM;
+
 		skb_put_data(skb, ies->ies[NL80211_BAND_6GHZ], ies->len[NL80211_BAND_6GHZ]);
 		skb_put_data(skb, ies->common_ies, ies->common_ie_len);
 		hdr = (struct ieee80211_hdr *)skb->data;
-- 
2.43.0



