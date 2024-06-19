Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B803F13DDC0;
	Wed, 19 Jun 2024 13:32:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803938; cv=none; b=k5wJKHxN+FAmVZUTl8JmlveHOZ+1Iv4blpeofP1xbU84baYwWXxmUl2dUYkpXnTFycd5vPiVze39YKunop81dsGDXGQ+/kvVc5NG3bI+hrDmQf63qUCDK2aM/THukZjoAdYA/HtJ0VmO6JiQVvo5512iEjpa+hd23vbk6qiPW1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803938; c=relaxed/simple;
	bh=FBhw3j+L/CIaakoQOgIlBpnIqJTn023Wc4fhY8L6NIw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XQXuNS2d6po6XmgyzLduA61Pi4i2VX0yM42kiaf1IVVEaH/+RmhcwA7ptgHBLJAFU7uNcrbW+I2HhQDnR8rFHTAtiJwsgJyNvoZfTdyDl8wqabxNFe4RNBQ/CncCMtyziik0mAw9Q8YmjWV2xXcaAWmPNkkA+CBbwa0moji4yI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=guY/hZ5I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="guY/hZ5I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38A98C2BBFC;
	Wed, 19 Jun 2024 13:32:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803938;
	bh=FBhw3j+L/CIaakoQOgIlBpnIqJTn023Wc4fhY8L6NIw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=guY/hZ5IwGcCY3HCjyDTn4RNSz4EwPI6m/c+qqqlBl602Pn+YZ0t2frZmNUwjTbir
	 EtiviXSTFPXUmZOENnQcZ5PMZg1quEhr9ZVEMKe5GH3GZvFD46FU60VaeT2J5RBvX5
	 dhKbWRkQd0CVs6iOd+84v759xLOvsDeUn+FU2xSs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+9bbe2de1bc9d470eb5fe@syzkaller.appspotmail.com,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 154/217] net: bridge: mst: pass vlan group directly to br_mst_vlan_set_state
Date: Wed, 19 Jun 2024 14:56:37 +0200
Message-ID: <20240619125602.632200828@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125556.491243678@linuxfoundation.org>
References: <20240619125556.491243678@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikolay Aleksandrov <razor@blackwall.org>

[ Upstream commit 36c92936e868601fa1f43da6758cf55805043509 ]

Pass the already obtained vlan group pointer to br_mst_vlan_set_state()
instead of dereferencing it again. Each caller has already correctly
dereferenced it for their context. This change is required for the
following suspicious RCU dereference fix. No functional changes
intended.

Fixes: 3a7c1661ae13 ("net: bridge: mst: fix vlan use-after-free")
Reported-by: syzbot+9bbe2de1bc9d470eb5fe@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=9bbe2de1bc9d470eb5fe
Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>
Link: https://lore.kernel.org/r/20240609103654.914987-2-razor@blackwall.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/br_mst.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/net/bridge/br_mst.c b/net/bridge/br_mst.c
index 3c66141d34d62..1de72816b0fb2 100644
--- a/net/bridge/br_mst.c
+++ b/net/bridge/br_mst.c
@@ -73,11 +73,10 @@ int br_mst_get_state(const struct net_device *dev, u16 msti, u8 *state)
 }
 EXPORT_SYMBOL_GPL(br_mst_get_state);
 
-static void br_mst_vlan_set_state(struct net_bridge_port *p, struct net_bridge_vlan *v,
+static void br_mst_vlan_set_state(struct net_bridge_vlan_group *vg,
+				  struct net_bridge_vlan *v,
 				  u8 state)
 {
-	struct net_bridge_vlan_group *vg = nbp_vlan_group(p);
-
 	if (br_vlan_get_state(v) == state)
 		return;
 
@@ -121,7 +120,7 @@ int br_mst_set_state(struct net_bridge_port *p, u16 msti, u8 state,
 		if (v->brvlan->msti != msti)
 			continue;
 
-		br_mst_vlan_set_state(p, v, state);
+		br_mst_vlan_set_state(vg, v, state);
 	}
 
 out:
@@ -140,13 +139,13 @@ static void br_mst_vlan_sync_state(struct net_bridge_vlan *pv, u16 msti)
 		 * it.
 		 */
 		if (v != pv && v->brvlan->msti == msti) {
-			br_mst_vlan_set_state(pv->port, pv, v->state);
+			br_mst_vlan_set_state(vg, pv, v->state);
 			return;
 		}
 	}
 
 	/* Otherwise, start out in a new MSTI with all ports disabled. */
-	return br_mst_vlan_set_state(pv->port, pv, BR_STATE_DISABLED);
+	return br_mst_vlan_set_state(vg, pv, BR_STATE_DISABLED);
 }
 
 int br_mst_vlan_set_msti(struct net_bridge_vlan *mv, u16 msti)
-- 
2.43.0



