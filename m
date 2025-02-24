Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C298E19644B;
	Mon, 24 Feb 2025 14:48:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408480; cv=none; b=p71dz7l9v/+BYyp48SuKUuTauEc/z+KCQwfe9ZopDS/lFrPaG3awyd2aLTnN2MeuRC64rPMalcu/yllG3PJAzWqYtTdm0KBIE7szuA3mWXuU8lgTRs00GJfnXns2u09oDdIs5kx8Lp/dnT1EdMU/0BiLg6DspaL9I3hjRLKBjiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408480; c=relaxed/simple;
	bh=X0NcAaI+8UfXgchMP/qzUdjBcSCIeiRaP4ACipTzodQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fprPdMJAjWJaAbqIOFMB7DaaNHp/mvzSt3ptGciySdKtGBVRh1OJaPYxzIfZ82zHeA5eZC8EATVbhMYSNxDriTI+9mtMiyVchhWH3kltQk+Ox/kMW/OWgVdXbxx8GPFYv2qlrrWAoAqH/q7ch1tzZKDjZYpl/BIXzY9P8WgCpmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T+wbryrA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T+wbryrA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30BB0C4CED6;
	Mon, 24 Feb 2025 14:48:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408480;
	bh=X0NcAaI+8UfXgchMP/qzUdjBcSCIeiRaP4ACipTzodQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T+wbryrAWd6e4HL/7bt7BgZvb7vuwn9jTE/ai3/WA1ubgPatZrxYd/NJi4wryHGx2
	 lwlAGpmZWPqJrtVSq/5DBybrrJ/KKmJ6eUlhJDGDAbf62oqazr+4xeMJebmzAzXGhQ
	 99S/VFmxCAUsECWkMwev+UHYEyWt6IfYj/Sypd3I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nick Hu <nick.hu@sifive.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 071/154] net: axienet: Set mac_managed_pm
Date: Mon, 24 Feb 2025 15:34:30 +0100
Message-ID: <20250224142609.863155785@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142607.058226288@linuxfoundation.org>
References: <20250224142607.058226288@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index de10a2d08c428..fe3438abcd253 100644
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



