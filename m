Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A08C377567;
	Wed, 23 Sep 2026 14:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790172971; cv=none; b=f+EdrdbqxTV3/EQF+1LvzNRrg2a7IxlHgriwa7ge79lHcWkBpeclgRrS3RsDc+/jgCCkyQ9aE5NtmSifNPyKZD5zaGVAD0P56XrlNhuV1ZDi6rg7A0CRdZYyv6W8gWtOX82uGC6YdRpx6DvbBI+tQHKt5LStiYNPmiOVZSmAJIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790172971; c=relaxed/simple;
	bh=rJ2OW/B3S46LjA+ur5BGveqPTaPiiXHiHncu4tRJX38=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AqpY1yZiMjSJtbweEE73F9PSFGahjEfL0XVKD2gIOEXrbuavGQ/se8h0drlHpRWOfks1ukXgY6V7ER0WEQw2R1UetKL8mIOtYOWfg20px9qQ4efjq05vliDUqF7NPpR59YRYVDMS5tra0ObnAopTxNrk0e+yANz6KGQ/HfDfjU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=soDdy4tP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="soDdy4tP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 361521F000FF;
	Wed, 23 Sep 2026 14:16:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790172969;
	bh=8Q9Oj5SPNbyC98a9YKVOIJgamq7Z6m5l1BjmoBq1TDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=soDdy4tP0xRVv5eEn8flAvO946GjWcuVgWEFv6N3QA12TahpuPErONEBf9yi1fLxt
	 m/DVYZzp1VrRrF1CxllqUSfi79RS9O1gGLDvTLaNGULpM7/Z47rmKW2ukphW9kkOUm
	 lCgxokx5dYqWTs3Q0NPbdA0AtNnzDtVsN/7qVhi0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+b59873f5699e941717ca@syzkaller.appspotmail.com,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 086/438] wifi: mac80211: dont RCU-dereference the mesh CSA settings we just set
Date: Wed, 23 Sep 2026 16:01:47 +0200
Message-ID: <20260923140647.009811042@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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
index bed7ac8382505..a35e2d5870b6f 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -1559,7 +1559,6 @@ int ieee80211_mesh_csa_beacon(struct ieee80211_sub_if_data *sdata,
 
 	ret = ieee80211_mesh_rebuild_beacon(sdata);
 	if (ret) {
-		tmp_csa_settings = rcu_dereference(ifmsh->csa);
 		RCU_INIT_POINTER(ifmsh->csa, NULL);
 		kfree_rcu(tmp_csa_settings, rcu_head);
 		return ret;
-- 
2.53.0



