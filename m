Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C5DC320CBE;
	Sat, 12 Sep 2026 08:24:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201496; cv=none; b=tiHkN7a7air9aSA7ARyv4DiRXyAenBD5CRKMze/TZ1Qu1Qn/ad2N+hhQAHsPh97cfbqUhriBN2g4N7sKwHjPH8aJXTqjRDw3GG891SIM1ahoO2PW2pHx/JvXoP9Ri321XQ7UYo1xdt7tXtOBObNZuUS8FcYrK5vEWPUFHPKBlfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201496; c=relaxed/simple;
	bh=iaE92IgQ5+DTMeG8hUoxLP9gnA200pIYdBdwNCpt5rA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eMcOeokHc6hvAFxNSzs4+aqQInGuTl4q3VzqZVxNgwhBZsLjnHTnzXDBJ4989iWp/4l3AMZKWa95i/y1belWw/Hdj2zHNaBj5ICSJx0x3VefEq8RCDkZst138IfhLXqRoSmnS3l/e5v2Dyr+NYQW9+0mBTwK2zB35jC8oCrerwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bLe6rL+h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bLe6rL+h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E35C1F000FF;
	Sat, 12 Sep 2026 08:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201495;
	bh=aFtheJskC6SkbQMYktenauGFF6sk6qomyQ1Tumh3iuQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bLe6rL+h/IB4iK8ZAZhbzxzdrfu0akQ/3UmXZ7GdS8Sna6DMlDmfHlTrVhwlSvw9H
	 BD/+wyuDW2N/BSYCS+g8j8QkAVCz6+S6j25H5FdNa3ygXE1sgKRSd0HgfOe8l0fbY/
	 1hNsidr8tSZ7j0x/ZNK/JAdn1FTwx7la8c7JEsAo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0965/1815] wifi: nl80211: clean up color-change beacon data on errors
Date: Sat, 12 Sep 2026 08:45:15 +0200
Message-ID: <20260912065711.628735026@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhao Li <enderaoelyther@gmail.com>

[ Upstream commit 927ee844c47ac2aef22c8f7a35f098ff576b398b ]

nl80211_color_change() calls nl80211_parse_beacon() for the beacon_next
template, which can allocate params.beacon_next.mbssid_ies and .rnr_ies.
A parsing failure returned directly instead of using the out: cleanup,
leaking any allocations completed before the error.

Allocate the nested attribute table before parsing beacon_next. Its
allocation failure can then return before beacon data exists, while a
later parsing failure uses out: to release the parsed data.

Fixes: dc1e3cb8da8b ("nl80211: MBSSID and EMA support in AP mode")
Assisted-by: Codex:gpt-5
Assisted-by: Claude:opus-4.8
Assisted-by: Kimi:K3
Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
Link: https://patch.msgid.link/20260731120244.82628-1-enderaoelyther@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/nl80211.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 5adcb6bd0fc56..755f8fe711fb2 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -18750,15 +18750,15 @@ static int nl80211_color_change(struct sk_buff *skb, struct genl_info *info)
 	if (!wdev->links[params.link_id].ap.beacon_interval)
 		return -EINVAL;
 
+	tb = kzalloc_objs(*tb, NL80211_ATTR_MAX + 1);
+	if (!tb)
+		return -ENOMEM;
+
 	err = nl80211_parse_beacon(rdev, info->attrs, &params.beacon_next,
 				   wdev->links[params.link_id].ap.chandef.chan,
 				   info->extack);
 	if (err)
-		return err;
-
-	tb = kzalloc_objs(*tb, NL80211_ATTR_MAX + 1);
-	if (!tb)
-		return -ENOMEM;
+		goto out;
 
 	err = nla_parse_nested(tb, NL80211_ATTR_MAX,
 			       info->attrs[NL80211_ATTR_COLOR_CHANGE_ELEMS],
-- 
2.53.0



