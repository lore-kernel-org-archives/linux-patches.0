Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB9A213C3F6;
	Wed,  5 Feb 2025 14:22:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765336; cv=none; b=Nrx+olEhAbfL63L04s0fojakLdRLI31kJfxgn0Nxyc0ICOsQc7DO+zbd8/2fO0uztxXIf2JoEmIHBnWPKqbAk5gT4kSZPwvoIIObNdWqsT3vmS90lrKvsde8vaVhwW6iYuC1qUderQyQBlQZj4jsCbL0zyNYYzgqY8giHccFCqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765336; c=relaxed/simple;
	bh=uv4b6EFox4E3aeVhDCjh3NpkIhTHLyGJMfbCE3CfCLo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mHOyLdbS7ohG1v+uE2ml2MgQMiaATd1IphnlqHvN/dSWgZ/kLe/6+ykxcjSdsvHQ3KVf8Py1W/KjlE7/f/ETB/AiKnWLTRQ5SF+FZ390SnJHZbXXCrv06yXLXa2nHMceclI+DyVGF1RfC/BXW46UzOgeDdX8QrSPqiD6WVTuAuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jBTp5I0i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jBTp5I0i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 292B0C4CED1;
	Wed,  5 Feb 2025 14:22:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765336;
	bh=uv4b6EFox4E3aeVhDCjh3NpkIhTHLyGJMfbCE3CfCLo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jBTp5I0ioFM3u1To8nw4bp1xlvvqui35oyUZy9eqVnBNLMl9pCHUZqtn7SGYMwQIQ
	 Ag8suG6+ztINskiRrs+VyNk0Z4cfX1YGoMHhA4nqOGpHIvBTXCMvBSDUh0kxgzw111
	 wNuBp2RleNjz73Sv9KxxxT9ECGuKOVd2KzuSIg8A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Yen Hsieh <mingyen.hsieh@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 193/590] wifi: mt76: mt7925: Init secondary link PM state
Date: Wed,  5 Feb 2025 14:39:08 +0100
Message-ID: <20250205134502.663015502@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

[ Upstream commit 28045ef2bc5bbeec4717da98bf31aca0faaccf02 ]

Initialize secondary link PM state.

Fixes: 86c051f2c418 ("wifi: mt76: mt7925: enabling MLO when the firmware supports it")
Signed-off-by: Ming Yen Hsieh <mingyen.hsieh@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Link: https://patch.msgid.link/20241211011926.5002-14-sean.wang@kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7925/main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/main.c b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
index dcdb9bcff3c40..a2d1c43098d3c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
@@ -1991,6 +1991,8 @@ mt7925_change_vif_links(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			goto free;
 
 		if (mconf != &mvif->bss_conf) {
+			mt7925_mcu_set_bss_pm(dev, link_conf, true);
+
 			err = mt7925_set_mlo_roc(phy, &mvif->bss_conf,
 						 vif->active_links);
 			if (err < 0)
-- 
2.39.5



