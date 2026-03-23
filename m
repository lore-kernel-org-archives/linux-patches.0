Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5902623ABAA;
	Mon, 23 Mar 2026 15:01:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278100; cv=none; b=PVY6U0RCwdngOExjo67G1eNAoX2bmp7XNG0tKTb8I01adZwtLXDYqZ5vgGmhSYP3AaAAxdQBtkrcEFgOwWixZXShSiMOiRDnH/d6UPRfWq1X8GT1mB8w3xW4y3PhnFEP/xI6K1S4abI0CUystcjJ3UOjbO+z1PHxFWEIl41Ypuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278100; c=relaxed/simple;
	bh=53mi8yacMBeYHkBPxBSvjIgVkT2LfGlzlRB6lF5OOhA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hIJWsvCSlBrK+4heGaIIKOF9rNN8QEp9kKqV3bY1fQ6naaIXyTJrCJ2abp61vXVjV1n7lhk0w41u3zlxwKj5My9ecFzc9S4kTKhBC6E+9h2+CFjBcP1InhFSLAbOP+yUsM3lch7INeb+NVRjnDFkMUe9f4h5TifBS1VeHVRRAhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jSWZqA8M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jSWZqA8M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA0CEC4CEF7;
	Mon, 23 Mar 2026 15:01:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774278100;
	bh=53mi8yacMBeYHkBPxBSvjIgVkT2LfGlzlRB6lF5OOhA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jSWZqA8METvBEXU81y+IcAkSQhOp29TZaa9IcIkGLRjuqLxKdcm+f3FEt/7Qk33w9
	 49pioi1CIG9M2hhZ0OahFap3aaA5206VH5ly4+ExO0CilcblWw0wtvYGMdV1tOW8WJ
	 DkjaJPacwxxbNjRPzYWTKGpslALNauDptWpqzrsI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ramanathan Choodamani <quic_rchoodam@quicinc.com>,
	Aishwarya R <aishwarya.r@oss.qualcomm.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 202/567] wifi: mac80211: set default WMM parameters on all links
Date: Mon, 23 Mar 2026 14:42:02 +0100
Message-ID: <20260323134538.843129777@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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
index af4d2b2e9a26f..2b44f1fe2031a 100644
--- a/net/mac80211/link.c
+++ b/net/mac80211/link.c
@@ -201,6 +201,7 @@ static int ieee80211_vif_update_links(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_bss_conf *old[IEEE80211_MLD_MAX_NUM_LINKS];
 	struct ieee80211_link_data *old_data[IEEE80211_MLD_MAX_NUM_LINKS];
 	bool use_deflink = old_links == 0; /* set for error case */
+	bool non_sta = sdata->vif.type != NL80211_IFTYPE_STATION;
 
 	sdata_assert_lock(sdata);
 
@@ -254,6 +255,7 @@ static int ieee80211_vif_update_links(struct ieee80211_sub_if_data *sdata,
 		link = links[link_id];
 		ieee80211_link_init(sdata, link_id, &link->data, &link->conf);
 		ieee80211_link_setup(&link->data);
+		ieee80211_set_wmm_default(&link->data, true, non_sta);
 	}
 
 	if (new_links == 0)
-- 
2.51.0



