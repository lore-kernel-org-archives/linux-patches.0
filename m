Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019402;
	b=YKuIvSFgwV3mXHb4Z7KvyoTqrx/6d/lfh58s3sQFOsjAM6RuFjlQSzTQ7FleZpEsTYAm
	 OKDMdI2y1LAQ/Wz6UttuAN2DZbHr9eIQR4hEKH4nwFlanwM1fHG3Xyofy91QsfJFyMABZ
	 wpXeVlWF7rWqhmBwVEZl73uEfkPiticHdZ8bNMrBV638pmrOqytkBbaf1u+9D33S856Qf
	 i9j3Vnl1nwmdsq4iTR+1nO+hAZhpB+vlTnhldf5SSGx4f35PoVvdqPbGzOI1Wyjm7UCwh
	 YHxDXn+YXnHiPTx2fJ4AKjK6sb8SLQTs1z3xQc4ZgKV6A0bFgnUgXMjkNrb1mox5Veg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019402;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CV3z8chcxvtLrx604DzzMh4au6DTCgZGHPPNxSZuASs=;
	b=4RFz5kUEAqNYBkHNG91KDUBegGtRjCgYKxLa1Lk2QSKsbLCPD2Zm4X8jyPqOxhlsFRz5
	 NLTHkFPvf9Bk8WWImvgkFdYElh1wAhAG7Hmz6sqR6b1MKXTqsgIds5lJCE2Wvk7fyfT9r
	 7PEii2egFFteBNsX810w/05rrGPk2iW39iNf5udkSdF7mtTkFSDJ9rLb9Jb1y4OoljQVY
	 tGsjIpZT2Kb7b0Tu7jel4JmLsgciXyQARwhe3vE7BD1NggOuvfdgLqH6nSYJPi80sSGmx
	 /U1stNnRL0i/6EIrKKvT3AGAI5qXk5gaxrSNCiOoppsYJDulhpFzj7CjeMke32bugsg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ncNEKji8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3D2260A3821;
	Wed, 18 Nov 2026 16:30:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ncNEKji8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DB171F000C6;
	Wed, 18 Nov 2026 16:30:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019402;
	bh=CV3z8chcxvtLrx604DzzMh4au6DTCgZGHPPNxSZuASs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ncNEKji8QDFGoHntXZAA0w3yRJRpWWhjvmeMNYLASagGeV0hFiGSPg4F35QI6A0xi
	 MgOkYDBasGpZ6BPnM1u4Km6GSy7YtNGMtJgzU/FFvOSKGvgLWeqFlypnAhK4/73gYX
	 3jJJ+u/jH9vJg0nHrUAima1qMdW/vxNZZXQWv1K0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Ming <ming.li@zohomail.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1584/2651] cxl/port: Attach endpoints to a dport under the lock that pins it
Date: Wed, 18 Nov 2026 15:47:04 +0100
Message-ID: <20261118150344.939120014@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/port.c | 117 ++++++++++++++++++++++------------------
 1 file changed, 64 insertions(+), 53 deletions(-)

diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
index 230f1a3c7d6fe..f3705ea44db77 100644
--- a/drivers/cxl/core/port.c
+++ b/drivers/cxl/core/port.c
@@ -1366,7 +1366,7 @@ static int add_ep(struct cxl_ep *new)
 {
 	struct cxl_port *port = new->dport->port;
 
-	guard(device)(&port->dev);
+	device_lock_assert(&port->dev);
 	if (port->dead)
 		return -ENXIO;
 
@@ -1382,6 +1382,11 @@ static int add_ep(struct cxl_ep *new)
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
@@ -1713,13 +1718,15 @@ static struct cxl_dport *probe_dport(struct cxl_port *port,
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
@@ -1736,7 +1743,7 @@ static struct cxl_dport *devm_cxl_create_port(struct device *ep_dev,
 		port = devm_cxl_add_port(&parent_port->dev, uport_dev,
 					 component_reg_phys, parent_dport);
 		if (IS_ERR(port))
-			return ERR_CAST(port);
+			return PTR_ERR(port);
 
 		/*
 		 * retry to make sure a port is found. a port device
@@ -1744,7 +1751,7 @@ static struct cxl_dport *devm_cxl_create_port(struct device *ep_dev,
 		 */
 		port = find_cxl_port_by_uport(uport_dev);
 		if (!port)
-			return ERR_PTR(-ENODEV);
+			return -ENODEV;
 
 		dev_dbg(ep_dev, "created port %s:%s\n",
 			dev_name(&port->dev), dev_name(port->uport_dev));
@@ -1753,11 +1760,25 @@ static struct cxl_dport *devm_cxl_create_port(struct device *ep_dev,
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
@@ -1765,7 +1786,7 @@ static int add_port_attach_ep(struct cxl_memdev *cxlmd,
 			      struct device *dport_dev)
 {
 	struct device *dparent = grandparent(dport_dev);
-	struct cxl_dport *dport, *parent_dport;
+	struct cxl_dport *parent_dport;
 	int rc;
 
 	if (is_cxl_host_bridge(dparent)) {
@@ -1794,33 +1815,23 @@ static int add_port_attach_ep(struct cxl_memdev *cxlmd,
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
 
 	/*
 	 * The port is already visible in CXL hierarchy, but it may still
@@ -1836,13 +1847,28 @@ static struct cxl_dport *find_or_add_dport(struct cxl_port *port,
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
@@ -1871,7 +1897,6 @@ int devm_cxl_enumerate_ports(struct cxl_memdev *cxlmd)
 	for (iter = dev; iter; iter = grandparent(iter)) {
 		struct device *dport_dev = grandparent(iter);
 		struct device *uport_dev;
-		struct cxl_dport *dport;
 
 		if (is_cxl_host_bridge(dport_dev))
 			return 0;
@@ -1898,27 +1923,13 @@ int devm_cxl_enumerate_ports(struct cxl_memdev *cxlmd)
 			 * RP port enumerated by cxl_acpi without dport will
 			 * have the dport added here.
 			 */
-			dport = find_or_add_dport(port, dport_dev);
-			if (IS_ERR(dport)) {
-				if (PTR_ERR(dport) == -EAGAIN)
-					goto retry;
-				return PTR_ERR(dport);
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



