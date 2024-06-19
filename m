Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9CA382495;
	Wed, 19 Jun 2024 13:20:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803222; cv=none; b=YHC+wBDeu8Z9kniQmWz1tUQqLxzACOi/PZa/DGsBs64jkxhMYeERsZnfwXjx+i3BMh2YjNTPzv1unxacNH6zMj2cHR2mPd5p87n3OZ+U0WqxdUQuTvS6o1aTP+viPU4Nihkqzzg/6XDDmbcWaxMk9KbVMzqtXpVRkfASjkr4enA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803222; c=relaxed/simple;
	bh=cJSSOw+LORJ2Uay9AMdMft/nUb73sJjrfJAqeDEwxyg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mOfYY8ytIFhMfubwSZfaOF3AD6D+j8t/8Fo0t/+l6PD64Q1A1hroBGR9jhPOXFRIR6tUGHW69KSqhUnoH9ASHVdNrtVLrb8s3PWH8a6Cs7lcqVdOwJEJLexLGPXGIJQQr1r34wNqP7OWySEHO7kVe33IIw5i8U8ax90DYZ5kt0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S/QxQnkp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S/QxQnkp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C4EEC2BBFC;
	Wed, 19 Jun 2024 13:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803222;
	bh=cJSSOw+LORJ2Uay9AMdMft/nUb73sJjrfJAqeDEwxyg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S/QxQnkpaavBf4O0GC/Ewy5/cF0jnmXiYgk9bOZNqJWrPPNzF4eotNj17q2M0kJUb
	 AgvcLt+XDeSvuRadk40QhyhdEb2iqBMcT9A8qu9VEhPpJPalc5f6WEsmMV4+jo3tyk
	 Va5DJeqUTzxoD+zInS1tGiklkLxInLP0wuYiUtU0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+9bbe2de1bc9d470eb5fe@syzkaller.appspotmail.com,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 177/281] net: bridge: mst: pass vlan group directly to br_mst_vlan_set_state
Date: Wed, 19 Jun 2024 14:55:36 +0200
Message-ID: <20240619125616.646637333@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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



