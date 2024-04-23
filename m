Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7F91143888;
	Tue, 23 Apr 2024 21:46:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908797; cv=none; b=OSzBCd7RR9of1YJd+Wz3W7/TOawdrX5RNWdiTicmIBmxVrZoyP/Vbg4IBE13t6m+YRuoyi3UnwHl3hgRhn13eghwyl2GFj0VgSk1i0CU3xv25y5AvIYhxH3QRLeuodn8HRLx6MtAuf6bzuEVCy6tlabsC7YWkR1Yo5Enx6BWb8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908797; c=relaxed/simple;
	bh=c20M6SIjRLOEYgEn52OdPIQHzT1+1y1Gvnpg77YRVpE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=awWeRVESv1TsI7uW6kiQLaV/JYqq5uubFcJOBLCmRsYFpb57aSoiK8mnUodGC2IxnBVcyCbC3zgXjlyu9PVtigw3BHo7EJA/T5clWg+y6pI9WKSUJcW9A8F+kt/XDbp72OUBc+nGuEbtfg4pztubiO91M4srhxx8+ATX1fVgi94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gPy1blqE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gPy1blqE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E0A5C3277B;
	Tue, 23 Apr 2024 21:46:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908797;
	bh=c20M6SIjRLOEYgEn52OdPIQHzT1+1y1Gvnpg77YRVpE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gPy1blqExUhqWjqFLlOZdpzIhsttmrjKjsEuZajR/vtEdACfe0/vk4I10971c+z6H
	 ltA7VZcHrSkOrrFrWFDCAE79moXu6v8Iq2D8rRxQQomiXZEU07DANULbmQarqRJ0kT
	 5epbEYL5cDlyVpMrhVkeWk+XFRKoBVNdQGi8DyFs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 25/71] net: dsa: mt7530: fix mirroring frames received on local port
Date: Tue, 23 Apr 2024 14:39:38 -0700
Message-ID: <20240423213845.006690223@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213844.122920086@linuxfoundation.org>
References: <20240423213844.122920086@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index f291d1e70f807..053f1b4aa324c 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -2437,6 +2437,9 @@ mt7530_setup(struct dsa_switch *ds)
 			   PVC_EG_TAG(MT7530_VLAN_EG_CONSISTENT));
 	}
 
+	/* Allow mirroring frames received on the local port (monitor port). */
+	mt7530_set(priv, MT753X_AGC, LOCAL_EN);
+
 	/* Setup VLAN ID 0 for VLAN-unaware bridges */
 	ret = mt7530_setup_vlan0(priv);
 	if (ret)
@@ -2553,6 +2556,9 @@ mt7531_setup_common(struct dsa_switch *ds)
 			   PVC_EG_TAG(MT7530_VLAN_EG_CONSISTENT));
 	}
 
+	/* Allow mirroring frames received on the local port (monitor port). */
+	mt7530_set(priv, MT753X_AGC, LOCAL_EN);
+
 	/* Flush the FDB table */
 	ret = mt7530_fdb_cmd(priv, MT7530_FDB_FLUSH, NULL);
 	if (ret < 0)
diff --git a/drivers/net/dsa/mt7530.h b/drivers/net/dsa/mt7530.h
index 299a26ad5809c..0247a58d5554c 100644
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



