Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E78263A1;
	Fri, 24 Nov 2023 18:59:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fkxYMFxL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E89BC433C8;
	Fri, 24 Nov 2023 18:59:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700852364;
	bh=O5+smgJr3AYXPrbOhljuaMlGdj8k9OE9ZhXl9y94kYg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fkxYMFxLaJpqB6JlWmrzjPh2iDp7l1DUqKTac6ZHbBZgRMDGttApUA022guzdqCk/
	 P+idTa/gsnQWPQfFDRy+CBUNnsSFyp3WilN/yZpkgeX+RXhzzbuVfQp+eEeu+TkqUa
	 lSFEjqpxegiQkArhIf4bJsLTB572h9bplsvT/BC8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Richter <rrichter@amd.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 301/372] cxl: Unify debug messages when calling devm_cxl_add_port()
Date: Fri, 24 Nov 2023 17:51:28 +0000
Message-ID: <20231124172020.467369749@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172010.413667921@linuxfoundation.org>
References: <20231124172010.413667921@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Robert Richter <rrichter@amd.com>

[ Upstream commit f3cd264c4ec1ab9b8918f3b083cfc13c5e7c26b7 ]

CXL ports are added in a couple of code paths using devm_cxl_add_port().
Debug messages are individually generated, but are incomplete and
inconsistent. Change this by moving its generation to
devm_cxl_add_port(). This unifies the messages and reduces code
duplication.  Also, generate messages on failure. Use a
__devm_cxl_add_port() wrapper to keep the readability of the error
exits.

Signed-off-by: Robert Richter <rrichter@amd.com>
Link: https://lore.kernel.org/r/20221018132341.76259-4-rrichter@amd.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Stable-dep-of: 98a04c7aced2 ("cxl/region: Fix x1 root-decoder granularity calculations")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/acpi.c      |  2 --
 drivers/cxl/core/port.c | 51 +++++++++++++++++++++++++++++++----------
 2 files changed, 39 insertions(+), 14 deletions(-)

diff --git a/drivers/cxl/acpi.c b/drivers/cxl/acpi.c
index 07b184382707e..dd610556a3afa 100644
--- a/drivers/cxl/acpi.c
+++ b/drivers/cxl/acpi.c
@@ -219,7 +219,6 @@ static int add_host_bridge_uport(struct device *match, void *arg)
 	port = devm_cxl_add_port(host, match, dport->component_reg_phys, dport);
 	if (IS_ERR(port))
 		return PTR_ERR(port);
-	dev_dbg(host, "%s: add: %s\n", dev_name(match), dev_name(&port->dev));
 
 	return 0;
 }
@@ -465,7 +464,6 @@ static int cxl_acpi_probe(struct platform_device *pdev)
 	root_port = devm_cxl_add_port(host, host, CXL_RESOURCE_NONE, NULL);
 	if (IS_ERR(root_port))
 		return PTR_ERR(root_port);
-	dev_dbg(host, "add: %s\n", dev_name(&root_port->dev));
 
 	rc = bus_for_each_dev(adev->dev.bus, NULL, root_port,
 			      add_host_bridge_dport);
diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
index e7556864ea808..93560d749aed8 100644
--- a/drivers/cxl/core/port.c
+++ b/drivers/cxl/core/port.c
@@ -655,16 +655,10 @@ static struct cxl_port *cxl_port_alloc(struct device *uport,
 	return ERR_PTR(rc);
 }
 
-/**
- * devm_cxl_add_port - register a cxl_port in CXL memory decode hierarchy
- * @host: host device for devm operations
- * @uport: "physical" device implementing this upstream port
- * @component_reg_phys: (optional) for configurable cxl_port instances
- * @parent_dport: next hop up in the CXL memory decode hierarchy
- */
-struct cxl_port *devm_cxl_add_port(struct device *host, struct device *uport,
-				   resource_size_t component_reg_phys,
-				   struct cxl_dport *parent_dport)
+static struct cxl_port *__devm_cxl_add_port(struct device *host,
+					    struct device *uport,
+					    resource_size_t component_reg_phys,
+					    struct cxl_dport *parent_dport)
 {
 	struct cxl_port *port;
 	struct device *dev;
@@ -702,6 +696,41 @@ struct cxl_port *devm_cxl_add_port(struct device *host, struct device *uport,
 	put_device(dev);
 	return ERR_PTR(rc);
 }
+
+/**
+ * devm_cxl_add_port - register a cxl_port in CXL memory decode hierarchy
+ * @host: host device for devm operations
+ * @uport: "physical" device implementing this upstream port
+ * @component_reg_phys: (optional) for configurable cxl_port instances
+ * @parent_dport: next hop up in the CXL memory decode hierarchy
+ */
+struct cxl_port *devm_cxl_add_port(struct device *host, struct device *uport,
+				   resource_size_t component_reg_phys,
+				   struct cxl_dport *parent_dport)
+{
+	struct cxl_port *port, *parent_port;
+
+	port = __devm_cxl_add_port(host, uport, component_reg_phys,
+				   parent_dport);
+
+	parent_port = parent_dport ? parent_dport->port : NULL;
+	if (IS_ERR(port)) {
+		dev_dbg(uport, "Failed to add %s%s%s%s: %ld\n",
+			dev_name(&port->dev),
+			parent_port ? " to " : "",
+			parent_port ? dev_name(&parent_port->dev) : "",
+			parent_port ? "" : " (root port)",
+			PTR_ERR(port));
+	} else {
+		dev_dbg(uport, "%s added%s%s%s\n",
+			dev_name(&port->dev),
+			parent_port ? " to " : "",
+			parent_port ? dev_name(&parent_port->dev) : "",
+			parent_port ? "" : " (root port)");
+	}
+
+	return port;
+}
 EXPORT_SYMBOL_NS_GPL(devm_cxl_add_port, CXL);
 
 struct pci_bus *cxl_port_to_pci_bus(struct cxl_port *port)
@@ -1147,8 +1176,6 @@ int devm_cxl_add_endpoint(struct cxl_memdev *cxlmd,
 	if (IS_ERR(endpoint))
 		return PTR_ERR(endpoint);
 
-	dev_dbg(&cxlmd->dev, "add: %s\n", dev_name(&endpoint->dev));
-
 	rc = cxl_endpoint_autoremove(cxlmd, endpoint);
 	if (rc)
 		return rc;
-- 
2.42.0



