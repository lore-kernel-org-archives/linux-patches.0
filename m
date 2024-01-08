Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83BB14BA96;
	Mon,  8 Jan 2024 15:14:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gu6B3YgK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE540C433C7;
	Mon,  8 Jan 2024 15:14:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704726844;
	bh=JmPDRVkZkwsr7441rlN7Ya+z3BJKv2lhkoU/jZ9K89M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gu6B3YgKXNC8Hx1FsYBz5JDTxUCdga0MBqgo9dn151N3rc1fKEinSXGck4/AF4T9J
	 ShuMZ20aSpvDkew3QoQ+dYrdcTRSknd2PAypQ7opUlX7BVGnVX8hX1sTwa1kPfu/3Q
	 ybjiMy415RyB9XNQfaIjJpJyQvcQnibc9yvcqyO4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Williams <dan.j.williams@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Jim Harris <jim.harris@samsung.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 097/124] cxl: Add cxl_decoders_committed() helper
Date: Mon,  8 Jan 2024 16:08:43 +0100
Message-ID: <20240108150607.432358800@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240108150602.976232871@linuxfoundation.org>
References: <20240108150602.976232871@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Jiang <dave.jiang@intel.com>

[ Upstream commit 458ba8189cb4380aa6a6cc4d52ab067f80a64829 ]

Add a helper to retrieve the number of decoders committed for the port.
Replace all the open coding of the calculation with the helper.

Link: https://lore.kernel.org/linux-cxl/651c98472dfed_ae7e729495@dwillia2-xfh.jf.intel.com.notmuch/
Suggested-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Jim Harris <jim.harris@samsung.com>
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Link: https://lore.kernel.org/r/169747906849.272156.1729290904857372335.stgit@djiang5-mobl3
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Stable-dep-of: 5558b92e8d39 ("cxl/core: Always hold region_rwsem while reading poison lists")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/hdm.c    | 7 ++++---
 drivers/cxl/core/mbox.c   | 2 +-
 drivers/cxl/core/memdev.c | 4 ++--
 drivers/cxl/core/port.c   | 7 +++++++
 drivers/cxl/cxl.h         | 1 +
 5 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/cxl/core/hdm.c b/drivers/cxl/core/hdm.c
index 22829267ccd86..54a535f6736bd 100644
--- a/drivers/cxl/core/hdm.c
+++ b/drivers/cxl/core/hdm.c
@@ -634,10 +634,11 @@ static int cxl_decoder_commit(struct cxl_decoder *cxld)
 	if (cxld->flags & CXL_DECODER_F_ENABLE)
 		return 0;
 
-	if (port->commit_end + 1 != id) {
+	if (cxl_num_decoders_committed(port) != id) {
 		dev_dbg(&port->dev,
 			"%s: out of order commit, expected decoder%d.%d\n",
-			dev_name(&cxld->dev), port->id, port->commit_end + 1);
+			dev_name(&cxld->dev), port->id,
+			cxl_num_decoders_committed(port));
 		return -EBUSY;
 	}
 
@@ -847,7 +848,7 @@ static int init_hdm_decoder(struct cxl_port *port, struct cxl_decoder *cxld,
 			cxld->target_type = CXL_DECODER_HOSTONLYMEM;
 		else
 			cxld->target_type = CXL_DECODER_DEVMEM;
-		if (cxld->id != port->commit_end + 1) {
+		if (cxld->id != cxl_num_decoders_committed(port)) {
 			dev_warn(&port->dev,
 				 "decoder%d.%d: Committed out of order\n",
 				 port->id, cxld->id);
diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
index b91bb98869917..b12986b968da4 100644
--- a/drivers/cxl/core/mbox.c
+++ b/drivers/cxl/core/mbox.c
@@ -1200,7 +1200,7 @@ int cxl_mem_sanitize(struct cxl_memdev *cxlmd, u16 cmd)
 	 * Require an endpoint to be safe otherwise the driver can not
 	 * be sure that the device is unmapped.
 	 */
-	if (endpoint && endpoint->commit_end == -1)
+	if (endpoint && cxl_num_decoders_committed(endpoint) == 0)
 		rc = __cxl_mem_sanitize(mds, cmd);
 	else
 		rc = -EBUSY;
diff --git a/drivers/cxl/core/memdev.c b/drivers/cxl/core/memdev.c
index fed9573cf355e..fc5c2b414793b 100644
--- a/drivers/cxl/core/memdev.c
+++ b/drivers/cxl/core/memdev.c
@@ -231,7 +231,7 @@ int cxl_trigger_poison_list(struct cxl_memdev *cxlmd)
 	if (rc)
 		return rc;
 
-	if (port->commit_end == -1) {
+	if (cxl_num_decoders_committed(port) == 0) {
 		/* No regions mapped to this memdev */
 		rc = cxl_get_poison_by_memdev(cxlmd);
 	} else {
@@ -282,7 +282,7 @@ static struct cxl_region *cxl_dpa_to_region(struct cxl_memdev *cxlmd, u64 dpa)
 		.dpa = dpa,
 	};
 	port = cxlmd->endpoint;
-	if (port && is_cxl_endpoint(port) && port->commit_end != -1)
+	if (port && is_cxl_endpoint(port) && cxl_num_decoders_committed(port))
 		device_for_each_child(&port->dev, &ctx, __cxl_dpa_to_region);
 
 	return ctx.cxlr;
diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
index 1e0558d18b965..f430280fa6bd0 100644
--- a/drivers/cxl/core/port.c
+++ b/drivers/cxl/core/port.c
@@ -37,6 +37,13 @@ DECLARE_RWSEM(cxl_region_rwsem);
 static DEFINE_IDA(cxl_port_ida);
 static DEFINE_XARRAY(cxl_root_buses);
 
+int cxl_num_decoders_committed(struct cxl_port *port)
+{
+	lockdep_assert_held(&cxl_region_rwsem);
+
+	return port->commit_end + 1;
+}
+
 static ssize_t devtype_show(struct device *dev, struct device_attribute *attr,
 			    char *buf)
 {
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index b5b015b661eae..6c6afda0e4c61 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -679,6 +679,7 @@ static inline bool is_cxl_root(struct cxl_port *port)
 	return port->uport_dev == port->dev.parent;
 }
 
+int cxl_num_decoders_committed(struct cxl_port *port);
 bool is_cxl_port(const struct device *dev);
 struct cxl_port *to_cxl_port(const struct device *dev);
 struct pci_bus;
-- 
2.43.0



