Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 545A941A81
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:36:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HsoH2qDJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01C33C433CA;
	Wed, 15 Nov 2023 19:36:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076985;
	bh=nsBq7CKfzfhothJlu5UCeKLmzatA3FZu1vVmgFX+XjY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HsoH2qDJDyFtyKhtXPl5IIioxXGDYxMeJOQcDHsAkDufYxDUxGNGDZNYWZMGwuLuW
	 ZR9XzRBLR7E8Yi96/ao32xpv8xhgoyZd5QGJIH5UhGxqT6NTF3BSHzzLVrCK6j3EG/
	 8Gqr/AIFR/j2IToDVO05sHv/1+pfqdG4M+8kpfFs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Richter <rrichter@amd.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 466/550] cxl/port: Fix @host confusion in cxl_dport_setup_regs()
Date: Wed, 15 Nov 2023 14:17:30 -0500
Message-ID: <20231115191633.175705464@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191600.708733204@linuxfoundation.org>
References: <20231115191600.708733204@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Williams <dan.j.williams@intel.com>

[ Upstream commit 33d9c987bf8fb68a9292aba7cc4b1711fcb1be4d ]

commit 5d2ffbe4b81a ("cxl/port: Store the downstream port's Component Register mappings in struct cxl_dport")

...moved the dport component registers from a raw component_reg_phys
passed in at dport instantiation time to a 'struct cxl_register_map'
populated with both the component register data *and* the "host" device
for mapping operations.

While typical CXL switch dports are mapped by their associated 'struct
cxl_port', an RCH host bridge dport registered by cxl_acpi needs to wait
until the cxl_mem driver makes the attachment to map the registers. This
is because there are no intervening 'struct cxl_port' instances between
the root cxl_port and the endpoint port in an RCH topology.

For now just mark the host as NULL in the RCH dport case until code that
needs to map the dport registers arrives.

This patch is not flagged for -stable since nothing in the current
driver uses the dport->comp_map.

Now, I am slightly uneasy that cxl_setup_comp_regs() sets map->host to a
wrong value and then cxl_dport_setup_regs() fixes it up, but the
alternatives I came up with are more messy. For example, adding an
@logdev to 'struct cxl_register_map' that the dev_printk()s can fall
back to when @host is NULL. I settled on "post-fixup+comment" since it
is only RCH dports that have this special case where register probing is
split between a host-bridge RCRB lookup and when cxl_mem_probe() does
the association of the cxl_memdev and endpoint port.

[moved rename of @comp_map to @reg_map into next patch]

Fixes: 5d2ffbe4b81a ("cxl/port: Store the downstream port's Component Register mappings in struct cxl_dport")
Signed-off-by: Robert Richter <rrichter@amd.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Link: https://lore.kernel.org/r/20231018171713.1883517-4-rrichter@amd.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/port.c | 43 +++++++++++++++++++++++++++++------------
 1 file changed, 31 insertions(+), 12 deletions(-)

diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
index c24cfe2271948..2c6001592fe20 100644
--- a/drivers/cxl/core/port.c
+++ b/drivers/cxl/core/port.c
@@ -722,13 +722,23 @@ static int cxl_port_setup_regs(struct cxl_port *port,
 				   component_reg_phys);
 }
 
-static int cxl_dport_setup_regs(struct cxl_dport *dport,
+static int cxl_dport_setup_regs(struct device *host, struct cxl_dport *dport,
 				resource_size_t component_reg_phys)
 {
+	int rc;
+
 	if (dev_is_platform(dport->dport_dev))
 		return 0;
-	return cxl_setup_comp_regs(dport->dport_dev, &dport->comp_map,
-				   component_reg_phys);
+
+	/*
+	 * use @dport->dport_dev for the context for error messages during
+	 * register probing, and fixup @host after the fact, since @host may be
+	 * NULL.
+	 */
+	rc = cxl_setup_comp_regs(dport->dport_dev, &dport->comp_map,
+				 component_reg_phys);
+	dport->comp_map.host = host;
+	return rc;
 }
 
 static struct cxl_port *__devm_cxl_add_port(struct device *host,
@@ -989,7 +999,16 @@ __devm_cxl_add_dport(struct cxl_port *port, struct device *dport_dev,
 	if (!dport)
 		return ERR_PTR(-ENOMEM);
 
-	if (rcrb != CXL_RESOURCE_NONE) {
+	dport->dport_dev = dport_dev;
+	dport->port_id = port_id;
+	dport->port = port;
+
+	if (rcrb == CXL_RESOURCE_NONE) {
+		rc = cxl_dport_setup_regs(&port->dev, dport,
+					  component_reg_phys);
+		if (rc)
+			return ERR_PTR(rc);
+	} else {
 		dport->rcrb.base = rcrb;
 		component_reg_phys = __rcrb_to_component(dport_dev, &dport->rcrb,
 							 CXL_RCRB_DOWNSTREAM);
@@ -998,6 +1017,14 @@ __devm_cxl_add_dport(struct cxl_port *port, struct device *dport_dev,
 			return ERR_PTR(-ENXIO);
 		}
 
+		/*
+		 * RCH @dport is not ready to map until associated with its
+		 * memdev
+		 */
+		rc = cxl_dport_setup_regs(NULL, dport, component_reg_phys);
+		if (rc)
+			return ERR_PTR(rc);
+
 		dport->rch = true;
 	}
 
@@ -1005,14 +1032,6 @@ __devm_cxl_add_dport(struct cxl_port *port, struct device *dport_dev,
 		dev_dbg(dport_dev, "Component Registers found for dport: %pa\n",
 			&component_reg_phys);
 
-	dport->dport_dev = dport_dev;
-	dport->port_id = port_id;
-	dport->port = port;
-
-	rc = cxl_dport_setup_regs(dport, component_reg_phys);
-	if (rc)
-		return ERR_PTR(rc);
-
 	cond_cxl_root_lock(port);
 	rc = add_dport(port, dport);
 	cond_cxl_root_unlock(port);
-- 
2.42.0



