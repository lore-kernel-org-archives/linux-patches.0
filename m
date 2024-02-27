Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4F2F13B7A0;
	Tue, 27 Feb 2024 13:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042379; cv=none; b=CXJSO1rwr0EUoKwkcOxCd7eGU6qcYmrZBgevyMYaqW+DB7IVDZQ+S3Pj3vSP6Jfuy0QorxKSynagzIpQpwdd7p8H84Aj7xDRQq9bMTaxywiPpzw3wQcrN5o5DkbzZNGvs6u+vVmpGWbNOaGF1TzhIh8eq9bEJdD3tGWa0TAID+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042379; c=relaxed/simple;
	bh=SKCxCjMXx+uhVAKq+FSQB9EvqT+YUdL044bh9kA+49k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iNOEt/6oxB0n+lQT+rkjq0481pEuSK4JqpBFO5VNfgOV9JhFdhnFJ8zlzt/gLDRIQDXtqwV9w1xA4e+bDluhn7FhKW2Lv0Y84v+QbZtbRXLPeOYASOVOlfp3O9blFLSDnSyRqjv8IfDA+zuXWbIENkidqLxHVqA1K2BG/omh6+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ns8c5p+Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ns8c5p+Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63AD3C433F1;
	Tue, 27 Feb 2024 13:59:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042379;
	bh=SKCxCjMXx+uhVAKq+FSQB9EvqT+YUdL044bh9kA+49k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ns8c5p+Y7CKqiL8aLZi9DybuMy9K3cAChlSal3aSjxR/+bwfmUkZRpiPgYF3BKewf
	 NQC8EekM9UsQ360d7Xms9+8kVL5kdNQickiB5fSJB25OgFLEhR/Ox9tc1jnJhJAmIl
	 fvz5gnwRYZW+VRVqHYN/hteswDK0TPFPqmGL7t0M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Justin Chen <justin.chen@broadcom.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 247/299] net: bcmasp: Indicate MAC is in charge of PHY PM
Date: Tue, 27 Feb 2024 14:25:58 +0100
Message-ID: <20240227131633.680254534@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
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

From: Florian Fainelli <florian.fainelli@broadcom.com>

[ Upstream commit 5b76d928f8b779a1b19c5842e7cabee4cbb610c3 ]

Avoid the PHY library call unnecessarily into the suspend/resume
functions by setting phydev->mac_managed_pm to true. The ASP driver
essentially does exactly what mdio_bus_phy_resume() does.

Fixes: 490cb412007d ("net: bcmasp: Add support for ASP2.0 Ethernet controller")
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: Justin Chen <justin.chen@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c b/drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c
index 53e5428812552..9cae5a3090000 100644
--- a/drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c
+++ b/drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c
@@ -1048,6 +1048,9 @@ static int bcmasp_netif_init(struct net_device *dev, bool phy_connect)
 			netdev_err(dev, "could not attach to PHY\n");
 			goto err_phy_disable;
 		}
+
+		/* Indicate that the MAC is responsible for PHY PM */
+		phydev->mac_managed_pm = true;
 	} else if (!intf->wolopts) {
 		ret = phy_resume(dev->phydev);
 		if (ret)
-- 
2.43.0



