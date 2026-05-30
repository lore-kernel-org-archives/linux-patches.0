Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35F411C5799;
	Sat, 30 May 2026 17:34:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162442; cv=none; b=B2StvnTqtDKeiMWuTLhhJ0B0v0hGMnTmAgLP2cOVVZ3wxKroLYu5N39iWEjXI7BuBRntgJ5qsQaMAjjFVJY3YrZcLwHzIe8I//Uf5Yj7MVQ1zP8TRakA1nq/BjYD8j3BKnZqE90+OE0OLxrv9gylIA8OIZfWniGdOsICJ6BLDM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162442; c=relaxed/simple;
	bh=hVHy76nG71WmhhufeDl5F9atimkXycmAe3G4/BPv0MA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vf+FBjc1ZMyppmGxXx/3u/bH8c/M4oOlHYETD87U7hXlb/uQd8avrMxAXQ5Ktp78ggBFgV0bbCD8StkgXndXZJHxTaCcm9q+8Iy0vNVeHs+uummw2thYnca47DUMchU3r2Dl9m8rXNTAqfphMbdmSclBueg2/zRq09UQd5wmjsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z+Ho/uEQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z+Ho/uEQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42D9C1F00893;
	Sat, 30 May 2026 17:34:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162440;
	bh=UtL25NPcYiqOFpgJ0oPI0LSZNPpFV80S3fkJtuuJVbY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z+Ho/uEQI1QUH2YLPdV8zNuKEoOPx3XEojWSFOZ9ZUM8WpPAmtQR7qr8O8qOwvwzJ
	 pi7+BDXfa/bLzjx6NNkm5sDLDpy8kVY3mrXi9oOVJpdJljQmimoJduKEEMneHHsB0S
	 uUmNkIiBpz6gYGfUor3KARi36GQagkN9TsuAvNTM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 922/969] net: lan966x: avoid unregistering netdev on register failure
Date: Sat, 30 May 2026 18:07:26 +0200
Message-ID: <20260530160326.198411345@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

From: Myeonghun Pak <mhun512@gmail.com>

[ Upstream commit c4f3d6eb1fcf6cd9ce4644f604d5aad1ce594dfc ]

lan966x_probe_port() stores the newly allocated net_device in the
port before calling register_netdev(). If register_netdev() fails,
the probe error path calls lan966x_cleanup_ports(), which sees
port->dev and calls unregister_netdev() for a device that was never
registered.

Destroy the phylink instance created for this port and clear port->dev
before returning the registration error. The common cleanup path now skips
ports without port->dev before reaching the registered netdev cleanup, so
it only handles ports that reached the registered-netdev lifetime.

This also avoids treating an uninitialized FDMA netdev and the failed port
as a NULL == NULL match in the common cleanup path.

Fixes: d28d6d2e37d1 ("net: lan966x: add port module support")
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Link: https://patch.msgid.link/20260506124331.31945-1-mhun512@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microchip/lan966x/lan966x_main.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
index 8c048ffde23d6..8347def40f9d4 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
@@ -688,11 +688,10 @@ static void lan966x_cleanup_ports(struct lan966x *lan966x)
 
 	for (p = 0; p < lan966x->num_phys_ports; p++) {
 		port = lan966x->ports[p];
-		if (!port)
+		if (!port || !port->dev)
 			continue;
 
-		if (port->dev)
-			unregister_netdev(port->dev);
+		unregister_netdev(port->dev);
 
 		if (lan966x->fdma && lan966x->fdma_ndev == port->dev)
 			lan966x_fdma_netdev_deinit(lan966x, port->dev);
@@ -805,6 +804,9 @@ static int lan966x_probe_port(struct lan966x *lan966x, u32 p,
 	err = register_netdev(dev);
 	if (err) {
 		dev_err(lan966x->dev, "register_netdev failed\n");
+		phylink_destroy(phylink);
+		port->phylink = NULL;
+		port->dev = NULL;
 		return err;
 	}
 
-- 
2.53.0



