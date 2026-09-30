Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A193F3DDAFC;
	Wed, 30 Sep 2026 19:22:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796146; cv=none; b=hRsucdiOpzQV0JbWXPMCQ1LeA7VduXkQlNrknn5ONzh8PWbhRMy9CLcBDZQzu4EI4hU7/3XSOAwGgeNtFQVit+Y+Z5uQGL3OJPcfr6esbifsUR2cYDA8bM3xFPpyKGGfYGky75hTyRsHoaC5Pkh2G/ieo4Q3hxi8CBrFfspUMTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796146; c=relaxed/simple;
	bh=PK7lwBWxDhXhFA+xyyWkC2gIVlQZHYlJTf154rj4Qtw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LoFy8IAdMMzD+YOeCY5YO74qAFHs9D8NOEKpbTwYRVU9EE+Euhv/Hl8h4cTCbLff094lzgbTMvDkoQfFkUM7KXnnlzeoAk3fBbhId8Z38QPRudp5qUO9IM+55kAt3iSErwf3nEwvM4jMcltu3q4UfL2WlbiWRkfoK6jw1g5me7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MMfbpNrv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MMfbpNrv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 049891F000FF;
	Wed, 30 Sep 2026 19:22:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796145;
	bh=Dh6RBOINANKTPaFz18XEIw+5c1ATT1B8IhH/ObhcnsI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MMfbpNrvVEqqv/UyO/yHlOFg5KDbC1Zk+mTLJidxK/pQmTTcx94Mhd+3042BjnWLN
	 N7Bi2cqREqOdG0DuzOZXbFxMkan1VKg9sG6u3Js+JWeEy7uecO0qQXspM7onrOoxSR
	 T3pngbnmBezaj9nIG6kxAIXo6xN453k+94KG3cBo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+f961b9f94edbc266f1f8@syzkaller.appspotmail.com,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0765/1193] wifi: mac80211: add HE 6 GHz capability in the scan elems len
Date: Wed, 30 Sep 2026 17:24:09 +0200
Message-ID: <20260930152451.252595254@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit cd54bf333f5631d3630bab0a832e9ae648f73515 ]

The HE 6 GHz Band Capability element is in the probe request for
every band if 6 GHz is supported, so add the size to scan_ies_len.

Otherwise, building probe request elements can fail, triggering the
WARN_ON in __ieee80211_start_scan().

Assisted-by: LLM
Fixes: 2ad2274c58ee ("mac80211: Add HE 6GHz capabilities element to probe request")
Reported-by: syzbot+f961b9f94edbc266f1f8@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=f961b9f94edbc266f1f8
Link: https://patch.msgid.link/20260908122838.201719-19-johannes@sipsolutions.net
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index a5674e52d7fe3..f0ffefe822241 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -1266,6 +1266,10 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 			sizeof(struct ieee80211_he_mcs_nss_supp) +
 			IEEE80211_HE_PPE_THRES_MAX_LEN;
 
+		if (local->hw.wiphy->bands[NL80211_BAND_6GHZ])
+			local->scan_ies_len +=
+				3 + sizeof(struct ieee80211_he_6ghz_capa);
+
 		if (supp_eht)
 			local->scan_ies_len +=
 				3 + sizeof(struct ieee80211_eht_cap_elem) +
-- 
2.53.0



