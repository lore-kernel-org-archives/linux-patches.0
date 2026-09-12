Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C0FA397922;
	Sat, 12 Sep 2026 10:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209459; cv=none; b=lMzsURYVcg0HeK1GyvVq2uSFCYGGCGE+iYk5lcWVHNHKCZbA/bL6HQsZVO2QAB45zJDIDM4rAK6W3ou+AeJrl056bfSsJmK1oP1VGcNHyKh9wLrxHCMlk9H4Flz5KMq9PSFD6MKkR7LOilFCQZyimUjyjMnDmcz5vZgupYEWLiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209459; c=relaxed/simple;
	bh=/Fl62+gLCTY9pWHPQDX+1ARAMd7UH619M8wG1CyZDIs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hFVaYNsbrER+kknNr9uCBJ9/78wDsVdRHnHyv70+DyMFwQf7lAcSuBtrvduQGcEmbkcDfIvCdDZOK2CL1yI8d3myjcVNH9YsnUQufAqG+yzaYXgx51TgmFMmghVTrVC3UwRrc81SOGQ2I3BQ08tods4sZHnZ3B48cir3S+RIX9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jb/J2s9w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jb/J2s9w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99DFC1F000FF;
	Sat, 12 Sep 2026 10:37:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209458;
	bh=1a1XACc+Zuvdvn2JBsejJ46WkOj++EVrcDLmmHGF1oI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Jb/J2s9wXzLWGLATGr9W82U59CRIQimHc0R+1++yYZoIb5NiLg1BxggGD2WcweMVo
	 OVxmSuAJuDRIyijtCxSb9BlIO81zdqlTy8ITMkpOiTBiygVKGPhREa4Q0rUEQgeE85
	 TJTYSCVsXb3H89a/jfYPdAyB4pkiK1egJ9puUdPU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0823/1518] wifi: nl80211: split out UHR operation information
Date: Sat, 12 Sep 2026 08:49:52 +0200
Message-ID: <20260912065642.056844835@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit e4b993f2bca78357b430170574f8de7bc7874088 ]

The beacon doesn't contain the full UHR operation, a number
of fields (such as NPCA) are only partially there. Add a new
attribute to contain the full information, so it's available
to the driver/mac80211.

Link: https://patch.msgid.link/20260303221710.866bacf82639.Iafdf37fb0f4304bdcdb824977d61e17b38c47685@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Stable-dep-of: 6c5fc504d0d6 ("wifi: cfg80211: stop PMSR before P2P and NAN teardown")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/nl80211.h |  6 ++++++
 net/wireless/nl80211.c       | 26 ++++++++++++++++----------
 2 files changed, 22 insertions(+), 10 deletions(-)

diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 69152abd64b9a..66440f40d144c 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -3000,6 +3000,10 @@ enum nl80211_commands {
  *	interference detection is not performed on these sub-channels, their
  *	corresponding bits are consistently set to zero.
  *
+ * @NL80211_ATTR_UHR_OPERATION: Full UHR Operation element, as it appears in
+ *	association response etc., since it's abridged in the beacon. Used
+ *	for START_AP etc.
+ *
  * @NUM_NL80211_ATTR: total number of nl80211_attrs available
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
@@ -3575,6 +3579,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_INCUMBENT_SIGNAL_INTERFERENCE_BITMAP,
 
+	NL80211_ATTR_UHR_OPERATION,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 53b784cc8a3fd..cbf1fcc81ae2f 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -341,6 +341,17 @@ static int validate_uhr_capa(const struct nlattr *attr,
 	return ieee80211_uhr_capa_size_ok(data, len, false);
 }
 
+static int validate_uhr_operation(const struct nlattr *attr,
+				  struct netlink_ext_ack *extack)
+{
+	const u8 *data = nla_data(attr);
+	unsigned int len = nla_len(attr);
+
+	if (!ieee80211_uhr_oper_size_ok(data, len, false))
+		return -EINVAL;
+	return 0;
+}
+
 /* policy for the attributes */
 static const struct nla_policy nl80211_policy[NUM_NL80211_ATTR];
 
@@ -947,6 +958,8 @@ static const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
 	[NL80211_ATTR_UHR_CAPABILITY] =
 		NLA_POLICY_VALIDATE_FN(NLA_BINARY, validate_uhr_capa, 255),
 	[NL80211_ATTR_DISABLE_UHR] = { .type = NLA_FLAG },
+	[NL80211_ATTR_UHR_OPERATION] =
+		NLA_POLICY_VALIDATE_FN(NLA_BINARY, validate_uhr_operation),
 };
 
 /* policy for the key attributes */
@@ -6470,16 +6483,6 @@ static int nl80211_calculate_ap_params(struct cfg80211_ap_settings *params)
 			return -EINVAL;
 	}
 
-	cap = cfg80211_find_ext_elem(WLAN_EID_EXT_UHR_OPER, ies, ies_len);
-	if (cap) {
-		if (!cap->datalen)
-			return -EINVAL;
-		params->uhr_oper = (void *)(cap->data + 1);
-		if (!ieee80211_uhr_oper_size_ok((const u8 *)params->uhr_oper,
-						cap->datalen - 1, true))
-			return -EINVAL;
-	}
-
 	return 0;
 }
 
@@ -6905,6 +6908,9 @@ static int nl80211_start_ap(struct sk_buff *skb, struct genl_info *info)
 	if (err)
 		goto out;
 
+	if (info->attrs[NL80211_ATTR_UHR_OPERATION])
+		params->uhr_oper = nla_data(info->attrs[NL80211_ATTR_UHR_OPERATION]);
+
 	err = nl80211_validate_ap_phy_operation(params);
 	if (err)
 		goto out;
-- 
2.53.0



