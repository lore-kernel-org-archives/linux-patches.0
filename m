Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B33A27AC5C;
	Thu, 15 Jan 2026 17:39:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498795; cv=none; b=UtFJPtKzS4WNJYMHpyQWm5DuZsZdkRE0o0ox4jC0r6y3D+wgsX+mU6FcofX09ac6l8QMzmLMdbg6s1TZeo3Qkgrnv1gS7QzPTedNVj/vdETfb7CBtgIoB7A7BbSccOT613Zhp7B5+siDU+NY/TRaDiRmY04YKIXQ93H7X23F9Bo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498795; c=relaxed/simple;
	bh=MV9RpJX2rXkhVQOdrRL7w5qIENZtoe4KVPALuVLRJdo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hurrozcRI5dR3bY/O79bm76I8Kxg1dhZDWaJmxdbJBdWB/XOTTLupuDrqlNNJFbXibpIBaBTOd8QoyFGHt3K25woepNM2BRtJ3XOzp7jI+9np83VQ7pZOIu8wbHA5DRkNm+lZEyQw3pAaVaoqVRMMQ2PxwNL1N+PokqrShQAF6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K3B8ABkB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K3B8ABkB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE58FC19423;
	Thu, 15 Jan 2026 17:39:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498795;
	bh=MV9RpJX2rXkhVQOdrRL7w5qIENZtoe4KVPALuVLRJdo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K3B8ABkBZune27MRrs2c/qspORZOQsUKOMlaGmjAxHPv7WIvi9OiKEkbVe8ETWVZj
	 GecuNX0FlAHJekPZhkZKmCLgVFr2CC/3yWvPLz3arUpQyiFAGKACbgy7+IXYxAqt0+
	 /7y49ICXMIuDWM9kfd49t+7xoZUA2eH/IT7w1CSM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jerry Wu <w.7erry@foxmail.com>,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 530/554] net: mscc: ocelot: Fix crash when adding interface under a lag
Date: Thu, 15 Jan 2026 17:49:56 +0100
Message-ID: <20260115164305.511025652@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

From: Jerry Wu <w.7erry@foxmail.com>

[ Upstream commit 34f3ff52cb9fa7dbf04f5c734fcc4cb6ed5d1a95 ]

Commit 15faa1f67ab4 ("lan966x: Fix crash when adding interface under a lag")
fixed a similar issue in the lan966x driver caused by a NULL pointer dereference.
The ocelot_set_aggr_pgids() function in the ocelot driver has similar logic
and is susceptible to the same crash.

This issue specifically affects the ocelot_vsc7514.c frontend, which leaves
unused ports as NULL pointers. The felix_vsc9959.c frontend is unaffected as
it uses the DSA framework which registers all ports.

Fix this by checking if the port pointer is valid before accessing it.

Fixes: 528d3f190c98 ("net: mscc: ocelot: drop the use of the "lags" array")
Signed-off-by: Jerry Wu <w.7erry@foxmail.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Link: https://patch.msgid.link/tencent_75EF812B305E26B0869C673DD1160866C90A@qq.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mscc/ocelot.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 96b1e394a397f..f3bf7757302c0 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1718,14 +1718,16 @@ static void ocelot_set_aggr_pgids(struct ocelot *ocelot)
 
 	/* Now, set PGIDs for each active LAG */
 	for (lag = 0; lag < ocelot->num_phys_ports; lag++) {
-		struct net_device *bond = ocelot->ports[lag]->bond;
+		struct ocelot_port *ocelot_port = ocelot->ports[lag];
 		int num_active_ports = 0;
+		struct net_device *bond;
 		unsigned long bond_mask;
 		u8 aggr_idx[16];
 
-		if (!bond || (visited & BIT(lag)))
+		if (!ocelot_port || !ocelot_port->bond || (visited & BIT(lag)))
 			continue;
 
+		bond = ocelot_port->bond;
 		bond_mask = ocelot_get_bond_mask(ocelot, bond);
 
 		for_each_set_bit(port, &bond_mask, ocelot->num_phys_ports) {
-- 
2.51.0



