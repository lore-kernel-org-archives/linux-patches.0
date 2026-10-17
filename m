Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 599773CDBAA;
	Sat, 17 Oct 2026 18:02:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260132; cv=none; b=eKLAfvxFzHKb8sxGcNwnXHWT0qjw2+mp7sMT5wQCAAnfFJFQoZeCbkjlxccX+0Ank1uGSfJz7Za81OvQxcuFAH1V0D2C/YAQWndmWkUvWOWVTZJBDdv2QSuu/GKSCgf3muNFHZ5E88PQXMVUEEpVkiQnQ8wXBPjcGU6lnEZV6/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260132; c=relaxed/simple;
	bh=MlTrsuF2cfkZ+Wk6q/4OYDpnS1STJD9xhpPZ7xupElE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E4ec/5ftLyEoYX88N+PRQHALjVGcOSEOljkSHFHSZG8GknrOKtZ34p5kIDj3+QwceZzTgD94vHCIh2kuHBJdWJulxx6zHMEJY9DjH5xs6UPSAol0xQ1OX8O7DSyoN0J+Oj2j/2fdDxfe0fNZ6J136fgL97KXRO/i06SWrrQiMAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IOg8YnKF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IOg8YnKF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B15971F000C4;
	Sat, 17 Oct 2026 18:02:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260131;
	bh=s5ftT/EOhKAnrjym0mOV113MLXp9pOSIoq3RS0Jb/zs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IOg8YnKFKSZp8xZZ5uwXxZnSRIgEjCZl+lJ9wjavGblJRBhhwliX0XUBtWYoi5Gey
	 2x79P+y5FfQBzsEHb1WLdVMb5GsCYesMry8qlsRUk7eIJIrPMSu8RR1XBSvj5HNvS0
	 V2mSl+PFan4DiQ5dZDIxmSMH8HIH7hGzyo5Ag7do=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1443/1674] wifi: nl80211: clean up color-change beacon data on errors
Date: Sat, 17 Oct 2026 18:01:55 +0200
Message-ID: <20261017160508.221013602@linuxfoundation.org>
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
index ac1cba2ce48a0..3eccc83fa79b7 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -16116,15 +16116,15 @@ static int nl80211_color_change(struct sk_buff *skb, struct genl_info *info)
 	if (!wdev->links[link_id].ap.beacon_interval)
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



