Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67C263EC2F1;
	Tue, 17 Mar 2026 17:06:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773767206; cv=none; b=uqh9NyZ6YgE2ufwd5w/plvT20XGz7RVkDXLSaV5Xq4GiIFcb9n8nc5ZT5pKIZ+6fBfhtuip6YNRPMaTGVJ/vGt6JW9TbBB//5UxiZ88bfgwS9HzMuUF2GAvEjQz30Vl6tCSJkuFQoLqhSr66i/wUGAApsqea65qrRDowmsBJ4NM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773767206; c=relaxed/simple;
	bh=rzO0+5k9JIx6RQxBf3Phu2t5xrIuCJP291T8Gq6NmnE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=krbctC6mLL1BTNOxEXl29Spdff8mcbEH/fbBRK+I//RuwkwUElNABqSNDT4Po6VPbdQtBnIDj9lPK1bIMhQgE4ScUjnXkXOjyT1C1TQrXZxW+OqAXAxY64PdB/R+9JW7bCDlIrSkM0z0lTfqNxO4jwX3pKlEH+3Rx3T+TpvoAYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IQoE/oAs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IQoE/oAs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FACEC4CEF7;
	Tue, 17 Mar 2026 17:06:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773767206;
	bh=rzO0+5k9JIx6RQxBf3Phu2t5xrIuCJP291T8Gq6NmnE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IQoE/oAsAUtCpp3zrmfa7o0aXhUNg5Vz4b+YdvP7Go1FiUCh1K3U0bd5G/rPmAZV0
	 i+U6A64CQ2Fpk1SNcQGbDqKSPYoY/8IjP3NS9bHBZIIFjcDT80ttp/V+UI0FKNYxii
	 CWkkoDlAW76zmuhByTv6zWQRBt3Y5TsI12faUCbE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ramanathan Choodamani <quic_rchoodam@quicinc.com>,
	Aishwarya R <aishwarya.r@oss.qualcomm.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 008/333] wifi: mac80211: set default WMM parameters on all links
Date: Tue, 17 Mar 2026 17:30:37 +0100
Message-ID: <20260317162959.664298066@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
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
index 4a19b765ccb69..05b0472bda40e 100644
--- a/net/mac80211/link.c
+++ b/net/mac80211/link.c
@@ -286,6 +286,7 @@ static int ieee80211_vif_update_links(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_bss_conf *old[IEEE80211_MLD_MAX_NUM_LINKS];
 	struct ieee80211_link_data *old_data[IEEE80211_MLD_MAX_NUM_LINKS];
 	bool use_deflink = old_links == 0; /* set for error case */
+	bool non_sta = sdata->vif.type != NL80211_IFTYPE_STATION;
 
 	lockdep_assert_wiphy(sdata->local->hw.wiphy);
 
@@ -342,6 +343,7 @@ static int ieee80211_vif_update_links(struct ieee80211_sub_if_data *sdata,
 		link = links[link_id];
 		ieee80211_link_init(sdata, link_id, &link->data, &link->conf);
 		ieee80211_link_setup(&link->data);
+		ieee80211_set_wmm_default(&link->data, true, non_sta);
 	}
 
 	if (new_links == 0)
-- 
2.51.0



