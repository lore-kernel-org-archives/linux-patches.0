Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DE59530E0F;
	Wed, 23 Sep 2026 14:38:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174319; cv=none; b=IoinAExORIc/WPs9auefah0r2fOBsWoxaeqPdngYG4pxzrt2vc0/teA1KdVYWv2Za30HBKSFVnl+lXORq8EaOovCPxn4scpgwX9M0gx8P0+fijirHXbWUJWuKVar6klYtKcOHxxyiA9pzxH7dnCYjJOwOroZLZyQB79vJFRHEzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174319; c=relaxed/simple;
	bh=Qf4SSHYKWzvF0ZaHt+KOzzvG31uz38uXaYQf9rbxhLw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CyHwn2b/SX+t9j83slLLygurnPpV+sX6BOyAujWB0BRov0dljKo6/f99/aW6locArg9yzri5h5MndKc+kLYOfoNGLXgx4R5vTgkHr8Hd0ne6d5PG2rXSbFLrF25Lqmi88E2xzrgG6ZJVZd6AP0InSG1mmvZb5pLnJwe6CML1CyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hTc10sG5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hTc10sG5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B83B91F000FF;
	Wed, 23 Sep 2026 14:38:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174318;
	bh=h1f4IJEeW1R8XdDgFJ8/dpSo9n/4xxC2p0y67FwqTu0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hTc10sG5JGf+L0gDy/I5eX4cIk36RPRotBRx7dN5Bi4dDJq8TVx/8x7//0xoTt3/W
	 ucZ60IRdopEMfiWdyBMGEORLtq+qU1+sCJynyWUzHpPUnzqUOXw9e5AdMfBvOv6llW
	 JbWEtWcHB7odPL+uzLR5hGUs43G2Dn/zNNMpKVBM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+b59873f5699e941717ca@syzkaller.appspotmail.com,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 077/398] wifi: mac80211: dont RCU-dereference the mesh CSA settings we just set
Date: Wed, 23 Sep 2026 16:02:31 +0200
Message-ID: <20260923140645.427386813@linuxfoundation.org>
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

[ Upstream commit b481e64e4498e2c053d5954f546ee02338f6ab63 ]

In the error path of ieee80211_mesh_csa_beacon() the settings that were
just assigned are read back with rcu_dereference(), which lockdep then
complains about.

There's no need to read the pointer at all, tmp_csa_settings still is
the right value anyway.

Assisted-by: LLM
Fixes: b8456a14e9d2 ("{nl,cfg,mac}80211: implement mesh channel switch userspace API")
Reported-by: syzbot+b59873f5699e941717ca@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=b59873f5699e941717ca
Link: https://patch.msgid.link/20260908122838.201719-17-johannes@sipsolutions.net
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/mesh.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 04b3ac4525035..a6c90cbb0baad 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -1575,7 +1575,6 @@ int ieee80211_mesh_csa_beacon(struct ieee80211_sub_if_data *sdata,
 
 	ret = ieee80211_mesh_rebuild_beacon(sdata);
 	if (ret) {
-		tmp_csa_settings = rcu_dereference(ifmsh->csa);
 		RCU_INIT_POINTER(ifmsh->csa, NULL);
 		kfree_rcu(tmp_csa_settings, rcu_head);
 		return ret;
-- 
2.53.0



