Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01D8438C437;
	Tue, 16 Jun 2026 15:14:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781622858; cv=none; b=jgSKMlpq59ZJUbI5uGIwe2fugxYf+2Jw5lIPSr7WKZeVD7lJ+NePxU8rQubgxAfw8J5KwpalECA+ORsCWEfnVo1kZyn0pgytiZHnTD5fpwFVLJqeAVhD7X2SHe5BBvHXslA04Zg/WJBLP3iCYhL3mcd8vDsK27OVez4C6oXt87c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781622858; c=relaxed/simple;
	bh=nuIsfejA+IUDJTQluutFwWVqlforFS2qjTHy4u1czMs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mr4jehJ5oi7MuROucqIETsfbkuPxbDU+272f218qzEkQOtl1nXpaNqFZGIMNyocFVhEvgVzCURCph6v5BQFRcL1tB+0io4vMqWs770bhNVThfyCQ7SQ7FZNKjX6BIXMOR7G31b+PRHFaN6NhPh2ISrFyHdT7J9OUVOSgBwC9tIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RrdfjwnZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RrdfjwnZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0BDE1F000E9;
	Tue, 16 Jun 2026 15:14:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781622857;
	bh=8rkZHbdl6yPIxxTPbiRgc6cIMS3123y6GilUk+d+gbs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RrdfjwnZYewcMDaGL4aJBwJpYkXqGWyP3I5mXReNfuJlF5EmYtbGVY4My0/ZfEqwc
	 cZCKSw9BNzKxjkyLM02Wv2/g1kJP/xWakfRpt1GT8lmQokX4EUlgLGMlct0AmzRezS
	 67gJNQTRCiuQU3ruUccs/znlwejeWY95hA7tn/os=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 043/378] wifi: cfg80211: enforce HE/EHT cap/oper consistency
Date: Tue, 16 Jun 2026 20:24:34 +0530
Message-ID: <20260616145112.175519570@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit cb9959ab5f99611d27a06586add84811fe8102dc ]

Xiang Mei reports that mac80211 could crash if eht_cap is set
but eht_oper isn't. Rather than fixing that for the individual
user(s), enforce that both HE/EHT have consistent elements.

Reported-by: Xiang Mei <xmei5@asu.edu>
Fixes: 22c64f37e1d4 ("wifi: mac80211: Update MCS15 support in link_conf")
Link: https://patch.msgid.link/20260603091812.101894-2-johannes@sipsolutions.net
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/nl80211.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 84fcfb1e53a156..fe0c0c198b2526 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -6499,6 +6499,12 @@ static int nl80211_calculate_ap_params(struct cfg80211_ap_settings *params)
 			return -EINVAL;
 	}
 
+	if (!!params->he_cap != !!params->he_oper)
+		return -EINVAL;
+
+	if (!!params->eht_cap != !!params->eht_oper)
+		return -EINVAL;
+
 	return 0;
 }
 
-- 
2.53.0



