Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9D762BDC0E;
	Sat, 12 Sep 2026 11:14:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789211646; cv=none; b=ZgzrVJR/wTS8qkM9NeQcu6psD4Xw1X6qsi0z81uWDhYuDE6PUAbjJrrUTTPPngjiS6WsDkFFf+BvdydngpETqLmvQ7QQxu9nFvDXdlC8V5MMaFaIrw1WRfdBVyjuzBkqzvF7wQFsMyq/2z6EEfK8Wu1QQgSirsE7B99s6tR7HmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789211646; c=relaxed/simple;
	bh=1LNZMSgRU6+MpMgQemU6yVhfzt7nD+yg+SsAjpcIOKQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H9mWwLxrZieuZP0CWUedb4XoN7V+c8cNpvms9CIY2SB/KBpaobOehYaH7YFkakQKIKBIe1kt+l7L+l3KexGrCELVOUhPdf8Wk7CuitLswM2Y/m/LggbP/hXVQpTZLaxxx3E+3MKO68VYV0W6o1by83vUjE3k81bkS0HvyqdYVGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fCf7yxuu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fCf7yxuu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 534B21F000FF;
	Sat, 12 Sep 2026 11:14:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789211644;
	bh=yi2AEqlMYKCOgu5qgbMtIdRY7n1AfkwgXBW9vXRtwTk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fCf7yxuu9o75rlOBeHgjesaVI95T1onma+fEYesvZqXcA41m8jeQzbePzeJ4wt9d6
	 wIFuKV2gk/qeoIUSpTdDFzA+olEpDT28bX97MNkht4pEENq/kGjVSfAFG15kgz5Yzc
	 pJy/p8rLiW8jaeWvYhNwo8VyswxBldB92XYREMlc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1272/1518] net: bridge: vlan: fix inverted default vlan notification
Date: Sat, 12 Sep 2026 08:57:21 +0200
Message-ID: <20260912065652.284556306@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Nikolay Aleksandrov <razor@blackwall.org>

[ Upstream commit 21040c7f931502070dcc66bb0f1aeed07dec032b ]

A notification should be emitted only when the vlan delete was successful
and not otherwise. The proper check is if br/nbp_vlan_delete returned 0.

Fixes: f545923b4a6b ("net: bridge: vlan: notify on vlan add/delete/change flags")
Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20260814141640.64958-1-razor@blackwall.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/br_vlan.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index a4ba725ad1dff..76da4f580d4c4 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -1131,7 +1131,7 @@ int __br_vlan_set_default_pvid(struct net_bridge *br, u16 pvid,
 		if (err)
 			goto out;
 
-		if (br_vlan_delete(br, old_pvid))
+		if (!br_vlan_delete(br, old_pvid))
 			br_vlan_notify(br, NULL, old_pvid, 0, RTM_DELVLAN);
 		br_vlan_notify(br, NULL, pvid, 0, RTM_NEWVLAN);
 		__set_bit(0, changed);
@@ -1153,7 +1153,7 @@ int __br_vlan_set_default_pvid(struct net_bridge *br, u16 pvid,
 				   &vlchange, extack);
 		if (err)
 			goto err_port;
-		if (nbp_vlan_delete(p, old_pvid))
+		if (!nbp_vlan_delete(p, old_pvid))
 			br_vlan_notify(br, p, old_pvid, 0, RTM_DELVLAN);
 		br_vlan_notify(p->br, p, pvid, 0, RTM_NEWVLAN);
 		__set_bit(p->port_no, changed);
-- 
2.53.0



