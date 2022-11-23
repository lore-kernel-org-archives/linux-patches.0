Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 956821C29
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:11:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3BBAC433C1;
	Wed, 23 Nov 2022 09:11:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669194687;
	bh=wd6Z4WHki5miCJglcnayt98Kb1pdCOpse2uI4eD2pes=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DLN/6/sczxeRpg4YOM0UP4xzDRh3jRnzDj3iOJpuAQbRC5bMMreLmKucI4kyip/xH
	 PNs3rF8qeKGmfdub1c566SAKP6YVoj9GtWZqhUKmpqXN9WP/woj1FHvB7CPnHtaXRQ
	 Iufq4wlio8bnyuPpCKSyxFU/CtxFMTVVSSRSt6EY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 008/156] wifi: cfg80211: silence a sparse RCU warning
Date: Wed, 23 Nov 2022 09:49:25 +0100
Message-Id: <20221123084558.169109946@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084557.816085212@linuxfoundation.org>
References: <20221123084557.816085212@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 03c0ad4b06c3566de624b4f4b78ac1a5d1e4c8e7 ]

All we're going to do with this pointer is assign it to
another __rcu pointer, but sparse can't see that, so
use rcu_access_pointer() to silence the warning here.

Fixes: c90b93b5b782 ("wifi: cfg80211: update hidden BSSes to avoid WARN_ON")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/scan.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index c433235e6390..630c64520516 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -1166,7 +1166,9 @@ cfg80211_update_known_bss(struct cfg80211_registered_device *rdev,
 		if (old == rcu_access_pointer(known->pub.ies))
 			rcu_assign_pointer(known->pub.ies, new->pub.beacon_ies);
 
-		cfg80211_update_hidden_bsses(known, new->pub.beacon_ies, old);
+		cfg80211_update_hidden_bsses(known,
+					     rcu_access_pointer(new->pub.beacon_ies),
+					     old);
 
 		if (old)
 			kfree_rcu((struct cfg80211_bss_ies *)old, rcu_head);
-- 
2.35.1



