Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 940895187EA;
	Wed, 30 Sep 2026 17:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788295; cv=none; b=efyECYdjIRfgwXQPRkpt2A1w8rQ/3g2/TvG2F7hTHq+FIE0r2kTAzcAb6gq5EIA+0E0oCD6UoV/f6zdwUwy8bAPGjfaaFAlthCMZcWsml2RvQn/DHiRjfpn+KHod0JAejpZ264V/vf4pzpjvpHE98BCIkGG3M2kb4TjFd2LGts0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788295; c=relaxed/simple;
	bh=+ImT4GhUcpF+hyjG+XBlI2FYfFUlUu/5kr7rfA/zY5Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jlKPK1ruG+PtTyXgQaDPjudZFBnPBFKQadQeC+R11WsPV9ttyqY/XsVnQdVGK9hl26f5IhbhsKxEohyZQ5DbH4wjr7a3Y6FMPU3wn9nPSm6fa4ihluUkbg1Snxxbo1Loxo1W0ks0mJ823UW+nMg+yz6y8W+NGGrCmM/QkxRscGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fj6qs8jY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fj6qs8jY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB9651F000FF;
	Wed, 30 Sep 2026 17:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788294;
	bh=jZZKMLy7OzHgv7fj4syyIslbue6o+6s/wO9dkHeizmM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Fj6qs8jYD46x0v1I4QoS05kOVwvueFAKsrWI2LFb7HbSTYyMqtM8zk/wHoKjXLSrc
	 s4gNkU7/1mCNuPhQIKd7WicL5wulN86azivAz6dBpdh7xO4RsBrKC6VcbTDVpiuD2d
	 XRLqXH5Xy6HEl0mosa9nn6jnEGpBumaXMXhZ/h/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+f961b9f94edbc266f1f8@syzkaller.appspotmail.com,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 075/877] wifi: mac80211: add HE 6 GHz capability in the scan elems len
Date: Wed, 30 Sep 2026 17:16:26 +0200
Message-ID: <20260930152416.356987024@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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
index 84cc2a21a9a59..a65d49e4402ad 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -1424,6 +1424,10 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
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



