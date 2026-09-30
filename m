Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FEFA3DC4D8;
	Wed, 30 Sep 2026 19:22:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796141; cv=none; b=Ts9xa68AoXIGS2DNrSBQslU7e3z399k8dIBFe7w6zhPeo9EGn/bD2dcNDxRwQyYUvEWXWuc4PgLSkjcqsmXOO4kv4I/ZPaJioQEShoGCjSFWqlOzJiK5M72Ft0axBb5CnE8sMl7VghtI+MzYfiZ2LEmbqtaBZ6hS48XBn2PwGSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796141; c=relaxed/simple;
	bh=707z2uFN246hXyYdZOd1RkFyiZWVM2nr9oF05cA4hkE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dhzRtpCQsn+GTZGXRaltTeowU2w7KSjybjOa0nK/1SDiCMjLMCGPRlYAiWXJU7YQwuIEoQSFJtkjSzw1wiXNjMhQ3PYa/yztP4gBdELuLiIiRtpLx4PqrmZG7QMj9cXcn5KEsBNGb42dzNvLNP/B2tNMW8Q0DVmInzdJOcwqYuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UjMnCKN4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UjMnCKN4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 531D11F000FF;
	Wed, 30 Sep 2026 19:22:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796139;
	bh=72ahFXaOu85ueFas4f9W7E4tRFm0BFpQ6zlhVSGcRZ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UjMnCKN4OzPx7xXuQKIZWk0amkEVVOmH4p+Nx4de5651PZTqQPIMy4jwfjXPOataz
	 lMsol2pfNabJ7LrE0v+zm7ZmK0z0LX0IFbtbnTGh8vzm+K3YyAJy5OArvrVmidPWec
	 ibuMZ3VLYF9zbQ3Y9qD9+ezuS7OQY2kDZsQaiAUU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+b59873f5699e941717ca@syzkaller.appspotmail.com,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0763/1193] wifi: mac80211: dont RCU-dereference the mesh CSA settings we just set
Date: Wed, 30 Sep 2026 17:24:07 +0200
Message-ID: <20260930152451.207871524@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 0899443e83cda..df941eef6106e 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -1582,7 +1582,6 @@ int ieee80211_mesh_csa_beacon(struct ieee80211_sub_if_data *sdata,
 
 	ret = ieee80211_mesh_rebuild_beacon(sdata);
 	if (ret) {
-		tmp_csa_settings = rcu_dereference(ifmsh->csa);
 		RCU_INIT_POINTER(ifmsh->csa, NULL);
 		kfree_rcu(tmp_csa_settings, rcu_head);
 		return ret;
-- 
2.53.0



