Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE1843A453F;
	Sat, 12 Sep 2026 20:02:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789243370; cv=none; b=ncakQl0YAjLNhRjpInyPWRBV+khJfxCIF7dtBDdLIGljHfMSmJuRO9plO+rYPvMCZRrHkNjBoUVfobF7C398JVu/+iL02rxzkvf1CfGH0urfDB3yspEY2WISm58+1KmsCnH4xzGk+0n1pDOovT4EVaqwyS5LKsYguKNZX0cNLV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789243370; c=relaxed/simple;
	bh=g4xTh3/ls+27+pCPenBWkmCnD84/7wIIn10PbpD3LCY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OU8qvtYsuEvKzu2wHlTELX0iHWflDRc3eUa67eM2Dd/IW0DY863tdO7y1GuCcN4BiZ0SZUMU54SvrU6O8C/SwPRpAltFjpBfVmuSGdP4B7pLhQdcZKTu/0NMpumJo8udpU3OB2k0K1IobQQOlE2YWiCUJCKyEMpELdEtCRur36o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FHOqKMZz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FHOqKMZz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D66F1F00898;
	Sat, 12 Sep 2026 20:02:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789243367;
	bh=yQi5xBPg0V0UXmDRTxrhQDSGHKI/++a0Erc7lsq0724=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FHOqKMZz1uOARTdD9uknkJppZ+wq8kfwHl7JrbnZeUQSVv8rXhsx+S++8CfJ3IJxA
	 Qf3QTuZq3ifdrb9+IyFUSeDXfuVUYnndNID6FsdtLIzDluHWLEXGMWMHZ+B7VK4+AC
	 2+QdbUBYXAl1MO7rWatiyqUoZwmz2rv61rHIx2Vc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 730/798] net: bridge: vlan: fix inverted default vlan notification
Date: Sat, 12 Sep 2026 09:05:58 +0200
Message-ID: <20260912065533.809316730@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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
index 759bed457d9f5..f57ec26539e90 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -1045,7 +1045,7 @@ int __br_vlan_set_default_pvid(struct net_bridge *br, u16 pvid,
 		if (err)
 			goto out;
 
-		if (br_vlan_delete(br, old_pvid))
+		if (!br_vlan_delete(br, old_pvid))
 			br_vlan_notify(br, NULL, old_pvid, 0, RTM_DELVLAN);
 		br_vlan_notify(br, NULL, pvid, 0, RTM_NEWVLAN);
 		set_bit(0, changed);
@@ -1067,7 +1067,7 @@ int __br_vlan_set_default_pvid(struct net_bridge *br, u16 pvid,
 				   &vlchange, extack);
 		if (err)
 			goto err_port;
-		if (nbp_vlan_delete(p, old_pvid))
+		if (!nbp_vlan_delete(p, old_pvid))
 			br_vlan_notify(br, p, old_pvid, 0, RTM_DELVLAN);
 		br_vlan_notify(p->br, p, pvid, 0, RTM_NEWVLAN);
 		set_bit(p->port_no, changed);
-- 
2.53.0



