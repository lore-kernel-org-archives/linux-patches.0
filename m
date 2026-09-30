Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0996A3B3BE1;
	Wed, 30 Sep 2026 18:12:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791932; cv=none; b=KPvYrt1Nix+jv1m8VDIZHZwEoA/d/2l1S3j8gYQQcE75Q5BQCfYT+iaU51XaN3CbWfF5Fs9IRXjjpH3Y0Pp+PbpOFOBADuOVcGpsFvTKsbWLtuIWuFj66xXjXRpO+1sEdyn6SDOA53YC/heKi92+HfMbmL5WUywvP/qed/2oAjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791932; c=relaxed/simple;
	bh=uG87h6TUY5RcyjsgG3EUfh4a3xKkjm/EHNumsjgUXdg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yo6suWWeeegXTihpCo3FWl6z0zHdSESijwntdAJFkjug/idHSUyBPN8F0xq0MWcjAU240iNSXbVF/OXENRaAHiyNFFGBdl1zyGijCIwu+5Y1R7H6h/rW73i4zERFltkiowtrV9QGiz/bwXk+jT/zrHcTx+33ZE1rBtnnlX4BTkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hXWK2yG2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hXWK2yG2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 648911F000FF;
	Wed, 30 Sep 2026 18:12:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791930;
	bh=fVF+i+KAxwKeYeja4YLtKDwXMqcwNlq/JPKs1oK583o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hXWK2yG2YQY/YCe7rTdjUBTBJsjFZ/mWiCQbC685bM5JeMNQsvJR+AQiTrTtXt/P4
	 jF4XSpLgLV9vRNEZviuwBpPW82HTQhMWB1SrfW85AhSN6VySIZXMOQCOLaCCwZiTkB
	 habOkOiJhi4C7ia2sdazmpcaGDAigsoz6V6bNQOs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+b59873f5699e941717ca@syzkaller.appspotmail.com,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 477/752] wifi: mac80211: dont RCU-dereference the mesh CSA settings we just set
Date: Wed, 30 Sep 2026 17:25:47 +0200
Message-ID: <20260930152408.594193604@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 167b0625b1a17..b6f2bb6c49663 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -1419,7 +1419,6 @@ int ieee80211_mesh_csa_beacon(struct ieee80211_sub_if_data *sdata,
 
 	ret = ieee80211_mesh_rebuild_beacon(sdata);
 	if (ret) {
-		tmp_csa_settings = rcu_dereference(ifmsh->csa);
 		RCU_INIT_POINTER(ifmsh->csa, NULL);
 		kfree_rcu(tmp_csa_settings, rcu_head);
 		return ret;
-- 
2.53.0



