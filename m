Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CAEE3B71AC;
	Thu, 17 Sep 2026 18:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668331; cv=none; b=njc4jOdgm/LHCVU1qv+S32OYy8W9NFoLOe4UgIy1qWRzKg7djqgYddAX48i4YP+dHn/FNi74wZGPM8+ygUrc4DZxJ+90YSK7bM23zIoWPwQ24rMlJoF86t0yfLhRe/GCogmoNXL2LPZQarslqzoDZoVaEb6/a3wZOazMPXGRAqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668331; c=relaxed/simple;
	bh=xu5FIfilFzMaNyKARu1uLZpSWiyldbR3xI1FL0kF8CU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HLNDKZU1d8juEBgRdqsZ9sHchTdb1MizG499YSYiu9g2DPUyXK0RzGuzjqtQ7b0UMHdK3DG4CueTKYO6EpT9ypOFGFHUjjDWZqEPqlPEBUFw4Kd2KLazckLObjswpRAmStNE8P5ZdfyoLE8MaAEnSsbb0W6eVoy3oAPUScBTfmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gpPzt4yK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gpPzt4yK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4178B1F000FF;
	Thu, 17 Sep 2026 18:05:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668329;
	bh=x1Ro0LKK7w6aELI6B0dx8ULnfi88QerSb18yy+WBlYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gpPzt4yKOwj6KC4rOojl6cTMKvbNwnBaexyQKOBnKkabjIr7XPMlGIupjFI+76ck6
	 ydcx/nztlDmQskJHOaIGqcSsCf4UmUtC836Gezzk3t2OclbHCK1ZTEdTE6N9+qDLsz
	 kdzG5DosXXcUFVGJiZrMvaNz0Raav4q2w+Vv5Oz0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0389/1102] wifi: mac80211: validate deauth frame length before reason access
Date: Thu, 17 Sep 2026 16:05:32 +0100
Message-ID: <20260917151549.422325794@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Zhao Li <enderaoelyther@gmail.com>

[ Upstream commit 4a360c6e18dfa9d70006c7247a6a8cc8dfe0d60f ]

ieee80211_rx_mgmt_deauth() reads the deauth reason code before checking
that the fixed field is actually present in the received frame.

Validate the deauth frame length first and only then read the reason
code.

Assisted-by: Codex:gpt-5.5
Assisted-by: Claude:claude-opus-4.8
Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
Link: https://patch.msgid.link/20260612185042.66260-6-enderaoelyther@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/mlme.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 453801b93c321..0e0bab76986b5 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -4459,13 +4459,15 @@ static void ieee80211_rx_mgmt_deauth(struct ieee80211_sub_if_data *sdata,
 				     struct ieee80211_mgmt *mgmt, size_t len)
 {
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
-	u16 reason_code = le16_to_cpu(mgmt->u.deauth.reason_code);
+	u16 reason_code;
 
 	lockdep_assert_wiphy(sdata->local->hw.wiphy);
 
-	if (len < 24 + 2)
+	if (len < offsetofend(struct ieee80211_mgmt, u.deauth.reason_code))
 		return;
 
+	reason_code = le16_to_cpu(mgmt->u.deauth.reason_code);
+
 	if (!ether_addr_equal(mgmt->bssid, mgmt->sa)) {
 		ieee80211_tdls_handle_disconnect(sdata, mgmt->sa, reason_code);
 		return;
-- 
2.53.0



