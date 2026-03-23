Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 190F23AEF4F;
	Mon, 23 Mar 2026 13:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274091; cv=none; b=tEbiBEloGyOYoU16jzI/BWUJ2V27CBoJ7NVJTIiTU+7prtrIcKjuey1XSDKk4bH0o79IqDeRoqdqv0TaxDBJU7b418PwySwSquvuQjhKlD6zh9T7xXTFxFHqNV0cbZcM3Q+0jlNwyEWoYdteGF5s9xIO1cTFZVR45wY9ObDECwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274091; c=relaxed/simple;
	bh=owaAb4U69Z8d2j/xfeTH2KBWKY0OVYGFueT0UFzKXwM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iqIWpRMBTjde1jAx2zdMThrV8jQfTK3laWDjR1LJiVgOnR2v48+iTptO7pxQyKuExmuPZSa+zbOHBg2plSlsEVIf3OQkM/+OdR5oIjShEnpm07mBaWsRODTVpFr9ixwGbG8mHldMHNPfPOYkGid+quafgOWtpFsaJ9lp5ye+jTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PQvS8u/y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PQvS8u/y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 920F3C4CEF7;
	Mon, 23 Mar 2026 13:54:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274091;
	bh=owaAb4U69Z8d2j/xfeTH2KBWKY0OVYGFueT0UFzKXwM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PQvS8u/y0tEpc3Nfe4EkJx5yDUKYDVxAiViuSAE3Jcl/ou3pnF0U82LjLToVJJTwU
	 +bxn6CE55Euc5Sp5dnBS1qWsSfV7Fad1pyv3UtS9nssbhNBq3wzcZCWRDe8kGo/8cx
	 mP1CJvb5LwN2O1dKOR1yrZPUG2W4sTfFuMgBUYRo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Cavallari <nicolas.cavallari@green-communications.fr>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 105/220] wifi: mac80211: use jiffies_delta_to_msecs() for sta_info inactive times
Date: Mon, 23 Mar 2026 14:44:42 +0100
Message-ID: <20260323134507.924694737@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134504.575022936@linuxfoundation.org>
References: <20260323134504.575022936@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolas Cavallari <nicolas.cavallari@green-communications.fr>

[ Upstream commit ac6f24cc9c0a9aefa55ec9696dcafa971d4d760b ]

Inactive times of around 0xffffffff milliseconds have been observed on
an ath9k device on ARM.  This is likely due to a memory ordering race in
the jiffies_to_msecs(jiffies - last_active()) calculation causing an
overflow when the observed jiffies is below ieee80211_sta_last_active().

Use jiffies_delta_to_msecs() instead to avoid this problem.

Fixes: 7bbdd2d98797 ("mac80211: implement station stats retrieval")
Signed-off-by: Nicolas Cavallari <nicolas.cavallari@green-communications.fr>
Link: https://patch.msgid.link/20260303161701.31808-1-nicolas.cavallari@green-communications.fr
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/sta_info.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 1a995bc301b19..b0d9bb830f293 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -2759,7 +2759,9 @@ static void sta_set_link_sinfo(struct sta_info *sta,
 	}
 
 	link_sinfo->inactive_time =
-		jiffies_to_msecs(jiffies - ieee80211_sta_last_active(sta, link_id));
+		jiffies_delta_to_msecs(jiffies -
+				       ieee80211_sta_last_active(sta,
+								 link_id));
 
 	if (!(link_sinfo->filled & (BIT_ULL(NL80211_STA_INFO_TX_BYTES64) |
 				    BIT_ULL(NL80211_STA_INFO_TX_BYTES)))) {
@@ -2992,7 +2994,8 @@ void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo,
 	sinfo->connected_time = ktime_get_seconds() - sta->last_connected;
 	sinfo->assoc_at = sta->assoc_at;
 	sinfo->inactive_time =
-		jiffies_to_msecs(jiffies - ieee80211_sta_last_active(sta, -1));
+		jiffies_delta_to_msecs(jiffies -
+				       ieee80211_sta_last_active(sta, -1));
 
 	if (!(sinfo->filled & (BIT_ULL(NL80211_STA_INFO_TX_BYTES64) |
 			       BIT_ULL(NL80211_STA_INFO_TX_BYTES)))) {
-- 
2.51.0



