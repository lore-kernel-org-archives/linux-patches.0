Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE91C2EA172;
	Wed, 28 Jan 2026 15:52:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615571; cv=none; b=CrC7kZAUMit2won5AFvK4gFiiW2t29R0Gfk2hVgL8sHVh7HB0wADD43VFLDBrGP0yxQOxfivFBd4NSxhiZCt3gkBsNYiF+Cbnojo4FcnLy18VsAxofKvGPo04SPWTqX9tYPrDwJj+h/u42QXtGwA1jvKJpto6EWkMwG1/WPrDiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615571; c=relaxed/simple;
	bh=q5ClAZscUaSSsPvG3vmKuWJXgGrsE2rzXgRD/anrOAU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GVJN6v9UxjHIfXiN8AiqDeKjYdjrR+JEJDUdyvUVoFO520WhY4FwRRfUiM8XfjE4cWFR5W3srU3giQM3uBFL17pb1LTJv9Yhxh+aK4518kUendo3yFJoW8JpRMv3cs4HJ42h9TqqEsFbKbpVH15QPGLrvpQvp6H0LLOxaWV9tH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KSXm3QAF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KSXm3QAF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 110CCC4CEF1;
	Wed, 28 Jan 2026 15:52:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615571;
	bh=q5ClAZscUaSSsPvG3vmKuWJXgGrsE2rzXgRD/anrOAU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KSXm3QAF8MFjfydmL1Yr3+QHc5H0KlUkmUF0mpJ/zUq2yPjEsQ8egyHD//IH5djuQ
	 PvAkvC252ngrGX8liLL14vlyYeRpkk7NGYOQsTBiihVxUP9e1WufYgjzS7z1BwdT6V
	 mC7kVk5Cdejxpq94xtuQOvG+V15dZ66or0zfw0bk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lachlan Hodges <lachlan.hodges@morsemicro.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 048/227] wifi: mac80211: dont perform DA check on S1G beacon
Date: Wed, 28 Jan 2026 16:21:33 +0100
Message-ID: <20260128145346.073034883@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
References: <20260128145344.331957407@linuxfoundation.org>
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

From: Lachlan Hodges <lachlan.hodges@morsemicro.com>

[ Upstream commit 5dc6975566f5d142ec53eb7e97af688c45dd314d ]

S1G beacons don't contain the DA field as per IEEE80211-2024 9.3.4.3,
so the DA broadcast check reads the SA address of the S1G beacon which
will subsequently lead to the beacon being dropped. As a result, passive
scanning is not possible. Fix this by only performing the check on
non-S1G beacons to allow S1G long beacons to be processed during a
passive scan.

Fixes: ddf82e752f8a ("wifi: mac80211: Allow beacons to update BSS table regardless of scan")
Signed-off-by: Lachlan Hodges <lachlan.hodges@morsemicro.com>
Link: https://patch.msgid.link/20260120031122.309942-1-lachlan.hodges@morsemicro.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/scan.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index bb9563f50e7b4..1e06a465b49e3 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -343,8 +343,13 @@ void ieee80211_scan_rx(struct ieee80211_local *local, struct sk_buff *skb)
 						 mgmt->da))
 			return;
 	} else {
-		/* Beacons are expected only with broadcast address */
-		if (!is_broadcast_ether_addr(mgmt->da))
+		/*
+		 * Non-S1G beacons are expected only with broadcast address.
+		 * S1G beacons only carry the SA so no DA check is required
+		 * nor possible.
+		 */
+		if (!ieee80211_is_s1g_beacon(mgmt->frame_control) &&
+		    !is_broadcast_ether_addr(mgmt->da))
 			return;
 	}
 
-- 
2.51.0



