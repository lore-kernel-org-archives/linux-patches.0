Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C951147277D;
	Sat, 12 Sep 2026 12:52:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789217547; cv=none; b=rerg/3yCJ+nQx3rfFuOCiYaAB6LFKC3zb6deS1w1/IcYRpNThupQg1rA3e0tg//cAM6S6qmv28B/MxV+WoRJZEHchRkWqVt+8ddLVy9X00nyEEy5lVzvw0dENkdo/x0I8P2szPuCvUZ73oPjFukjcOHPkRNRH1QizSL9GSfJb1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789217547; c=relaxed/simple;
	bh=lok5PhgmpqL2T8frYtIk9iDF6qez8BEZM+m9mhjGQXc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hsho1DXeXI7/xsjPCNrdSXsx/cKEHVjad3HrzB94ubq3C36szt9GWuaaWLy1y7nUvIyKVtifTZjWxZI5oEu/xzm5TFeXW6PRDKlPMPGh3VzR8/PcC9NHyYOR8vTWkk5aSIszJ/W60OWY1siiV0AoChwHu5/aOG8IcS30h3TqnQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gNeqyADd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gNeqyADd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76E411F000FF;
	Sat, 12 Sep 2026 12:52:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789217545;
	bh=oxhOnzH8OBJS1CqYHjsWp53LJjSLssIo6gjQc4ralrU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gNeqyADdY0isYQ8RyLvVQdPwxOmgNcBp3GT23ze4zPmKxhJOfF2o7wKn3+LgQacnR
	 72UgKZHdygcJYZjuqamiUCEva8fRs5GgBItQQpmaaf/ZBPo/Njemtye3zYZNwRhGW4
	 tgpUgVlpOGN4vPywHARpA6oKKpTxKjZDVv6vpjM0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0932/1376] wifi: mac80211: skip default WMM setup for AP_VLAN links
Date: Sat, 12 Sep 2026 08:55:58 +0200
Message-ID: <20260912065628.334394791@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 29813394bbff1..7e249e2f93bfa 100644
--- a/net/mac80211/link.c
+++ b/net/mac80211/link.c
@@ -340,7 +340,8 @@ static int ieee80211_vif_update_links(struct ieee80211_sub_if_data *sdata,
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



