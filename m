Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC8BB1A0BFD;
	Sun,  7 Sep 2025 20:33:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277185; cv=none; b=puVsFxBKuA38nWqyyOiN4IC9WYY7MZp2sCcRfQGQjx+/6ESv54/NPi1rvwsnm9JZUFkPiS7eX8A1EimCJYtADmimJnc3WBKfVTrharTBIMbMkPVwEPHLPzhPDYNKEuaJ/Fnad9B9f9I1YsCUDu8UKRZebtsxhwXjNgXYBSp2jPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277185; c=relaxed/simple;
	bh=PyFSkBSah4LGqPgmfsq69F35sJUWGI2MEN8y7qrWFKM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aUG9wk5FJVv3H0SWCi+HkPcWl1se57HlPp4lb0WKfmfzesIFmEdO7KCXOpv70P5oyfedS+u6fwgVpIJ0V4t2/MAlGklfY0n3xkotoCjOMI9ljeWH5QP9mBf3am/OCaSl2mqzpx/xcXgri48Sqfe5I9QFfDgdbzVd/InVtj+gMe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=glmgW+p6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="glmgW+p6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 181AFC4CEF0;
	Sun,  7 Sep 2025 20:33:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277185;
	bh=PyFSkBSah4LGqPgmfsq69F35sJUWGI2MEN8y7qrWFKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=glmgW+p6M0rHEJQZHY3f9sdIwmexklJuG5lhMy0g0/YNJkCE6Oud+jsuXHD8VLu49
	 +dCKwIuPuQiTR+ELi5iwdH3kGo8NwF7HB+kFnjUZ/HdG82T8AZSGY71u68LuLflZl5
	 i32QiQ6kSLbsCBiboTo6HmTrkjcpMVhUXwUjx24A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Yen Hsieh <mingyen.hsieh@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>
Subject: [PATCH 6.12 111/175] wifi: mt76: mt7925: fix the wrong bss cleanup for SAP
Date: Sun,  7 Sep 2025 21:58:26 +0200
Message-ID: <20250907195617.482672155@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195614.892725141@linuxfoundation.org>
References: <20250907195614.892725141@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1187,6 +1187,9 @@ mt7925_mac_sta_remove_links(struct mt792
 		struct mt792x_bss_conf *mconf;
 		struct mt792x_link_sta *mlink;
 
+		if (vif->type == NL80211_IFTYPE_AP)
+			break;
+
 		link_sta = mt792x_sta_to_link_sta(vif, sta, link_id);
 		if (!link_sta)
 			continue;


