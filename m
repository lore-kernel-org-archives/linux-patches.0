Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF99D43F4A9;
	Thu, 30 Jul 2026 14:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421288; cv=none; b=EFriWW6GHnZlk0u18covuCBGWzyCV3yqaAnJPJntVE9/DVyYP094BiN8jYHGxZJtcKpRGaQZlbYQJwP3EujmfFCDv02d4oy4Okeal5SvtEc5nBqB0kQO0GfUY9BdT7aTQY5MUJ+yZFwiJjTICqVSEgXftCZiV8DADYrbSX3TEAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421288; c=relaxed/simple;
	bh=C6/2IUupmXO9Sb6TYt5gEl/SILr+wQfGifx1jbBIypw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ROD0MWQye8B6f3yegrImaYF9gIt3FTsJG+8vm6gTUjMVGwRq4R3RlQRxz4Ce8lNDsJmZXcNbKGGnih6ZH8QKTAJLzoi5RnLz6I3k2zYrIt+GHN9BW9iNYK+c8TyjpmhqDV4D7yfqCz4I4cjXGAhbcESGB0w7xrCRy1ovP6SjncY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N9cqnkUB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N9cqnkUB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 275E61F00A3E;
	Thu, 30 Jul 2026 14:21:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421284;
	bh=xciF2hH5k7Q6Zv/xU0yrqu7u+Vfnl/dHwzzJzgKjNP8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N9cqnkUBpvi8lVXeElRLcbY7it6F6asTMSn6JNAX8o0KtJiMt4S1e6rMa12E+JUSN
	 /XP6z+QB+wSE2J7j8YlgGKDqzvmq3/B1PP2DGGw5llYlJxygHa3xMroxeZBtwtrrMf
	 05c/tmUZFHV5zXgim8jjWoo4z2Lb8MVYvSwhqGv4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 052/744] wifi: cfg80211: Fix an error handling path in cfg80211_wext_siwscan()
Date: Thu, 30 Jul 2026 16:05:25 +0200
Message-ID: <20260730141445.385307642@linuxfoundation.org>
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

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit c6659f66d4ee4841aafae5659d2ef5e4c5c63cb6 ]

If the test against IEEE80211_MAX_SSID_LEN fails, then 'creq' leaks.
Use the existing error handling path to fix it.

Fixes: 2a5193119269 ("cfg80211/nl80211: scanning (and mac80211 update to use it)")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://patch.msgid.link/a1be7eea4da0da18f90589af252bb76a18a61978.1781984889.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/scan.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index d9f2a77e127ce8..654f3300912dab 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -3613,8 +3613,10 @@ int cfg80211_wext_siwscan(struct net_device *dev,
 	/* translate "Scan for SSID" request */
 	if (wreq) {
 		if (wrqu->data.flags & IW_SCAN_THIS_ESSID) {
-			if (wreq->essid_len > IEEE80211_MAX_SSID_LEN)
-				return -EINVAL;
+			if (wreq->essid_len > IEEE80211_MAX_SSID_LEN) {
+				err = -EINVAL;
+				goto out;
+			}
 			memcpy(creq->req.ssids[0].ssid, wreq->essid,
 			       wreq->essid_len);
 			creq->req.ssids[0].ssid_len = wreq->essid_len;
-- 
2.53.0



