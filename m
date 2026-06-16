Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 432A143E9DC;
	Tue, 16 Jun 2026 15:17:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781623033; cv=none; b=P8pI2N8a0Jh/xArl3XRe6Vfe4g6yiALcguuL8ngjAOZhJcvtLCXU3PWrHzeuhVLtan1ituluL+kZoAxHqQZ1XY5ZNT8tz6s/Dm5++pp2jKhZP7NC2kwCocXS6xKA+aTIApf3vvB2JadFw/SjxsseISrnLMl7R92IiBFEdm7YfUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781623033; c=relaxed/simple;
	bh=qzd43nYe+B1L2BCxq96s+1Ke0nLQOlFIU/TqHlcwfzE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hr7EUky1Di6OtzGc8IY1RbVQ0WFECdIio/IUMZVLaZvMOYZw317I7vZivXA6wqKOyqkN15YyWt00QvzhzxYRES5uJKovczDYPTOjW1dApLIVT5aWB16V7WozaoJRnBkBW0RD73gBIB3wZIhLsFwI9KuEmV6jAy3yo+vvd2JVxfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zPJ2SkNn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zPJ2SkNn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03FD31F00A3D;
	Tue, 16 Jun 2026 15:17:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781623031;
	bh=HNJQUiCjnnW1VFccxJRGkre0JQdylPKiC+FpV7EMC+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zPJ2SkNn/vCxutv0+NHvYFTa3sP84R1vitTqBlsp4NOwccnW8fXlPj879r+zoW7kr
	 n0+IXRTY1gJ+uNITHHBTzqTd5HvWjFPB4QQhH1r8iceAsSFt3kEy1sFWdxxcOOJH10
	 5L+cLCwUF0iQ5Xi7P3f1xyl1idRfMlsXjRtwR+9s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 042/378] wifi: nl80211: split out UHR operation information
Date: Tue, 16 Jun 2026 20:24:33 +0530
Message-ID: <20260616145112.121213576@linuxfoundation.org>
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

[ Upstream commit e4b993f2bca78357b430170574f8de7bc7874088 ]

The beacon doesn't contain the full UHR operation, a number
of fields (such as NPCA) are only partially there. Add a new
attribute to contain the full information, so it's available
to the driver/mac80211.

Link: https://patch.msgid.link/20260303221710.866bacf82639.Iafdf37fb0f4304bdcdb824977d61e17b38c47685@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Stable-dep-of: cb9959ab5f99 ("wifi: cfg80211: enforce HE/EHT cap/oper consistency")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/nl80211.h |  6 ++++++
 net/wireless/nl80211.c       | 26 ++++++++++++++++----------
 2 files changed, 22 insertions(+), 10 deletions(-)

diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index b53e2d78c7bb3f..b997e6c6fc4b38 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -3001,6 +3001,10 @@ enum nl80211_commands {
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
@@ -3576,6 +3580,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_INCUMBENT_SIGNAL_INTERFERENCE_BITMAP,
 
+	NL80211_ATTR_UHR_OPERATION,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index d00357488ea8ea..84fcfb1e53a156 100644
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
 
@@ -946,6 +957,8 @@ static const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
 	[NL80211_ATTR_UHR_CAPABILITY] =
 		NLA_POLICY_VALIDATE_FN(NLA_BINARY, validate_uhr_capa, 255),
 	[NL80211_ATTR_DISABLE_UHR] = { .type = NLA_FLAG },
+	[NL80211_ATTR_UHR_OPERATION] =
+		NLA_POLICY_VALIDATE_FN(NLA_BINARY, validate_uhr_operation),
 };
 
 /* policy for the key attributes */
@@ -6486,16 +6499,6 @@ static int nl80211_calculate_ap_params(struct cfg80211_ap_settings *params)
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
 
@@ -6928,6 +6931,9 @@ static int nl80211_start_ap(struct sk_buff *skb, struct genl_info *info)
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



