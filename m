Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7026D341AB8;
	Tue, 16 Dec 2025 11:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884818; cv=none; b=aYwoZALVFu7a4HWD51U46dSF0dM8B8nb5tAIfBGo7XGQq5qeVm6FuA5CqByfhJkApvydagoJzxxggaI/eXJMsfjEYZFOhN/KjRxw3g/BTiQgYVG/v8CbeWP3/vUnT0hwC0Fnax0kxKCK4oy09DCcBS6anX0KskmOz3mQfpQ/bK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884818; c=relaxed/simple;
	bh=2GRhsr9DuX8B5sDlGSqaLDiz0LCNeQjo20+ujQVH4DY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ylnlk6EAdTEjW0ukg7gCiabAEcoJ9k8lPll/Zpcg4ko5ygk+6QrYtC1BlFZH/yXpQtxiBz4HyO1gCz0AbXm4U1jCMh+fS1BO4EIrgCU3SJ24TvDCxehFvrdnRWnvBGUmkPfUgB5lYWVBGgCix8xhH1/9AIrwieJ3CtyS3m5w018=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=03tBuzui; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="03tBuzui"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5AA8C4CEF1;
	Tue, 16 Dec 2025 11:33:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884818;
	bh=2GRhsr9DuX8B5sDlGSqaLDiz0LCNeQjo20+ujQVH4DY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=03tBuzuisjNEOKz+bsDaDS8iDD64VwaxOO6y4v0a76IREokoXGnpX64ICygPLZQke
	 x+rvz7ZtDhBCL9qkRFcT3bGh3KVRj1l4gi0zXNH/9fKHUQAStQxvApUhmm9kDqISg5
	 BEMrsSNetUyqhTcJPWqUUZdDJ1eeaBjqL4vEiSJY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	MD Danish Anwar <danishanwar@ti.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 281/354] net: hsr: Create and export hsr_get_port_ndev()
Date: Tue, 16 Dec 2025 12:14:08 +0100
Message-ID: <20251216111331.095041207@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: MD Danish Anwar <danishanwar@ti.com>

[ Upstream commit 9c10dd8eed74de9e8adeb820939f8745cd566d4a ]

Create an API to get the net_device to the slave port of HSR device. The
API will take hsr net_device and enum hsr_port_type for which we want the
net_device as arguments.

This API can be used by client drivers who support HSR and want to get
the net_devcie of slave ports from the hsr device. Export this API for
the same.

This API needs the enum hsr_port_type to be accessible by the drivers using
hsr. Move the enum hsr_port_type from net/hsr/hsr_main.h to
include/linux/if_hsr.h for the same.

Signed-off-by: MD Danish Anwar <danishanwar@ti.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: 30296ac76426 ("net: dsa: xrs700x: reject unsupported HSR configurations")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/if_hsr.h | 17 +++++++++++++++++
 net/hsr/hsr_device.c   | 13 +++++++++++++
 net/hsr/hsr_main.h     |  9 ---------
 3 files changed, 30 insertions(+), 9 deletions(-)

diff --git a/include/linux/if_hsr.h b/include/linux/if_hsr.h
index 0404f5bf4f30f..d7941fd880329 100644
--- a/include/linux/if_hsr.h
+++ b/include/linux/if_hsr.h
@@ -13,6 +13,15 @@ enum hsr_version {
 	PRP_V1,
 };
 
+enum hsr_port_type {
+	HSR_PT_NONE = 0,	/* Must be 0, used by framereg */
+	HSR_PT_SLAVE_A,
+	HSR_PT_SLAVE_B,
+	HSR_PT_INTERLINK,
+	HSR_PT_MASTER,
+	HSR_PT_PORTS,	/* This must be the last item in the enum */
+};
+
 /* HSR Tag.
  * As defined in IEC-62439-3:2010, the HSR tag is really { ethertype = 0x88FB,
  * path, LSDU_size, sequence Nr }. But we let eth_header() create { h_dest,
@@ -32,6 +41,8 @@ struct hsr_tag {
 #if IS_ENABLED(CONFIG_HSR)
 extern bool is_hsr_master(struct net_device *dev);
 extern int hsr_get_version(struct net_device *dev, enum hsr_version *ver);
+struct net_device *hsr_get_port_ndev(struct net_device *ndev,
+				     enum hsr_port_type pt);
 #else
 static inline bool is_hsr_master(struct net_device *dev)
 {
@@ -42,6 +53,12 @@ static inline int hsr_get_version(struct net_device *dev,
 {
 	return -EINVAL;
 }
+
+static inline struct net_device *hsr_get_port_ndev(struct net_device *ndev,
+						   enum hsr_port_type pt)
+{
+	return ERR_PTR(-EINVAL);
+}
 #endif /* CONFIG_HSR */
 
 #endif /*_LINUX_IF_HSR_H_*/
diff --git a/net/hsr/hsr_device.c b/net/hsr/hsr_device.c
index ae368cdcbd936..c568d91764235 100644
--- a/net/hsr/hsr_device.c
+++ b/net/hsr/hsr_device.c
@@ -676,6 +676,19 @@ bool is_hsr_master(struct net_device *dev)
 }
 EXPORT_SYMBOL(is_hsr_master);
 
+struct net_device *hsr_get_port_ndev(struct net_device *ndev,
+				     enum hsr_port_type pt)
+{
+	struct hsr_priv *hsr = netdev_priv(ndev);
+	struct hsr_port *port;
+
+	hsr_for_each_port(hsr, port)
+		if (port->type == pt)
+			return port->dev;
+	return NULL;
+}
+EXPORT_SYMBOL(hsr_get_port_ndev);
+
 /* Default multicast address for HSR Supervision frames */
 static const unsigned char def_multicast_addr[ETH_ALEN] __aligned(2) = {
 	0x01, 0x15, 0x4e, 0x00, 0x01, 0x00
diff --git a/net/hsr/hsr_main.h b/net/hsr/hsr_main.h
index 37beb40763dba..677371bc36ea7 100644
--- a/net/hsr/hsr_main.h
+++ b/net/hsr/hsr_main.h
@@ -121,15 +121,6 @@ struct hsrv1_ethhdr_sp {
 	struct hsr_sup_tag	hsr_sup;
 } __packed;
 
-enum hsr_port_type {
-	HSR_PT_NONE = 0,	/* Must be 0, used by framereg */
-	HSR_PT_SLAVE_A,
-	HSR_PT_SLAVE_B,
-	HSR_PT_INTERLINK,
-	HSR_PT_MASTER,
-	HSR_PT_PORTS,	/* This must be the last item in the enum */
-};
-
 /* PRP Redunancy Control Trailor (RCT).
  * As defined in IEC-62439-4:2012, the PRP RCT is really { sequence Nr,
  * Lan indentifier (LanId), LSDU_size and PRP_suffix = 0x88FB }.
-- 
2.51.0



