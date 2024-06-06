Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCD981974F3;
	Thu,  6 Jun 2024 14:11:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683099; cv=none; b=ZkilTY8pmyjW5HN8YWrgfHloluRBahLpP7fLSzX4Wfc4k7VUbJaswrfWAqtdX6oDc0grmOBwH0vsGOJDW7RdmwIpdyXKg/VeRCVDZKolCVB6gHHDJSPzknXsbVSqQ9P+fALph/F8QPsvGBed/Nea3HX5mJ4g0qAfA3+mcp3Bu7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683099; c=relaxed/simple;
	bh=h1Op1Y/3X0SyjLOR6e/C5H5PlTp8N1eaeAgv+UyKj2U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K2vilRepVykpNWxchLqhoYb7gfLdJSY2S2Wr+nEKpH/tgltUgDjRTobJOiJ9f5pFC1WTjjyBVWUgCBps+6D/OuE0YxA41441Qc8uy3ZkRsLaTQklsZVdgz9f5YEvmZB/VePD3Tmdw/cqF0uP7v151RcTHc5QLWYYXSUt0D0LObM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cJjxjSzi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cJjxjSzi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A304AC32781;
	Thu,  6 Jun 2024 14:11:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683099;
	bh=h1Op1Y/3X0SyjLOR6e/C5H5PlTp8N1eaeAgv+UyKj2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cJjxjSziPpB12BrE78mufURzJO+yr7FWOslZs+9R52SUbYJ+hd7qAxyly0fiOaU5k
	 q3DdGPh5NA5s/32LLrVfGHz92on3J9+NDZb1MuqcGRYifU3imIf2hVCiwyUKI1KRLW
	 MSwqYCPH0zvHCJT5S6HlidPwLBOgTXy12JYrIjE8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Romain Gantois <romain.gantois@bootlin.com>,
	Simon Horman <horms@kernel.org>,
	MD Danish Anwar <danishanwar@ti.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.6 017/744] net: ti: icssg_prueth: Fix NULL pointer dereference in prueth_probe()
Date: Thu,  6 Jun 2024 15:54:49 +0200
Message-ID: <20240606131733.001867311@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Romain Gantois <romain.gantois@bootlin.com>

commit b31c7e78086127a7fcaa761e8d336ee855a920c6 upstream.

In the prueth_probe() function, if one of the calls to emac_phy_connect()
fails due to of_phy_connect() returning NULL, then the subsequent call to
phy_attached_info() will dereference a NULL pointer.

Check the return code of emac_phy_connect and fail cleanly if there is an
error.

Fixes: 128d5874c082 ("net: ti: icssg-prueth: Add ICSSG ethernet driver")
Cc: stable@vger.kernel.org
Signed-off-by: Romain Gantois <romain.gantois@bootlin.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: MD Danish Anwar <danishanwar@ti.com>
Link: https://lore.kernel.org/r/20240521-icssg-prueth-fix-v1-1-b4b17b1433e9@bootlin.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/ti/icssg/icssg_prueth.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/ti/icssg/icssg_prueth.c
+++ b/drivers/net/ethernet/ti/icssg/icssg_prueth.c
@@ -2136,7 +2136,12 @@ static int prueth_probe(struct platform_
 
 		prueth->registered_netdevs[PRUETH_MAC0] = prueth->emac[PRUETH_MAC0]->ndev;
 
-		emac_phy_connect(prueth->emac[PRUETH_MAC0]);
+		ret = emac_phy_connect(prueth->emac[PRUETH_MAC0]);
+		if (ret) {
+			dev_err(dev,
+				"can't connect to MII0 PHY, error -%d", ret);
+			goto netdev_unregister;
+		}
 		phy_attached_info(prueth->emac[PRUETH_MAC0]->ndev->phydev);
 	}
 
@@ -2148,7 +2153,12 @@ static int prueth_probe(struct platform_
 		}
 
 		prueth->registered_netdevs[PRUETH_MAC1] = prueth->emac[PRUETH_MAC1]->ndev;
-		emac_phy_connect(prueth->emac[PRUETH_MAC1]);
+		ret = emac_phy_connect(prueth->emac[PRUETH_MAC1]);
+		if (ret) {
+			dev_err(dev,
+				"can't connect to MII1 PHY, error %d", ret);
+			goto netdev_unregister;
+		}
 		phy_attached_info(prueth->emac[PRUETH_MAC1]->ndev->phydev);
 	}
 


