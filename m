Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A454E485CC7;
	Wed, 23 Sep 2026 14:12:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790172760; cv=none; b=akgOXRuStK7X3peJ45thF+ukHr4pe+s9SHjCP0lR82IitbrPavhxOMwF3BPabJVNDJP5UI2Rqd8vLHDlS8OpwtnSnc6Rk2Bn4pyd8Na/bN8JWcoxAGzBMdgr1dgUQfRSS5zerR0P7ZqAQZHVM0Ps/TOUzyTv/seNXdiY9EbRPcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790172760; c=relaxed/simple;
	bh=BxptpCGwXys9S9M0DWgSZRPaHrEtN92+yH59kEEqPJM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TpnzjnBe9KX5ntVc0HM8BaJa22wniHyJWPcLjOoxZyMl7mCMPVlPuoslw2SaqM0T0DpfPzhLIy+bG0vb/z8GXiLd1KJ819ANidI04EUbO26bNvkaporbOSWU+MC8FpFFh+PoLK1C6d23aG/CKEZIdIZWCW3wBgJ0KSJBucDBS1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dv5EiCbE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dv5EiCbE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 097A41F000FF;
	Wed, 23 Sep 2026 14:12:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790172759;
	bh=MErxvURdT8mLsMKTzk3Z+infYVrYeeQfWttfkcLn8H4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Dv5EiCbEQ0Pro4HfyJgq3yH1VbMNF0vexBsfIEinw8Fourli8ys2Pw6nRh+57FYJs
	 v3GECPgtdR+2HVnguzJFcfEGWu06AAGkrL5cdA6S9t99PPz0MSRXhxTH6ZPOFMxsjT
	 wx2We4o2Av/8B3WnT7bWVrXKr8JYdObPtBvjN4t0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+abff43d2d045e37c0bb2@syzkaller.appspotmail.com,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 054/438] wifi: cfg80211: dont get the radio mask for netdev-less wdevs
Date: Wed, 23 Sep 2026 16:01:15 +0200
Message-ID: <20260923140646.183780653@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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
index 24527bf321b2a..7142b81963d27 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -2426,16 +2426,15 @@ static void cfg80211_calculate_bi_data(struct wiphy *wiphy, u32 new_beacon_int,
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



