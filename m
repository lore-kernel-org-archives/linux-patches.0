Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E631327C00;
	Thu, 28 May 2026 20:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780001427; cv=none; b=a2MMKD2cDb4pauYP2RPppTem6baBOh2Vx4GzAAKH+/RQzTSE8KSM0TvJvgxl991H6Feqml8E/w/tieW030VyaHR3okEgIDkV/avVJ6g163Jlp2M/JRCXv4EoWx2a2fQM7v8PRXXbtjTmu+ilHPxkAGNG0W+7aFImJd5GzL0KgDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780001427; c=relaxed/simple;
	bh=jmOldHPDFFCGDdY9ZvVxVNYMnLwVDvugAdHdAwGTMHc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DHH656C8NEP96QqSgpBgn1l8gSw6y6GlSeOtdWZdaI0MhCmfqSRgbVa13NjIcYg7eLrHGj6p6e8iX3yBCfP8sTgnZ3+H1qFEeqyLRlYrnZFPA0LmvB2bl9pPUPRlruY9jC4wynxNe1xbBbzUEg9RAHhvJ3i/1l9G9W6Rb8PFfgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SkIaKJv5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SkIaKJv5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AEC41F000E9;
	Thu, 28 May 2026 20:50:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780001426;
	bh=9rLmfIZOMA1Xx1/7xUFbwk9bZIh5WA0+gZzA6uPGgJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SkIaKJv59FydD4ggcTd7jZLM9lhrboPNyRjWAddR4tOY6Kzl6xWYpcIE5FhHEKbDR
	 735W0u6quvsgIGCh/bYzg5Ft9MQiF0qqvhx5NWjkoop7jvrxASh6vFnOQ0iGzDv3Mc
	 pbeFnHO5ByOV0j4/ZRPYJsU6poH51/R5+TbdVNYs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 124/186] net: lan966x: avoid unregistering netdev on register failure
Date: Thu, 28 May 2026 21:50:04 +0200
Message-ID: <20260528194932.292237574@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194928.941004471@linuxfoundation.org>
References: <20260528194928.941004471@linuxfoundation.org>
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
index 5466f14e000ce..ce48685a50b20 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
@@ -750,11 +750,10 @@ static void lan966x_cleanup_ports(struct lan966x *lan966x)
 
 	for (p = 0; p < lan966x->num_phys_ports; p++) {
 		port = lan966x->ports[p];
-		if (!port)
+		if (!port || !port->dev)
 			continue;
 
-		if (port->dev)
-			unregister_netdev(port->dev);
+		unregister_netdev(port->dev);
 
 		lan966x_xdp_port_deinit(port);
 		if (lan966x->fdma && lan966x->fdma_ndev == port->dev)
@@ -875,6 +874,9 @@ static int lan966x_probe_port(struct lan966x *lan966x, u32 p,
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



