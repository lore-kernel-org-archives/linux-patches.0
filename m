Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE93B143889;
	Tue, 23 Apr 2024 21:43:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908592; cv=none; b=OoZitjoRfSxZMgIu/vfbxS2IXOJUnr+T00bly0zeaoE3lS8u5X5P8sDXPNNP5j0WS7akji0VrmaO0OgUCxFdWAPaopTP+U3lLqdQkdJeEPjSAFNFBy22aUXxp3NVPtoSp7DgTZOhMYkZoF7VSscnWhqyLyIa78FzQ8A8BMP0rNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908592; c=relaxed/simple;
	bh=S+dOXAYRduH64dD8hFlL8+1G4avCBSR8K+e1hKX1z4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=A4s5+C8lt1wZGRsf1/Ryef2fPWa2etTlj3Iv49xW4HgCYXxRr45t/h+Serxpup/jhX8dTOjLe2WDfuC7XU4dJbcZkpShvtXrRlSu/jCsQzCAvZINU21UHkqtHVzsGOTnRo6Ej7LO88/rhcxtx7fPXsVYBXdgefg/iQtN03CePkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hS/xA8R4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hS/xA8R4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FF10C3277B;
	Tue, 23 Apr 2024 21:43:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908592;
	bh=S+dOXAYRduH64dD8hFlL8+1G4avCBSR8K+e1hKX1z4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hS/xA8R4DuTtUqqwUc75RLVhWWM06KXORwJEHVqLlBQ2B9iYAlG25NhBU1YgfOBze
	 xl8kLqfDlR8TA7dWdm1pBobNg+zNpJKXkndP0VyuijXye7DJP6H9kyZMDjL9MHApfx
	 V2prNg7BWkWHuBGsHPGI48l6rWWmFEAxSJ4se4G8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 053/158] net: dsa: mt7530: fix mirroring frames received on local port
Date: Tue, 23 Apr 2024 14:38:10 -0700
Message-ID: <20240423213857.498754317@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.696477232@linuxfoundation.org>
References: <20240423213855.696477232@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arınç ÜNAL <arinc.unal@arinc9.com>

[ Upstream commit d59cf049c8378677053703e724808836f180888e ]

This switch intellectual property provides a bit on the ARL global control
register which controls allowing mirroring frames which are received on the
local port (monitor port). This bit is unset after reset.

This ability must be enabled to fully support the port mirroring feature on
this switch intellectual property.

Therefore, this patch fixes the traffic not being reflected on a port,
which would be configured like below:

  tc qdisc add dev swp0 clsact

  tc filter add dev swp0 ingress matchall skip_sw \
  action mirred egress mirror dev swp0

As a side note, this configuration provides the hairpinning feature for a
single port.

Fixes: 37feab6076aa ("net: dsa: mt7530: add support for port mirroring")
Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mt7530.c | 6 ++++++
 drivers/net/dsa/mt7530.h | 4 ++++
 2 files changed, 10 insertions(+)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 88f081672f6fb..a123bb832db91 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -2518,6 +2518,9 @@ mt7530_setup(struct dsa_switch *ds)
 			   PVC_EG_TAG(MT7530_VLAN_EG_CONSISTENT));
 	}
 
+	/* Allow mirroring frames received on the local port (monitor port). */
+	mt7530_set(priv, MT753X_AGC, LOCAL_EN);
+
 	/* Setup VLAN ID 0 for VLAN-unaware bridges */
 	ret = mt7530_setup_vlan0(priv);
 	if (ret)
@@ -2626,6 +2629,9 @@ mt7531_setup_common(struct dsa_switch *ds)
 			   PVC_EG_TAG(MT7530_VLAN_EG_CONSISTENT));
 	}
 
+	/* Allow mirroring frames received on the local port (monitor port). */
+	mt7530_set(priv, MT753X_AGC, LOCAL_EN);
+
 	/* Flush the FDB table */
 	ret = mt7530_fdb_cmd(priv, MT7530_FDB_FLUSH, NULL);
 	if (ret < 0)
diff --git a/drivers/net/dsa/mt7530.h b/drivers/net/dsa/mt7530.h
index ddefeb69afda1..9388c1205bea2 100644
--- a/drivers/net/dsa/mt7530.h
+++ b/drivers/net/dsa/mt7530.h
@@ -32,6 +32,10 @@ enum mt753x_id {
 #define SYSC_REG_RSTCTRL		0x34
 #define  RESET_MCM			BIT(2)
 
+/* Register for ARL global control */
+#define MT753X_AGC			0xc
+#define  LOCAL_EN			BIT(7)
+
 /* Registers to mac forward control for unknown frames */
 #define MT7530_MFC			0x10
 #define  BC_FFP(x)			(((x) & 0xff) << 24)
-- 
2.43.0



