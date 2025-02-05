Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 048831519BE;
	Wed,  5 Feb 2025 14:21:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765279; cv=none; b=OeXjuew9rYOnvBSQ2CH84ZLDZEzlo6WBRen2MPyexAMT7G/1VTTqfUCIdgJ/z5OvGrjd/0IJIl5zQOfwVQTPRGqQsmhr7tT5nkYfKfOGWdMjWvDEt56Et8i/SUxbRDycjKQlh5dQP1HDDzixJ4KYkNytmO4un74N112ENhAdBlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765279; c=relaxed/simple;
	bh=/zfueHGcZNzwx/29k/6kYWu1/4imQ6UfJScZOwyFW3c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aOIsz1OcwWx/4X6qAo2qF5/mmlEKp0cvemOhm2+2ra98A7WmQU6CyeVeridiKGzNvB3p7y9/vYULupLnMNLrF1fZA2wgroqTW4fkkzaHzgLhat47xcKiO8Z3v4VafmNUIoAwrryirM/UlK+yGtIaiOz+rC/f4invfODCE9VW3sc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ouDhQMWQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ouDhQMWQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66767C4CED1;
	Wed,  5 Feb 2025 14:21:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765278;
	bh=/zfueHGcZNzwx/29k/6kYWu1/4imQ6UfJScZOwyFW3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ouDhQMWQnxGXCeSutEZStmXGYN8i7Z3XTW7KJcbBoLn1fWfNixgtWK2EqqXLNMZyt
	 EHUtOUaUw8Bqozrh1VOLeDiP8aw3I4fII3RDeJhuGJcRgzNkH7Orlr8JWOsl+u7cEh
	 O93rl0Gt9Zxp5chzQeiVb8LF3qcx0jPgTpPuklDE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Cavallari <nicolas.cavallari@green-communications.fr>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 162/623] wifi: mt76: mt7915: Fix mesh scan on MT7916 DBDC
Date: Wed,  5 Feb 2025 14:38:24 +0100
Message-ID: <20250205134502.431439178@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolas Cavallari <nicolas.cavallari@green-communications.fr>

[ Upstream commit f21b77cb556296116b1cce1d62295d13e35da574 ]

commit c4f075582304 ("wifi: mt76: mt7915: fix command timeout in AP stop
period") changes the behavior of mt7915_bss_info_changed() in mesh mode
when enable_beacon becomes false: it calls mt7915_mcu_add_bss_info(...,
false) and mt7915_mcu_add_sta(..., false) while the previous code
didn't.  These sends mcu commands that apparently confuse the firmware.

This breaks scanning while in mesh mode on AsiaRF MT7916 DBDC-based cards:
scanning works but no mesh frames get sent afterwards and the firmware
seems to be hosed.  It breaks on MT7916 DBDC but not on MT7915 DBDC.

Fixes: c4f075582304 ("wifi: mt76: mt7915: fix command timeout in AP stop period")
Signed-off-by: Nicolas Cavallari <nicolas.cavallari@green-communications.fr>
Link: https://patch.msgid.link/20240927085350.4594-1-nicolas.cavallari@green-communications.fr
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/main.c b/drivers/net/wireless/mediatek/mt76/mt7915/main.c
index c6f498fc81ffd..8183708a9b355 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/main.c
@@ -619,8 +619,9 @@ static void mt7915_bss_info_changed(struct ieee80211_hw *hw,
 	if (changed & BSS_CHANGED_ASSOC)
 		set_bss_info = vif->cfg.assoc;
 	if (changed & BSS_CHANGED_BEACON_ENABLED &&
+	    info->enable_beacon &&
 	    vif->type != NL80211_IFTYPE_AP)
-		set_bss_info = set_sta = info->enable_beacon;
+		set_bss_info = set_sta = 1;
 
 	if (set_bss_info == 1)
 		mt7915_mcu_add_bss_info(phy, vif, true);
-- 
2.39.5



