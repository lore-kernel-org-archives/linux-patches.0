Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6D1C145B36;
	Tue, 27 Feb 2024 13:28:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709040522; cv=none; b=F98w3H55KENo3jaLN1LNYLhOtTnvOG/W4K5oXBPJdQwuO0oRB5MGkJAFbQ3s4FEHnQAUt21xqlt0WXaS4wngk6bmp69EJcIvfSE1k0M7HfyNvERGWFtznBq70tOi0m/1tulR/QcYZj5NU8HWIQOZ1b1tqyQHHkOomBlaim0z5Go=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709040522; c=relaxed/simple;
	bh=9cI5Yta4iMzj0qg14XJKwAZyU2CweKkZsfcnOuohBj8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JqMYucpZDJN7qrmPP/frYTjZPfZzld+vz0ZTM+pbddHBjZQiH0ennvlyfHX3avgqMag0kve2hMqWbXXQ0CikRYvwPKtI/rqjPfdgspP7rD5W5OxCoN+TPPoymFh3Ml1se+rTG79JM1kixymL5ARCve9OyHFj/SB+OI7EsCDlUwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2LK3c7Fp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2LK3c7Fp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6200C433C7;
	Tue, 27 Feb 2024 13:28:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709040522;
	bh=9cI5Yta4iMzj0qg14XJKwAZyU2CweKkZsfcnOuohBj8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2LK3c7FpnvBfG2IFlMB4/nFChJKY6R9q8RXDgDSj6MXHzJVefx+sd7CQvKMHWj2EY
	 t5imwjK+Iq6kFU7fHhR0+bw2zMdZ2Ni8AB4nheZKcCq36UDeh60bOLLQ95rFs5xYbL
	 /Um346f8yNUZU9WKPX09LMJ6RPUr7FLnBB5cKplk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 015/334] wifi: mac80211: fix race condition on enabling fast-xmit
Date: Tue, 27 Feb 2024 14:17:53 +0100
Message-ID: <20240227131631.112561744@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit bcbc84af1183c8cf3d1ca9b78540c2185cd85e7f ]

fast-xmit must only be enabled after the sta has been uploaded to the driver,
otherwise it could end up passing the not-yet-uploaded sta via drv_tx calls
to the driver, leading to potential crashes because of uninitialized drv_priv
data.
Add a missing sta->uploaded check and re-check fast xmit after inserting a sta.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
Link: https://msgid.link/20240104181059.84032-1-nbd@nbd.name
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/sta_info.c | 2 ++
 net/mac80211/tx.c       | 2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index c33decbb97f2d..bcf3f727fc6da 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -913,6 +913,8 @@ static int sta_info_insert_finish(struct sta_info *sta) __acquires(RCU)
 	if (ieee80211_vif_is_mesh(&sdata->vif))
 		mesh_accept_plinks_update(sdata);
 
+	ieee80211_check_fast_xmit(sta);
+
 	return 0;
  out_remove:
 	if (sta->sta.valid_links)
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index d7aa75b7fd917..a85918594cbe2 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -3048,7 +3048,7 @@ void ieee80211_check_fast_xmit(struct sta_info *sta)
 	    sdata->vif.type == NL80211_IFTYPE_STATION)
 		goto out;
 
-	if (!test_sta_flag(sta, WLAN_STA_AUTHORIZED))
+	if (!test_sta_flag(sta, WLAN_STA_AUTHORIZED) || !sta->uploaded)
 		goto out;
 
 	if (test_sta_flag(sta, WLAN_STA_PS_STA) ||
-- 
2.43.0



