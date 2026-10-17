Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BA4B3CAE9B;
	Sat, 17 Oct 2026 18:02:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260129; cv=none; b=qchyWfLnACq1dChyewFUaXLlaOPb4KhHIpJKGIseMJTjSXetNku9O7kR+ALrnw7neYA4BO4BARb6dwGu5JWAGv7/1N+mAZoD2zTOQHKCfBO9trN/xd5LVySWIFFBvo7o7WYwHnc/Yg/zTzz3G/RtkslydZSIwfjvvOnJ2hvU5UA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260129; c=relaxed/simple;
	bh=9WvvtfnthTUu3tgEg8tboIUs266/7I6VzMXEC5cl5xk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OV0R0WFOFpTxUMa6A6+mYe6FjHKkpAwGG/3rcWg8cpqc31XNuMAWODUuI0F3PN5hTukebx1uNwQxO1s8gaIZ0ruhD5V/S1V+VOyqM+ZlsPTKFKWNp6QhXXCivD7q2XXTOmZQyL+8OeE5of/WIPFMyul9H/Elp0n3EQ6a6zGkS5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E/WaAUxr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E/WaAUxr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B78D51F000C4;
	Sat, 17 Oct 2026 18:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260128;
	bh=/vXiXNJ8sWyDhmi9qPK9dQSsG7iVeFbcH4QpirGaiPs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E/WaAUxrqZsOmD07vZNxpTBzkP8dVti31F3Z3U/Dg4CcFzB665C+3seBSYaqqH2bL
	 RRZPqIQgjAyfUhZ3movAT4AcbXR18u/BeKnZBhJdjKpjp1llloXNoYqFx/xwNASxqm
	 zwMUNE/g/mKg1Q3Ick6wtifoO1BAvGqSLPEioH6c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1442/1674] wifi: nl80211: check link is beaconing for color change
Date: Sat, 17 Oct 2026 18:01:54 +0200
Message-ID: <20261017160508.194458432@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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
 net/wireless/nl80211.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index c4af4cc443676..ac1cba2ce48a0 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -16090,6 +16090,7 @@ static int nl80211_color_change(struct sk_buff *skb, struct genl_info *info)
 	struct net_device *dev = info->user_ptr[1];
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct nlattr **tb;
+	unsigned int link_id;
 	u16 offset;
 	int err;
 
@@ -16111,6 +16112,10 @@ static int nl80211_color_change(struct sk_buff *skb, struct genl_info *info)
 	params.count = nla_get_u8(info->attrs[NL80211_ATTR_COLOR_CHANGE_COUNT]);
 	params.color = nla_get_u8(info->attrs[NL80211_ATTR_COLOR_CHANGE_COLOR]);
 
+	link_id = nl80211_link_id(info->attrs);
+	if (!wdev->links[link_id].ap.beacon_interval)
+		return -EINVAL;
+
 	err = nl80211_parse_beacon(rdev, info->attrs, &params.beacon_next,
 				   info->extack);
 	if (err)
-- 
2.53.0



