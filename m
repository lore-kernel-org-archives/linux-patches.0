Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B114D2F2C52;
	Tue, 17 Jun 2025 16:22:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177328; cv=none; b=SHl2M3eCPtGfWb53wG014cHef7IT+Eg27M0/v9KTMS9cQmveyjHrASmM7B3aDyfNwMJ6qU4CmvDGVHqMVs5kxXhy9px6Z0140r+XdCabfAddElzKEVyL+bWP+Tj1Ev8K54tufhhJReedP0jm0MzV6HKnUs57AA3ho2Cw//0vlZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177328; c=relaxed/simple;
	bh=K37Kp7cbck+lrXVaVQiQqawLozfvebDUQqkUIQVrbrs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p0xAdaCqNLcsuPz5saQzOfzGgtk/pGZznYowmR6RGhsUZPRA+8zPhqcondjlbfznIvd4hgD01fdQttBsN9KFHVOGqhZJ9DoY1VU8Dm7Oh3jsVUcW4NRMT+K9+zvUioZCzd5KoQ0lzpGyU01AQ3ZOoc3lfRjYkmv/hmdQGxO+bdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=psJMONS8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="psJMONS8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D853BC4CEF0;
	Tue, 17 Jun 2025 16:22:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177328;
	bh=K37Kp7cbck+lrXVaVQiQqawLozfvebDUQqkUIQVrbrs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=psJMONS8hnqmWSFQ0UiRviyGKfgX4JZZZQEMU2QJIqDD2fjK4f9CV2jU2AWRR+wmO
	 dvFk0loxDqQOe1ZKK/59L/yNGPMQSR89cowl+cD5f7Uhsu8kCnv5fE70byouEgIjBc
	 O49mVCeY3NLb9Sw8WLhWyL+DPEIy2HvXdvJ47Bqo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qasim Ijaz <qasdev00@gmail.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 290/780] wifi: mt76: mt7996: prevent uninit return in mt7996_mac_sta_add_links
Date: Tue, 17 Jun 2025 17:19:58 +0200
Message-ID: <20250617152503.278893590@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qasim Ijaz <qasdev00@gmail.com>

[ Upstream commit d9bc625861d490cb76ae8af86fac6f8ab0655a18 ]

If link_conf_dereference_protected() or mt7996_vif_link()
or link_sta_dereference_protected() fail the code jumps to
the error_unlink label and returns ret which is uninitialised.

Fix this by setting err before jumping to error_unlink.

Fixes: c7e4fc362443 ("wifi: mt76: mt7996: Update mt7996_mcu_add_sta to MLO support")
Fixes: dd82a9e02c05 ("wifi: mt76: mt7996: Rely on mt7996_sta_link in sta_add/sta_remove callbacks")
Signed-off-by: Qasim Ijaz <qasdev00@gmail.com>
Link: https://patch.msgid.link/20250421110550.9839-1-qasdev00@gmail.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/main.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/main.c b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
index 91c64e3a0860f..70823bbb165c7 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -998,16 +998,22 @@ mt7996_mac_sta_add_links(struct mt7996_dev *dev, struct ieee80211_vif *vif,
 			continue;
 
 		link_conf = link_conf_dereference_protected(vif, link_id);
-		if (!link_conf)
+		if (!link_conf) {
+			err = -EINVAL;
 			goto error_unlink;
+		}
 
 		link = mt7996_vif_link(dev, vif, link_id);
-		if (!link)
+		if (!link) {
+			err = -EINVAL;
 			goto error_unlink;
+		}
 
 		link_sta = link_sta_dereference_protected(sta, link_id);
-		if (!link_sta)
+		if (!link_sta) {
+			err = -EINVAL;
 			goto error_unlink;
+		}
 
 		err = mt7996_mac_sta_init_link(dev, link_conf, link_sta, link,
 					       link_id);
-- 
2.39.5



