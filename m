Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1C0038D3E2;
	Wed, 30 Sep 2026 16:30:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785806; cv=none; b=XUKb6JcFBf/BbecSRmhnSP/9qSnVQ9O2YSupIOo+ynW3qpcDYmfy9wYfiKnq7ndjqA67/dpSWP61KbGEieL9MT4ni+vdQE4qVsYWNkHwogJpQa9FIknD+WzIjHFlRmcp+CmhmLVfo3Abix0E8h02hbWfmPHGCdSAHfU4kp/U5WA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785806; c=relaxed/simple;
	bh=V1OgYKfQO1ammuRD7VqGH6+wrArTihmbAokk6Q8Ctkg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FuO3J21W4wqW5zfWAA+SpbzqwJkEecnTpproKUySqysQ/ulcPUhhF/VtLodQBPe4APtFcZ4RrkZZ2YPdXFPujsIG6XuJd804IiW+jsb5SRFrko37sff1vSSzD6zO+QQa2BNYcJjqr+cbRMMyXO/cKKQSoCkE61mzUEHQ4/z2FKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r+r5Crc4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r+r5Crc4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B5D81F000FF;
	Wed, 30 Sep 2026 16:30:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785804;
	bh=3uoa6CKRSdEvEWLJkm3FzBeRnZfgGeGzQ1CVN3NqPQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r+r5Crc4YvT4BS7z60cBaSPpPww7HwyI1OoVd6RPW/KY3Pq6RqLI8aK0dzXGqFozr
	 Nwqno3mIpS1CgT+UXVPzJNiNyBj6TpDyCb8OMh7fOuxUCRB4Oy0Vo8fevVNJpU2Hxm
	 Vu/jOqgT9JS8QHIvHdx33CtsFMmrj+YK4Y+PnNgI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+b59873f5699e941717ca@syzkaller.appspotmail.com,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 636/982] wifi: mac80211: dont RCU-dereference the mesh CSA settings we just set
Date: Wed, 30 Sep 2026 17:22:52 +0200
Message-ID: <20260930152430.430499643@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 1b928cd4545aa..79569c6fbbd05 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -1417,7 +1417,6 @@ int ieee80211_mesh_csa_beacon(struct ieee80211_sub_if_data *sdata,
 
 	ret = ieee80211_mesh_rebuild_beacon(sdata);
 	if (ret) {
-		tmp_csa_settings = rcu_dereference(ifmsh->csa);
 		RCU_INIT_POINTER(ifmsh->csa, NULL);
 		kfree_rcu(tmp_csa_settings, rcu_head);
 		return ret;
-- 
2.53.0



