Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BB8C7E107;
	Sun,  7 Sep 2025 20:45:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277922; cv=none; b=tromoW+odOtOy059oS8dva2tsiFJagLXVJMNyjrk0IXeH3xF42dPjmcs6DIu8VQeUm5KFcZofgWTt83DELVhDB1XWog7QfcW/t4ahLdYD9WFFMJZSPaFDeEqWqWkKOmeCV0+/ERQT+0oQl+diWsIT64OggeugpdYXpV+yl9DgQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277922; c=relaxed/simple;
	bh=fuEzeCrPhVCCyWrAmPUtXMkKmbU9d2dnnxKrFr+d3oA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t8YGj5Qr6yemitDu0nxqtNKdnr4hrxvbodwCENcUdWodacdn9z/AYUs9+eJ2tgkJccqOe/ul2MKeVV3eyuptqsP1ZdMPODbzWuoLZopv5QH1/GSY1axwEA8jHfFiT+dPXbFJhYVbjQimBIoInDSGY7a6OtBKKMIz8Fv2jDX5pfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JDwPbMYz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JDwPbMYz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36D61C4CEF0;
	Sun,  7 Sep 2025 20:45:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277921;
	bh=fuEzeCrPhVCCyWrAmPUtXMkKmbU9d2dnnxKrFr+d3oA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JDwPbMYzQRdIWzv5D9gZnp8J/d6r+gWHHy2itRTqsdWD6UDQXVZ2vt1QJ0IeJIkVt
	 2pka4eO8R4zpYDLNf4/0EaGpSb0LNFiZ8lTKu+YYrXhbIFBWt2xb49MpgnbirN9HcZ
	 Yt04avB+gCcaP3I6WP6VW3GxX44Cyzv8CMmcMYS0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Yen Hsieh <mingyen.hsieh@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>
Subject: [PATCH 6.16 121/183] wifi: mt76: mt7925: fix the wrong bss cleanup for SAP
Date: Sun,  7 Sep 2025 21:59:08 +0200
Message-ID: <20250907195618.665892806@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195615.802693401@linuxfoundation.org>
References: <20250907195615.802693401@linuxfoundation.org>
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

From: Ming Yen Hsieh <mingyen.hsieh@mediatek.com>

commit 55424e7b9eeb141d9c8d8a8740ee131c28490425 upstream.

When in SAP mode, if a STA disconnect, the SAP's BSS
should not be cleared.

Fixes: 0ebb60da8416 ("wifi: mt76: mt7925: adjust rm BSS flow to prevent next connection failure")
Cc: stable@vger.kernel.org
Signed-off-by: Ming Yen Hsieh <mingyen.hsieh@mediatek.com>
Link: https://patch.msgid.link/20250728052612.39751-1-mingyen.hsieh@mediatek.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/mediatek/mt76/mt7925/main.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/wireless/mediatek/mt76/mt7925/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
@@ -1191,6 +1191,9 @@ mt7925_mac_sta_remove_links(struct mt792
 		struct mt792x_bss_conf *mconf;
 		struct mt792x_link_sta *mlink;
 
+		if (vif->type == NL80211_IFTYPE_AP)
+			break;
+
 		link_sta = mt792x_sta_to_link_sta(vif, sta, link_id);
 		if (!link_sta)
 			continue;


