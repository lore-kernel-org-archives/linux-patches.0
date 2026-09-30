Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A097F4F96CB;
	Wed, 30 Sep 2026 15:50:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783405; cv=none; b=RSiwYs+CII1dud1SGYp7V6tJPh3cu06kxPwIPusBgfQRSYs2UOePTXCYYl1e3OPPoLLfhCKkDrlLK1QdPD5NFs/9FUV4VFBMgwdBYwSIjUEs87ngCP/rOqBqV/1Uj9l31U+ckx6QlbAgQ3EAtrvsO2Uk1t8/HXUlFTKvUtLitA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783405; c=relaxed/simple;
	bh=U+QbxHDv66BAH6proEOlwUYueZo5XFLHgR9SyjbB09A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tWrU+3rPy8QJl+qsEHs7wwsQRlTBO5ZsCphqTzOUClEdin3nd8MUeVn/ePhRogWr74LmFQu7u/xGvpbMCNlkQ5XlgabG8iGWimn92/PJxQpJpGEuFVHHP+rycE16CKzaxnHZ8dpuh/Q25Uz3GJaRFndKXIOlZ1Id3RwgiLSaM7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vIHsO6YZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vIHsO6YZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19D931F00893;
	Wed, 30 Sep 2026 15:50:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783401;
	bh=t9WJtGpzaUb2zf6KSCEetUc6W5CvhcKQw+y7I1YvIa4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vIHsO6YZwqW2YtVTFOtZCN1n9ZO6DAknQB04UKBT1P5XGdefOy6MKBNk8MB6QH54N
	 IjUNI0koq2ntQB+6q9NbYCoh0Y4o/HdgpAWo5Wf6O86VzheNN6mhXBxcDMSX2BLXdl
	 hiHNGCA2Q/TJg1Ml1ab9+H0SkfywGC2MLpniUyl8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+b59873f5699e941717ca@syzkaller.appspotmail.com,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 385/595] wifi: mac80211: dont RCU-dereference the mesh CSA settings we just set
Date: Wed, 30 Sep 2026 17:24:38 +0200
Message-ID: <20260930152355.957012575@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 4b09cd19c4e04..6af86da48995f 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -1379,7 +1379,6 @@ int ieee80211_mesh_csa_beacon(struct ieee80211_sub_if_data *sdata,
 
 	ret = ieee80211_mesh_rebuild_beacon(sdata);
 	if (ret) {
-		tmp_csa_settings = rcu_dereference(ifmsh->csa);
 		RCU_INIT_POINTER(ifmsh->csa, NULL);
 		kfree_rcu(tmp_csa_settings, rcu_head);
 		return ret;
-- 
2.53.0



