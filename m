Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C2B335FF6B;
	Wed,  3 Dec 2025 16:28:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779300; cv=none; b=rbqksqidex7L4sDQRE0APYhkiiUUck1VAMXqzc7ls+FCwGPo0cd9LlJm/PcjjLJ9wOY7JIT14zPyx1Qlh818O/SQ/NzICWQ9T7TCY9SL5np48wtqUJb2CUBXeOz/lFW+peezzPogbVtES4Mvx5KlSkAVkF19GAiNettSxN9xuX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779300; c=relaxed/simple;
	bh=86mYzpP3M44yRL/wsD0GpeOp8afTTdLcCkYa2Zof84w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oXDNTa0QVZ45egJfvpuo7CVg72L1JaVHAZr6BsMfdycCO6xkg8x4uLSHXGZs8yo8RCBHp605F+CcKIILs1141VaZ2zHdVJC7YHKYPN0HIcOaWw5iFNUvVtxzeMQ1UsJ6JfOTIiOjOgi4R0At2A0u18Og4QMDEeAQG6IHrAdd9dY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Uz3vyv/9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Uz3vyv/9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBA7DC4CEF5;
	Wed,  3 Dec 2025 16:28:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779300;
	bh=86mYzpP3M44yRL/wsD0GpeOp8afTTdLcCkYa2Zof84w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Uz3vyv/9rcDiElgVKlTpJoewFNXykRcgAeEFRLXn5w5fgwxRRuwjkEzXm1dKFp80d
	 fBy9+r1yO1Js7Yq9OVZQyAL7lRiXFuIF67a2KHQGv82fvlkG7Bb+TNoT04I0rW7FMY
	 zZmaoE5j9JZmZtiNUf31ver5eV8tlnBvzndmwhLw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilan Peer <ilan.peer@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 209/568] wifi: mac80211: Fix HE capabilities element check
Date: Wed,  3 Dec 2025 16:23:31 +0100
Message-ID: <20251203152448.380094340@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilan Peer <ilan.peer@intel.com>

[ Upstream commit ea928544f3215fdeac24d66bef85e10bb638b8c1 ]

The element data length check did not account for the extra
octet used for the extension ID. Fix it.

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20250907115109.8da0012e2286.I8c0c69a0011f7153c13b365b14dfef48cfe7c3e3@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/mlme.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index cc47d6b88f04d..15826bbde70c2 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -4386,7 +4386,7 @@ static u8 ieee80211_max_rx_chains(struct ieee80211_link_data *link,
 	he_cap_elem = cfg80211_find_ext_elem(WLAN_EID_EXT_HE_CAPABILITY,
 					     ies->data, ies->len);
 
-	if (!he_cap_elem || he_cap_elem->datalen < sizeof(*he_cap))
+	if (!he_cap_elem || he_cap_elem->datalen < sizeof(*he_cap) + 1)
 		return chains;
 
 	/* skip one byte ext_tag_id */
-- 
2.51.0



