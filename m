Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BAA44D7D30;
	Tue, 13 Oct 2026 12:21:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894117; cv=none; b=V0qI5Z5zzFttu/EDrTPX4LF+b1+02wdmNISBn1/L+cIRhgqrkjBc0avYrM74dzNQPeACb4Oql+upUWXMHqcZdFYiROGJU+XdUcBfzi2DsGyn5KYt8r4bsQv1a/pyUSCNub6EzrCRYe7RrGKfc9sHbBMvu0ifU+mPPyuoq73jI5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894117; c=relaxed/simple;
	bh=0BnGQPIw4VmMgyqiMQx0DxYMQEtfTHetn6BfmYcPFoI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KYx6PMlbQBhxSrZBFKIm+3S0C+yvwK0ZtZDSD1METoQVSUZ8x5YqqrtWBAmj9PN0ZbqKCfcfkBNvybGQuAiMK3QWxGza0GQ5kyq42eyHxm07Tyd2vZ2EVk/3mqBjbNixJZ4WAMNj/8MwyApxBhIrwIn2itL9q5o2aKSOALffdOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yV1FzTOM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yV1FzTOM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DC001F0089A;
	Tue, 13 Oct 2026 12:21:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894115;
	bh=bdGWWVvoqQmuo6IaYAU142taQEqH+tYcUqCtm1LOR0o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yV1FzTOMEdKLwmMEIJaDMudYpGxDtg5kUV46Ng6E8mtzO62DRBLI4CszE7//6v3Ux
	 l8xlqgvXwH2twAvbM5MmH4fIFnSsYcJGznWQE5uFVBD3CHViD/HqsuG4YyQe2uyZfm
	 vfwsSS7lDoIJTtNa18YRUkXgLWSGXIdp8hxTAuf0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 453/621] wifi: nl80211: clean up color-change beacon data on errors
Date: Tue, 13 Oct 2026 13:37:28 +0200
Message-ID: <20261013112931.581376867@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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
index 5f84753f731b5..b851e398b1b36 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -17794,15 +17794,15 @@ static int nl80211_color_change(struct sk_buff *skb, struct genl_info *info)
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



