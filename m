Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38F7D6FB1;
	Tue,  5 Dec 2023 03:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fkLzucqo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF75DC433C7;
	Tue,  5 Dec 2023 03:35:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701747310;
	bh=kxDAObiAMRJQYj9EnoC4fqjc1PwCRCKFH0af/LidByE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fkLzucqoysO0uZW86gAEBUBFm3EsCjD/cEeqP/iDA/CXQLnZwYeLY9adRtL6+6g8u
	 +8572jRgBM8Sc7Hz5C6Un3yX9Zfoq+L1puL6Jh+PcilM9w27eISstw7nRi+krbYzRY
	 YzEOyznESGFTnSiqSuJyNIT4KzQP0zSHle5qX21s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
	Raju Rangoju <Raju.Rangoju@amd.com>,
	Wojciech Drewek <wojciech.drewek@intel.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 027/135] amd-xgbe: propagate the correct speed and duplex status
Date: Tue,  5 Dec 2023 12:15:48 +0900
Message-ID: <20231205031532.352956670@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031530.557782248@linuxfoundation.org>
References: <20231205031530.557782248@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Raju Rangoju <Raju.Rangoju@amd.com>

[ Upstream commit 7a2323ac24a50311f64a3a9b54ed5bef5821ecae ]

xgbe_get_link_ksettings() does not propagate correct speed and duplex
information to ethtool during cable unplug. Due to which ethtool reports
incorrect values for speed and duplex.

Address this by propagating correct information.

Fixes: 7c12aa08779c ("amd-xgbe: Move the PHY support into amd-xgbe")
Acked-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Signed-off-by: Raju Rangoju <Raju.Rangoju@amd.com>
Reviewed-by: Wojciech Drewek <wojciech.drewek@intel.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amd/xgbe/xgbe-ethtool.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-ethtool.c b/drivers/net/ethernet/amd/xgbe/xgbe-ethtool.c
index 61f39a0e04f95..64aebf922dda9 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-ethtool.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-ethtool.c
@@ -314,10 +314,15 @@ static int xgbe_get_link_ksettings(struct net_device *netdev,
 
 	cmd->base.phy_address = pdata->phy.address;
 
-	cmd->base.autoneg = pdata->phy.autoneg;
-	cmd->base.speed = pdata->phy.speed;
-	cmd->base.duplex = pdata->phy.duplex;
+	if (netif_carrier_ok(netdev)) {
+		cmd->base.speed = pdata->phy.speed;
+		cmd->base.duplex = pdata->phy.duplex;
+	} else {
+		cmd->base.speed = SPEED_UNKNOWN;
+		cmd->base.duplex = DUPLEX_UNKNOWN;
+	}
 
+	cmd->base.autoneg = pdata->phy.autoneg;
 	cmd->base.port = PORT_NONE;
 
 	XGBE_LM_COPY(cmd, supported, lks, supported);
-- 
2.42.0



