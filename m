Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 606DC46AA68;
	Tue, 21 Jul 2026 15:36:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648186; cv=none; b=p8y3U4P4nVYv1Or32S4gZfzQA6kTPrmkgPhEsI5kJkr33VrVnfnHQRqUWMr2z6EOUjsmQsB4rFycCFcSBwqyjdXPCveMpMcmxMFEdpnj/C0dVRYFcp7qHkDfwmnUnrEJUlK6mP7qsXa+46IvRgvymChg7f41aCC+/x7KPsScgMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648186; c=relaxed/simple;
	bh=/CO6+lCmPlrrBCwpGamxWal+o5r2TPElKHnnB7g75HI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ESwwcAx6jH1WpjfHE6jmZt/fZNfuUKoF6Vyg53ib9Oh/f8km8IKo7jEJchBGLOv0MeMLARruPXULNJThRtzy8k5HyEbIO0i+R6hHf53FUBKatalByENS0jLhLDU6ItxRfEx8OG2661DsRRoHPWHQmKiqzzJoRGe9Q24jhF33zwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KQgxLM0+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KQgxLM0+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE2ED1F000E9;
	Tue, 21 Jul 2026 15:36:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648185;
	bh=d9++t9RJnulwKo+xhcJRu4pmDh0zAGTUsT4sDpZl1zM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KQgxLM0+RwyByqxAzwDns9dEviMaAlRWAqCl9GEcu0pk+3dVTBYNBeVC/hdXyVHYr
	 WCnOBp1D5/vVbYhek+DVA8f5HM4UBt3+AbTH2filRaMaulGofVmQJGdP6bO0OUaqJ+
	 h7GDNdpszRHAPKOerWonsb9Mqc5SHKkewMcWE7uA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tristan Madani <tristan@talencesecurity.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0104/2077] wifi: rtw89: add bounds check on firmware mac_id in link lookup
Date: Tue, 21 Jul 2026 16:56:17 +0200
Message-ID: <20260721152555.147016687@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index fd29dbbb120d2f..05adf20a65be1e 100644
--- a/drivers/net/wireless/realtek/rtw89/core.h
+++ b/drivers/net/wireless/realtek/rtw89/core.h
@@ -6492,6 +6492,9 @@ static inline void rtw89_assoc_link_clr(struct rtw89_sta_link *rtwsta_link)
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



