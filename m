Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B4A33A0E94;
	Thu, 15 Jan 2026 17:11:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497106; cv=none; b=ON16enongW1l7W5ASB//CqfjI27FD4UoPAtqjrQL0qNAeNF+nRU4RWfbtL2q2egVJS2XXnpzg5sEUOg0km/Kf7XMcp+/PQhWYizvBRt6EqOqSCjCs8LAKZEPRaT20y4RZ3qJUqd5S0EQ+aEdc4w43+SOtBa0uP0HQYeNCBXi8b4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497106; c=relaxed/simple;
	bh=Sfiy6ADU3k8naNoI8tYCFUkkhPhXQMtGKe9BaAuUp9U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N7RxrDscHNe+bKq+KBNj+7gY/eu1yrz8zXdb2CgBRd3pUvTUDlPKZSvSlUON0hWhH1uDmPTX0Aj8pPLl6Gb7dTESbP1pnRbOFazgcBVO8pg8YtBYywOmjtz+LWRQpxfl2zeVGsIa1rpza+pzjMO44Ovv/xL1bxKLG5jOJWuiN20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cQQbALhX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cQQbALhX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D19BBC116D0;
	Thu, 15 Jan 2026 17:11:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497106;
	bh=Sfiy6ADU3k8naNoI8tYCFUkkhPhXQMtGKe9BaAuUp9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cQQbALhXGLl1J2dg2yufuEU743UzxSfqbbTuIeI7ffdifzxqIBsGPSmqzMuilViQh
	 BB/PNkYq4l1ojbRCarTqME9xqRNXw4auFDLdppYVs4LcV5+eTCxvicbl9tb0erx9gN
	 6pdG01FyrmNP8fHqI2LplWQHrEJ2ogcII4LawoVo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jerry Wu <w.7erry@foxmail.com>,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 38/72] net: mscc: ocelot: Fix crash when adding interface under a lag
Date: Thu, 15 Jan 2026 17:48:48 +0100
Message-ID: <20260115164144.875810720@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164143.482647486@linuxfoundation.org>
References: <20260115164143.482647486@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 203cb4978544a..01417c2a61e23 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -2202,14 +2202,16 @@ static void ocelot_set_aggr_pgids(struct ocelot *ocelot)
 
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



