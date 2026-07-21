Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7915415F10;
	Tue, 21 Jul 2026 21:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669577; cv=none; b=GWkeRk4llVnX6twM28j6bVYam0D+tZafR7vvtSSaQNVCETOM8ole4qmmVSrdTB5qPU2hwcZZ8sEzWcpX36xhQ3G1Yrv6O3z/NjNeeRPH0/y+yuorHP6cnVbCzz8dFiUdjVs9aHyZxuYujC/em3zAQSkNnT/k2SJNM7SfKUS+X6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669577; c=relaxed/simple;
	bh=eGgPe959VnyqqvRFzhdNX5LBvJ5Ovt2691YCJ2LFPXY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a6m+vbyh4gMAV0jaY0+C/E6QVCWkV9q7n4+c5AVzr0qrkWEWzpB+uxEACZYv5/efD2kJUdTs5GSegSTAAwe9R+Fo7BsXGOQzA3srU4MSfILj5OVbRRPCdlm3MRJsAFmpPONXZpsxW2V35kJPFsjWdN8YSPHeuWpmHsJ+mpmB30A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2YQi/H+Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2YQi/H+Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 289B81F000E9;
	Tue, 21 Jul 2026 21:32:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669576;
	bh=sXj87tkuZHDagTbnElAHdvXtPirURqL5rpBrqaF9vaE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2YQi/H+Y2eb83+W2Iyrh2SptzgOmzWlKBK61rPfN7nRE/rGqLgamo/jyu2FPv9iE3
	 12ns8pWasBIJRIHZWK72vNd9sW0ydHX5FfLlvdQAspK+Exk9agclEAzC0OSQPHaPX+
	 Tw43ic+0xFaHPqqXEtdDd5Qc6Xbm2nbwblq8hVHU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Elad Nachman <enachman@marvell.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0605/1067] net: marvell: prestera: initialize err in prestera_port_sfp_bind
Date: Tue, 21 Jul 2026 17:20:06 +0200
Message-ID: <20260721152438.135074449@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

From: Ruoyu Wang <ruoyuw560@gmail.com>

[ Upstream commit 62b01f72d93c7bc8fde3b2e5b5f783eca5f53324 ]

prestera_port_sfp_bind() returns err after walking the ports node. If no
child node matches the port's front-panel id, err is never assigned.

Initialize err to 0 because absence of a matching optional port device
tree node is not an error. In that case no phylink is created and port
creation should continue with port->phy_link left NULL. Errors from
malformed matched nodes and phylink_create() still propagate.

Fixes: 52323ef75414 ("net: marvell: prestera: add phylink support")
Signed-off-by: Ruoyu Wang <ruoyuw560@gmail.com>
Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Acked-by: Elad Nachman <enachman@marvell.com>
Link: https://patch.msgid.link/20260617193228.1653582-1-ruoyuw560@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/prestera/prestera_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_main.c b/drivers/net/ethernet/marvell/prestera/prestera_main.c
index 47796e4d900c63..b7dc6241ba3e53 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_main.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_main.c
@@ -379,7 +379,7 @@ static int prestera_port_sfp_bind(struct prestera_port *port)
 	struct device_node *ports, *node;
 	struct fwnode_handle *fwnode;
 	struct phylink *phy_link;
-	int err;
+	int err = 0;
 
 	if (!sw->np)
 		return 0;
-- 
2.53.0



