Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE51B361675;
	Wed, 30 Sep 2026 16:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785825; cv=none; b=fO4FX5jw/PdNQ2KdO1f5i6XNPXU3xrrWzfzFdlgBCUqRjXGQ9a4uqZQJiiKXTbyAvyEeVZJRAD/chr3v+wrzG2jO7uydkXJqlIRKyYgEJEhKWdBvzj7tztmPTJieRsMHlfjEmz3d9Z9Un0kcjxvs9Pae1rPXe1cUmKxmjyVHTQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785825; c=relaxed/simple;
	bh=bOxdgUMx3binV6dFniZJYNr57ZT/lNuR82k2TwQpSeI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HHJlaTJb1fTJXWnQRzCfndsYmGfELyfitlC9BPrd9S3MJPiFyhMANXuLSnYnr0EcpJmJENMuFth36nQTq2YbQn7j5f0TuQ/pRTsa8esoRy7xLw5etSD4Lbt82qniFJqjugxi38YQV3dDa/ts7OOuD9f7nlauMKcmsDLT/z3OR/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FSJB/vp9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FSJB/vp9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 230781F000FF;
	Wed, 30 Sep 2026 16:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785824;
	bh=cmOD+1LyDm0lHrSOIhHBp6iTIQ7l9HzIAYzSdLbck7A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FSJB/vp93psnc9l0shB9WeR0XTVr9S1gxcMSjrQ7gSSZDBHdJOPQUrp5FU+XB+sEk
	 rd+H4AAfJvWs/pk1/MpnqDaPGo/hQDl+s6qQWOkdAoPIj8N9da5I+5st5Kp6mRPZgq
	 qMznPI+bbqEHjWtHw35ihXHrtYrVJImVGYbKpoNk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+f961b9f94edbc266f1f8@syzkaller.appspotmail.com,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 638/982] wifi: mac80211: add HE 6 GHz capability in the scan elems len
Date: Wed, 30 Sep 2026 17:22:54 +0200
Message-ID: <20260930152430.471920006@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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
index 033f407559b68..b695c0b6728ed 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -1232,6 +1232,10 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
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



