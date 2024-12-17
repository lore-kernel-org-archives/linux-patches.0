Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2FA41F76DA;
	Tue, 17 Dec 2024 17:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456621; cv=none; b=pV9c5E8r32y3m6Z1oFBli/W5hi2V0g1weMD8rtS/hz7+2LvjFV5aoiZE0uJ36Qokn8nrMlfcahRLw4fZ39reG1lFEUGZiCneViI3LMYx3dxwN5xHIExcL+vBokpzpM6lpV9hJaHjenfo2mDDoTxV916Y6nygLs0VQb2kQ7oxv0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456621; c=relaxed/simple;
	bh=6WJSTnsWsnn4ILtB7MIL3lR8xpH9FrxYQ4CzMxlitsc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fY6i4dLt7BPglYJL7j2skkulmAAWCnG8TAGgTanop8FoCSe8NAXYC/p/Mr3qw3FfffBOTq+tVREc+yF/LapBEftGp8hw3P4yzCaM/rPuJ07lBT0EMHU3pGU9k32ebJ28nOXY/YqNqtu8yTI9pEwUbF822U9PxW05KVGZhiI51LI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wzB8LjuA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wzB8LjuA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58F2DC4CED3;
	Tue, 17 Dec 2024 17:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456621;
	bh=6WJSTnsWsnn4ILtB7MIL3lR8xpH9FrxYQ4CzMxlitsc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wzB8LjuAmRVDiOrE/Jo2R+f3KLhSfe3blt6QQ263N8k1qNdV3ISDOrILaHlvyKrvv
	 z6qb/unGMVY5Mgp90XYq+G19M+CCFYL1xJyh4ZIYg2SM90mU2IrbWGW6WIIUOveS1P
	 Mrz1ukI4bLRLTullop6Vxb3XDwuJ5itq0B8+UPpY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Lin <benjamin-jw.lin@mediatek.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 086/172] wifi: mac80211: fix station NSS capability initialization order
Date: Tue, 17 Dec 2024 18:07:22 +0100
Message-ID: <20241217170549.854519813@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170546.209657098@linuxfoundation.org>
References: <20241217170546.209657098@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Benjamin Lin <benjamin-jw.lin@mediatek.com>

[ Upstream commit 819e0f1e58e0ba3800cd9eb96b2a39e44e49df97 ]

Station's spatial streaming capability should be initialized before
handling VHT OMN, because the handling requires the capability information.

Fixes: a8bca3e9371d ("wifi: mac80211: track capability/opmode NSS separately")
Signed-off-by: Benjamin Lin <benjamin-jw.lin@mediatek.com>
Link: https://patch.msgid.link/20241118080722.9603-1-benjamin-jw.lin@mediatek.com
[rewrite subject]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/cfg.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 16d47123a73c..1b1bf044378d 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1911,6 +1911,8 @@ static int sta_link_apply_parameters(struct ieee80211_local *local,
 						    params->eht_capa_len,
 						    link_sta);
 
+	ieee80211_sta_init_nss(link_sta);
+
 	if (params->opmode_notif_used) {
 		/* returned value is only needed for rc update, but the
 		 * rc isn't initialized here yet, so ignore it
@@ -1920,8 +1922,6 @@ static int sta_link_apply_parameters(struct ieee80211_local *local,
 					      sband->band);
 	}
 
-	ieee80211_sta_init_nss(link_sta);
-
 	return 0;
 }
 
-- 
2.39.5



