Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40EE72E8E04;
	Tue, 15 Jul 2025 13:44:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587079; cv=none; b=slaMnKyyXYW5R9ThbZhcoyijFnUK/ZfxduWMINZYN9tsSgAmMjhCn79R6YCgFeGi2EpBYlEvWhxsAajRyXnIg4WzqJbFlW17CFwgzplcDJ3tonuaagHx1AEhIEXDOrC56G+kdRST2MG9han+PU0HwiBk4Dexmyqy87vMusLgV+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587079; c=relaxed/simple;
	bh=QWQT3QKdNeSBTE88Q3r5OCucxCl0MbeayFQEBOJOyBs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ltvQU2KHJYstore2tEdJnwbYNGeNgP/tq8ZF7EkrHDIPyuDAzIGlhaqt7zscJrDNR5/qB/W8vXS4AYFR5UdYZ7u7m1qW6mhlEVWY6EuwoOnX9nBk+kG+/d0znfJe99RBDSsA4LtZVMnOBCtmnxYmlXshK0mbPwUnPOZC60yN0/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1xS5uLP7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1xS5uLP7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80BA4C4CEE3;
	Tue, 15 Jul 2025 13:44:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587078;
	bh=QWQT3QKdNeSBTE88Q3r5OCucxCl0MbeayFQEBOJOyBs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1xS5uLP7SoNEcipiMenqkuMRabD6FOwMUj7bAZez3bVJFmoqkDyNmNu1yvsr6fiGb
	 TPSY0Uc7SEWu5iHhmy24MXj49m6anRk3c4qi/mX9ctOIqikC11bRAtoo7sUsRwF+pw
	 3A9+5/hsH1ZgrGlJl2uyxuD//caE0rvVUffHYnFw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lachlan Hodges <lachlan.hodges@morsemicro.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 127/192] wifi: cfg80211: fix S1G beacon head validation in nl80211
Date: Tue, 15 Jul 2025 15:13:42 +0200
Message-ID: <20250715130819.993024429@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130814.854109770@linuxfoundation.org>
References: <20250715130814.854109770@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index f039a7d0d6f73..0c7e8389bc49e 100644
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



