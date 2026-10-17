Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 602EA3AB476;
	Sat, 17 Oct 2026 16:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255116; cv=none; b=hZ3naTbsEM6+7LmEtoXBynd5jPWfeevWhF5mGodPNnm2A5tMDoh544QSU6qrrxAxoSyOujFlzNU5Jw1SAAYO2PgoiWFOcj8FD4/8OCr28ET4IkX5Pt+xEWE2ZahspsqFXOs8NZBVOmj74OiV7Cq8GI+J4YFLvGNl/ecyTL/Nim4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255116; c=relaxed/simple;
	bh=EZRyk7IZVLi4wt79duPjPrFHvQOvcB0ihmQ/c8bHX4s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qAwuskGUg+LTNShmbXf/08oJt+mSBG/5bALTkD8UExgwhpKPbCqbSZdpnhaJc6HZrXmkLx4G0bDBMQbRGRwk5kaXLZLPr0VUDGjE+9ZA9U41DJD74SfVR6pNznr8UOKqVWt/T4qOK0vevrQX2HHILPlfC36i8Biu6EhZO9PnaPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ay4GJp99; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ay4GJp99"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 685861F000C5;
	Sat, 17 Oct 2026 16:38:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255115;
	bh=PKwra8SOM1VGd5rCy7QbqtDeoTjT5OeBBCK45cuFNoQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ay4GJp99Ikyr+PEmY3zb+3DQoyIk1bM+ailbqmW+rRyDYBfKENV2hkn0DMSXz3m8w
	 mxSuIh2CBkJthEvkkVRhzZIDJdnH5ivhnvrDWkLkQlQm+AjjUlTTG+2iQftdZ01gw6
	 ZlxhsshCH7UIrjSPn4SaJo2kRFCUbbVDtHKhlzsk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 671/869] wifi: nl80211: check link is beaconing for color change
Date: Sat, 17 Oct 2026 17:58:32 +0200
Message-ID: <20261017160054.192621301@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 55308cee9c2196f39cd1ce8ee6c1fed9e12a00d4 ]

When trying to do a color change, validate that the link is
beaconing first, to avoid calling the driver with an invalid
link.

Reviewed-by: Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20260415145348.beb59ea5fbf7.I128a956a3e610bb6a5c9cad941d7d5b59b735a5e@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Stable-dep-of: 927ee844c47a ("wifi: nl80211: clean up color-change beacon data on errors")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/nl80211.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index dddd15f2d6b57..49ee160f3b3b2 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -16171,6 +16171,10 @@ static int nl80211_color_change(struct sk_buff *skb, struct genl_info *info)
 	params.count = nla_get_u8(info->attrs[NL80211_ATTR_COLOR_CHANGE_COUNT]);
 	params.color = nla_get_u8(info->attrs[NL80211_ATTR_COLOR_CHANGE_COLOR]);
 
+	params.link_id = nl80211_link_id(info->attrs);
+	if (!wdev->links[params.link_id].ap.beacon_interval)
+		return -EINVAL;
+
 	err = nl80211_parse_beacon(rdev, info->attrs, &params.beacon_next,
 				   info->extack);
 	if (err)
@@ -16236,7 +16240,6 @@ static int nl80211_color_change(struct sk_buff *skb, struct genl_info *info)
 		params.counter_offset_presp = offset;
 	}
 
-	params.link_id = nl80211_link_id(info->attrs);
 	err = rdev_color_change(rdev, dev, &params);
 
 out:
-- 
2.53.0



