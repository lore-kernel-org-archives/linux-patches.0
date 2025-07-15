Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56C282E3380;
	Tue, 15 Jul 2025 13:20:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752585617; cv=none; b=kz2uJ/XVAiR4pQvXM3XQ0FgdMKUpqyK5zVz06ySl5UaPIwGIragR/TL+7/SUI6+yf6q/uxZ70CUb94p20oZ7zAA+SxOY9M2u5gAtbKjq+hkZe30LTC37ht2sOyXAlEStPVYsl4ypAzriJYmTVG85Vit55KStvJ0vCUb8Dx3IDEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752585617; c=relaxed/simple;
	bh=D4BrgpG5f8UpymrGZFGCW1ywEvTWSncUN4Zft5ONr8Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gt3oBFUT5pOT6ih78muDO8OpoyMcZK9jb/n0htjzR/fwsgN4lxGocyPxs6h0e45zOtXU71mk19XjMpCeR5msXK4naKgIPp7NqPv+5FHVSbgBDJm98K2xl2hqTFtbgHns/LPyf2nEXFo5rfod0nI0xLYbzWu71WIrYqSVmOLpdd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nXH1cS3J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nXH1cS3J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEC12C4CEE3;
	Tue, 15 Jul 2025 13:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752585617;
	bh=D4BrgpG5f8UpymrGZFGCW1ywEvTWSncUN4Zft5ONr8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nXH1cS3JXY6fOb/1wh7B770WZcCcy+IN61pTUdbDPCjymQpSJcr2fxB9dL7wm+dCz
	 oYrmXVGyTPyft7kOhf9UB6CccnWaGnHHEgp6hHxUudz5jz7aPduh5ke0arJfaWtd60
	 wfoAbqcN/iakBX8kc+ZF7fUh4vGj20DitWREujkQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lachlan Hodges <lachlan.hodges@morsemicro.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 107/163] wifi: cfg80211: fix S1G beacon head validation in nl80211
Date: Tue, 15 Jul 2025 15:12:55 +0200
Message-ID: <20250715130813.151723030@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130808.777350091@linuxfoundation.org>
References: <20250715130808.777350091@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Lachlan Hodges <lachlan.hodges@morsemicro.com>

[ Upstream commit 1fe44a86ff0ff483aa1f1332f2b08f431fa51ce8 ]

S1G beacons contain fixed length optional fields that precede the
variable length elements, ensure we take this into account when
validating the beacon. This particular case was missed in
1e1f706fc2ce ("wifi: cfg80211/mac80211: correctly parse S1G
beacon optional elements").

Fixes: 1d47f1198d58 ("nl80211: correctly validate S1G beacon head")
Signed-off-by: Lachlan Hodges <lachlan.hodges@morsemicro.com>
Link: https://patch.msgid.link/20250626115118.68660-1-lachlan.hodges@morsemicro.com
[shorten/reword subject]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/nl80211.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index c778ffa1c8efd..4eb44821c70d3 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -229,6 +229,7 @@ static int validate_beacon_head(const struct nlattr *attr,
 	unsigned int len = nla_len(attr);
 	const struct element *elem;
 	const struct ieee80211_mgmt *mgmt = (void *)data;
+	const struct ieee80211_ext *ext;
 	unsigned int fixedlen, hdrlen;
 	bool s1g_bcn;
 
@@ -237,8 +238,10 @@ static int validate_beacon_head(const struct nlattr *attr,
 
 	s1g_bcn = ieee80211_is_s1g_beacon(mgmt->frame_control);
 	if (s1g_bcn) {
-		fixedlen = offsetof(struct ieee80211_ext,
-				    u.s1g_beacon.variable);
+		ext = (struct ieee80211_ext *)mgmt;
+		fixedlen =
+			offsetof(struct ieee80211_ext, u.s1g_beacon.variable) +
+			ieee80211_s1g_optional_len(ext->frame_control);
 		hdrlen = offsetof(struct ieee80211_ext, u.s1g_beacon);
 	} else {
 		fixedlen = offsetof(struct ieee80211_mgmt,
-- 
2.39.5



