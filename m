Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E557524888A;
	Tue, 20 May 2025 14:08:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750129; cv=none; b=gQQwJTkOjMdV6g+IWgFK+8AO/sqjm8YXCzR3WFAkICzXWARoURD2diTE0YDfzPYtCo6thBDQQiTEtaXsQ0l8s5IEAgSTuIycQcVLtetpBf/uXhGI+qbcWwQEAEEtdk/snCAhe2XXGOSHo6uxFxVdOILsUQKdhQSRIVejozOldXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750129; c=relaxed/simple;
	bh=ZLztwofXTJ3GY9QWoVa7XPOFRfhYG4VIZ8K5ZVJdSDI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FTBStIpjdTex1HuFydvEP6R7FgXY4Q8KAFpigmgposp/X4T8BJGKOyAP1Y/FC27FJP2dvWWhs1IOqMByDqRJ/kjTc6FWhQh2rNqaalqCTxFdgj6Uxse9Oe7OVImKBvkRDAVd+UuHrwuWUDnIUd5NN3xZhegEepfCXkr+W/g8l6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OZmdoyRj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OZmdoyRj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61931C4CEE9;
	Tue, 20 May 2025 14:08:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750128;
	bh=ZLztwofXTJ3GY9QWoVa7XPOFRfhYG4VIZ8K5ZVJdSDI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OZmdoyRj7AnCVNHun69LeSepzPlRVkZ7KHbEjs8ENy9Qonm7c0GQXVact+tRL6PhG
	 FWuNdJ5Upk6t+y9iCYv1m0mPe6TcnP0GvLG5VIkzYXC40/US2qEAsjTXvBCBB/sV3S
	 CvC7Vq/mEqLA/bRlpnpJ61I140dP9xI4c3tHA6vM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 052/143] net: dsa: b53: prevent standalone from trying to forward to other ports
Date: Tue, 20 May 2025 15:50:07 +0200
Message-ID: <20250520125812.094209600@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.036375422@linuxfoundation.org>
References: <20250520125810.036375422@linuxfoundation.org>
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

From: Jonas Gorski <jonas.gorski@gmail.com>

[ Upstream commit 4227ea91e2657f7965e34313448e9d0a2b67712e ]

When bridged ports and standalone ports share a VLAN, e.g. via VLAN
uppers, or untagged traffic with a vlan unaware bridge, the ASIC will
still try to forward traffic to known FDB entries on standalone ports.
But since the port VLAN masks prevent forwarding to bridged ports, this
traffic will be dropped.

This e.g. can be observed in the bridge_vlan_unaware ping tests, where
this breaks pinging with learning on.

Work around this by enabling the simplified EAP mode on switches
supporting it for standalone ports, which causes the ASIC to redirect
traffic of unknown source MAC addresses to the CPU port.

Since standalone ports do not learn, there are no known source MAC
addresses, so effectively this redirects all incoming traffic to the CPU
port.

Fixes: ff39c2d68679 ("net: dsa: b53: Add bridge support")
Signed-off-by: Jonas Gorski <jonas.gorski@gmail.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Link: https://patch.msgid.link/20250508091424.26870-1-jonas.gorski@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/b53/b53_common.c | 33 ++++++++++++++++++++++++++++++++
 drivers/net/dsa/b53/b53_regs.h   | 14 ++++++++++++++
 2 files changed, 47 insertions(+)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index e072d2b50c987..0168ad495e6c9 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -326,6 +326,26 @@ static void b53_get_vlan_entry(struct b53_device *dev, u16 vid,
 	}
 }
 
+static void b53_set_eap_mode(struct b53_device *dev, int port, int mode)
+{
+	u64 eap_conf;
+
+	if (is5325(dev) || is5365(dev) || dev->chip_id == BCM5389_DEVICE_ID)
+		return;
+
+	b53_read64(dev, B53_EAP_PAGE, B53_PORT_EAP_CONF(port), &eap_conf);
+
+	if (is63xx(dev)) {
+		eap_conf &= ~EAP_MODE_MASK_63XX;
+		eap_conf |= (u64)mode << EAP_MODE_SHIFT_63XX;
+	} else {
+		eap_conf &= ~EAP_MODE_MASK;
+		eap_conf |= (u64)mode << EAP_MODE_SHIFT;
+	}
+
+	b53_write64(dev, B53_EAP_PAGE, B53_PORT_EAP_CONF(port), eap_conf);
+}
+
 static void b53_set_forwarding(struct b53_device *dev, int enable)
 {
 	u8 mgmt;
@@ -586,6 +606,13 @@ int b53_setup_port(struct dsa_switch *ds, int port)
 	b53_port_set_mcast_flood(dev, port, true);
 	b53_port_set_learning(dev, port, false);
 
+	/* Force all traffic to go to the CPU port to prevent the ASIC from
+	 * trying to forward to bridged ports on matching FDB entries, then
+	 * dropping frames because it isn't allowed to forward there.
+	 */
+	if (dsa_is_user_port(ds, port))
+		b53_set_eap_mode(dev, port, EAP_MODE_SIMPLIFIED);
+
 	return 0;
 }
 EXPORT_SYMBOL(b53_setup_port);
@@ -2043,6 +2070,9 @@ int b53_br_join(struct dsa_switch *ds, int port, struct dsa_bridge bridge,
 		pvlan |= BIT(i);
 	}
 
+	/* Disable redirection of unknown SA to the CPU port */
+	b53_set_eap_mode(dev, port, EAP_MODE_BASIC);
+
 	/* Configure the local port VLAN control membership to include
 	 * remote ports and update the local port bitmask
 	 */
@@ -2078,6 +2108,9 @@ void b53_br_leave(struct dsa_switch *ds, int port, struct dsa_bridge bridge)
 			pvlan &= ~BIT(i);
 	}
 
+	/* Enable redirection of unknown SA to the CPU port */
+	b53_set_eap_mode(dev, port, EAP_MODE_SIMPLIFIED);
+
 	b53_write16(dev, B53_PVLAN_PAGE, B53_PVLAN_PORT_MASK(port), pvlan);
 	dev->ports[port].vlan_ctl_mask = pvlan;
 
diff --git a/drivers/net/dsa/b53/b53_regs.h b/drivers/net/dsa/b53/b53_regs.h
index bfbcb66bef662..5f7a0e5c5709d 100644
--- a/drivers/net/dsa/b53/b53_regs.h
+++ b/drivers/net/dsa/b53/b53_regs.h
@@ -50,6 +50,9 @@
 /* Jumbo Frame Registers */
 #define B53_JUMBO_PAGE			0x40
 
+/* EAP Registers */
+#define B53_EAP_PAGE			0x42
+
 /* EEE Control Registers Page */
 #define B53_EEE_PAGE			0x92
 
@@ -480,6 +483,17 @@
 #define   JMS_MIN_SIZE			1518
 #define   JMS_MAX_SIZE			9724
 
+/*************************************************************************
+ * EAP Page Registers
+ *************************************************************************/
+#define B53_PORT_EAP_CONF(i)		(0x20 + 8 * (i))
+#define  EAP_MODE_SHIFT			51
+#define  EAP_MODE_SHIFT_63XX		50
+#define  EAP_MODE_MASK			(0x3ull << EAP_MODE_SHIFT)
+#define  EAP_MODE_MASK_63XX		(0x3ull << EAP_MODE_SHIFT_63XX)
+#define  EAP_MODE_BASIC			0
+#define  EAP_MODE_SIMPLIFIED		3
+
 /*************************************************************************
  * EEE Configuration Page Registers
  *************************************************************************/
-- 
2.39.5



