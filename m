Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98A733BBE1;
	Mon, 15 Apr 2024 14:28:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191294; cv=none; b=iF7RyM9jmX5JUvPa339DRUaAnaAoNsRFomsekKaquMhymcfrU9quoRrdKzgjuroyFFoDOznmmCWHP14muDt2XefhqR5zn4GTZ6TjAtt+R/CjiE8IWMeQUjtfwtIKU0J+KuvZwZxjhVPrUe/Ur2zaT1zZcb2TeFuZXAdmOdm7KK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191294; c=relaxed/simple;
	bh=iYh5rpKkKfPA/9MXiAHVIzprr6p5HUaMbuzCtDCa3Ek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i5rmu40db50JhZrU/esCUJfhWDWhhQqhw2e23TH14Ukl1DqG9JjVXlDGvKl1n6AP11X4c26GfsrleZuvlWfjTF1ybtcw0yDrd23PfXs+Tjn1kLsYu8I2I2ScbKK6EUDQ77ed3kVmK3ZuOOF9mtznPJ52dzFQcdtHPDRim94E8IY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=loUavTOy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="loUavTOy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC9B3C113CC;
	Mon, 15 Apr 2024 14:28:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191294;
	bh=iYh5rpKkKfPA/9MXiAHVIzprr6p5HUaMbuzCtDCa3Ek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=loUavTOyF3TuPp++1ig0HVq6jgRNOEXHLa2hw7efoxow/hYXO89+IlBsBAZj4gfv5
	 N+dfH//5jMXp26fI29K7ZxD6YpPw2PBpydrD9QGMJOQm84HlnBkh+9vbVaGciNvZMA
	 EUv5j3SJilEBoc9aU5xVFicjxvETIMl+FVVG1SAk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 058/172] cxl: Split out combine_coordinates() for common shared usage
Date: Mon, 15 Apr 2024 16:19:17 +0200
Message-ID: <20240415142002.184000636@linuxfoundation.org>
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

[ Upstream commit 032f7b37adff6985e22516053698b77131c2ce96 ]

Refactor the common code of combining coordinates in order to reduce code.
Create a new function cxl_cooordinates_combine() it combine two 'struct
access_coordinate'.

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Tested-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Link: https://lore.kernel.org/r/20240308220055.2172956-6-dave.jiang@intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Stable-dep-of: 592780b8391f ("cxl: Fix retrieving of access_coordinates in PCIe path")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/cdat.c | 32 +++++++++++++++++++++++---------
 drivers/cxl/core/port.c | 18 ++----------------
 drivers/cxl/cxl.h       |  4 ++++
 3 files changed, 29 insertions(+), 25 deletions(-)

diff --git a/drivers/cxl/core/cdat.c b/drivers/cxl/core/cdat.c
index 0363ca434ef45..4739a9d776a65 100644
--- a/drivers/cxl/core/cdat.c
+++ b/drivers/cxl/core/cdat.c
@@ -185,15 +185,7 @@ static int cxl_port_perf_data_calculate(struct cxl_port *port,
 	xa_for_each(dsmas_xa, index, dent) {
 		int qos_class;
 
-		dent->coord.read_latency = dent->coord.read_latency +
-					   c.read_latency;
-		dent->coord.write_latency = dent->coord.write_latency +
-					    c.write_latency;
-		dent->coord.read_bandwidth = min_t(int, c.read_bandwidth,
-						   dent->coord.read_bandwidth);
-		dent->coord.write_bandwidth = min_t(int, c.write_bandwidth,
-						    dent->coord.write_bandwidth);
-
+		cxl_coordinates_combine(&dent->coord, &dent->coord, &c);
 		dent->entries = 1;
 		rc = cxl_root->ops->qos_class(cxl_root, &dent->coord, 1,
 					      &qos_class);
@@ -484,4 +476,26 @@ void cxl_switch_parse_cdat(struct cxl_port *port)
 }
 EXPORT_SYMBOL_NS_GPL(cxl_switch_parse_cdat, CXL);
 
+/**
+ * cxl_coordinates_combine - Combine the two input coordinates
+ *
+ * @out: Output coordinate of c1 and c2 combined
+ * @c1: input coordinates
+ * @c2: input coordinates
+ */
+void cxl_coordinates_combine(struct access_coordinate *out,
+			     struct access_coordinate *c1,
+			     struct access_coordinate *c2)
+{
+		if (c1->write_bandwidth && c2->write_bandwidth)
+			out->write_bandwidth = min(c1->write_bandwidth,
+						   c2->write_bandwidth);
+		out->write_latency = c1->write_latency + c2->write_latency;
+
+		if (c1->read_bandwidth && c2->read_bandwidth)
+			out->read_bandwidth = min(c1->read_bandwidth,
+						  c2->read_bandwidth);
+		out->read_latency = c1->read_latency + c2->read_latency;
+}
+
 MODULE_IMPORT_NS(CXL);
diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
index 612bf7e1e8474..af9458b2678cf 100644
--- a/drivers/cxl/core/port.c
+++ b/drivers/cxl/core/port.c
@@ -2096,20 +2096,6 @@ bool schedule_cxl_memdev_detach(struct cxl_memdev *cxlmd)
 }
 EXPORT_SYMBOL_NS_GPL(schedule_cxl_memdev_detach, CXL);
 
-static void combine_coordinates(struct access_coordinate *c1,
-				struct access_coordinate *c2)
-{
-		if (c2->write_bandwidth)
-			c1->write_bandwidth = min(c1->write_bandwidth,
-						  c2->write_bandwidth);
-		c1->write_latency += c2->write_latency;
-
-		if (c2->read_bandwidth)
-			c1->read_bandwidth = min(c1->read_bandwidth,
-						 c2->read_bandwidth);
-		c1->read_latency += c2->read_latency;
-}
-
 /**
  * cxl_endpoint_get_perf_coordinates - Retrieve performance numbers stored in dports
  *				   of CXL path
@@ -2143,7 +2129,7 @@ int cxl_endpoint_get_perf_coordinates(struct cxl_port *port,
 	 * nothing to gather.
 	 */
 	while (iter && !is_cxl_root(to_cxl_port(iter->dev.parent))) {
-		combine_coordinates(&c, &dport->sw_coord);
+		cxl_coordinates_combine(&c, &c, &dport->sw_coord);
 		c.write_latency += dport->link_latency;
 		c.read_latency += dport->link_latency;
 
@@ -2152,7 +2138,7 @@ int cxl_endpoint_get_perf_coordinates(struct cxl_port *port,
 	}
 
 	/* Augment with the generic port (host bridge) perf data */
-	combine_coordinates(&c, &dport->hb_coord[ACCESS_COORDINATE_LOCAL]);
+	cxl_coordinates_combine(&c, &c, &dport->hb_coord[ACCESS_COORDINATE_LOCAL]);
 
 	/* Get the calculated PCI paths bandwidth */
 	pdev = to_pci_dev(port->uport_dev->parent);
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index fe7448f2745e1..fab2da4b1f04e 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -882,6 +882,10 @@ int cxl_endpoint_get_perf_coordinates(struct cxl_port *port,
 
 void cxl_memdev_update_perf(struct cxl_memdev *cxlmd);
 
+void cxl_coordinates_combine(struct access_coordinate *out,
+			     struct access_coordinate *c1,
+			     struct access_coordinate *c2);
+
 /*
  * Unit test builds overrides this to __weak, find the 'strong' version
  * of these symbols in tools/testing/cxl/.
-- 
2.43.0



