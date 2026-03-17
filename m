Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D56D2F83A2;
	Tue, 17 Mar 2026 16:37:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773765459; cv=none; b=Zi87dO7KD4kLYaSVdaS+HhqRK3H1X5SvI6gHnYnJRgFDyGZ4rTWc+vqzwMevYZeAL0y8JNxxOEoWF3WT/Q0QNmmGF3bbHodbLdamLhH1oZ2THHdTLjtcJpf/OHeMM5fyWzWc8uU1xxdQzB/2b1LgJ4HxmBtZ7GYsi3nMcUJK0f0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773765459; c=relaxed/simple;
	bh=+r0dWqhqBmSoYxWY5Qgh6WrFV0W0sBrAj7h6w0MQGY8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RDIOX3tnQTu320Y7cIWwzcCCDw8Cv59IB5lL9EbwK6vl9/1uQ7T5pLLI8CP6UwtosiBtLL3GQY28TdZQ+Kh1PKPxDb+kwht1fwJ2puhV1n+gxRNDZjacmBB8e3gO9PvRYIYjunL/flxY9pDNe2wVg6+Ip/bqSGhDNMw0iw/GLVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ghc7Akgh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ghc7Akgh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94264C4CEF7;
	Tue, 17 Mar 2026 16:37:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773765459;
	bh=+r0dWqhqBmSoYxWY5Qgh6WrFV0W0sBrAj7h6w0MQGY8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ghc7AkghwJDSqqROhpHoPQr7Jh5AgS58khSfX0VJSS87Uiys13VgOlUcVJcXNkTHG
	 99b+f73kERP19VSCFbcxmkkZglTqWODG7OuGOocImmiaTaECEtqPCvcdGxLnGJnxFB
	 uwN4CX77a/0j5IC15ba7vErkXLS+d9PYRRVChqCg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ramanathan Choodamani <quic_rchoodam@quicinc.com>,
	Aishwarya R <aishwarya.r@oss.qualcomm.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 016/378] wifi: mac80211: set default WMM parameters on all links
Date: Tue, 17 Mar 2026 17:29:33 +0100
Message-ID: <20260317163007.572435721@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ramanathan Choodamani <quic_rchoodam@quicinc.com>

[ Upstream commit 2259d14499d16b115ef8d5d2ddc867e2be7cb5b5 ]

Currently, mac80211 only initializes default WMM parameters
on the deflink during do_open(). For MLO cases, this
leaves the additional links without proper WMM defaults
if hostapd does not supply per-link WMM parameters, leading
to inconsistent QoS behavior across links.

Set default WMM parameters for each link during
ieee80211_vif_update_links(), because this ensures all
individual links in an MLD have valid WMM settings during
bring-up and behave consistently across different BSS.

Signed-off-by: Ramanathan Choodamani <quic_rchoodam@quicinc.com>
Signed-off-by: Aishwarya R <aishwarya.r@oss.qualcomm.com>
Link: https://patch.msgid.link/20260205094216.3093542-1-aishwarya.r@oss.qualcomm.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/link.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/mac80211/link.c b/net/mac80211/link.c
index 1e05845872afc..b659497680b51 100644
--- a/net/mac80211/link.c
+++ b/net/mac80211/link.c
@@ -281,6 +281,7 @@ static int ieee80211_vif_update_links(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_bss_conf *old[IEEE80211_MLD_MAX_NUM_LINKS];
 	struct ieee80211_link_data *old_data[IEEE80211_MLD_MAX_NUM_LINKS];
 	bool use_deflink = old_links == 0; /* set for error case */
+	bool non_sta = sdata->vif.type != NL80211_IFTYPE_STATION;
 
 	lockdep_assert_wiphy(sdata->local->hw.wiphy);
 
@@ -337,6 +338,7 @@ static int ieee80211_vif_update_links(struct ieee80211_sub_if_data *sdata,
 		link = links[link_id];
 		ieee80211_link_init(sdata, link_id, &link->data, &link->conf);
 		ieee80211_link_setup(&link->data);
+		ieee80211_set_wmm_default(&link->data, true, non_sta);
 	}
 
 	if (new_links == 0)
-- 
2.51.0



