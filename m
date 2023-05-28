Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3200D569D
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:32:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B06FEC433D2;
	Sun, 28 May 2023 19:32:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685302361;
	bh=tlN1MXKmvWwtwLomffp7nqQLqUEEJ6ofhs2tEj/TMlo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eIXI7QVkBSfh4l8sqcVrB7I3bWusLYEuXDp9wLS9yXUDSiRDf0NE9M1nOfOeFGNe2
	 r6lmT064xaO5gxpshpQAMQHT3PpaaKz/bkN114DPkEyS/+SbD/I5n7KQXtUYPv6/c/
	 AwyMKFOSfmXssDV/G9ioDOxjdpwRQSb0HwRH3REw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Williams <dan.j.williams@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Dave Jiang <dave.jiang@intel.com>
Subject: [PATCH 6.3 104/127] cxl: Move cxl_await_media_ready() to before capacity info retrieval
Date: Sun, 28 May 2023 20:11:20 +0100
Message-Id: <20230528190839.661683140@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190836.161231414@linuxfoundation.org>
References: <20230528190836.161231414@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dave Jiang <dave.jiang@intel.com>

commit e764f12208b99ac7892c4e3f6bf88d71ca71036f upstream.

Move cxl_await_media_ready() to cxl_pci probe before driver starts issuing
IDENTIFY and retrieving memory device information to ensure that the
device is ready to provide the information. Allow cxl_pci_probe() to succeed
even if media is not ready. Cache the media failure in cxlds and don't ask
the device for any media information.

The rationale for proceeding in the !media_ready case is to allow for
mailbox operations to interrogate and/or remediate the device. After
media is repaired then rebinding the cxl_pci driver is expected to
restart the capacity scan.

Suggested-by: Dan Williams <dan.j.williams@intel.com>
Fixes: b39cb1052a5c ("cxl/mem: Register CXL memX devices")
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Link: https://lore.kernel.org/r/168445310026.3251520.8124296540679268206.stgit@djiang5-mobl3
[djbw: fixup cxl_test]
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cxl/core/mbox.c      |   15 ++++++++++-----
 drivers/cxl/cxlmem.h         |    2 ++
 drivers/cxl/mem.c            |    3 +++
 drivers/cxl/pci.c            |    6 ++++++
 drivers/cxl/port.c           |    6 ------
 tools/testing/cxl/test/mem.c |    1 +
 6 files changed, 22 insertions(+), 11 deletions(-)

--- a/drivers/cxl/core/mbox.c
+++ b/drivers/cxl/core/mbox.c
@@ -984,7 +984,7 @@ static int cxl_mem_get_partition_info(st
  * cxl_dev_state_identify() - Send the IDENTIFY command to the device.
  * @cxlds: The device data for the operation
  *
- * Return: 0 if identify was executed successfully.
+ * Return: 0 if identify was executed successfully or media not ready.
  *
  * This will dispatch the identify command to the device and on success populate
  * structures to be exported to sysfs.
@@ -996,6 +996,9 @@ int cxl_dev_state_identify(struct cxl_de
 	struct cxl_mbox_cmd mbox_cmd;
 	int rc;
 
+	if (!cxlds->media_ready)
+		return 0;
+
 	mbox_cmd = (struct cxl_mbox_cmd) {
 		.opcode = CXL_MBOX_OP_IDENTIFY,
 		.size_out = sizeof(id),
@@ -1065,10 +1068,12 @@ int cxl_mem_create_range_info(struct cxl
 				   cxlds->persistent_only_bytes, "pmem");
 	}
 
-	rc = cxl_mem_get_partition_info(cxlds);
-	if (rc) {
-		dev_err(dev, "Failed to query partition information\n");
-		return rc;
+	if (cxlds->media_ready) {
+		rc = cxl_mem_get_partition_info(cxlds);
+		if (rc) {
+			dev_err(dev, "Failed to query partition information\n");
+			return rc;
+		}
 	}
 
 	rc = add_dpa_res(dev, &cxlds->dpa_res, &cxlds->ram_res, 0,
--- a/drivers/cxl/cxlmem.h
+++ b/drivers/cxl/cxlmem.h
@@ -227,6 +227,7 @@ struct cxl_event_state {
  * @regs: Parsed register blocks
  * @cxl_dvsec: Offset to the PCIe device DVSEC
  * @rcd: operating in RCD mode (CXL 3.0 9.11.8 CXL Devices Attached to an RCH)
+ * @media_ready: Indicate whether the device media is usable
  * @payload_size: Size of space for payload
  *                (CXL 2.0 8.2.8.4.3 Mailbox Capabilities Register)
  * @lsa_size: Size of Label Storage Area
@@ -264,6 +265,7 @@ struct cxl_dev_state {
 	int cxl_dvsec;
 
 	bool rcd;
+	bool media_ready;
 	size_t payload_size;
 	size_t lsa_size;
 	struct mutex mbox_mutex; /* Protects device mailbox and firmware */
--- a/drivers/cxl/mem.c
+++ b/drivers/cxl/mem.c
@@ -104,6 +104,9 @@ static int cxl_mem_probe(struct device *
 	struct dentry *dentry;
 	int rc;
 
+	if (!cxlds->media_ready)
+		return -EBUSY;
+
 	/*
 	 * Someone is trying to reattach this device after it lost its port
 	 * connection (an endpoint port previously registered by this memdev was
--- a/drivers/cxl/pci.c
+++ b/drivers/cxl/pci.c
@@ -757,6 +757,12 @@ static int cxl_pci_probe(struct pci_dev
 	if (rc)
 		dev_dbg(&pdev->dev, "Failed to map RAS capability.\n");
 
+	rc = cxl_await_media_ready(cxlds);
+	if (rc == 0)
+		cxlds->media_ready = true;
+	else
+		dev_warn(&pdev->dev, "Media not active (%d)\n", rc);
+
 	rc = cxl_pci_setup_mailbox(cxlds);
 	if (rc)
 		return rc;
--- a/drivers/cxl/port.c
+++ b/drivers/cxl/port.c
@@ -117,12 +117,6 @@ static int cxl_endpoint_port_probe(struc
 	if (rc)
 		return rc;
 
-	rc = cxl_await_media_ready(cxlds);
-	if (rc) {
-		dev_err(&port->dev, "Media not active (%d)\n", rc);
-		return rc;
-	}
-
 	rc = devm_cxl_enumerate_decoders(cxlhdm, &info);
 	if (rc)
 		return rc;
--- a/tools/testing/cxl/test/mem.c
+++ b/tools/testing/cxl/test/mem.c
@@ -1010,6 +1010,7 @@ static int cxl_mock_mem_probe(struct pla
 	if (rc)
 		return rc;
 
+	cxlds->media_ready = true;
 	rc = cxl_dev_state_identify(cxlds);
 	if (rc)
 		return rc;


