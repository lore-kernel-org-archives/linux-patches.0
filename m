Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51B3919E7F7;
	Sat, 12 Sep 2026 08:20:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201246; cv=none; b=Smk7Fy+BwH5AkfCspQgoi5IjlnwpuAJ0dvD0646lfUItGnR9InVk+jjituAK8dIF280DGLHmb9PxSG1dRaglJheRTc3dBSaqLTQRagC3aXozhHsqobdDUqrwYD9JRLMVQlanLNU9JU+CYZW/+fpl/9ZUsdovoCXCbi1Yl36ZldQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201246; c=relaxed/simple;
	bh=lqYK2umx4j57G1Q55RP107vjABTtrefoLfMS79g0u+w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=COguhY0/XByjsVZBopGdmyxFPue0b64GNhb2v6z6TPjxfaC0aRFAeJxMMoZxo5qNnMZJ5aOFv6fS70MJKDKkTvh+yAH9GrvtMXseQfmIxzVmx1DnXgkigdeNnvtHy2BgSjpewMHMxexB8FXjAgGH2j+txNiIh2/thNTbwnryKpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IHRiK2t7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IHRiK2t7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AFEC1F000FF;
	Sat, 12 Sep 2026 08:20:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201245;
	bh=zaQ/EKMsOXTJ7K+b3pyw11IerAfQR0e/igUcPJ7OCaE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IHRiK2t7uh/V8oZpff9bR/C4KDhbALGiaufNRkyJexJvBTaq42dFfI3OmyKu4Ti2j
	 0TbPlXQJsMLuSjcYi25pXhpMREGz20haXPZZbrlFl3Cr9bTYm/96WgGuXP0EabNmeg
	 qV4f3Xpbz96Vevbe8gjgAiOPZRzOTdciRWw50IHM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jose Ignacio Tornos Martinez <jtornosm@redhat.com>,
	Alex Gavin <alex.gavin@candelatech.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0955/1815] wifi: mt76: mt7996: remove beacon_int_min_gcd from ADHOC interface combinations
Date: Sat, 12 Sep 2026 08:45:05 +0200
Message-ID: <20260912065711.389075275@linuxfoundation.org>
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

From: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>

[ Upstream commit 4df22710a77d2365e56d720bc4106e54c1dfa2ff ]

The driver fails to register with error -22 (EINVAL) due to a cfg80211
validation failure in wiphy_verify_iface_combinations().

Commit 5ef0e8e2653b ("wifi: mt76: mt7996: fix iface combination for
different chipsets") added beacon_int_min_gcd to if_comb_global and
if_comb_global_7992, but these combinations include ADHOC (IBSS)
interface type. This violates a cfg80211 rule from commit 56271da29c52
("cfg80211: disallow beacon_int_min_gcd with IBSS") that explicitly
forbids combining ADHOC with beacon_int_min_gcd.

The restriction exists because beacon_int_min_gcd requires static,
predictable beacon intervals to coordinate multiple beaconing interfaces,
but ADHOC interfaces have dynamic beacon intervals that change when
joining different networks, making the GCD constraint unenforceable.

Remove beacon_int_min_gcd from the interface combinations that include
ADHOC because they are not necessary for ADHOC operation. The if_comb
combination (AP/MESH/STA only, without ADHOC) correctly retains
beacon_int_min_gcd for multi-AP coordination.

Fixes: 5ef0e8e2653b ("wifi: mt76: mt7996: fix iface combination for different chipsets")
Signed-off-by: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
Tested-by: Alex Gavin <alex.gavin@candelatech.com>
Link: https://patch.msgid.link/20260702104337.679536-1-jtornosm@redhat.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/init.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/init.c b/drivers/net/wireless/mediatek/mt76/mt7996/init.c
index 3965127cae541..fa74aba426903 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/init.c
@@ -34,7 +34,6 @@ static const struct ieee80211_iface_combination if_comb_global = {
 			       BIT(NL80211_CHAN_WIDTH_40) |
 			       BIT(NL80211_CHAN_WIDTH_80) |
 			       BIT(NL80211_CHAN_WIDTH_160),
-	.beacon_int_min_gcd = 100,
 };
 
 static const struct ieee80211_iface_combination if_comb_global_7992 = {
@@ -47,7 +46,6 @@ static const struct ieee80211_iface_combination if_comb_global_7992 = {
 			       BIT(NL80211_CHAN_WIDTH_40) |
 			       BIT(NL80211_CHAN_WIDTH_80) |
 			       BIT(NL80211_CHAN_WIDTH_160),
-	.beacon_int_min_gcd = 100,
 };
 
 static const struct ieee80211_iface_limit if_limits[] = {
-- 
2.53.0



