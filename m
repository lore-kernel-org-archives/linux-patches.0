Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4255C3ADB9A;
	Sat, 17 Oct 2026 16:38:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255123; cv=none; b=jqaT4NHxshKUl44NMQYsN6UU9BtoxO2U+ckPtEVeSWdXYDID9CDwkBFlihG5Uv9GNpBV9kABitnXrli3saTys40CzyNy05DCXKgNL3vqlusl7F8B5xLBZ6wAoijGKILr8e/mxH6vTyFmICesLDKUxxWAvEGr3/ag4dhEiGtfx2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255123; c=relaxed/simple;
	bh=HxoOE06q4sctUHbqpB2KbuQpMizp3nM/9+zUgKZ4onA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cqAqPrREufUI+H9/wEWskywUZKKFuX/ZV8T2NigiG8C05Y66wwEWQufl7vv9mkQ96/PFl+HoBsJehCm1lpSw1j7/4BQwzyL9oddN85lIv46ApqJh93rwrKrlfwoFL3j9xZLFfY6dZ1yKKYK07OfO58kpjVpu6OeOy1szAURhLkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iw4n+L7x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iw4n+L7x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49CC81F000C4;
	Sat, 17 Oct 2026 16:38:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255120;
	bh=RtGoY8qVrWpPs8o8y7FgJJmNlVgJHei93WDEvVZ0/pc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iw4n+L7xQM87j4YNx4kCQ8zTo9uoZ9QAd8631uSbuJ2qodoMLs8V49Q5jyNOOxnEN
	 OAV5ZvtIz1w52SMw/sVQAy0g3KWHbDw+X3Idu7AeBGDn679uVMYfhWwQGRk9uAWCSQ
	 YPXL9pwJwLPP8SujkremuYpoaxrAt0q+KhoMjBh0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 672/869] wifi: nl80211: clean up color-change beacon data on errors
Date: Sat, 17 Oct 2026 17:58:33 +0200
Message-ID: <20261017160054.218845589@linuxfoundation.org>
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
index 49ee160f3b3b2..c5df80b547077 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -16175,15 +16175,15 @@ static int nl80211_color_change(struct sk_buff *skb, struct genl_info *info)
 	if (!wdev->links[params.link_id].ap.beacon_interval)
 		return -EINVAL;
 
-	err = nl80211_parse_beacon(rdev, info->attrs, &params.beacon_next,
-				   info->extack);
-	if (err)
-		return err;
-
 	tb = kcalloc(NL80211_ATTR_MAX + 1, sizeof(*tb), GFP_KERNEL);
 	if (!tb)
 		return -ENOMEM;
 
+	err = nl80211_parse_beacon(rdev, info->attrs, &params.beacon_next,
+				   info->extack);
+	if (err)
+		goto out;
+
 	err = nla_parse_nested(tb, NL80211_ATTR_MAX,
 			       info->attrs[NL80211_ATTR_COLOR_CHANGE_ELEMS],
 			       nl80211_policy, info->extack);
-- 
2.53.0



