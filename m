Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8508D134B3
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 18:21:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02AB9C433C8;
	Mon, 26 Jun 2023 18:21:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687803714;
	bh=tUH00yyE4wQ/jUInbYBJIIke763jhJXKk/7E7+xsa18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OfI10Ec1MrraRyx2KOP1YCG2ADkM/JnuX7dpPdZlP5N9KMCSKD7fMsX1i2Q/i6Yxv
	 /MZ3e6QUYYLKa9LFCvUYPmQMboCD/SBYH1HebWqLy6TDkzyBmAIUujVCDh/CsgccNd
	 8zksCP1au18OAXRYsC7P6zEldHM9eVJsJ7acN09g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 124/199] net: dsa: mt7530: fix handling of BPDUs on MT7530 switch
Date: Mon, 26 Jun 2023 20:10:30 +0200
Message-ID: <20230626180811.089730380@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230626180805.643662628@linuxfoundation.org>
References: <20230626180805.643662628@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Arınç ÜNAL <arinc.unal@arinc9.com>

[ Upstream commit d7c66073559386b836bded7cdc8b66ee5c049129 ]

BPDUs are link-local frames, therefore they must be trapped to the CPU
port. Currently, the MT7530 switch treats BPDUs as regular multicast
frames, therefore flooding them to user ports. To fix this, set BPDUs to be
trapped to the CPU port. Group this on mt7530_setup() and
mt7531_setup_common() into mt753x_trap_frames() and call that.

Fixes: b8f126a8d543 ("net-next: dsa: add dsa support for Mediatek MT7530 switch")
Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mt7530.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 7dbbd5e509d3b..40be635d2ecc9 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -991,6 +991,14 @@ static void mt7530_setup_port5(struct dsa_switch *ds, phy_interface_t interface)
 	mutex_unlock(&priv->reg_mutex);
 }
 
+static void
+mt753x_trap_frames(struct mt7530_priv *priv)
+{
+	/* Trap BPDUs to the CPU port(s) */
+	mt7530_rmw(priv, MT753X_BPC, MT753X_BPDU_PORT_FW_MASK,
+		   MT753X_BPDU_CPU_ONLY);
+}
+
 static int
 mt753x_cpu_port_enable(struct dsa_switch *ds, int port)
 {
@@ -2214,6 +2222,8 @@ mt7530_setup(struct dsa_switch *ds)
 
 	priv->p6_interface = PHY_INTERFACE_MODE_NA;
 
+	mt753x_trap_frames(priv);
+
 	/* Enable and reset MIB counters */
 	mt7530_mib_reset(ds);
 
@@ -2320,8 +2330,8 @@ mt7531_setup_common(struct dsa_switch *ds)
 			   BIT(cpu_dp->index));
 		break;
 	}
-	mt7530_rmw(priv, MT753X_BPC, MT753X_BPDU_PORT_FW_MASK,
-		   MT753X_BPDU_CPU_ONLY);
+
+	mt753x_trap_frames(priv);
 
 	/* Enable and reset MIB counters */
 	mt7530_mib_reset(ds);
-- 
2.39.2



