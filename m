Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B76D73AD517;
	Wed, 23 Sep 2026 14:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174350; cv=none; b=TQWDTJaDMCjXuhxBHqhwzEzmdCIIQV5dHIYTgVUAyl/5190DHX6+5pS5aO333Bm5kK5fPU1UzuO/3LOyUEH3n+eejaVyjZzT633CtGU7spKk8JgfbXuqEhP8K8KcW4vA4kaOOyop+Mv64CLWA8vpPFjIQQjkynemFCuzr1whras=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174350; c=relaxed/simple;
	bh=rrgNm+0g9V/O/4vEc2p8JL/dx3f/2NcN9xfBnAWe9N0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m50DRHRG/wOf3Mr2qH+UnsD/blCoGTTBj4/5KJHdDIZFvOSdKHDMGrAN6p0hOMACiEMyW3iRal8XjXNkfGpvwbj22c7btVDz25D53DUMyzHQd0WNltBceSIXUTqtBvsCGAYsNUgJtOyzilvW7B1yzLLPRbROZ7Ab3087jG14+ZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pbaGPhhz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pbaGPhhz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38A1D1F000FF;
	Wed, 23 Sep 2026 14:39:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174348;
	bh=QKMZNRsw8FauIWpgr5gH70n6JKKoX4sAOmeADzp9JeU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pbaGPhhzYwDKpMWgpv93+lQ0oQWWSdH1jjZMbxIA4QiDKWGsGVLi4xLV1X8LbN6l1
	 LqALRFCNHcxMEgSIYymXlarF4DSJc1FWNrAGU/o7tlJ7dYXcm7vgD07JbIAwJqRcf3
	 uxeDB6QLnh+AAQVG0Gbo0qKPUzuMD9ueJCnTA6po=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 068/398] wifi: cfg80211: restore netns_immutable on failures
Date: Wed, 23 Sep 2026 16:02:22 +0200
Message-ID: <20260923140645.194718749@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit eeee52cfd1d639774c9812e8890631404a057dd2 ]

Switching a wiphy's netns has to clear netns_immutable before moving
interfaces, but then if any of the interfaces fails to move, it gets
netns_immutable cleared forever. Then userspace can move it by itself,
breaking the assumption that they all move together.

Fix the order here and always reset netns_immutable after attempting
the move.

Assisted-by: LLM
Fixes: 463d018323851 ("cfg80211: make aware of net namespaces")
Link: https://patch.msgid.link/20260904170220.7ea88157dcbc.Id868585a790be8b9ece9b39b0db464a5963faaf3@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index 55abf5a203338..3c11f35f957db 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -164,9 +164,9 @@ int cfg80211_switch_netns(struct cfg80211_registered_device *rdev,
 			continue;
 		wdev->netdev->netns_immutable = false;
 		err = dev_change_net_namespace(wdev->netdev, net, "wlan%d");
+		wdev->netdev->netns_immutable = true;
 		if (err)
 			break;
-		wdev->netdev->netns_immutable = true;
 	}
 
 	if (err) {
-- 
2.53.0



