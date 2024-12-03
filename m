Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22C7A1F76AA;
	Tue,  3 Dec 2024 16:05:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241953; cv=none; b=objeI7h8nm5X88hujrdnXTFy//EFm1aEb0GPNTK0eQ6XuUmPelg6c4u0UtnbT8HyE5rywVQIY44PxMSPam3bXEg8zWMkmT04+erTvf+Onwdkai3fSoemz98AWidesx03SevpJpXZPbjWNNy+a0/ai3UHMdyvMtiX5T8rX/pbvbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241953; c=relaxed/simple;
	bh=YMEgwi6zwhLp+aZ1IbVsNNp04ZFtYflZadBFqIwwjhw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kOJotUNdBkm7HhimGp5E8dokV3yQpXHM4PDTfhJKJSJkjxZZxe1zzfUu6byq+fSORQqHop06DBkc14CqxhoEAAXIRcYpOVOvdnQXfmPPrMJIi8KW9tBHIvEPsGnTmqQmD2PAsGUEx/t0FircsTWKm/2nowfT8Mf5d4HCwLWL90E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dTGX4/g6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dTGX4/g6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 812EAC4CECF;
	Tue,  3 Dec 2024 16:05:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241953;
	bh=YMEgwi6zwhLp+aZ1IbVsNNp04ZFtYflZadBFqIwwjhw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dTGX4/g6g2i59Qg0ezpCHXdIsA6Db79lxgJbVqpNJnI0omgQUzAwjpWMz3mGPdJGG
	 i7l3oNoLCQo+HgEbTOngUJFQgJH27Sq4dHTXIYpybn5K09iAiJ5fnnrWc4d7gAGlPP
	 F/veiIA4NnNqB9kaLLonxuGKamjVnpNfuICIOVBc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Lai <justinlai0215@realtek.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 564/826] rtase: Correct the speed for RTL907XD-V1
Date: Tue,  3 Dec 2024 15:44:51 +0100
Message-ID: <20241203144805.745192886@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Justin Lai <justinlai0215@realtek.com>

[ Upstream commit c1fc14c4df801fe2d9ec3160b52fa63569ce164c ]

Previously, the reported speed was uniformly set to SPEED_5000, but the
RTL907XD-V1 actually operates at a speed of SPEED_10000. Therefore, this
patch makes the necessary correction.

Fixes: dd7f17c40fd1 ("rtase: Implement ethtool function")
Signed-off-by: Justin Lai <justinlai0215@realtek.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/realtek/rtase/rtase_main.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/realtek/rtase/rtase_main.c b/drivers/net/ethernet/realtek/rtase/rtase_main.c
index c2999e24904d1..7b433b290a973 100644
--- a/drivers/net/ethernet/realtek/rtase/rtase_main.c
+++ b/drivers/net/ethernet/realtek/rtase/rtase_main.c
@@ -1714,10 +1714,21 @@ static int rtase_get_settings(struct net_device *dev,
 			      struct ethtool_link_ksettings *cmd)
 {
 	u32 supported = SUPPORTED_MII | SUPPORTED_Pause | SUPPORTED_Asym_Pause;
+	const struct rtase_private *tp = netdev_priv(dev);
 
 	ethtool_convert_legacy_u32_to_link_mode(cmd->link_modes.supported,
 						supported);
-	cmd->base.speed = SPEED_5000;
+
+	switch (tp->hw_ver) {
+	case RTASE_HW_VER_906X_7XA:
+	case RTASE_HW_VER_906X_7XC:
+		cmd->base.speed = SPEED_5000;
+		break;
+	case RTASE_HW_VER_907XD_V1:
+		cmd->base.speed = SPEED_10000;
+		break;
+	}
+
 	cmd->base.duplex = DUPLEX_FULL;
 	cmd->base.port = PORT_MII;
 	cmd->base.autoneg = AUTONEG_DISABLE;
-- 
2.43.0



