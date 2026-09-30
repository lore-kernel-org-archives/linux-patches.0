Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7CFC4FB9AF;
	Wed, 30 Sep 2026 17:11:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788290; cv=none; b=gFA3iYZySlLRUB9D4TT0QCMFzExf8H6tF19CgRQkLk+N2P7RLP2tWbYDsHo0cmUfGiaMLuC9XGjwLfGPUIBQt4SU+JqpcYjBCoNYa3pZa9tOLZWNX1ufT/ERpKabXu8zH/OhtYn8MTFYI8fXnJI7wu9stfIu+2g82n1lOAbp2zs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788290; c=relaxed/simple;
	bh=9DLskXB0Glx0oSg96qnaoa0oTZfP6HUk7fouUa0RZSg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pE4yroDKua7P0V5HIRgnzFy1QD5WPnxPsLn/U9hY5RT5m7gCSblAoOgfXzWSrIwYnK3qedR2LOB7+uqJShZmcvQiz/7PFiFJDJr2m5QETP/y19HTIiNXqzGmKmtQ1T6cFSTEla/9EilcknAMtzUh2b727x+i/PuRPe2eupqpn5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vle4FKZ+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vle4FKZ+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C3BD1F000FF;
	Wed, 30 Sep 2026 17:11:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788288;
	bh=G/fHEAjYO2czHiQPzGBce33Cr5yi5v/CS1oI7vweUpE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vle4FKZ+lsXFPFqojOzfcaqU00DWlmxBWftDoRQLwo72JTwrihucUwHMaK+PA17ww
	 ykkbLq3QuV4Z+BiiyaTx//TpcMaTGNcv671KU2cM3FkeO40aWpqrRV/YEpUXtjTnI+
	 pfwFlnNyTf5dnNO8J6k8WBw6/1FacLWUDR5ctRxo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+b59873f5699e941717ca@syzkaller.appspotmail.com,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 073/877] wifi: mac80211: dont RCU-dereference the mesh CSA settings we just set
Date: Wed, 30 Sep 2026 17:16:24 +0200
Message-ID: <20260930152416.315386331@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 57cf3f90f7fbe..4c601b9cb3bb2 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -1577,7 +1577,6 @@ int ieee80211_mesh_csa_beacon(struct ieee80211_sub_if_data *sdata,
 
 	ret = ieee80211_mesh_rebuild_beacon(sdata);
 	if (ret) {
-		tmp_csa_settings = rcu_dereference(ifmsh->csa);
 		RCU_INIT_POINTER(ifmsh->csa, NULL);
 		kfree_rcu(tmp_csa_settings, rcu_head);
 		return ret;
-- 
2.53.0



