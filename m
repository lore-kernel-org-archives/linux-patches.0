Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0532875810;
	Mon, 15 Apr 2024 14:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191179; cv=none; b=hYkpbRePFI3RA1kuDsiW7UcXxP0OzQ38JUPog0W5T5TAofhfwidhUPZ1mdVawMv53xL//mu469qXxlgKBr1x3jYuAUS65EJ1dN4BOAMv0KCFny2Cr7GiOYb/yB7K6ZfzGgVJerYTGZ/xoRe07a1YmlmjocsXIroMfvStkUojTec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191179; c=relaxed/simple;
	bh=K8nwCyi3iYp8B8FyKlGh8c2lEHMqwje8d/XYxwpT/80=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uD27mRcBoxQI8tIt0H0QE7K+WLe0s2r0Pi6d/9ZxBZXMLmvVXw2qWP8vapsrhfNUY0UYQoWVmzFYKoRizTmZylHrZgaB3+zNqr4/uBOeTQdqYvMdgAFR0yHxwr33uI+MnbxTOKkjlN9XK5Oy6TVqlwbJ7/8UJ3krj1OOfYrT2Ms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RZoB+j3W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RZoB+j3W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EB93C2BD10;
	Mon, 15 Apr 2024 14:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191178;
	bh=K8nwCyi3iYp8B8FyKlGh8c2lEHMqwje8d/XYxwpT/80=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RZoB+j3WE2FPnQFWraXq6FucL+p7S0xJPx8lbwjB7stfWgLDCuFn4bgakRRQNCDWF
	 oD8Ihi6IkoimUcwqPuTMPoCE6hd1fwOvdS/dILl5LzkR5QgSFw6cSJl1fhtZT6/v8a
	 0EbWmvZWRYdxW1/n8F45gusjy+smatI7Wk3o2WVs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 059/172] cxl: Split out host bridge access coordinates
Date: Mon, 15 Apr 2024 16:19:18 +0200
Message-ID: <20240415142002.213143197@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141959.976094777@linuxfoundation.org>
References: <20240415141959.976094777@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Jiang <dave.jiang@intel.com>

[ Upstream commit 863027d40993f13155451bd898bfe4c4e9b7002f ]

The difference between access class 0 and access class 1 for 'struct
access_coordinate', if any, is that class 0 is for the distance from
the target to the closest initiator and that class 1 is for the distance
from the target to the closest CPU. For CXL memory, the nearest initiator
may not necessarily be a CPU node. The performance path from the CXL
endpoint to the host bridge should remain the same. However, the numbers
extracted and stored from HMAT is the difference for the two access
classes. Split out the performance numbers for the host bridge (generic
target) from the calculation of the entire path in order to allow
calculation of both access classes for a CXL region.

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Tested-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Link: https://lore.kernel.org/r/20240308220055.2172956-7-dave.jiang@intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Stable-dep-of: 592780b8391f ("cxl: Fix retrieving of access_coordinates in PCIe path")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/cdat.c | 28 ++++++++++++++++++++++------
 drivers/cxl/core/port.c | 35 ++++++++++++++++++++++++++++++++---
 drivers/cxl/cxl.h       |  2 ++
 3 files changed, 56 insertions(+), 9 deletions(-)

diff --git a/drivers/cxl/core/cdat.c b/drivers/cxl/core/cdat.c
index 4739a9d776a65..fbf167f9d59d4 100644
--- a/drivers/cxl/core/cdat.c
+++ b/drivers/cxl/core/cdat.c
@@ -162,15 +162,22 @@ static int cxl_cdat_endpoint_process(struct cxl_port *port,
 static int cxl_port_perf_data_calculate(struct cxl_port *port,
 					struct xarray *dsmas_xa)
 {
-	struct access_coordinate c;
+	struct access_coordinate ep_c;
+	struct access_coordinate coord[ACCESS_COORDINATE_MAX];
 	struct dsmas_entry *dent;
 	int valid_entries = 0;
 	unsigned long index;
 	int rc;
 
-	rc = cxl_endpoint_get_perf_coordinates(port, &c);
+	rc = cxl_endpoint_get_perf_coordinates(port, &ep_c);
 	if (rc) {
-		dev_dbg(&port->dev, "Failed to retrieve perf coordinates.\n");
+		dev_dbg(&port->dev, "Failed to retrieve ep perf coordinates.\n");
+		return rc;
+	}
+
+	rc = cxl_hb_get_perf_coordinates(port, coord);
+	if (rc)  {
+		dev_dbg(&port->dev, "Failed to retrieve hb perf coordinates.\n");
 		return rc;
 	}
 
@@ -185,10 +192,19 @@ static int cxl_port_perf_data_calculate(struct cxl_port *port,
 	xa_for_each(dsmas_xa, index, dent) {
 		int qos_class;
 
-		cxl_coordinates_combine(&dent->coord, &dent->coord, &c);
+		cxl_coordinates_combine(&dent->coord, &dent->coord, &ep_c);
+		/*
+		 * Keeping the host bridge coordinates separate from the dsmas
+		 * coordinates in order to allow calculation of access class
+		 * 0 and 1 for region later.
+		 */
+		cxl_coordinates_combine(&coord[ACCESS_COORDINATE_LOCAL],
+					&coord[ACCESS_COORDINATE_LOCAL],
+					&dent->coord);
 		dent->entries = 1;
-		rc = cxl_root->ops->qos_class(cxl_root, &dent->coord, 1,
-					      &qos_class);
+		rc = cxl_root->ops->qos_class(cxl_root,
+					      &coord[ACCESS_COORDINATE_LOCAL],
+					      1, &qos_class);
 		if (rc != 1)
 			continue;
 
diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
index af9458b2678cf..b2a2f6c34886d 100644
--- a/drivers/cxl/core/port.c
+++ b/drivers/cxl/core/port.c
@@ -2096,6 +2096,38 @@ bool schedule_cxl_memdev_detach(struct cxl_memdev *cxlmd)
 }
 EXPORT_SYMBOL_NS_GPL(schedule_cxl_memdev_detach, CXL);
 
+/**
+ * cxl_hb_get_perf_coordinates - Retrieve performance numbers between initiator
+ *				 and host bridge
+ *
+ * @port: endpoint cxl_port
+ * @coord: output access coordinates
+ *
+ * Return: errno on failure, 0 on success.
+ */
+int cxl_hb_get_perf_coordinates(struct cxl_port *port,
+				struct access_coordinate *coord)
+{
+	struct cxl_port *iter = port;
+	struct cxl_dport *dport;
+
+	if (!is_cxl_endpoint(port))
+		return -EINVAL;
+
+	dport = iter->parent_dport;
+	while (iter && !is_cxl_root(to_cxl_port(iter->dev.parent))) {
+		iter = to_cxl_port(iter->dev.parent);
+		dport = iter->parent_dport;
+	}
+
+	coord[ACCESS_COORDINATE_LOCAL] =
+		dport->hb_coord[ACCESS_COORDINATE_LOCAL];
+	coord[ACCESS_COORDINATE_CPU] =
+		dport->hb_coord[ACCESS_COORDINATE_CPU];
+
+	return 0;
+}
+
 /**
  * cxl_endpoint_get_perf_coordinates - Retrieve performance numbers stored in dports
  *				   of CXL path
@@ -2137,9 +2169,6 @@ int cxl_endpoint_get_perf_coordinates(struct cxl_port *port,
 		dport = iter->parent_dport;
 	}
 
-	/* Augment with the generic port (host bridge) perf data */
-	cxl_coordinates_combine(&c, &c, &dport->hb_coord[ACCESS_COORDINATE_LOCAL]);
-
 	/* Get the calculated PCI paths bandwidth */
 	pdev = to_pci_dev(port->uport_dev->parent);
 	bw = pcie_bandwidth_available(pdev, NULL, NULL, NULL);
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index fab2da4b1f04e..de477eb7f5d54 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -879,6 +879,8 @@ void cxl_switch_parse_cdat(struct cxl_port *port);
 
 int cxl_endpoint_get_perf_coordinates(struct cxl_port *port,
 				      struct access_coordinate *coord);
+int cxl_hb_get_perf_coordinates(struct cxl_port *port,
+				struct access_coordinate *coord);
 
 void cxl_memdev_update_perf(struct cxl_memdev *cxlmd);
 
-- 
2.43.0



