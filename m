Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68E5952B1F7;
	Wed, 23 Sep 2026 14:14:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790172882; cv=none; b=J6dikWfLHLGOEE+LJuWGY68HAHbOLmqCND0zcuP8gu2Rr62FMSt4kE7bJP/nVDlqX7z6Ox3H7N5HanBD1Oo6WQWQnGdae/bUuw0+Cif1Ip6WMQww1HV9mB5eAd5VTQQWSEkkYNcd4kVBLp45tkC6g+wQHSfjP8HC667jxx+wmMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790172882; c=relaxed/simple;
	bh=cw2ppyVCsP3xslOYGyEfvtmQK8qIykdArMZ2sBTO++0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pDDVV8+qw2rBVxqDTRgOc9HhYi9vuEGN5MSmL6sfHep4V5hEcX1bcibaNYskPezjMpFpi6XGj2YfgSxvMc+Q2wk5nYLhkw7bkhIefHZrwLvDnhbUeAwoR15sS1sZ6WVAg7+tjXfAcEh9SzlebRo1mDLGQxlC3IZY6jtjnzqS3B0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ps6z3DWJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ps6z3DWJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58D8E1F000FF;
	Wed, 23 Sep 2026 14:14:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790172881;
	bh=dPgDNKxzBAmxstFlCNifE3pJ6q6YwBt2IvEYMtc529Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ps6z3DWJfcBsZviKQEzUrovf9ottH5cZ7abMgXJxaywHgGQtPjUhYgUWkpCAY3dkz
	 6zzAuAdumyaGiR9yf5mQo/Kp+TJOLqL2R7mb0bNyiVnki/kxAnYKiOUPg7L/NbfQp0
	 raA6Is6v4giLXjya4i4hKsqTLw4nZmxpl1W8Ze9Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+f961b9f94edbc266f1f8@syzkaller.appspotmail.com,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 088/438] wifi: mac80211: add HE 6 GHz capability in the scan elems len
Date: Wed, 23 Sep 2026 16:01:49 +0200
Message-ID: <20260923140647.062065473@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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
index eb1eaaf34612e..8edfef2b57f80 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -1454,6 +1454,10 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
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



