Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E4F43BAD8B;
	Wed, 23 Sep 2026 14:38:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174326; cv=none; b=McoEee1agJ6xAJj9Q73Y5CUPFEx+8HDQWQXdcme12PY2kPqJReMnLM4aCqHwNC3ra32auoJuUvhcjy1EqQ9G7cx3ZSEAH4eK0eYajiUEPZOBaRoyEB59qnGyHxnohhiWCGf4MG+RubahzyPcjq2UHMyOYITvUG8GCaKXpv1BB8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174326; c=relaxed/simple;
	bh=++dUlofeEtePnZL1NcpdnB3U9nl0O8ZoVhZ7BI8CYts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jisn9hQercFZOYtIRoMxrQu7I8f2YiRYDXsveqQNWM8VGr+XHw8D1lxD5r24vfKIlevLK+fj/JySVrURX2zRz2kBuduQ6OLsbIqCyKV3D1b0Q+vK5d/aGkBVUFvRaaFCSUlHqIaZRY0Xv1dMvKv/oN7UwAuUXGH1lwcMWVOsGwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F2lpV94l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F2lpV94l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76F441F000FF;
	Wed, 23 Sep 2026 14:38:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174325;
	bh=ip1Iv3uSahZGw+Qgto3RNibAhpMjsOki8TmNdPBZlHQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F2lpV94lJXePPQD7JkLnNKzszRa+aan83q4tU2ygvpGTIQZJqykHjKLbedSZtQNnO
	 aHPRZC6aKiXw3WbmSJC/y36ezZKrSZsE8h7yfNb4HcYXPOP6Gt8l8gSfITh1oBcVKs
	 WX89AoH9kubFK8WXkZuLwklojjVRqFCroa1UQUVY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+f961b9f94edbc266f1f8@syzkaller.appspotmail.com,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 079/398] wifi: mac80211: add HE 6 GHz capability in the scan elems len
Date: Wed, 23 Sep 2026 16:02:33 +0200
Message-ID: <20260923140645.484117687@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 655a8aec77386..cf1d4a031af31 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -1431,6 +1431,10 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
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



