Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 150362571CA;
	Mon, 24 Feb 2025 14:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408928; cv=none; b=WD9bPCbGtzD9B5NEVTPsaiqHdDX+8JuFqvqQny+aGtXPlkIKt05u2nNNDiI1JCaG1Q//5NJ06am6atyhhsN38WyTMTd4tOsLH+EYNwj60irWV1yHxop8F1bXpwjzDZ3lzgbMOesZ/L8rl6TlD9kuFoOO3P+/LEFzC2bBX34dUW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408928; c=relaxed/simple;
	bh=6aWLg6yEsA3FI7742LsJ+uf5lI0DjP0IRih4i7+iMFM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oWj7p4mbiv0eNvynX4FeGmKNVrMM+C3nmC23oczS4x5JIZY3aNfkq7aI88w+0qPW3mtuQscWcrqaY18OIizT1G9322FwnmZHFvdle6mQ9XwrrgBuRYw/2m16SPftvMSaygDo/dDZ+wtswV8iZ4SboVf9qYtLEyQNxpPQhTswECg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=giGb77yt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="giGb77yt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 890AEC4CED6;
	Mon, 24 Feb 2025 14:55:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408928;
	bh=6aWLg6yEsA3FI7742LsJ+uf5lI0DjP0IRih4i7+iMFM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=giGb77ytP2z9yVf0u7G3dQ+tur5NE7Z7S5zv2Be6J24s5zVTkdV42iCDICVKUlOKw
	 sAtPqXxoBPMFSQqRdsGoZZNG4v62gh+mv4ORfZBhevfaQn9DS04ZmoR3wsWn3TbRGi
	 TwjGT3Z9vtqgMIzq1lNG5FVbqKDBcqVUNkRBupiE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nick Hu <nick.hu@sifive.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 046/138] net: axienet: Set mac_managed_pm
Date: Mon, 24 Feb 2025 15:34:36 +0100
Message-ID: <20250224142606.281281939@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142604.442289573@linuxfoundation.org>
References: <20250224142604.442289573@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nick Hu <nick.hu@sifive.com>

[ Upstream commit a370295367b55662a32a4be92565fe72a5aa79bb ]

The external PHY will undergo a soft reset twice during the resume process
when it wake up from suspend. The first reset occurs when the axienet
driver calls phylink_of_phy_connect(), and the second occurs when
mdio_bus_phy_resume() invokes phy_init_hw(). The second soft reset of the
external PHY does not reinitialize the internal PHY, which causes issues
with the internal PHY, resulting in the PHY link being down. To prevent
this, setting the mac_managed_pm flag skips the mdio_bus_phy_resume()
function.

Fixes: a129b41fe0a8 ("Revert "net: phy: dp83867: perform soft reset and retain established link"")
Signed-off-by: Nick Hu <nick.hu@sifive.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://patch.msgid.link/20250217055843.19799-1-nick.hu@sifive.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index ae743991117c4..300cf7fed8bca 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -2888,6 +2888,7 @@ static int axienet_probe(struct platform_device *pdev)
 
 	lp->phylink_config.dev = &ndev->dev;
 	lp->phylink_config.type = PHYLINK_NETDEV;
+	lp->phylink_config.mac_managed_pm = true;
 	lp->phylink_config.mac_capabilities = MAC_SYM_PAUSE | MAC_ASYM_PAUSE |
 		MAC_10FD | MAC_100FD | MAC_1000FD;
 
-- 
2.39.5



