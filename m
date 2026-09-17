Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C432E4F93BC;
	Thu, 17 Sep 2026 17:58:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667918; cv=none; b=NWSFoeACbC/L44o7tozbe9E+1+cv4mp3rYP1iiUqEgbz2ipL0MsaESWuQurnvaSlzT2iStxh16w3HDsHSK3tpzO7ExiWcOrZk4lOiDohiJVQDb3qUNks4Uob4yxjgcr8WJYPcNpURGQ/4B7PoJOxB35sePSji3SFFgj992Qczgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667918; c=relaxed/simple;
	bh=RckveI/up09krXFduwlF9HR2OXPxqfh8nBzFvkPe98U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HjJLFmvT0z1vuv5b78tDNYay/2i+JaXk9e+2BQcUSiuafd/U3Ao3hy4TgmsXI/h0OQT8fKfLKGMoonjgwcgjRHwDc/XTO1DRHOXmB3jTKpQcthk6ehs7ehK7A9i9pdq9OEpG1dlcAtS1+fJx9SR/KuA5XrXZowBNjLMkebAtZqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GabDkNOw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GabDkNOw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25BE71F000FF;
	Thu, 17 Sep 2026 17:58:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667916;
	bh=eTBsIx6Wdo7Z6Xg8q0i/BbZlLwhVZbSYcypKDUGbjsQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GabDkNOwEO8P13OYCVf9AATti1o1OSijweICxO0mpvthPDq7zdfstzva4kUZwijmT
	 98KRbJLkJ77MD6F4/D4sXvCgFN0FvHYD4ttBePD0VvDjnEzmBW8Rx6GduhNNgzQv20
	 HJAOVx93yZ1snDB8AAaJjcI5O4M0JEQPfc4ZeCNs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0216/1102] dpaa2-switch: fix handling of NAPI on the remove path
Date: Thu, 17 Sep 2026 16:02:39 +0100
Message-ID: <20260917151545.001294537@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ioana Ciornei <ioana.ciornei@nxp.com>

[ Upstream commit e23d7c8c1d4ba435c457d7ffb2669175ec819b07 ]

All the NAPI instances for a DPSW device are attached to the first
switch port's net_device but shared by all ports. The NAPI instances get
disabled only once the last port goes down.

This causes an issue on the .remove() path where each port is
unregistered and freed one at a time, causing the NAPI instances to be
deleted even though they are not disabled.

In order to avoid this, split up the unregister_netdev() calls from the
free_netdev() so that we make sure all ports go down before we attempt
a deletion of NAPI instances. Also, make the netif_napi_del() explicit
as it is on the .probe() path.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Link: https://patch.msgid.link/20260528173452.1953102-6-ioana.ciornei@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/freescale/dpaa2/dpaa2-switch.c   | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
index ff3a71c4419f2..b6a92742294a1 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
@@ -3306,7 +3306,6 @@ static void dpaa2_switch_teardown(struct fsl_mc_device *sw_dev)
 
 static void dpaa2_switch_remove(struct fsl_mc_device *sw_dev)
 {
-	struct ethsw_port_priv *port_priv;
 	struct ethsw_core *ethsw;
 	struct device *dev;
 	int i;
@@ -3318,11 +3317,17 @@ static void dpaa2_switch_remove(struct fsl_mc_device *sw_dev)
 
 	dpsw_disable(ethsw->mc_io, 0, ethsw->dpsw_handle);
 
-	for (i = 0; i < ethsw->sw_attr.num_ifs; i++) {
-		port_priv = ethsw->ports[i];
-		unregister_netdev(port_priv->netdev);
+	/* Unregister all the netdevs so that they are brought down and the
+	 * shared NAPI instances gets disabled.
+	 */
+	for (i = 0; i < ethsw->sw_attr.num_ifs; i++)
+		unregister_netdev(ethsw->ports[i]->netdev);
+
+	for (i = 0; i < DPAA2_SWITCH_RX_NUM_FQS; i++)
+		netif_napi_del(&ethsw->fq[i].napi);
+
+	for (i = 0; i < ethsw->sw_attr.num_ifs; i++)
 		dpaa2_switch_remove_port(ethsw, i);
-	}
 
 	kfree(ethsw->fdbs);
 	kfree(ethsw->filter_blocks);
-- 
2.53.0



