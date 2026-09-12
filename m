Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 632D130ACF6;
	Sat, 12 Sep 2026 15:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789225895; cv=none; b=qDpClHZem5yly4YWwbEBqS5dVAXVB/QMkT6fKnA95mt3pbLgqGYWizH/sPs4z2PwLL6X1GOAY1b66/lVnLbRgGcToBgVqSCrgmUEW96ffVmK8SE3Xq4RBC28EEUMVLzbtuWyxsGJPtozcNrbVUgWkrUhpDDFL8REk/O3lLPT+TE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789225895; c=relaxed/simple;
	bh=TQ1c34uje1p0SLN8xLAy4DILGwfg3w6AmAO1VU9wfK4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kYkKF4m+D7goL0dsubMW7RsQ+qWNJOYM7VzHRIhvZvobwZCFpr4DSBJBK1z6QDHa5WD52xddzE/qQHCRjuoh0jxMjVXkrM37f2D8JfbDpvDDfwlvBjtK/l8XNTR/IIZ9h8qa2GglHAlkqJ18VopZ54Juk5FikKJzsHldZvXOfzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xNBVcAOy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xNBVcAOy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F34851F000FF;
	Sat, 12 Sep 2026 15:11:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789225894;
	bh=V0rWuhjJLraZf/cml2x1j06LZfJTQWVx7oOoGTxV7q4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xNBVcAOyUsEk9GKgKvZA3Hm/S7VdPwfQZlvk4/M46GFoOHSIMGL1ZIB8EgcbqTdBG
	 E4HYLnG/hUEP1RZ3CbPsoeifR5tVcaACXdxb+hMgqCdhkrlqN1r5Y8vTOFiWNNDnWh
	 FMN7XVaa+1n5X5u1hvZLFilK9UFs+t/s5LhdecZc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1274/1424] net: bridge: vlan: fix inverted default vlan notification
Date: Sat, 12 Sep 2026 09:01:46 +0200
Message-ID: <20260912065635.807944118@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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
index 171d1dddb26a8..67db91022207a 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -1129,7 +1129,7 @@ int __br_vlan_set_default_pvid(struct net_bridge *br, u16 pvid,
 		if (err)
 			goto out;
 
-		if (br_vlan_delete(br, old_pvid))
+		if (!br_vlan_delete(br, old_pvid))
 			br_vlan_notify(br, NULL, old_pvid, 0, RTM_DELVLAN);
 		br_vlan_notify(br, NULL, pvid, 0, RTM_NEWVLAN);
 		__set_bit(0, changed);
@@ -1151,7 +1151,7 @@ int __br_vlan_set_default_pvid(struct net_bridge *br, u16 pvid,
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



