Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 453241A08AF;
	Thu, 15 Jan 2026 17:08:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496890; cv=none; b=dVe2uXfGXqRJnnAm3i/La/hTAW4KpdUnTYuuA58UUKY20CE4bJC3HPiGCBl4JCL5E/ks8p1MkwqUVrxc6a47yd3rPt0ObIpjyBhAGB2MK3Lqljk0qJFh5Z901rGWO8Bl+zROYssGeAgRKTjUk28jk/PSvQqcRj5AE/T+Ectd+Aw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496890; c=relaxed/simple;
	bh=d9CfbPBHcKSU1KFmUx/wJ0COy6Wo0nrfPg7GNtowq/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DYLHOV7J9bRp3V1kXYCvzbGY3zaBkiGNNlxdOU+dTTXQi1//slD5u82lk53PJFkQ6eeEhgsAWmgaDiPFa+S6jFMV7o81R/aR5e4T1k7jeGaFAfG/Jy4eVBt2naUxsMZ/efmD4ijSfhHTc82qzHAILH+dBzm+dIqu5sJMlDi9ic8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VqSS/CRY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VqSS/CRY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 825E9C116D0;
	Thu, 15 Jan 2026 17:08:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496889;
	bh=d9CfbPBHcKSU1KFmUx/wJ0COy6Wo0nrfPg7GNtowq/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VqSS/CRYSg7RFQuMTcwRFrfmxe6Kyl/i5DoGeANkfE4OyiXn3gXxuB42NX+59MV5F
	 +XlE753uov/19k89ipgIatYsGtTsLiWIxh9t4oJE6gyU5sBlXeZQDH9ExHfTffSvAc
	 PN/M84Wj8fSAK4j9CjOvh4MC2WkFGeu32goo5+q0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jerry Wu <w.7erry@foxmail.com>,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 52/88] net: mscc: ocelot: Fix crash when adding interface under a lag
Date: Thu, 15 Jan 2026 17:48:35 +0100
Message-ID: <20260115164148.197506423@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164146.312481509@linuxfoundation.org>
References: <20260115164146.312481509@linuxfoundation.org>
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
index 252d8e6f18c3c..a77d42d611dab 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -2307,14 +2307,16 @@ static void ocelot_set_aggr_pgids(struct ocelot *ocelot)
 
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



