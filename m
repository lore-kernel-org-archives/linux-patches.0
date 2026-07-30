Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 462E93C2785;
	Thu, 30 Jul 2026 14:21:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421319; cv=none; b=jH8D4GlX2bKnlxVVcITeVkzIN0UOLL+2TiSxUcK/UCREwyj0Bdd35WTgWre5XGU9G7h68ELHAB5DkdroIPx8H6/PjYadawfy8GEcA1xZUistIegK4mBMVix7TEvHeAyodXetS1vNU0vPzdiWrqhaaaKTw61eG9DuPQQTYXThc5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421319; c=relaxed/simple;
	bh=2nfRv0fdZfAPS0F3LGnfKJlAoJMcUl1u+fLgMG/qw0U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kxAnXMvEPjaQg4TWCX+51PAZ27eTBMzc2GeG2d5QpdxtEEF4G1YQwLfMUNqKtd3tXOw9rmujmii8FYqrUw9CRdlv6A7NySPr05txFkL+of9lYbzSi9ciggn4Xb71zFUHyB8FgpqTYBtt4hdouxA51Hw8jpnGrMPhl3OqxqAR65Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WznpHNX5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WznpHNX5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 653CE1F000E9;
	Thu, 30 Jul 2026 14:21:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421317;
	bh=+pYyQXO90sLAt4JuXml7KIO4CtGvTsOacOyXL7VTyPE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WznpHNX54ncQooj08ZBvc37D3YHWgaWDaFbHl9Kwb74UYzB+fBcbTYEQvAY0ca+jb
	 C+mJwXf6SGpK7Z71HR+Fyh97Xe8m427zesl3ciEFS7CUonavgby3d/34rWED910Yju
	 WXrWHTOoQxIv6nU5mfifqMFuIYvQlhpgfWQwymLY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 062/744] wifi: nl80211: validate nested MBSSID IE blobs
Date: Thu, 30 Jul 2026 16:05:35 +0200
Message-ID: <20260730141445.595844231@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhao Li <enderaoelyther@gmail.com>

[ Upstream commit 7f4b01812323443b55e4c65381c9dc851ff009e3 ]

Validate each nested NL80211_ATTR_MBSSID_ELEMS entry as a well-formed
information-element stream before storing it for beacon construction.

RNR parsing already validates each nested blob with validate_ie_attr()
before storing it. Apply the same syntactic IE validation to MBSSID
entries before counting and copying their data and length pointers.

Fixes: dc1e3cb8da8b ("nl80211: MBSSID and EMA support in AP mode")
Assisted-by: Codex:gpt-5.5
Assisted-by: Claude:claude-opus-4.8
Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
Link: https://patch.msgid.link/20260612131854.43575-3-enderaoelyther@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/nl80211.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index c7edaea9873e0a..264ae4e742a1c4 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -6321,7 +6321,8 @@ static int nl80211_parse_mbssid_config(struct wiphy *wiphy,
 }
 
 static struct cfg80211_mbssid_elems *
-nl80211_parse_mbssid_elems(struct wiphy *wiphy, struct nlattr *attrs)
+nl80211_parse_mbssid_elems(struct wiphy *wiphy, struct nlattr *attrs,
+			   struct netlink_ext_ack *extack)
 {
 	struct nlattr *nl_elems;
 	struct cfg80211_mbssid_elems *elems;
@@ -6332,6 +6333,12 @@ nl80211_parse_mbssid_elems(struct wiphy *wiphy, struct nlattr *attrs)
 		return ERR_PTR(-EINVAL);
 
 	nla_for_each_nested(nl_elems, attrs, rem_elems) {
+		int ret;
+
+		ret = validate_ie_attr(nl_elems, extack);
+		if (ret)
+			return ERR_PTR(ret);
+
 		if (num_elems >= 255)
 			return ERR_PTR(-EINVAL);
 		num_elems++;
@@ -6503,7 +6510,8 @@ static int nl80211_parse_beacon(struct cfg80211_registered_device *rdev,
 	if (attrs[NL80211_ATTR_MBSSID_ELEMS]) {
 		struct cfg80211_mbssid_elems *mbssid =
 			nl80211_parse_mbssid_elems(&rdev->wiphy,
-						   attrs[NL80211_ATTR_MBSSID_ELEMS]);
+						   attrs[NL80211_ATTR_MBSSID_ELEMS],
+						   extack);
 
 		if (IS_ERR(mbssid))
 			return PTR_ERR(mbssid);
-- 
2.53.0



