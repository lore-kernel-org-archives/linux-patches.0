Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7349038F248;
	Sat, 12 Sep 2026 14:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789224897; cv=none; b=UA1HFhsy9WAOUNXnYzTKQ6nYbPQFcAB/6vaczPRbQkf4zF+L7X6HhCNDfyxcs4S7Sh9d9X74Nsjw7xbj9ZnDQsMsFcz5rkjbU7I7/1gqNBN5mEkYZnWbLLfiCV7pUxA0GnFDLZVbASjpWiZg5vQ7qsp3zTZI9yUf+K9WZvBcbug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789224897; c=relaxed/simple;
	bh=/iqcjoAkDF9Wbn2q5mA9TbT6xMcaGDdKqM5FxYRMtjg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BKrdodWzrao4qy0g18rXOKetYvSA02ksuFgpLjUQLt6fZRReKIF3o9WTGYecjcX+kCEg29kf7Qd9eny9jxgXTYhReUETQ3GEXnQO9Zjy8OZxRF/i+136Xzx5ClHFd9kXw7zxAg2rMN4QzWWmg/ndSufH6gvACvFDB2vgjmE+b7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dEVufOxX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dEVufOxX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 311661F000FF;
	Sat, 12 Sep 2026 14:54:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789224896;
	bh=OaOAAP1By5bx+vpm9nmvlPvW6zYTSFu4WXTgUxLqOtU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dEVufOxXkP6TEgx7F5pkq7llT7A0v7DsGS9V3oTRUeXHF0aQJT2d3VydTQgDRy/Ld
	 32uJGDWKaVshNULXq6nDHP1STRMwwAoPadH+4SJp8s4unqNXtcPqAfK8wZ0jIjBMFz
	 z834J/CgLwVk/sgZn+x0J+fF+baIHOfU5IqfQTkY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1085/1424] wifi: mac80211: skip default WMM setup for AP_VLAN links
Date: Sat, 12 Sep 2026 08:58:37 +0200
Message-ID: <20260912065631.605106201@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index f3980ee817396..7e9ca63f5aab2 100644
--- a/net/mac80211/link.c
+++ b/net/mac80211/link.c
@@ -255,7 +255,8 @@ static int ieee80211_vif_update_links(struct ieee80211_sub_if_data *sdata,
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



