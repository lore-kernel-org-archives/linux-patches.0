Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E8D738CFEA
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:08:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302123; cv=none; b=NEdjakuYyefkUBFZu3DAfuonDIbmd4WDDx5R+An0vyWMaMgkioHPbff5vaGWEXnbj8m5UZ8xTH0NQ4nO5z0y9ppfPogqWBf/lNY7+jxTPPrG591KqFHTczQe2VD7W4grL6saq1by+mCYWtHsWSDfoQI0aHP/LfsxQW0bysrXqy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302123; c=relaxed/simple;
	bh=Z8gm7U0sXwEgCEGyREEIjiRDWP8+g2gzfMBVGcqs4X0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nTaQju9m6QBkxlEtHcilYcPOyXkTEpbYkPYlKnZZ0LRp8pksorK+DDVptrmreGbS+oRGHRryoWGprHwiIGsXdBR7fAOL0rVUTqU+s1dubbiJWYXON2TncDgz3aIo47IXdKE4y0JJDRlojUPP3v+sMeij6F83q3efs8v4AQOJo60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Pz5l87Yg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Pz5l87Yg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B30CBC19424;
	Sat, 28 Feb 2026 18:08:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302123;
	bh=Z8gm7U0sXwEgCEGyREEIjiRDWP8+g2gzfMBVGcqs4X0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pz5l87YgQ4QPyNF6fifm2dMmMf+qVU1KuGFWQSVntzMpQ8v/5J0guOLyTG+Yd3K5F
	 5kzqh3w+Ayo82wWPvMF7O4iZGPWjeqsFDrxcxf8NLzO4sqa8dzKDi184UKzDqgA2if
	 aczvJsgW1JSLObGuXUMhAiKsYHJbmfcnBj9uEqvMNdf6GXrDyeg9+VulylvHIEcguo
	 wEkBZp0LFLWN5+OQJjCAxYGZMnaxzspp/SKEPzuVOr185uE4DifhOmydIh+qEAYDSU
	 MjlGVPX3A4v+7bwnnHl6CyUhB7kYg3t1U1fVyf9dhmAxA6Ot/KzGvT3lXjuZEmZPPn
	 o0HyZH4t3NJmQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 114/283] wifi: cfg80211: stop NAN and P2P in cfg80211_leave
Date: Sat, 28 Feb 2026 13:04:16 -0500
Message-ID: <20260228180709.1583486-114-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Miri Korenblit <miriam.rachel.korenblit@intel.com>

[ Upstream commit e1696c8bd0056bc1a5f7766f58ac333adc203e8a ]

Seems that there is an assumption that this function should be called
only for netdev interfaces, but it can also be called in suspend, or
from nl80211_netlink_notify (indirectly).
Note that the documentation of NL80211_ATTR_SOCKET_OWNER explicitly
says that NAN interfaces would be destroyed as well in the
nl80211_netlink_notify case.

Fix this by also stopping P2P and NAN.

Fixes: cb3b7d87652a ("cfg80211: add start / stop NAN commands")
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20260107140430.dab142cbef0b.I290cc47836d56dd7e35012ce06bec36c6da688cd@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index f6693983b5e98..0baa4c6ab1694 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -1331,8 +1331,10 @@ void __cfg80211_leave(struct cfg80211_registered_device *rdev,
 		__cfg80211_leave_ocb(rdev, dev);
 		break;
 	case NL80211_IFTYPE_P2P_DEVICE:
+		cfg80211_stop_p2p_device(rdev, wdev);
+		break;
 	case NL80211_IFTYPE_NAN:
-		/* cannot happen, has no netdev */
+		cfg80211_stop_nan(rdev, wdev);
 		break;
 	case NL80211_IFTYPE_AP_VLAN:
 	case NL80211_IFTYPE_MONITOR:
-- 
2.51.0

