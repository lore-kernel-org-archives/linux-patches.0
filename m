Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B97CC265630;
	Tue,  8 Apr 2025 11:13:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110812; cv=none; b=qXS/LSCxoEYKA4KCCn9fz4y+xocqP83UbgTBLgDxfTE2LVST08IBNLua2PB14ey3iy1c9bU+BSk2XZ3iECr668TF16uNYXrNA7bret/fqLN8mdlhDBW1uhFCAFOVAkSiOa99rf86KTDhdK03GyxX90VihR9m4nSfxy1CFbKG2KM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110812; c=relaxed/simple;
	bh=/AZjxmViMRQo0MTLVV6VS1JOuTgGojhXOtdn16SJZio=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IIZcc2S5IWzqTBDw8aOZFTFwsfzh4BBNmVuHzfBppuMqpto2vgqi9pzmdIbcVFE12n6mFtoZUwwo/Yb+BeQSI5A8XsVS3p6qO02nSd5dHYGP3MJUuEPQKwv0keL9fby5aDWVDuaRYO1GzpnNENsISa8iyuhYBbeGhwYxhp/vgMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LNxa6RPg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LNxa6RPg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6772C4CEEA;
	Tue,  8 Apr 2025 11:13:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110812;
	bh=/AZjxmViMRQo0MTLVV6VS1JOuTgGojhXOtdn16SJZio=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LNxa6RPgwu60hbN+o/J85t48GLmd9HC4Qt55pjZRccp+J+cdH3PWGKrM/8S2dkBHY
	 ez5+GrY/S3U6qjZoZjUyXQkQhEtVpIq/2HhEbhE6+zbwtnQojlkBo407aD1yNVkzIH
	 48XT9gR96sT5x+vSyQO+i//B+6ftuRSc7oDgpGzo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikhail Lobanov <m.lobanov@rosa.ru>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 202/731] wifi: mac80211: check basic rates validity in sta_link_apply_parameters
Date: Tue,  8 Apr 2025 12:41:39 +0200
Message-ID: <20250408104918.978733744@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikhail Lobanov <m.lobanov@rosa.ru>

[ Upstream commit 16ee3ea8faef8ff042acc15867a6c458c573de61 ]

When userspace sets supported rates for a new station via
NL80211_CMD_NEW_STATION, it might send a list that's empty
or contains only invalid values. Currently, we process these
values in sta_link_apply_parameters() without checking the result of
ieee80211_parse_bitrates(), which can lead to an empty rates bitmap.

A similar issue was addressed for NL80211_CMD_SET_BSS in commit
ce04abc3fcc6 ("wifi: mac80211: check basic rates validity").
This patch applies the same approach in sta_link_apply_parameters()
for NL80211_CMD_NEW_STATION, ensuring there is at least one valid
rate by inspecting the result of ieee80211_parse_bitrates().

Found by Linux Verification Center (linuxtesting.org) with Syzkaller.

Fixes: b95eb7f0eee4 ("wifi: cfg80211/mac80211: separate link params from station params")
Signed-off-by: Mikhail Lobanov <m.lobanov@rosa.ru>
Link: https://patch.msgid.link/20250317103139.17625-1-m.lobanov@rosa.ru
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/cfg.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 9351c64608a99..b766472703b12 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1908,12 +1908,12 @@ static int sta_link_apply_parameters(struct ieee80211_local *local,
 	}
 
 	if (params->supported_rates &&
-	    params->supported_rates_len) {
-		ieee80211_parse_bitrates(link->conf->chanreq.oper.width,
-					 sband, params->supported_rates,
-					 params->supported_rates_len,
-					 &link_sta->pub->supp_rates[sband->band]);
-	}
+	    params->supported_rates_len &&
+	    !ieee80211_parse_bitrates(link->conf->chanreq.oper.width,
+				      sband, params->supported_rates,
+				      params->supported_rates_len,
+				      &link_sta->pub->supp_rates[sband->band]))
+		return -EINVAL;
 
 	if (params->ht_capa)
 		ieee80211_ht_cap_ie_to_sta_ht_cap(sdata, sband,
-- 
2.39.5



