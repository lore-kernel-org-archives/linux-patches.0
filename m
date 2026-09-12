Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 564A53624A5;
	Sat, 12 Sep 2026 09:11:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204275; cv=none; b=ODPLa+8tjlekHyQHn63b3hYv2G1Ue1Y5ABlufZ3rU5Q1DEtxmO7tMAgDf0BOfWQfxEvrCRlvCvd/wq9ZwLx972J8li1Fz+DjnK8Lzl5/Xo/1AkaPZ9Tj3hjUcN+KcBc42DOwc1MGjHydRzhHsiDfhE/k/OFZUKZClomoVjUElCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204275; c=relaxed/simple;
	bh=UmfFEyOIoTznty9IAixqKQlPvVWPuyRnQX2bYHYRuu0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bvm/rZqco49lzcefSJkKtsMLNJim5up1C0IXWQnxNEdIE7UNKuRcgNV4AO2BELJooQlEZIEbLjQorEIHJxHR5+uTAUBBON6qEUu3cqTk525pIr9iVkwBgj5Za7ThrL4cw12MVimoSsvgrP8ZcrH6YiikDBqPCzSmT7Mo+BbRSRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mmrypRSk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mmrypRSk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB86A1F000FF;
	Sat, 12 Sep 2026 09:11:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204274;
	bh=vhDYeunmu7ZSkdwRHpgTsIQ6ttGphhtQ4lOGVNkodc0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mmrypRSk0oZkQxpJX6DQwyWRbg3Ph8cfmca8rn2tyswExc+4jJlohV7gRprlLWGI3
	 3rG1zpbdJZGHFwVTeYfi8Ty5RMEMGWP26SWH/OapDI4EVq2jXKmRvt1gFe9GmTk/bE
	 KXlieJQ0aPOb5fC6u+PPSvkMhRZcxu8TOCxrrtA0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1579/1815] net: bridge: vlan: fix inverted default vlan notification
Date: Sat, 12 Sep 2026 08:55:29 +0200
Message-ID: <20260912065726.056372074@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 31c1b2cf75d92..1e0e436629ece 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -1136,7 +1136,7 @@ int __br_vlan_set_default_pvid(struct net_bridge *br, u16 pvid,
 		if (err)
 			goto out;
 
-		if (br_vlan_delete(br, old_pvid))
+		if (!br_vlan_delete(br, old_pvid))
 			br_vlan_notify(br, NULL, old_pvid, 0, RTM_DELVLAN);
 		br_vlan_notify(br, NULL, pvid, 0, RTM_NEWVLAN);
 		__set_bit(0, changed);
@@ -1158,7 +1158,7 @@ int __br_vlan_set_default_pvid(struct net_bridge *br, u16 pvid,
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



