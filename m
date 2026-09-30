Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5814650C2A4;
	Wed, 30 Sep 2026 17:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788219; cv=none; b=AxA8+nSmrzzthZGKKmq3qop1sQ5DE6JVTf04twVl1fBvxccczFhbyrJjh8X3wlRPIFEziiL0VpzhFBrwr8JKla0l6Thps0yPKMlk08/5yQNT01G8mhbzv5wlIXnlr/pMJ4j8aD1eqR3VRfIpeRPTJWKyW/TpehWe8zEMzDlFal4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788219; c=relaxed/simple;
	bh=VA8KBfm36KiEwwBSqoBEFzsUbQ0daaGpt1oiSWELJqk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nj4wU3oNYLGWwg/2nOjhcOeLuld8KKVQvwTmYDJTKsIFCYXo8v2WXDq8KSKFqX33irUpYwr0mzLjpyNKnGJK+vuwV3/70pTFfMshVMPgEUaF/u3UCnZlDYQeZ+sEhoWWTkEQ56Uwd496r1UIaRrVKUuAbGBr3jgBN2lkXQcnJbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=125rCbhj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="125rCbhj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B4C31F000FF;
	Wed, 30 Sep 2026 17:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788218;
	bh=rbRHlPbtTHb+uZVFb4otW/uKLBe/L/CQHxvqUQanckA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=125rCbhjIhm6uurHyqoy0+5nxPE/nBay/MbEkFaNooFdXGm0QwlxIuvsi18khsytb
	 V3VpIjGjfIxC1CLFeunj2RD4PFksWuAxr7C6MPe5fv1g4amHj4GqhiOzy/wqLt1T6f
	 0aIdz5NbVmPbFxRhK/s1/gQfl9P/nYH5IOrU6p8I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+abff43d2d045e37c0bb2@syzkaller.appspotmail.com,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 046/877] wifi: cfg80211: dont get the radio mask for netdev-less wdevs
Date: Wed, 30 Sep 2026 17:15:57 +0200
Message-ID: <20260930152415.742879048@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

[ Upstream commit a7783e585360ee05dfe21d3173dbbe985c94f29e ]

cfg80211_calculate_bi_data() calls rdev_get_radio_mask() with
wdev->netdev, which can be NULL and then crashes in mac80211.

To avoid that, invert the order of checks since wdev->netdev
is always valid for beaconing interfaces.

Assisted-by: LLM
Fixes: abb4cfe3661a ("wifi: cfg80211: extend interface combination check for multi-radio")
Reported-by: syzbot+abff43d2d045e37c0bb2@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=abff43d2d045e37c0bb2
Link: https://patch.msgid.link/20260904165614.2056a8b7dc91.I7412c5062d8166ad6c81ee7252cec49dea19a60f@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/util.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/net/wireless/util.c b/net/wireless/util.c
index 8478f3a0e9402..f565fb5ddd44a 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -2355,16 +2355,15 @@ static void cfg80211_calculate_bi_data(struct wiphy *wiphy, u32 new_beacon_int,
 		if (wdev->valid_links)
 			continue;
 
+		wdev_bi = cfg80211_wdev_bi(wdev);
+		if (!wdev_bi)
+			continue;
+
 		/* skip wdevs not active on the given wiphy radio */
 		if (radio_idx >= 0 &&
 		    !(rdev_get_radio_mask(rdev, wdev->netdev) & BIT(radio_idx)))
 			continue;
 
-		wdev_bi = cfg80211_wdev_bi(wdev);
-
-		if (!wdev_bi)
-			continue;
-
 		if (!*beacon_int_gcd) {
 			*beacon_int_gcd = wdev_bi;
 			continue;
-- 
2.53.0



