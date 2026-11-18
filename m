Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029771;
	b=og2H19WTVsTiCxJyhPhsiK59BXxO2/v+rpf8Zj54F6m1hzxK0HiGTUOiu0k/RO18o5gf
	 bAZQxKVKyIYyKrNwDAonyn35UaLv0RCNoy7IleG+IAnWCABiawNxqiflTxtf1sAvIys83
	 IM8pJjYu8fhyOBwsZV5+NIOADf5ES3OmZQhclPtzp65Kerp/y2lRKlmQ3ZTjgK3aVc8E4
	 KaLvC1Q2FUlStPw5GDSSL0ezA4CxhXcIHy9UczK5/WmKy3vTuyPpDhwoii7w+0DykGFMd
	 58OtassiihqdZjwbUimx5XnbT+/zjatbpMEv23FhkksM+ReV3kmFSEMEv1kuikyj//A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029771;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=e+ad0cro3uoA6ysViBoepUM289sjJB5UTruRKKt8G58=;
	b=FGa3jXyZ0iQcRswtBMgMwUd+sahCsguBWxQPtToxzdV5BQZu5KgiQXyDIf5rZ3HWrgyK
	 KERduDw4G+zNTnxws9hJhQOLY4ThwfdhaBSICVCmeN1Yq89Mu16AtvoEbzdNoqF3sfR5E
	 evC1wprbSao455fsUkFydVJlq4q3oDntdx5LEnKajZci4jLvuN/kDAnhIwjlhipTBur+j
	 puIxwsvMfnvsPatHhe/gqaVyBOcm6GUiyEeSuTmiE9E8Y8AgqhhM+MLAKq3wXHzQJh7yX
	 S8/Iv6beSQxVdBZiHkgV3vvV3JRk15U4+MiYoExLirl2shZRq55BJfn5BeOR84sgMqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VaZftUv0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CAC0606A31C;
	Wed, 18 Nov 2026 19:22:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VaZftUv0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85DB11F000C4;
	Wed, 18 Nov 2026 19:22:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029771;
	bh=e+ad0cro3uoA6ysViBoepUM289sjJB5UTruRKKt8G58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VaZftUv0bWnNDmtgI/LpaMeiQRN5O7iRIm7W2u8xV1xaH3rLPnyVQQ8VEHOyt6OId
	 qWd9Jk80erXNO8DC6CDIIDNl5hlIxO/TBCrgjT4s982mtCUEDgen0zK/NcpjHe2B9i
	 O5AAuJS3a/xlUpCtx5mukTBT/kjoMyrCDt6wAu9o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Richter <rrichter@amd.com>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0426/1756] cxl: Add a cached copy of target_map to cxl_decoder
Date: Wed, 18 Nov 2026 15:42:33 +0100
Message-ID: <20261118150025.719635070@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Jiang <dave.jiang@intel.com>

[ Upstream commit 02edab6ceefaaf8cb917e864d8c26dbac0ea9686 ]

Add a cached copy of the hardware port-id list that is available at init
before all @dport objects have been instantiated. Change is in preparation
of delayed dport instantiation.

Reviewed-by: Robert Richter <rrichter@amd.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Tested-by: Robert Richter <rrichter@amd.com>
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Stable-dep-of: 3f846646b3d3 ("cxl/hdm: Make switch decoder target parsing endian-safe")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/acpi.c           |  7 +++----
 drivers/cxl/core/hdm.c       | 20 ++++++++------------
 drivers/cxl/core/port.c      | 22 +++++++---------------
 drivers/cxl/core/region.c    |  4 +++-
 drivers/cxl/cxl.h            |  8 ++++++--
 tools/testing/cxl/test/cxl.c |  8 ++++----
 6 files changed, 31 insertions(+), 38 deletions(-)

diff --git a/drivers/cxl/acpi.c b/drivers/cxl/acpi.c
index 01cc06a75e111..84b5986d1ebfc 100644
--- a/drivers/cxl/acpi.c
+++ b/drivers/cxl/acpi.c
@@ -349,7 +349,6 @@ DEFINE_FREE(del_cxl_resource, struct resource *, if (_T) del_cxl_resource(_T))
 static int __cxl_parse_cfmws(struct acpi_cedt_cfmws *cfmws,
 			     struct cxl_cfmws_context *ctx)
 {
-	int target_map[CXL_DECODER_MAX_INTERLEAVE];
 	struct cxl_port *root_port = ctx->root_port;
 	struct cxl_cxims_context cxims_ctx;
 	struct device *dev = ctx->dev;
@@ -367,8 +366,6 @@ static int __cxl_parse_cfmws(struct acpi_cedt_cfmws *cfmws,
 	rc = eig_to_granularity(cfmws->granularity, &ig);
 	if (rc)
 		return rc;
-	for (i = 0; i < ways; i++)
-		target_map[i] = cfmws->interleave_targets[i];
 
 	struct resource *res __free(del_cxl_resource) = alloc_cxl_resource(
 		cfmws->base_hpa, cfmws->window_size, ctx->id++);
@@ -394,6 +391,8 @@ static int __cxl_parse_cfmws(struct acpi_cedt_cfmws *cfmws,
 		.end = cfmws->base_hpa + cfmws->window_size - 1,
 	};
 	cxld->interleave_ways = ways;
+	for (i = 0; i < ways; i++)
+		cxld->target_map[i] = cfmws->interleave_targets[i];
 	/*
 	 * Minimize the x1 granularity to advertise support for any
 	 * valid region granularity
@@ -424,7 +423,7 @@ static int __cxl_parse_cfmws(struct acpi_cedt_cfmws *cfmws,
 	if (cfmws->interleave_arithmetic == ACPI_CEDT_CFMWS_ARITHMETIC_XOR)
 		cxlrd->hpa_to_spa = cxl_xor_hpa_to_spa;
 
-	rc = cxl_decoder_add(cxld, target_map);
+	rc = cxl_decoder_add(cxld);
 	if (rc)
 		return rc;
 	return cxl_root_decoder_autoremove(dev, no_free_ptr(cxlrd));
diff --git a/drivers/cxl/core/hdm.c b/drivers/cxl/core/hdm.c
index 1e3b485c89051..a4b81f9ce8ab2 100644
--- a/drivers/cxl/core/hdm.c
+++ b/drivers/cxl/core/hdm.c
@@ -18,12 +18,11 @@
 
 DECLARE_RWSEM(cxl_dpa_rwsem);
 
-static int add_hdm_decoder(struct cxl_port *port, struct cxl_decoder *cxld,
-			   int *target_map)
+static int add_hdm_decoder(struct cxl_port *port, struct cxl_decoder *cxld)
 {
 	int rc;
 
-	rc = cxl_decoder_add_locked(cxld, target_map);
+	rc = cxl_decoder_add_locked(cxld);
 	if (rc) {
 		put_device(&cxld->dev);
 		dev_err(&port->dev, "Failed to add decoder\n");
@@ -50,7 +49,6 @@ int devm_cxl_add_passthrough_decoder(struct cxl_port *port)
 {
 	struct cxl_switch_decoder *cxlsd;
 	struct cxl_dport *dport = NULL;
-	int single_port_map[1];
 	unsigned long index;
 	struct cxl_hdm *cxlhdm = dev_get_drvdata(&port->dev);
 
@@ -69,9 +67,9 @@ int devm_cxl_add_passthrough_decoder(struct cxl_port *port)
 
 	xa_for_each(&port->dports, index, dport)
 		break;
-	single_port_map[0] = dport->port_id;
+	cxlsd->cxld.target_map[0] = dport->port_id;
 
-	return add_hdm_decoder(port, &cxlsd->cxld, single_port_map);
+	return add_hdm_decoder(port, &cxlsd->cxld);
 }
 EXPORT_SYMBOL_NS_GPL(devm_cxl_add_passthrough_decoder, CXL);
 
@@ -825,7 +823,7 @@ static int cxl_setup_hdm_decoder_from_dvsec(
 }
 
 static int init_hdm_decoder(struct cxl_port *port, struct cxl_decoder *cxld,
-			    int *target_map, void __iomem *hdm, int which,
+			    void __iomem *hdm, int which,
 			    u64 *dpa_base, struct cxl_endpoint_dvsec_info *info)
 {
 	struct cxl_endpoint_decoder *cxled = NULL;
@@ -954,7 +952,7 @@ static int init_hdm_decoder(struct cxl_port *port, struct cxl_decoder *cxld,
 		hi = readl(hdm + CXL_HDM_DECODER0_TL_HIGH(which));
 		target_list.value = (hi << 32) + lo;
 		for (i = 0; i < cxld->interleave_ways; i++)
-			target_map[i] = target_list.target_id[i];
+			cxld->target_map[i] = target_list.target_id[i];
 
 		return 0;
 	}
@@ -1042,7 +1040,6 @@ int devm_cxl_enumerate_decoders(struct cxl_hdm *cxlhdm,
 	cxl_settle_decoders(cxlhdm);
 
 	for (i = 0; i < cxlhdm->decoder_count; i++) {
-		int target_map[CXL_DECODER_MAX_INTERLEAVE] = { 0 };
 		int rc, target_count = cxlhdm->target_count;
 		struct cxl_decoder *cxld;
 
@@ -1070,8 +1067,7 @@ int devm_cxl_enumerate_decoders(struct cxl_hdm *cxlhdm,
 			cxld = &cxlsd->cxld;
 		}
 
-		rc = init_hdm_decoder(port, cxld, target_map, hdm, i,
-				      &dpa_base, info);
+		rc = init_hdm_decoder(port, cxld, hdm, i, &dpa_base, info);
 		if (rc) {
 			dev_warn(&port->dev,
 				 "Failed to initialize decoder%d.%d\n",
@@ -1079,7 +1075,7 @@ int devm_cxl_enumerate_decoders(struct cxl_hdm *cxlhdm,
 			put_device(&cxld->dev);
 			return rc;
 		}
-		rc = add_hdm_decoder(port, cxld, target_map);
+		rc = add_hdm_decoder(port, cxld);
 		if (rc) {
 			dev_warn(&port->dev,
 				 "Failed to add decoder%d.%d\n", port->id, i);
diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
index 723574f58f48c..5b586c60c77fe 100644
--- a/drivers/cxl/core/port.c
+++ b/drivers/cxl/core/port.c
@@ -1715,13 +1715,11 @@ struct cxl_port *cxl_mem_find_port(struct cxl_memdev *cxlmd,
 EXPORT_SYMBOL_NS_GPL(cxl_mem_find_port, CXL);
 
 static int decoder_populate_targets(struct cxl_switch_decoder *cxlsd,
-				    struct cxl_port *port, int *target_map)
+				    struct cxl_port *port)
 {
+	struct cxl_decoder *cxld = &cxlsd->cxld;
 	int i;
 
-	if (!target_map)
-		return 0;
-
 	device_lock_assert(&port->dev);
 
 	if (xa_empty(&port->dports))
@@ -1729,7 +1727,7 @@ static int decoder_populate_targets(struct cxl_switch_decoder *cxlsd,
 
 	guard(rwsem_write)(&cxl_region_rwsem);
 	for (i = 0; i < cxlsd->cxld.interleave_ways; i++) {
-		struct cxl_dport *dport = find_dport(port, target_map[i]);
+		struct cxl_dport *dport = find_dport(port, cxld->target_map[i]);
 
 		if (!dport)
 			return -ENXIO;
@@ -1921,9 +1919,6 @@ EXPORT_SYMBOL_NS_GPL(cxl_endpoint_decoder_alloc, CXL);
 /**
  * cxl_decoder_add_locked - Add a decoder with targets
  * @cxld: The cxl decoder allocated by cxl_<type>_decoder_alloc()
- * @target_map: A list of downstream ports that this decoder can direct memory
- *              traffic to. These numbers should correspond with the port number
- *              in the PCIe Link Capabilities structure.
  *
  * Certain types of decoders may not have any targets. The main example of this
  * is an endpoint device. A more awkward example is a hostbridge whose root
@@ -1937,7 +1932,7 @@ EXPORT_SYMBOL_NS_GPL(cxl_endpoint_decoder_alloc, CXL);
  * Return: Negative error code if the decoder wasn't properly configured; else
  *	   returns 0.
  */
-int cxl_decoder_add_locked(struct cxl_decoder *cxld, int *target_map)
+int cxl_decoder_add_locked(struct cxl_decoder *cxld)
 {
 	struct cxl_port *port;
 	struct device *dev;
@@ -1958,7 +1953,7 @@ int cxl_decoder_add_locked(struct cxl_decoder *cxld, int *target_map)
 	if (!is_endpoint_decoder(dev)) {
 		struct cxl_switch_decoder *cxlsd = to_cxl_switch_decoder(dev);
 
-		rc = decoder_populate_targets(cxlsd, port, target_map);
+		rc = decoder_populate_targets(cxlsd, port);
 		if (rc && (cxld->flags & CXL_DECODER_F_ENABLE)) {
 			dev_err(&port->dev,
 				"Failed to populate active decoder targets\n");
@@ -1977,9 +1972,6 @@ EXPORT_SYMBOL_NS_GPL(cxl_decoder_add_locked, CXL);
 /**
  * cxl_decoder_add - Add a decoder with targets
  * @cxld: The cxl decoder allocated by cxl_<type>_decoder_alloc()
- * @target_map: A list of downstream ports that this decoder can direct memory
- *              traffic to. These numbers should correspond with the port number
- *              in the PCIe Link Capabilities structure.
  *
  * This is the unlocked variant of cxl_decoder_add_locked().
  * See cxl_decoder_add_locked().
@@ -1987,7 +1979,7 @@ EXPORT_SYMBOL_NS_GPL(cxl_decoder_add_locked, CXL);
  * Context: Process context. Takes and releases the device lock of the port that
  *	    owns the @cxld.
  */
-int cxl_decoder_add(struct cxl_decoder *cxld, int *target_map)
+int cxl_decoder_add(struct cxl_decoder *cxld)
 {
 	struct cxl_port *port;
 
@@ -2000,7 +1992,7 @@ int cxl_decoder_add(struct cxl_decoder *cxld, int *target_map)
 	port = to_cxl_port(cxld->dev.parent);
 
 	guard(device)(&port->dev);
-	return cxl_decoder_add_locked(cxld, target_map);
+	return cxl_decoder_add_locked(cxld);
 }
 EXPORT_SYMBOL_NS_GPL(cxl_decoder_add, CXL);
 
diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
index 15253e5c28d60..e1c9e121b7c64 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -1478,8 +1478,10 @@ static int cxl_port_setup_targets(struct cxl_port *port,
 				cxl_rr->nr_targets_set);
 			return -ENXIO;
 		}
-	} else
+	} else {
 		cxlsd->target[cxl_rr->nr_targets_set] = ep->dport;
+		cxlsd->cxld.target_map[cxl_rr->nr_targets_set] = ep->dport->port_id;
+	}
 	inc = 1;
 out_target_set:
 	cxl_rr->nr_targets_set += inc;
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index 22cd757b71936..e3747c619ee11 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -358,6 +358,9 @@ enum cxl_decoder_type {
  * @target_type: accelerator vs expander (type2 vs type3) selector
  * @region: currently assigned region for this decoder
  * @flags: memory type capabilities and locking
+ * @target_map: cached copy of hardware port-id list, available at init
+ *              before all @dport objects have been instantiated. While
+ *              dport id is 8bit, CFMWS interleave targets are 32bits.
  * @commit: device/decoder-type specific callback to commit settings to hw
  * @reset: device/decoder-type specific callback to reset hw settings
 */
@@ -370,6 +373,7 @@ struct cxl_decoder {
 	enum cxl_decoder_type target_type;
 	struct cxl_region *region;
 	unsigned long flags;
+	u32 target_map[CXL_DECODER_MAX_INTERLEAVE];
 	int (*commit)(struct cxl_decoder *cxld);
 	void (*reset)(struct cxl_decoder *cxld);
 };
@@ -798,9 +802,9 @@ struct cxl_root_decoder *cxl_root_decoder_alloc(struct cxl_port *port,
 						unsigned int nr_targets);
 struct cxl_switch_decoder *cxl_switch_decoder_alloc(struct cxl_port *port,
 						    unsigned int nr_targets);
-int cxl_decoder_add(struct cxl_decoder *cxld, int *target_map);
+int cxl_decoder_add(struct cxl_decoder *cxld);
 struct cxl_endpoint_decoder *cxl_endpoint_decoder_alloc(struct cxl_port *port);
-int cxl_decoder_add_locked(struct cxl_decoder *cxld, int *target_map);
+int cxl_decoder_add_locked(struct cxl_decoder *cxld);
 int cxl_decoder_autoremove(struct device *host, struct cxl_decoder *cxld);
 static inline int cxl_root_decoder_autoremove(struct device *host,
 					      struct cxl_root_decoder *cxlrd)
diff --git a/tools/testing/cxl/test/cxl.c b/tools/testing/cxl/test/cxl.c
index b9236c6d30d9d..49e8b82004cb5 100644
--- a/tools/testing/cxl/test/cxl.c
+++ b/tools/testing/cxl/test/cxl.c
@@ -654,7 +654,7 @@ static int mock_cxl_add_passthrough_decoder(struct cxl_port *port)
 
 
 struct target_map_ctx {
-	int *target_map;
+	u32 *target_map;
 	int index;
 	int target_count;
 };
@@ -866,9 +866,7 @@ static int mock_cxl_enumerate_decoders(struct cxl_hdm *cxlhdm,
 		target_count = NR_CXL_SWITCH_PORTS;
 
 	for (i = 0; i < NR_CXL_PORT_DECODERS; i++) {
-		int target_map[CXL_DECODER_MAX_INTERLEAVE] = { 0 };
 		struct target_map_ctx ctx = {
-			.target_map = target_map,
 			.target_count = target_count,
 		};
 		struct cxl_decoder *cxld;
@@ -897,6 +895,8 @@ static int mock_cxl_enumerate_decoders(struct cxl_hdm *cxlhdm,
 			cxld = &cxled->cxld;
 		}
 
+		ctx.target_map = cxld->target_map;
+
 		mock_init_hdm_decoder(cxld);
 
 		if (target_count) {
@@ -908,7 +908,7 @@ static int mock_cxl_enumerate_decoders(struct cxl_hdm *cxlhdm,
 			}
 		}
 
-		rc = cxl_decoder_add_locked(cxld, target_map);
+		rc = cxl_decoder_add_locked(cxld);
 		if (rc) {
 			put_device(&cxld->dev);
 			dev_err(&port->dev, "Failed to add decoder\n");
-- 
2.53.0



