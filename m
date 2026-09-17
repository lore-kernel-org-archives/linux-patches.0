Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E31CD4848B5;
	Thu, 17 Sep 2026 16:02:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660946; cv=none; b=bWb3dWdD7doiYbYTlZg3FVfl3ctzH1odUjTqRL1x9m8yNGWIHwDB4Px84XJbVxs2XjTQrwQ+efDcuwqZWgJ0J2qby1HD2Yn3iYz8E/mXXxiKTZj2C6jas/0hg/Dev0oWIDd+nmMTq4OdbePPRWDjsgjx0QXKB5/j0Bm83dzNdSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660946; c=relaxed/simple;
	bh=niM/eeEXMz1i4sWoT7luBqwqjxdiPceEBYlKty/dH3w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DEWpR/+xrXux7Eyj3ht3gsIPj9MeW/R3QzGJiB4WwplevA9NueGOScDGSvu0Yxa8+DEGpUyo7WrBzMlgCvP5kF8AujhGvCHxti94cTFDVwdj4JheUMr/fg+u5l1BYziB6NrBjZ8P+lBFt02Mio1+kH05kv+yif4YZxlvnvqC278=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YzwoHn10; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YzwoHn10"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 432CF1F000FF;
	Thu, 17 Sep 2026 16:02:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660944;
	bh=HOkof/S4sl9Die4rm+ZPlrZDxJR2Zv76vfIz9BCKDms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YzwoHn10eldvG65DI9/r/DleHjSXjQiWoWoEKVAjS4jdWsuDJ/ac2Il/7//4JASko
	 W8B8Okbkten4Iy5wnVhTidgrhFwpeC8Q0PIyrFdlupY7U+7bKHwHixUbebv5dbHMC/
	 80AFr9vRCA56BN5Ks6Ki+63k1MXtQA3Ha+iLPqkQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0030/1250] wifi: nl80211: check link is beaconing for color change
Date: Thu, 17 Sep 2026 15:57:05 +0100
Message-ID: <20260917151552.746673634@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

[ Upstream commit 55308cee9c2196f39cd1ce8ee6c1fed9e12a00d4 ]

When trying to do a color change, validate that the link is
beaconing first, to avoid calling the driver with an invalid
link.

Reviewed-by: Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20260415145348.beb59ea5fbf7.I128a956a3e610bb6a5c9cad941d7d5b59b735a5e@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/nl80211.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index badb951763840..906a974cce5dc 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -17783,6 +17783,10 @@ static int nl80211_color_change(struct sk_buff *skb, struct genl_info *info)
 	params.count = nla_get_u8(info->attrs[NL80211_ATTR_COLOR_CHANGE_COUNT]);
 	params.color = nla_get_u8(info->attrs[NL80211_ATTR_COLOR_CHANGE_COLOR]);
 
+	params.link_id = nl80211_link_id(info->attrs);
+	if (!wdev->links[params.link_id].ap.beacon_interval)
+		return -EINVAL;
+
 	err = nl80211_parse_beacon(rdev, info->attrs, &params.beacon_next,
 				   info->extack);
 	if (err)
@@ -17856,7 +17860,6 @@ static int nl80211_color_change(struct sk_buff *skb, struct genl_info *info)
 			goto out;
 	}
 
-	params.link_id = nl80211_link_id(info->attrs);
 	err = rdev_color_change(rdev, dev, &params);
 
 out:
-- 
2.53.0



