Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D5D233C198;
	Sat, 12 Sep 2026 10:46:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209970; cv=none; b=tiGrL9ME0bDG31xK/xzsz021FfytMqHcohoa4P2tHfV9EBwq/wdZyiQgahDu7nnsNL7eqTZecr2xYl8cPXRISA3EootrlH4imGwIUXwN9R0hIhkoxRrJATfXC+v2rs6LcRHIbdMFIheUVHF7NVOU1O23gbb6z6RQJJ/z5TLjWSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209970; c=relaxed/simple;
	bh=qjz6gAvvRDIjIUkGDY5yVlzrJA3ZOyum8bBUd1OMlw4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hXoJ0h1PqEMdPjmFEE9d607ZX/TPCAIx2Bj7wLJ1nVpSLb6FVAJjrKg9x8wq9pFcv5OUkW62e9WBh2f0OKeN17ARpK610YCSrpLn/6f6+tdkqgqG52/GrP8au13vDIHwy6HGkDLW1zsG3ThD6KTIzbcUjFC4l9CPiEc0fGX6wCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OtOnahKI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OtOnahKI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBC111F000FF;
	Sat, 12 Sep 2026 10:46:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209969;
	bh=3uSjTMfkoJhDuE0BJo/LoDQHoGVTOE+GNQg1tokGxHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OtOnahKInI8ohXq0bwISX3YVoYl5taFv6jjEngJup2VeeEETIUAItBDWXCxs3ZIQs
	 BnRDkUcMSySEYuT8S97nXV8XP8nrxBO5s/q1BITB2jiKKDoGMr3sa7L1xeCYfn2hmF
	 tLDou/EudJVXeUsHJxD2k/1sVWKkaeVlMTR5wjgQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0931/1518] wifi: mac80211: skip default WMM setup for AP_VLAN links
Date: Sat, 12 Sep 2026 08:51:40 +0200
Message-ID: <20260912065644.512108859@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 4d8cfff012aaa971d50b01823b1015c1073c3ff6 ]

AP_VLAN interfaces are never passed to the driver, so setting default WMM
parameters on their links trips the check-sdata-in-driver warning in
drv_conf_tx(), as well as in the BSS_CHANGED_QOS link info notification.
Skip it, matching the existing AP_VLAN handling in this function.

Fixes: 2259d14499d1 ("wifi: mac80211: set default WMM parameters on all links")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Link: https://patch.msgid.link/20260804082608.2011433-1-nbd@nbd.name
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/link.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/link.c b/net/mac80211/link.c
index 235e370c2b59e..cd02053ff5063 100644
--- a/net/mac80211/link.c
+++ b/net/mac80211/link.c
@@ -343,7 +343,8 @@ static int ieee80211_vif_update_links(struct ieee80211_sub_if_data *sdata,
 		link = links[link_id];
 		ieee80211_link_init(sdata, link_id, &link->data, &link->conf);
 		ieee80211_link_setup(&link->data);
-		ieee80211_set_wmm_default(&link->data, true, non_sta);
+		if (sdata->vif.type != NL80211_IFTYPE_AP_VLAN)
+			ieee80211_set_wmm_default(&link->data, true, non_sta);
 	}
 
 	if (new_links == 0)
-- 
2.53.0



