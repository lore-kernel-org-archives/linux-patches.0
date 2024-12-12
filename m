Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BA2D2185A0;
	Thu, 12 Dec 2024 15:42:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734018156; cv=none; b=cMxPtVjhIU0Z2rWa1+h4kM0/JxVF92CDb8VOXdSwmQFgCK76OdxRpdcCuhTXLb1wBhlgabYJJSquxvNMMugFiXRL8A6iuGp7c3AjbkPmkmg9Sii8DXNCh4+MncqwKHTL2UGphYxc2N21QfvcGUIy7MQmNPjZWfDsMsmH9Bmb830=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734018156; c=relaxed/simple;
	bh=Ce01SXzXQ2dT49nWXF2GtND1oKpQteixkiIkWziFdTY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tSiiH+PjwZ+pSpbZVdB2SLQQgNshOTR8iAVYg3aID/Ezv927zLRXD04FNoUfyDGKaBGT1rnTLM/ALOdcsGVHW5/qkV+IIWSNURJyT0nRNzJ4HwLeuDwXU6mD4dNEORFllvakxSmBq/ibJX2JoBatSbc2MQzF/R5rHKMmoj7yfGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a0tUNadk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a0tUNadk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B03ADC4CECE;
	Thu, 12 Dec 2024 15:42:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734018156;
	bh=Ce01SXzXQ2dT49nWXF2GtND1oKpQteixkiIkWziFdTY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a0tUNadkNtpW2SkZHEy2MCSExfMc1sl7XgXq5gtiVCddqrj5hcuybEvBfhPhirQKj
	 3uX6lMmKkjtIw0A+1elMu8xV/8VYksA1zIRkhz0uhaXwyUskGlTBOmmLCbcrgXM4oe
	 e1IUHIT1vltaQzw7ReeUlr/gKaaokpdd1BKeS9r8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 213/356] wifi: rtw89: check return value of ieee80211_probereq_get() for RNR
Date: Thu, 12 Dec 2024 15:58:52 +0100
Message-ID: <20241212144253.030188638@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 468cfa43ec049..a8e2efae6e526 100644
--- a/drivers/net/wireless/realtek/rtw89/fw.c
+++ b/drivers/net/wireless/realtek/rtw89/fw.c
@@ -3662,6 +3662,9 @@ static int rtw89_update_6ghz_rnr_chan(struct rtw89_dev *rtwdev,
 
 		skb = ieee80211_probereq_get(rtwdev->hw, rtwvif->mac_addr,
 					     NULL, 0, req->ie_len);
+		if (!skb)
+			return -ENOMEM;
+
 		skb_put_data(skb, ies->ies[NL80211_BAND_6GHZ], ies->len[NL80211_BAND_6GHZ]);
 		skb_put_data(skb, ies->common_ies, ies->common_ie_len);
 		hdr = (struct ieee80211_hdr *)skb->data;
-- 
2.43.0



