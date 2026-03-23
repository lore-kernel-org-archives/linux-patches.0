Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A137E274B5F;
	Mon, 23 Mar 2026 16:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282418; cv=none; b=QtjI93FW/ipDQc8XdR4lneFomcev6xGYzpUfb05m6QomU5O/Aap5dVOY3mkYruI2GcJjbbZYAlwqAMmb/Bn0RDgHKUALVrrc62uXAGyt27UKNqp7U1+jPDNWg5F4CRoUBfOELz02R3w3Pg0x8F6DhjQ7S3ZgRzdHpWywjMToAAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282418; c=relaxed/simple;
	bh=QYZCgyQvsaLnD3/gOg98hth1Y+54aN1dFIm12mJ3HJM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g08B41gjGjhRLtRDu4qkMpNGum23SVNJ00YIadAyk3sd3I69uqGiA3aB94ipSNO1IJLMpXmZ+4rqY34c8Zi2kgkvawxM+3Miq9IPNtD8zmb8iBe51BbpbH+6k5W0ZoYteBz9JlGUEVy7HgUCb52SXSjTRj1ZlDHKSSpuAN7gTWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wzcllvk6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wzcllvk6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D48EC2BCB4;
	Mon, 23 Mar 2026 16:13:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282418;
	bh=QYZCgyQvsaLnD3/gOg98hth1Y+54aN1dFIm12mJ3HJM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wzcllvk6N9FoTNF7leElYe6kJMEfYxHSVsuX2ysZEaeAjgZLHx8YZSIFSqApDEGFd
	 7mNXIdDb8TCxk2wm800tzx8x8Sfmcr3mmusqmEpkgimfLkQvMol7W0/QinCsuEUKho
	 Cdtd01XjzKInM7Ysk4dApVSF8662SR9psWUt840o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ramanathan Choodamani <quic_rchoodam@quicinc.com>,
	Aishwarya R <aishwarya.r@oss.qualcomm.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 150/481] wifi: mac80211: set default WMM parameters on all links
Date: Mon, 23 Mar 2026 14:42:12 +0100
Message-ID: <20260323134528.904829084@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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
index a85b44c1bc995..cd84e7f3b742e 100644
--- a/net/mac80211/link.c
+++ b/net/mac80211/link.c
@@ -176,6 +176,7 @@ static int ieee80211_vif_update_links(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_bss_conf *old[IEEE80211_MLD_MAX_NUM_LINKS];
 	struct ieee80211_link_data *old_data[IEEE80211_MLD_MAX_NUM_LINKS];
 	bool use_deflink = old_links == 0; /* set for error case */
+	bool non_sta = sdata->vif.type != NL80211_IFTYPE_STATION;
 
 	sdata_assert_lock(sdata);
 
@@ -229,6 +230,7 @@ static int ieee80211_vif_update_links(struct ieee80211_sub_if_data *sdata,
 		link = links[link_id];
 		ieee80211_link_init(sdata, link_id, &link->data, &link->conf);
 		ieee80211_link_setup(&link->data);
+		ieee80211_set_wmm_default(&link->data, true, non_sta);
 	}
 
 	if (new_links == 0)
-- 
2.51.0



