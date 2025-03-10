Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F238A22D799;
	Mon, 10 Mar 2025 17:26:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627602; cv=none; b=LrStvhNBhZmmngaNJS3UNv6+n4FrbjEZ9+F+FENktCc8TzW72JY5YGyAMkE8o4spRHH6uADOYq6H+LbVMN5uCfxoni6nbB4QydjM9yvNeGZfG3++QDzN3DC13SZ2LPlZ0eT1vuOldzqYYg8W9Du54E8qWmu++vR6oS9WzRdCvsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627602; c=relaxed/simple;
	bh=zvyjyCSLDPQ1rkZSg79nr/sQD90zCiBFlEZVQJPZlCM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nHGqmxgWN2woH2J+W9NAR/XIL68n0PcZqpfJ2eylGhe+jg7zIEN2nXCs1UgaCcd0t0HrIMHPh6L7ez7dTBknaMuaOov431cf01SqoTr+gKYbD3ngmuvxto10y1/NNxsLGEpnljiXa63RqLtSqYNr7qjm5U2Cj1ARu1KccIoMo8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v/ajClyC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v/ajClyC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78F16C4CEE5;
	Mon, 10 Mar 2025 17:26:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627601;
	bh=zvyjyCSLDPQ1rkZSg79nr/sQD90zCiBFlEZVQJPZlCM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v/ajClyCUhfNVUdSwQ0xTWavg5E6y15625qQDJ2CQH7pYeg9YxN0ZWpVGEIXQpiCi
	 718gR97uYX6k4vEMlbEtCbuTlS3PrgWJIuDNHgR4PB6i7ERxBaZpaKezNiBLFs3UVq
	 tOQGhrQi8cdnJdjzOmuTsaFozUsZ8/PvAhmfjvJM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilan Peer <ilan.peer@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 153/269] wifi: mac80211: Support parsing EPCS ML element
Date: Mon, 10 Mar 2025 18:05:06 +0100
Message-ID: <20250310170503.822690710@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
References: <20250310170457.700086763@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilan Peer <ilan.peer@intel.com>

[ Upstream commit 24711d60f8492a30622e419cee643d59264ea939 ]

Add support for parsing an ML element of type EPCS priority
access, which can optionally be included in EHT protected action
frames used to configure EPCS.

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20250102161730.5afdf65cff46.I0ffa30b40fbad47bc5b608b5fd46047a8c44e904@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Stable-dep-of: 99ca2c28e6b6 ("wifi: mac80211: fix MLE non-inheritance parsing")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/ieee80211_i.h |  2 ++
 net/mac80211/parse.c       | 29 +++++++++++++++++++++++++++++
 2 files changed, 31 insertions(+)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 7a0242e937d36..bfe0514efca37 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1751,6 +1751,7 @@ struct ieee802_11_elems {
 	const struct ieee80211_eht_operation *eht_operation;
 	const struct ieee80211_multi_link_elem *ml_basic;
 	const struct ieee80211_multi_link_elem *ml_reconf;
+	const struct ieee80211_multi_link_elem *ml_epcs;
 	const struct ieee80211_bandwidth_indication *bandwidth_indication;
 	const struct ieee80211_ttlm_elem *ttlm[IEEE80211_TTLM_MAX_CNT];
 
@@ -1781,6 +1782,7 @@ struct ieee802_11_elems {
 	/* mult-link element can be de-fragmented and thus u8 is not sufficient */
 	size_t ml_basic_len;
 	size_t ml_reconf_len;
+	size_t ml_epcs_len;
 
 	u8 ttlm_num;
 
diff --git a/net/mac80211/parse.c b/net/mac80211/parse.c
index 279c5143b3356..cd318c1c67bec 100644
--- a/net/mac80211/parse.c
+++ b/net/mac80211/parse.c
@@ -44,6 +44,9 @@ struct ieee80211_elems_parse {
 	/* The reconfiguration Multi-Link element in the original elements */
 	const struct element *ml_reconf_elem;
 
+	/* The EPCS Multi-Link element in the original elements */
+	const struct element *ml_epcs_elem;
+
 	/*
 	 * scratch buffer that can be used for various element parsing related
 	 * tasks, e.g., element de-fragmentation etc.
@@ -159,6 +162,9 @@ ieee80211_parse_extension_element(u32 *crc,
 			case IEEE80211_ML_CONTROL_TYPE_RECONF:
 				elems_parse->ml_reconf_elem = elem;
 				break;
+			case IEEE80211_ML_CONTROL_TYPE_PRIO_ACCESS:
+				elems_parse->ml_epcs_elem = elem;
+				break;
 			default:
 				break;
 			}
@@ -943,6 +949,27 @@ ieee80211_mle_defrag_reconf(struct ieee80211_elems_parse *elems_parse)
 	elems_parse->scratch_pos += ml_len;
 }
 
+static void
+ieee80211_mle_defrag_epcs(struct ieee80211_elems_parse *elems_parse)
+{
+	struct ieee802_11_elems *elems = &elems_parse->elems;
+	ssize_t ml_len;
+
+	ml_len = cfg80211_defragment_element(elems_parse->ml_epcs_elem,
+					     elems->ie_start,
+					     elems->total_len,
+					     elems_parse->scratch_pos,
+					     elems_parse->scratch +
+						elems_parse->scratch_len -
+						elems_parse->scratch_pos,
+					     WLAN_EID_FRAGMENT);
+	if (ml_len < 0)
+		return;
+	elems->ml_epcs = (void *)elems_parse->scratch_pos;
+	elems->ml_epcs_len = ml_len;
+	elems_parse->scratch_pos += ml_len;
+}
+
 struct ieee802_11_elems *
 ieee802_11_parse_elems_full(struct ieee80211_elems_parse_params *params)
 {
@@ -1001,6 +1028,8 @@ ieee802_11_parse_elems_full(struct ieee80211_elems_parse_params *params)
 
 	ieee80211_mle_defrag_reconf(elems_parse);
 
+	ieee80211_mle_defrag_epcs(elems_parse);
+
 	if (elems->tim && !elems->parse_error) {
 		const struct ieee80211_tim_ie *tim_ie = elems->tim;
 
-- 
2.39.5



