Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 853E135E53C;
	Tue,  6 Jan 2026 17:47:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721658; cv=none; b=BYhVLMZt4XLrbD1F1cbcDVWaZwZnAowO4Q4FqC8XO0ndfxE+7tJ7zmAg+1IVeY2uJpKuxpt+C6q30Cg5gdBMHDseWrI4I38MHeEm9m5eiS82wsJWaJwNJBunxRrMies/kLxMJODtitN3gbKAo9FmfvMQffyKtffgEAwtXRFTrVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721658; c=relaxed/simple;
	bh=iFy+DIOQPCJBoZ6RczqvWuxi9/XB3zO3LT31K3x/mZo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h8hiojXUe4cx4rzymx37trCCkVTQzrvVe8rfGSyd7jKg+mgkGTgCgC+SiZmq/VkRNUTDeSElBhajHe+kDX+avsH7ICQNtWVDuldNYWuNsl5pkF3hZCNbdaKaag+OJgJ2zX3k+h0x97uD8omuzpwald67yZDANrGEAKH/nXq2YBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xen9ye/r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xen9ye/r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7D8AC116C6;
	Tue,  6 Jan 2026 17:47:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721658;
	bh=iFy+DIOQPCJBoZ6RczqvWuxi9/XB3zO3LT31K3x/mZo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xen9ye/rx6tzFx9I4oNhuIxLUJusDlU7g1+XQx+HlWByrWicHwWeeF/SX/66SJEo1
	 KUAOeymcKfKFCli5AMHoygaWHVkw5GIispirSuJGYZBna77SmS2WwsjXxBOGJItY4s
	 Nq1due2BakjB5SZvGR8jKL8qIYwHey63kQAGmO6w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 034/312] net: airoha: Move net_devs registration in a dedicated routine
Date: Tue,  6 Jan 2026 18:01:48 +0100
Message-ID: <20260106170549.090604762@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 5e7365b5a1ac8f517a7a84442289d7de242deb76 ]

Since airoha_probe() is not executed under rtnl lock, there is small race
where a given device is configured by user-space while the remaining ones
are not completely loaded from the dts yet. This condition will allow a
hw device misconfiguration since there are some conditions (e.g. GDM2 check
in airoha_dev_init()) that require all device are properly loaded from the
device tree. Fix the issue moving net_devices registration at the end of
the airoha_probe routine.

Fixes: 9cd451d414f6e ("net: airoha: Add loopback support for GDM2")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20251214-airoha-fix-dev-registration-v1-1-860e027ad4c6@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/airoha/airoha_eth.c | 39 ++++++++++++++++--------
 1 file changed, 26 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/airoha/airoha_eth.c b/drivers/net/ethernet/airoha/airoha_eth.c
index 433a646e9831..0394ba6a90a9 100644
--- a/drivers/net/ethernet/airoha/airoha_eth.c
+++ b/drivers/net/ethernet/airoha/airoha_eth.c
@@ -2900,19 +2900,26 @@ static int airoha_alloc_gdm_port(struct airoha_eth *eth,
 	port->id = id;
 	eth->ports[p] = port;
 
-	err = airoha_metadata_dst_alloc(port);
-	if (err)
-		return err;
+	return airoha_metadata_dst_alloc(port);
+}
 
-	err = register_netdev(dev);
-	if (err)
-		goto free_metadata_dst;
+static int airoha_register_gdm_devices(struct airoha_eth *eth)
+{
+	int i;
 
-	return 0;
+	for (i = 0; i < ARRAY_SIZE(eth->ports); i++) {
+		struct airoha_gdm_port *port = eth->ports[i];
+		int err;
 
-free_metadata_dst:
-	airoha_metadata_dst_free(port);
-	return err;
+		if (!port)
+			continue;
+
+		err = register_netdev(port->dev);
+		if (err)
+			return err;
+	}
+
+	return 0;
 }
 
 static int airoha_probe(struct platform_device *pdev)
@@ -2993,6 +3000,10 @@ static int airoha_probe(struct platform_device *pdev)
 		}
 	}
 
+	err = airoha_register_gdm_devices(eth);
+	if (err)
+		goto error_napi_stop;
+
 	return 0;
 
 error_napi_stop:
@@ -3006,10 +3017,12 @@ static int airoha_probe(struct platform_device *pdev)
 	for (i = 0; i < ARRAY_SIZE(eth->ports); i++) {
 		struct airoha_gdm_port *port = eth->ports[i];
 
-		if (port && port->dev->reg_state == NETREG_REGISTERED) {
+		if (!port)
+			continue;
+
+		if (port->dev->reg_state == NETREG_REGISTERED)
 			unregister_netdev(port->dev);
-			airoha_metadata_dst_free(port);
-		}
+		airoha_metadata_dst_free(port);
 	}
 	free_netdev(eth->napi_dev);
 	platform_set_drvdata(pdev, NULL);
-- 
2.51.0



