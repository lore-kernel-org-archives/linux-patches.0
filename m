Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D282D26FA77;
	Tue, 12 Aug 2025 19:14:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026052; cv=none; b=VvlwbP5gvoORphpGsP1SKcdmYXu0FyMYbcsjS9S5ypf86jxPdaPvutp/wsaZuB5HzrYiHkGhbV9Jq7jGK5SiTxk8/A7uzccKS1nctrqPvlpLNNIuou4UmPDvhBxU9YLM1ActxkebAPD+f7Q/Xau7CJKL6eJ5Fl54svtqU9A/lH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026052; c=relaxed/simple;
	bh=cgy4J5of8Q+zV63k8qOSD1en4hryHlZfFwlsYkzBlRU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J0YToZm/ABg/CaoVMyFkOVL0KS3mhfRSwtrBYucXd5675Xmmq+F4kNUy5/8v+jI08SfSDySh0d/wjBxwDvkAELPss+Tu3T1PyOahTVzMqXIWbllIXAkZCB6uw06J83Qt73umZd3hAFWbxTALkK7QjK4eGxJoA6sPiNPrcFwuQG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KcOncBcP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KcOncBcP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD6D8C4CEF0;
	Tue, 12 Aug 2025 19:14:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026052;
	bh=cgy4J5of8Q+zV63k8qOSD1en4hryHlZfFwlsYkzBlRU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KcOncBcPK+FT3JRP2rUymtJVSUM9eyN2cI8OBfiNzG3DUtzTsUtzscEFCJKgLsAKV
	 4iiXHzMl/FaOw3ntN8a4c5yH+eeYHhWE3YTIKfrCBdGxTRFp46hG2wIl8Iv8sBJBLM
	 Td00mW3tUatfpREXavA1GbHkRJfZ0Bp/NEBSLNAc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Kaistra <martin.kaistra@linutronix.de>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 189/480] wifi: mac80211: fix WARN_ON for monitor mode on some devices
Date: Tue, 12 Aug 2025 19:46:37 +0200
Message-ID: <20250812174405.300112840@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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



