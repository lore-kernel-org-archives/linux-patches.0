Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213926;
	b=h42eA/cEMju/SK1yoxrulHluaTpPKNh5N5+iojlrfvd/3+GTYMh9gIV+oRXp0zkzyV6o
	 eETbk03qAK56+4bVsCyTHThJEn02Ow5lUo0PfWANZlI2pTfTAj/2VU6aL/zay7NTztZLQ
	 I5B4IS8hDs+CJvcq/ohjKy5Tp+l63+2IDC4IStRadx5ZN7RYlpavHOZV4GVTMfA6gOHMu
	 x37tmRrWCMdHUiTTUQGm0wIDAq0xmIA6YS2xgOQ/+dhNjXO/vRl+HJBL45yYJSc3koOeS
	 cW5fe1oF1GgSDRb54NkH0EeEOaIIhxjn9ZPomVk8zB6f9Z5iNystY+P3rW3wX+cA8QA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213926;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Xi/IVSoB6jqIl0SyRRTCiGJmDicgQWVJYmMG4IMtf8o=;
	b=0osnWz1FWBMx88V3Cu26OjtUBYXVcth0YiU9B4SdNqIR0VikvbCyXlNM9SXQCChn7vvL
	 Q8QTVGtNW0GDnPo4fS2KgqXHeVcxoZitJOxA3DO6XtC16uC1izeOFhWVkqwuGs3X/XEKc
	 W/AsPVxC89iA6I0INdC5Af/iA+niBUpd9RLYqPIh5S9Q60SaXe0LHQp4Rn3+RCG7Cf4Qt
	 tBknESIQGqvEGiOoG5e18wkCzWdMpxTj6Nc47FRQ0sYj6roOruMe/xjH8mN18nWMwudPK
	 23a7/71gjkvFgrWhqf0EhqMyG7ND60INSr3ktxO3QaynSdp+dUfZCIQbT0vgKLbwyKQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RmVjt02T;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0468C606A31A;
	Wed, 28 Oct 2026 18:58:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RmVjt02T
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 162E71F01825;
	Wed, 28 Oct 2026 18:58:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213925;
	bh=Xi/IVSoB6jqIl0SyRRTCiGJmDicgQWVJYmMG4IMtf8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RmVjt02T+939RdOaPqVo4s7d/DqS1TqLsKahyAmYYod956On0jQVDMJAk9GGh47VP
	 tMm6cWUbynFXamy+2Iji5K/I8qiiwQMeiC2a0oOWq6uEbz5DvjY+nI6xJoqDaLKbwR
	 ulMytco5lEVP7YtC38yWPkMTgIO8yjEci09OayhA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0679/1887] cxl/port: Fix use-after-free, permit out-of-order decoder shutdown
Date: Wed, 28 Oct 2026 17:46:15 +0100
Message-ID: <20261028170514.862431679@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Williams <dan.j.williams@intel.com>

[ Upstream commit 101c268bd2f37e965a5468353e62d154db38838e ]

In support of investigating an initialization failure report [1],
cxl_test was updated to register mock memory-devices after the mock
root-port/bus device had been registered. That led to cxl_test crashing
with a use-after-free bug with the following signature:

    cxl_port_attach_region: cxl region3: cxl_host_bridge.0:port3 decoder3.0 add: mem0:decoder7.0 @ 0 next: cxl_switch_uport.0 nr_eps: 1 nr_targets: 1
    cxl_port_attach_region: cxl region3: cxl_host_bridge.0:port3 decoder3.0 add: mem4:decoder14.0 @ 1 next: cxl_switch_uport.0 nr_eps: 2 nr_targets: 1
    cxl_port_setup_targets: cxl region3: cxl_switch_uport.0:port6 target[0] = cxl_switch_dport.0 for mem0:decoder7.0 @ 0
1)  cxl_port_setup_targets: cxl region3: cxl_switch_uport.0:port6 target[1] = cxl_switch_dport.4 for mem4:decoder14.0 @ 1
    [..]
    cxld_unregister: cxl decoder14.0:
    cxl_region_decode_reset: cxl_region region3:
    mock_decoder_reset: cxl_port port3: decoder3.0 reset
2)  mock_decoder_reset: cxl_port port3: decoder3.0: out of order reset, expected decoder3.1
    cxl_endpoint_decoder_release: cxl decoder14.0:
    [..]
    cxld_unregister: cxl decoder7.0:
3)  cxl_region_decode_reset: cxl_region region3:
    Oops: general protection fault, probably for non-canonical address 0x6b6b6b6b6b6b6bc3: 0000 [#1] PREEMPT SMP PTI
    [..]
    RIP: 0010:to_cxl_port+0x8/0x60 [cxl_core]
    [..]
    Call Trace:
     <TASK>
     cxl_region_decode_reset+0x69/0x190 [cxl_core]
     cxl_region_detach+0xe8/0x210 [cxl_core]
     cxl_decoder_kill_region+0x27/0x40 [cxl_core]
     cxld_unregister+0x5d/0x60 [cxl_core]

At 1) a region has been established with 2 endpoint decoders (7.0 and
14.0). Those endpoints share a common switch-decoder in the topology
(3.0). At teardown, 2), decoder14.0 is the first to be removed and hits
the "out of order reset case" in the switch decoder. The effect though
is that region3 cleanup is aborted leaving it in-tact and
referencing decoder14.0. At 3) the second attempt to teardown region3
trips over the stale decoder14.0 object which has long since been
deleted.

The fix here is to recognize that the CXL specification places no
mandate on in-order shutdown of switch-decoders, the driver enforces
in-order allocation, and hardware enforces in-order commit. So, rather
than fail and leave objects dangling, always remove them.

In support of making cxl_region_decode_reset() always succeed,
cxl_region_invalidate_memregion() failures are turned into warnings.
Crashing the kernel is ok there since system integrity is at risk if
caches cannot be managed around physical address mutation events like
CXL region destruction.

A new device_for_each_child_reverse_from() is added to cleanup
port->commit_end after all dependent decoders have been disabled. In
other words if decoders are allocated 0->1->2 and disabled 1->2->0 then
port->commit_end only decrements from 2 after 2 has been disabled, and
it decrements all the way to zero since 1 was disabled previously.

Link: http://lore.kernel.org/20241004212504.1246-1-gourry@gourry.net [1]
Cc: stable@vger.kernel.org
Fixes: 176baefb2eb5 ("cxl/hdm: Commit decoder state to hardware")
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Zijun Hu <quic_zijuhu@quicinc.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Link: https://patch.msgid.link/172964782781.81806.17902885593105284330.stgit@dwillia2-xfh.jf.intel.com
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/core.c          | 35 ++++++++++++++++++++++++++
 drivers/cxl/core/hdm.c       | 48 ++++++++++++++++++++++++++++++------
 drivers/cxl/core/region.c    | 29 ++++++----------------
 drivers/cxl/cxl.h            |  3 ++-
 include/linux/device.h       |  3 +++
 tools/testing/cxl/test/cxl.c | 14 ++++-------
 6 files changed, 93 insertions(+), 39 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 00737fc051575..6427d8e43347b 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -4076,6 +4076,41 @@ int device_for_each_child_reverse(struct device *parent, void *data,
 }
 EXPORT_SYMBOL_GPL(device_for_each_child_reverse);
 
+/**
+ * device_for_each_child_reverse_from - device child iterator in reversed order.
+ * @parent: parent struct device.
+ * @from: optional starting point in child list
+ * @fn: function to be called for each device.
+ * @data: data for the callback.
+ *
+ * Iterate over @parent's child devices, starting at @from, and call @fn
+ * for each, passing it @data. This helper is identical to
+ * device_for_each_child_reverse() when @from is NULL.
+ *
+ * @fn is checked each iteration. If it returns anything other than 0,
+ * iteration stop and that value is returned to the caller of
+ * device_for_each_child_reverse_from();
+ */
+int device_for_each_child_reverse_from(struct device *parent,
+				       struct device *from, const void *data,
+				       int (*fn)(struct device *, const void *))
+{
+	struct klist_iter i;
+	struct device *child;
+	int error = 0;
+
+	if (!parent->p)
+		return 0;
+
+	klist_iter_init_node(&parent->p->klist_children, &i,
+			     (from ? &from->p->knode_parent : NULL));
+	while ((child = prev_device(&i)) && !error)
+		error = fn(child, data);
+	klist_iter_exit(&i);
+	return error;
+}
+EXPORT_SYMBOL_GPL(device_for_each_child_reverse_from);
+
 /**
  * device_find_child - device iterator for locating a particular device.
  * @parent: parent struct device
diff --git a/drivers/cxl/core/hdm.c b/drivers/cxl/core/hdm.c
index 7d48f5a575ceb..580cf7834cf11 100644
--- a/drivers/cxl/core/hdm.c
+++ b/drivers/cxl/core/hdm.c
@@ -641,7 +641,42 @@ static int cxl_decoder_commit(struct cxl_decoder *cxld)
 	return 0;
 }
 
-static int cxl_decoder_reset(struct cxl_decoder *cxld)
+static int commit_reap(struct device *dev, const void *data)
+{
+	struct cxl_port *port = to_cxl_port(dev->parent);
+	struct cxl_decoder *cxld;
+
+	if (!is_switch_decoder(dev) && !is_endpoint_decoder(dev))
+		return 0;
+
+	cxld = to_cxl_decoder(dev);
+	if (port->commit_end == cxld->id &&
+	    ((cxld->flags & CXL_DECODER_F_ENABLE) == 0)) {
+		port->commit_end--;
+		dev_dbg(&port->dev, "reap: %s commit_end: %d\n",
+			dev_name(&cxld->dev), port->commit_end);
+	}
+
+	return 0;
+}
+
+void cxl_port_commit_reap(struct cxl_decoder *cxld)
+{
+	struct cxl_port *port = to_cxl_port(cxld->dev.parent);
+
+	/*
+	 * Once the highest committed decoder is disabled, free any other
+	 * decoders that were pinned allocated by out-of-order release.
+	 */
+	port->commit_end--;
+	dev_dbg(&port->dev, "reap: %s commit_end: %d\n", dev_name(&cxld->dev),
+		port->commit_end);
+	device_for_each_child_reverse_from(&port->dev, &cxld->dev, NULL,
+					   commit_reap);
+}
+EXPORT_SYMBOL_NS_GPL(cxl_port_commit_reap, CXL);
+
+static void cxl_decoder_reset(struct cxl_decoder *cxld)
 {
 	struct cxl_port *port = to_cxl_port(cxld->dev.parent);
 	struct cxl_hdm *cxlhdm = dev_get_drvdata(&port->dev);
@@ -650,14 +685,14 @@ static int cxl_decoder_reset(struct cxl_decoder *cxld)
 	u32 ctrl;
 
 	if ((cxld->flags & CXL_DECODER_F_ENABLE) == 0)
-		return 0;
+		return;
 
-	if (port->commit_end != id) {
+	if (port->commit_end == id)
+		cxl_port_commit_reap(cxld);
+	else
 		dev_dbg(&port->dev,
 			"%s: out of order reset, expected decoder%d.%d\n",
 			dev_name(&cxld->dev), port->id, port->commit_end);
-		return -EBUSY;
-	}
 
 	down_read(&cxl_dpa_rwsem);
 	ctrl = readl(hdm + CXL_HDM_DECODER0_CTRL_OFFSET(id));
@@ -670,10 +705,7 @@ static int cxl_decoder_reset(struct cxl_decoder *cxld)
 	writel(0, hdm + CXL_HDM_DECODER0_BASE_LOW_OFFSET(id));
 	up_read(&cxl_dpa_rwsem);
 
-	port->commit_end--;
 	cxld->flags &= ~CXL_DECODER_F_ENABLE;
-
-	return 0;
 }
 
 static int init_hdm_decoder(struct cxl_port *port, struct cxl_decoder *cxld,
diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
index 0e03c4908050b..cd53738a628de 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -121,7 +121,7 @@ static struct cxl_region_ref *cxl_rr_load(struct cxl_port *port,
 	return xa_load(&port->regions, (unsigned long)cxlr);
 }
 
-static int cxl_region_decode_reset(struct cxl_region *cxlr, int count)
+static void cxl_region_decode_reset(struct cxl_region *cxlr, int count)
 {
 	struct cxl_region_params *p = &cxlr->params;
 	int i;
@@ -131,7 +131,6 @@ static int cxl_region_decode_reset(struct cxl_region *cxlr, int count)
 		struct cxl_memdev *cxlmd = cxled_to_memdev(cxled);
 		struct cxl_port *iter = cxled_to_port(cxled);
 		struct cxl_ep *ep;
-		int rc = 0;
 
 		while (!is_cxl_root(to_cxl_port(iter->dev.parent)))
 			iter = to_cxl_port(iter->dev.parent);
@@ -144,17 +143,11 @@ static int cxl_region_decode_reset(struct cxl_region *cxlr, int count)
 			cxl_rr = cxl_rr_load(iter, cxlr);
 			cxld = cxl_rr->decoder;
 			if (cxld->reset)
-				rc = cxld->reset(cxld);
-			if (rc)
-				return rc;
+				cxld->reset(cxld);
 		}
 
-		rc = cxled->cxld.reset(&cxled->cxld);
-		if (rc)
-			return rc;
+		cxled->cxld.reset(&cxled->cxld);
 	}
-
-	return 0;
 }
 
 static int cxl_region_decode_commit(struct cxl_region *cxlr)
@@ -244,8 +237,10 @@ static ssize_t commit_store(struct device *dev, struct device_attribute *attr,
 		 * The lock was dropped, so need to revalidate that the reset is
 		 * still pending.
 		 */
-		if (p->state == CXL_CONFIG_RESET_PENDING)
-			rc = cxl_region_decode_reset(cxlr, p->interleave_ways);
+		if (p->state == CXL_CONFIG_RESET_PENDING) {
+			cxl_region_decode_reset(cxlr, p->interleave_ways);
+			p->state = CXL_CONFIG_ACTIVE;
+		}
 	}
 
 	if (rc)
@@ -253,8 +248,6 @@ static ssize_t commit_store(struct device *dev, struct device_attribute *attr,
 
 	if (commit)
 		p->state = CXL_CONFIG_COMMIT;
-	else if (p->state == CXL_CONFIG_RESET_PENDING)
-		p->state = CXL_CONFIG_ACTIVE;
 
 out:
 	up_write(&cxl_region_rwsem);
@@ -1393,13 +1386,7 @@ static int cxl_region_detach(struct cxl_endpoint_decoder *cxled)
 	get_device(&cxlr->dev);
 
 	if (p->state > CXL_CONFIG_ACTIVE) {
-		/*
-		 * TODO: tear down all impacted regions if a device is
-		 * removed out of order
-		 */
-		rc = cxl_region_decode_reset(cxlr, p->interleave_ways);
-		if (rc)
-			goto out;
+		cxl_region_decode_reset(cxlr, p->interleave_ways);
 		p->state = CXL_CONFIG_ACTIVE;
 	}
 
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index 827fa94cddda1..0f3568071966d 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -273,7 +273,7 @@ struct cxl_decoder {
 	struct cxl_region *region;
 	unsigned long flags;
 	int (*commit)(struct cxl_decoder *cxld);
-	int (*reset)(struct cxl_decoder *cxld);
+	void (*reset)(struct cxl_decoder *cxld);
 };
 
 /*
@@ -555,6 +555,7 @@ static inline bool is_cxl_root(struct cxl_port *port)
 
 bool is_cxl_port(struct device *dev);
 struct cxl_port *to_cxl_port(struct device *dev);
+void cxl_port_commit_reap(struct cxl_decoder *cxld);
 struct pci_bus;
 int devm_cxl_register_pci_bus(struct device *host, struct device *uport,
 			      struct pci_bus *bus);
diff --git a/include/linux/device.h b/include/linux/device.h
index eae657af3a0e5..0e83be1bccc44 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -957,6 +957,9 @@ int device_for_each_child(struct device *dev, void *data,
 			  int (*fn)(struct device *dev, void *data));
 int device_for_each_child_reverse(struct device *dev, void *data,
 				  int (*fn)(struct device *dev, void *data));
+int device_for_each_child_reverse_from(struct device *parent,
+				       struct device *from, const void *data,
+				       int (*fn)(struct device *, const void *));
 struct device *device_find_child(struct device *dev, void *data,
 				 int (*match)(struct device *dev, void *data));
 struct device *device_find_child_by_name(struct device *parent,
diff --git a/tools/testing/cxl/test/cxl.c b/tools/testing/cxl/test/cxl.c
index 7be8bc4e4500e..37bd29e555903 100644
--- a/tools/testing/cxl/test/cxl.c
+++ b/tools/testing/cxl/test/cxl.c
@@ -533,26 +533,22 @@ static int mock_decoder_commit(struct cxl_decoder *cxld)
 	return 0;
 }
 
-static int mock_decoder_reset(struct cxl_decoder *cxld)
+static void mock_decoder_reset(struct cxl_decoder *cxld)
 {
 	struct cxl_port *port = to_cxl_port(cxld->dev.parent);
 	int id = cxld->id;
 
 	if ((cxld->flags & CXL_DECODER_F_ENABLE) == 0)
-		return 0;
+		return;
 
 	dev_dbg(&port->dev, "%s reset\n", dev_name(&cxld->dev));
-	if (port->commit_end != id) {
+	if (port->commit_end == id)
+		cxl_port_commit_reap(cxld);
+	else
 		dev_dbg(&port->dev,
 			"%s: out of order reset, expected decoder%d.%d\n",
 			dev_name(&cxld->dev), port->id, port->commit_end);
-		return -EBUSY;
-	}
-
-	port->commit_end--;
 	cxld->flags &= ~CXL_DECODER_F_ENABLE;
-
-	return 0;
 }
 
 static void default_mock_decoder(struct cxl_decoder *cxld)
-- 
2.53.0



