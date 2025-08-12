Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0713321ABD0;
	Tue, 12 Aug 2025 18:40:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024020; cv=none; b=fM6nLjaJ3+gzXfHTjYdd8UY5xqvnqysoiqGTiEQJ4S0tTvM34VFRTd2bcGy3DGfM0bq9lSfxsjnNAHChx3vET3L8NaKQMaSC185kL9FGTAkVRo/MMqBR5YOcs89zQV0MLYN6zgfMieGsCMYYDVSzGl4/Tz16ZNV253L68/IS9ks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024020; c=relaxed/simple;
	bh=y8f60VoeE3Rz5pu3oVwohH+qF3l5FGcasmbV23egHMs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nd08rieF1mR5nyiwIwRCqynNAN5b0eJQcPybgjja0mw8bz/87oyUaqA/qI3LvAiysGDDXANqEQ3G2irhL8AShR8+zeXQNSIWjKBC0Rnv0byBkHSzDszV5q4W60Lh671HRUgFsE6WNcDSYCjWl7/Z5/LHtTXstnSoEZmfGpIfmjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MVXPb14i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MVXPb14i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69F83C4CEF0;
	Tue, 12 Aug 2025 18:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024019;
	bh=y8f60VoeE3Rz5pu3oVwohH+qF3l5FGcasmbV23egHMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MVXPb14isl2OHUiDzJcj4LSpevO4PG+HcoOu6OVxe8/N+2v1PyxhNelRsmvo2achR
	 HMcdl4J7L2bjJy8TEFhImkoNRNUF+tr0Jnx12NNeTTh9F/UUVEE7bHctQCPV3mxblQ
	 CnR+98YWujJnT9Rsfs5lOE7S5djqnbhyk6UlQfj4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Kaistra <martin.kaistra@linutronix.de>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 250/627] wifi: mac80211: fix WARN_ON for monitor mode on some devices
Date: Tue, 12 Aug 2025 19:29:05 +0200
Message-ID: <20250812173428.820004679@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit c57e5b9819dfd16d709bcd6cb633301ed0829a66 ]

On devices without WANT_MONITOR_VIF (and probably without
channel context support) we get a WARN_ON for changing the
per-link setting of a monitor interface.

Since we already skip AP_VLAN interfaces and MONITOR with
WANT_MONITOR_VIF and/or NO_VIRTUAL_MONITOR should update
the settings, catch this in the link change code instead
of the warning.

Reported-by: Martin Kaistra <martin.kaistra@linutronix.de>
Link: https://lore.kernel.org/r/a9de62a0-28f1-4981-84df-253489da74ed@linutronix.de/
Fixes: c4382d5ca1af ("wifi: mac80211: update the right link for tx power")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/main.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 6b6de43d9420..1bad353d8a77 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -407,9 +407,20 @@ void ieee80211_link_info_change_notify(struct ieee80211_sub_if_data *sdata,
 
 	WARN_ON_ONCE(changed & BSS_CHANGED_VIF_CFG_FLAGS);
 
-	if (!changed || sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
+	if (!changed)
 		return;
 
+	switch (sdata->vif.type) {
+	case NL80211_IFTYPE_AP_VLAN:
+		return;
+	case NL80211_IFTYPE_MONITOR:
+		if (!ieee80211_hw_check(&local->hw, WANT_MONITOR_VIF))
+			return;
+		break;
+	default:
+		break;
+	}
+
 	if (!check_sdata_in_driver(sdata))
 		return;
 
-- 
2.39.5



