Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2F8A4457D5;
	Sat, 12 Sep 2026 08:39:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202386; cv=none; b=XAJZqu9Y1ab7DoKktpjkXZ3IWPj57C0KJOCg2SAvwwGtL2w47QvW/23FFlUybopZgTc5PBBZmtmL5et7/UZoYHtF083QleU7XtmP1rvvaIBHNrEdFCY26BWfbLDk3hAjOocnuqaEmDWF8D/IXnkBuVQ0upNk82UjpFUh4sMHLTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202386; c=relaxed/simple;
	bh=Mc3fZEglkPJ6K+WVgauSDjQzYRqt/HSinM05vUbumug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nHKTL009t4HEx5RWo/8+9VEQ1t/thLAr/HqK4bOvrIGTylmj02LkH7b1Ge0NzaKYulF+mYCXC6G6dyO2v5qWJFvAdXsQ8UwAASEbhYxBMUoPgPG4TDfhESHA4FmtlwL+Na2PxqAzg5pGBMrTqtPEU/na1vb9MyZfLJqRGug+SbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q5ZNSEqu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q5ZNSEqu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C57E1F000FF;
	Sat, 12 Sep 2026 08:39:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789202385;
	bh=zG12sWgGbPeLZ/QGl/vaX1ifj5i9aqDWxhI+YZrgYBg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q5ZNSEqurho12rVlflfpEY/GPtozdLPpwBxjrZsVmMlX14G4736enyhOm78yx5bQ9
	 xcedDovjYFz3NcY49Rx1vOem02zVt6whp8ZHiIrIKy+VaC/cT3tn6pJoSV0rfpYFd8
	 uaXX0ebkEv+7/20Kovuxd8nJciGaX4fZTkutD/i0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1149/1815] wifi: mac80211: skip default WMM setup for AP_VLAN links
Date: Sat, 12 Sep 2026 08:48:19 +0200
Message-ID: <20260912065715.988656764@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index dc68144dc363a..931950a105088 100644
--- a/net/mac80211/link.c
+++ b/net/mac80211/link.c
@@ -360,7 +360,8 @@ static int ieee80211_vif_update_links(struct ieee80211_sub_if_data *sdata,
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



