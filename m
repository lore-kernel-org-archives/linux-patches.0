Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622577;
	b=Y8PiNWtz5xR06LSHRbkeBx+fFkkBENzXENYUEvxZD9oGV767aX28/msVzk+1yoAaIKi+
	 EoJJzLwJ1O3aAsqpRq9UcksqgrrtGhpUie6VX9GXh49ibh+vn+0GuHVKvJaYN9Eyc6jSy
	 W3U2cQXTAFDlzdUuKpRKgd8BFydRboR2B4xKrHnf1ME55YrxPNfhT9H7KwqVh2B3XL6ds
	 WFstdojbhP6yShfoN70A4Pe5NlUNBvqNBDtz/YnrWaC4ts+9Y87ONXmylZRX4AnGl3hio
	 PBVZdgfeHtyn56sXLwjmKA3isZZgDlr1dII1AgjYK21kk+TeTzW6XuzpRsu8/Qs9f+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622577;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BlboHtRWp4yVBCBeY+5NAwCTc6jtSt8YBG0waP2XPc8=;
	b=Ab2ToOldHVck0mxP982YmaOxoPMeAyilVVlaFtOoMxtDMBdU77AR86raeOlvtDtgts7i
	 aGoQGgTDJMA/+9U6j2ZhLCOw5nKooAIoj80bu0guD5jGn6Hp1fK0o06SGw2FHJhag3CrD
	 1OTh/wVrfudaumn6fABmKx/qxf+QEwQdiw2uaQDJ4Bn4N5NenOggAGC2JgyYlCvKGm8xL
	 2rhkeAyso705+ybDUm3iWK7J3qeKk8S631l47F/DC+q5r49gZOh8U999IuKX3YXQljxxp
	 +Wxy1gPMgbOrLqqhHyWj/AmSjVM7ZwwE+DvppCqiW/po7e0vGb1tIXOn6x3EiGvkO/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oNmKZjzs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C72E1606A331;
	Wed, 25 Nov 2026 16:02:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oNmKZjzs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2CD41F000C0;
	Wed, 25 Nov 2026 16:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622577;
	bh=BlboHtRWp4yVBCBeY+5NAwCTc6jtSt8YBG0waP2XPc8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oNmKZjzsCCr7mufRnt4AULzRw6hRFopiuOt85Q2y+izq91HmHjPFjCIScWnGQQhz2
	 7MI0dXgfNgS/JgZ4iudPKZx+wZLnpNMTOlytVJ/wxWA9FGxPMghoRVIBHQdNUt24qg
	 9K2HG1SUc00C4JCwisUmYWZKODYGuJZ+z564MNgg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Ming <ming.li@zohomail.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 581/990] cxl/port: Attach endpoints to a dport under the lock that pins it
Date: Wed, 25 Nov 2026 15:32:28 +0100
Message-ID: <20261125143835.699921473@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Jiang <dave.jiang@intel.com>

[ Upstream commit bcda00c78d075340fe30cb6c980507fac711e7d1 ]

devm_cxl_enumerate_ports() and add_port_attach_ep() look up or create a
dport under its port's device lock, drop the lock, then pass the dport
to cxl_add_ep(). add_ep() reads dport->port before taking the lock, and
cxl_gpf_port_setup() reads and writes the dport with no lock held.

A concurrent cxl_detach_ep() for another memdev below the same port can
free the dport in that window: it calls del_dports() under the port lock
when the last endpoint leaves. The enumerating memdev then dereferences
freed memory.

Attach the endpoint and set up GPF while the port lock from the lookup
is still held. Make add_ep() assert that lock instead of taking it.
Under the lock, a dport found in port->dports is still live, since
removal erases it from the xarray before freeing it.

[ dj: Added kdoc update from Alison. ]

Fixes: de516b40116e ("cxl/port: Record dport in endpoint references")
Reported-by: Li Ming <ming.li@zohomail.com>
Closes: https://lore.kernel.org/linux-cxl/0c68324c-cfc7-46b2-9344-24ae40e88923@zohomail.com/
Assisted-by: LLM
Reviewed-by: Li Ming <ming.li@zohomail.com>
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Link: https://patch.msgid.link/20261001154744.1095902-4-dave.jiang@intel.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
[ sashal: Replaced the dport lookup's lock guard with a single guard(device)(&port->dev) in the helper because port_to_host() doesn't exist here, so upstream's two-lock scheme was dropped. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/port.c | 121 +++++++++++++++++++++-------------------
 1 file changed, 65 insertions(+), 56 deletions(-)

diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
index b9a585f64b8ab..9c9fcea02816f 100644
--- a/drivers/cxl/core/port.c
+++ b/drivers/cxl/core/port.c
@@ -1383,7 +1383,7 @@ static int add_ep(struct cxl_ep *new)
 {
 	struct cxl_port *port = new->dport->port;
 
-	guard(device)(&port->dev);
+	device_lock_assert(&port->dev);
 	if (port->dead)
 		return -ENXIO;
 
@@ -1399,6 +1399,11 @@ static int add_ep(struct cxl_ep *new)
  * Intermediate CXL ports are scanned based on the arrival of endpoints.
  * When those endpoints depart the port can be destroyed once all
  * endpoints that care about that port have been removed.
+ *
+ * Context: Caller must hold the device lock of @dport->port, which pins
+ *          @dport, across the lookup of @dport and this call. @dport->port
+ *          is never the CXL root port, whose dports are pinned by its
+ *          uport_dev instead.
  */
 static int cxl_add_ep(struct cxl_dport *dport, struct device *ep_dev)
 {
@@ -1727,13 +1732,15 @@ static struct cxl_dport *probe_dport(struct cxl_port *port,
 	return drv->add_dport(port, dport_dev);
 }
 
-static struct cxl_dport *devm_cxl_create_port(struct device *ep_dev,
-					      struct cxl_port *parent_port,
-					      struct cxl_dport *parent_dport,
-					      struct device *uport_dev,
-					      struct device *dport_dev)
+static int devm_cxl_create_port(struct device *ep_dev,
+				struct cxl_port *parent_port,
+				struct cxl_dport *parent_dport,
+				struct device *uport_dev,
+				struct device *dport_dev)
 {
 	resource_size_t component_reg_phys;
+	struct cxl_dport *dport;
+	int rc;
 
 	device_lock_assert(&parent_port->dev);
 	if (!parent_port->dev.driver) {
@@ -1750,7 +1757,7 @@ static struct cxl_dport *devm_cxl_create_port(struct device *ep_dev,
 		port = devm_cxl_add_port(&parent_port->dev, uport_dev,
 					 component_reg_phys, parent_dport);
 		if (IS_ERR(port))
-			return ERR_CAST(port);
+			return PTR_ERR(port);
 
 		/*
 		 * retry to make sure a port is found. a port device
@@ -1758,7 +1765,7 @@ static struct cxl_dport *devm_cxl_create_port(struct device *ep_dev,
 		 */
 		port = find_cxl_port_by_uport(uport_dev);
 		if (!port)
-			return ERR_PTR(-ENODEV);
+			return -ENODEV;
 
 		dev_dbg(ep_dev, "created port %s:%s\n",
 			dev_name(&port->dev), dev_name(port->uport_dev));
@@ -1767,11 +1774,25 @@ static struct cxl_dport *devm_cxl_create_port(struct device *ep_dev,
 		 * Port was created before right before this function is
 		 * called. Signal the caller to deal with it.
 		 */
-		return ERR_PTR(-EAGAIN);
+		return -EAGAIN;
 	}
 
+	/* @dport is only valid while @port's lock is held */
 	guard(device)(&port->dev);
-	return probe_dport(port, dport_dev);
+	dport = probe_dport(port, dport_dev);
+	if (IS_ERR(dport))
+		return PTR_ERR(dport);
+
+	rc = cxl_add_ep(dport, ep_dev);
+	if (rc == -EBUSY) {
+		/*
+		 * "can't" happen, but this error code means
+		 * something to the caller, so translate it.
+		 */
+		rc = -ENXIO;
+	}
+
+	return rc;
 }
 
 static int add_port_attach_ep(struct cxl_memdev *cxlmd,
@@ -1779,7 +1800,7 @@ static int add_port_attach_ep(struct cxl_memdev *cxlmd,
 			      struct device *dport_dev)
 {
 	struct device *dparent = grandparent(dport_dev);
-	struct cxl_dport *dport, *parent_dport;
+	struct cxl_dport *parent_dport;
 	int rc;
 
 	if (is_cxl_host_bridge(dparent)) {
@@ -1808,46 +1829,51 @@ static int add_port_attach_ep(struct cxl_memdev *cxlmd,
 				return PTR_ERR(parent_dport);
 		}
 
-		dport = devm_cxl_create_port(&cxlmd->dev, parent_port,
-					     parent_dport, uport_dev,
-					     dport_dev);
-		if (IS_ERR(dport)) {
-			/* Port or dport already exists, restart iteration */
-			if (PTR_ERR(dport) == -EAGAIN || PTR_ERR(dport) == -EBUSY)
-				return 0;
-			return PTR_ERR(dport);
-		}
+		rc = devm_cxl_create_port(&cxlmd->dev, parent_port,
+					  parent_dport, uport_dev, dport_dev);
 	}
 
-	rc = cxl_add_ep(dport, &cxlmd->dev);
-	if (rc == -EBUSY) {
-		/*
-		 * "can't" happen, but this error code means
-		 * something to the caller, so translate it.
-		 */
-		rc = -ENXIO;
-	}
+	/* Port or dport already exists, restart iteration */
+	if (rc == -EAGAIN || rc == -EBUSY)
+		return 0;
 
 	return rc;
 }
 
-static struct cxl_dport *find_or_add_dport(struct cxl_port *port,
-					   struct device *dport_dev)
+static int find_or_add_dport_attach_ep(struct cxl_memdev *cxlmd,
+				       struct cxl_port *port,
+				       struct device *dport_dev)
 {
 	struct cxl_dport *dport;
+	int rc;
 
-	device_lock_assert(&port->dev);
+	guard(device)(&port->dev);
 	dport = cxl_find_dport_by_dev(port, dport_dev);
 	if (!dport) {
 		dport = probe_dport(port, dport_dev);
 		if (IS_ERR(dport))
-			return dport;
+			return PTR_ERR(dport);
 
 		/* New dport added, restart iteration */
-		return ERR_PTR(-EAGAIN);
+		return -EAGAIN;
 	}
 
-	return dport;
+	/* @dport is only valid while @port's lock is held */
+	rc = cxl_add_ep(dport, &cxlmd->dev);
+
+	/*
+	 * If the endpoint already exists in the port's list,
+	 * that's ok, it was added on a previous pass.
+	 * Otherwise, retry in add_port_attach_ep() after taking
+	 * the parent_port lock as the current port may be being
+	 * reaped.
+	 */
+	if (rc && rc != -EBUSY)
+		return rc;
+
+	cxl_gpf_port_setup(dport);
+
+	return 0;
 }
 
 int devm_cxl_enumerate_ports(struct cxl_memdev *cxlmd)
@@ -1876,7 +1902,6 @@ int devm_cxl_enumerate_ports(struct cxl_memdev *cxlmd)
 	for (iter = dev; iter; iter = grandparent(iter)) {
 		struct device *dport_dev = grandparent(iter);
 		struct device *uport_dev;
-		struct cxl_dport *dport;
 
 		if (is_cxl_host_bridge(dport_dev))
 			return 0;
@@ -1903,29 +1928,13 @@ int devm_cxl_enumerate_ports(struct cxl_memdev *cxlmd)
 			 * RP port enumerated by cxl_acpi without dport will
 			 * have the dport added here.
 			 */
-			scoped_guard(device, &port->dev) {
-				dport = find_or_add_dport(port, dport_dev);
-				if (IS_ERR(dport)) {
-					if (PTR_ERR(dport) == -EAGAIN)
-						goto retry;
-					return PTR_ERR(dport);
-				}
-			}
-
-			rc = cxl_add_ep(dport, &cxlmd->dev);
-
-			/*
-			 * If the endpoint already exists in the port's list,
-			 * that's ok, it was added on a previous pass.
-			 * Otherwise, retry in add_port_attach_ep() after taking
-			 * the parent_port lock as the current port may be being
-			 * reaped.
-			 */
-			if (rc && rc != -EBUSY)
+			rc = find_or_add_dport_attach_ep(cxlmd, port,
+							 dport_dev);
+			if (rc == -EAGAIN)
+				goto retry;
+			if (rc)
 				return rc;
 
-			cxl_gpf_port_setup(dport);
-
 			/* Any more ports to add between this one and the root? */
 			if (!dev_is_cxl_root_child(&port->dev))
 				continue;
-- 
2.53.0



