Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F65034252B
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:02:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301769; cv=none; b=ZE61G2FfIHfJhMylXaCQbXOw6bmPHqV0h1dqngd9ueaGa6SquYQYrHlrImOO3k+a8ZGbJOwxEbS00nmS42LSS0CAA9ulRUuLj0+jvihsaJYXPpewxVkC0Px6b6cRqT5du1kh0KNdXIsl3/l9cn6xyn5Db3J8OixBWmuglMxDWGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301769; c=relaxed/simple;
	bh=nJXbVlmHPH79nHU8XYjdHlLUo4ElEQBlb0L7BuarAFI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TyLBmVLMAxbVCFlhhT88q61KgaUgrf/TDMi/Ibz+ym51ldDp6KqcL/o+DhP7M0SVOYGdH7iNx7+yND8PysQQeJU4sx4CAYd40K0lp3nrrsTdLiMLqkAurab0sJMJ0OncsiO/+FSjOnpjBwi8qkC9ztDUDp6CSd/09YV+esLixGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=spuyle//; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="spuyle//"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93741C116D0;
	Sat, 28 Feb 2026 18:02:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301769;
	bh=nJXbVlmHPH79nHU8XYjdHlLUo4ElEQBlb0L7BuarAFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=spuyle//5hAth7s0ahXB5Bzcc3FFSF0KDNqC23BMm2jO/A0JqAg2Sl9E/mybUO9II
	 3CWyj85mxGg+ij059mGlTfN0q1sWnjLaK99oTJgWlrvxgb22Rg/JwDs9BH9V+o6S4C
	 E40et6+dNQGtJ397OfhREevehvXikuJ6HO4r9MO8NfnUAUWDNLjtDmL1RnKouetaAE
	 h4Zvn2IVDD5kIFGOS3Sv7MOLK3QPNh8lQ5R/sR9Wq3mW8vSV9lmOceFqfyh3xa78Vs
	 OEJ6inNCtZh6yF1OrXqH5ELf/nsH3vcG+KUcQT4/GoSsKpsZwgSB3CLlRbdfIlCZTr
	 7EADEhNA/8qcw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Huang Chenming <chenming.huang@oss.qualcomm.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 176/385] wifi: cfg80211: Fix use_for flag update on BSS refresh
Date: Sat, 28 Feb 2026 12:56:38 -0500
Message-ID: <20260228180011.1568201-176-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Huang Chenming <chenming.huang@oss.qualcomm.com>

[ Upstream commit 4073ea516106e5f98ed0476f89cdede8baa98d37 ]

Userspace may fail to connect to certain BSS that were initially
marked as unusable due to regulatory restrictions (use_for = 0,
e.g., 6 GHz power type mismatch). Even after these restrictions
are removed and the BSS becomes usable, connection attempts still
fail.

The issue occurs in cfg80211_update_known_bss() where the use_for
flag is updated using bitwise AND (&=) instead of direct assignment.
Once a BSS is marked with use_for = 0, the AND operation masks out
any subsequent non-zero values, permanently keeping the flag at 0.
This causes __cfg80211_get_bss(), invoked by nl80211_assoc_bss(), to
fail the check "(bss->pub.use_for & use_for) != use_for", thereby
blocking association.

Replace the bitwise AND operation with direct assignment so the use_for
flag accurately reflects the current BSS state.

Fixes: d02a12b8e4bb ("wifi: cfg80211: add BSS usage reporting")
Signed-off-by: Huang Chenming <chenming.huang@oss.qualcomm.com>
Link: https://patch.msgid.link/20251209025733.2098456-1-chenming.huang@oss.qualcomm.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/scan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index f00ccc6d803be..f9aff1c58e800 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -1906,7 +1906,7 @@ cfg80211_update_known_bss(struct cfg80211_registered_device *rdev,
 	ether_addr_copy(known->parent_bssid, new->parent_bssid);
 	known->pub.max_bssid_indicator = new->pub.max_bssid_indicator;
 	known->pub.bssid_index = new->pub.bssid_index;
-	known->pub.use_for &= new->pub.use_for;
+	known->pub.use_for = new->pub.use_for;
 	known->pub.cannot_use_reasons = new->pub.cannot_use_reasons;
 	known->bss_source = new->bss_source;
 
-- 
2.51.0

