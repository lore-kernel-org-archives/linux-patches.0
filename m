Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCADA15703C;
	Mon, 29 Jan 2024 17:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548017; cv=none; b=EALgHQJl1SVh7Lsc7VnubaPlGXHOylbB9XLdjQkvcMiudh/Eb64/tbMenEv6BaSaesBYqWXJbPGicIf8D+uQhvYYUlupDR69rmtdjoWLzfg4m7beVYc+3U13qTm/xzbhrDnNfmOyUqYlCNauHgZyZj2O4Lhsm60G4qoIaaS2qpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548017; c=relaxed/simple;
	bh=EqBEn/SWq9K8p2ImqcV9BerZy0oTzSinLCUfEOXDQU4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sSFK7nJtLk/ceQTFibDleUaU0M5Q3SRzlGoCNVBDotSroPLlEqYojK/tqummPZnpilF31y+ioZsIpRl6FCi42ihaRVUEq35EIweB4Mde3SnR0o/tJVdVpH84e6DO5bCCQU+Vp4LmFCaEMpwxwWFtxULS2pDpWRXWg5JPfCkYQT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z/BKlFb9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z/BKlFb9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BC98C433C7;
	Mon, 29 Jan 2024 17:06:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548017;
	bh=EqBEn/SWq9K8p2ImqcV9BerZy0oTzSinLCUfEOXDQU4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z/BKlFb9BTmrMYQjq2VFhb/Y70zxuU/1x0P0W7fmt3HpFQWFLe0I9trJZPrHEbFte
	 sZoUEvd9n8nt2rj6bw95dmyWLZl4V9Urw6XOjRhvXZqgSH5BCBDqddu7hxquyXSAgJ
	 Dw2j8S3QB6SMdutNX6wr2U/wSyFI7xYX6xNqCnr0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Vijendar Mukunda <Vijendar.Mukunda@amd.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 001/346] soundwire: bus: introduce controller_id
Date: Mon, 29 Jan 2024 09:00:32 -0800
Message-ID: <20240129170016.397787793@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit 6543ac13c623f906200dfd3f1c407d8d333b6995 ]

The existing SoundWire support misses a clear Controller/Manager
hiearchical definition to deal with all variants across SOC vendors.

a) Intel platforms have one controller with 4 or more Managers.
b) AMD platforms have two controllers with one Manager each, but due
to BIOS issues use two different link_id values within the scope of a
single controller.
c) QCOM platforms have one or more controller with one Manager each.

This patch adds a 'controller_id' which can be set by higher
levels. If assigned to -1, the controller_id will be set to the
system-unique IDA-assigned bus->id.

The main change is that the bus->id is no longer used for any device
name, which makes the definition completely predictable and not
dependent on any enumeration order. The bus->id is only used to insert
the Managers in the stream rt context.

Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Vijendar Mukunda <Vijendar.Mukunda@amd.com>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Tested-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/stable/20231017160933.12624-2-pierre-louis.bossart%40linux.intel.com
Tested-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20231017160933.12624-2-pierre-louis.bossart@linux.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Stable-dep-of: 8a8a9ac8a497 ("soundwire: fix initializing sysfs for same devices on different buses")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/amd_manager.c     | 8 ++++++++
 drivers/soundwire/bus.c             | 4 ++++
 drivers/soundwire/debugfs.c         | 2 +-
 drivers/soundwire/intel_auxdevice.c | 3 +++
 drivers/soundwire/master.c          | 2 +-
 drivers/soundwire/qcom.c            | 3 +++
 include/linux/soundwire/sdw.h       | 4 +++-
 7 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/drivers/soundwire/amd_manager.c b/drivers/soundwire/amd_manager.c
index 3a99f6dcdfaf..a3b1f4e6f0f9 100644
--- a/drivers/soundwire/amd_manager.c
+++ b/drivers/soundwire/amd_manager.c
@@ -927,6 +927,14 @@ static int amd_sdw_manager_probe(struct platform_device *pdev)
 	amd_manager->bus.clk_stop_timeout = 200;
 	amd_manager->bus.link_id = amd_manager->instance;
 
+	/*
+	 * Due to BIOS compatibility, the two links are exposed within
+	 * the scope of a single controller. If this changes, the
+	 * controller_id will have to be updated with drv_data
+	 * information.
+	 */
+	amd_manager->bus.controller_id = 0;
+
 	switch (amd_manager->instance) {
 	case ACP_SDW0:
 		amd_manager->num_dout_ports = AMD_SDW0_MAX_TX_PORTS;
diff --git a/drivers/soundwire/bus.c b/drivers/soundwire/bus.c
index 41b0d9adf68e..f3fec15c3112 100644
--- a/drivers/soundwire/bus.c
+++ b/drivers/soundwire/bus.c
@@ -22,6 +22,10 @@ static int sdw_get_id(struct sdw_bus *bus)
 		return rc;
 
 	bus->id = rc;
+
+	if (bus->controller_id == -1)
+		bus->controller_id = rc;
+
 	return 0;
 }
 
diff --git a/drivers/soundwire/debugfs.c b/drivers/soundwire/debugfs.c
index d1553cb77187..67abd7e52f09 100644
--- a/drivers/soundwire/debugfs.c
+++ b/drivers/soundwire/debugfs.c
@@ -20,7 +20,7 @@ void sdw_bus_debugfs_init(struct sdw_bus *bus)
 		return;
 
 	/* create the debugfs master-N */
-	snprintf(name, sizeof(name), "master-%d-%d", bus->id, bus->link_id);
+	snprintf(name, sizeof(name), "master-%d-%d", bus->controller_id, bus->link_id);
 	bus->debugfs = debugfs_create_dir(name, sdw_debugfs_root);
 }
 
diff --git a/drivers/soundwire/intel_auxdevice.c b/drivers/soundwire/intel_auxdevice.c
index 7f15e3549e53..93698532deac 100644
--- a/drivers/soundwire/intel_auxdevice.c
+++ b/drivers/soundwire/intel_auxdevice.c
@@ -234,6 +234,9 @@ static int intel_link_probe(struct auxiliary_device *auxdev,
 	cdns->instance = sdw->instance;
 	cdns->msg_count = 0;
 
+	/* single controller for all SoundWire links */
+	bus->controller_id = 0;
+
 	bus->link_id = auxdev->id;
 	bus->clk_stop_timeout = 1;
 
diff --git a/drivers/soundwire/master.c b/drivers/soundwire/master.c
index 9b05c9e25ebe..51abedbbaa66 100644
--- a/drivers/soundwire/master.c
+++ b/drivers/soundwire/master.c
@@ -145,7 +145,7 @@ int sdw_master_device_add(struct sdw_bus *bus, struct device *parent,
 	md->dev.fwnode = fwnode;
 	md->dev.dma_mask = parent->dma_mask;
 
-	dev_set_name(&md->dev, "sdw-master-%d", bus->id);
+	dev_set_name(&md->dev, "sdw-master-%d-%d", bus->controller_id, bus->link_id);
 
 	ret = device_register(&md->dev);
 	if (ret) {
diff --git a/drivers/soundwire/qcom.c b/drivers/soundwire/qcom.c
index a1e2d6c98186..8e027eee8b73 100644
--- a/drivers/soundwire/qcom.c
+++ b/drivers/soundwire/qcom.c
@@ -1624,6 +1624,9 @@ static int qcom_swrm_probe(struct platform_device *pdev)
 		}
 	}
 
+	/* FIXME: is there a DT-defined value to use ? */
+	ctrl->bus.controller_id = -1;
+
 	ret = sdw_bus_master_add(&ctrl->bus, dev, dev->fwnode);
 	if (ret) {
 		dev_err(dev, "Failed to register Soundwire controller (%d)\n",
diff --git a/include/linux/soundwire/sdw.h b/include/linux/soundwire/sdw.h
index 4f3d14bb1538..c383579a008b 100644
--- a/include/linux/soundwire/sdw.h
+++ b/include/linux/soundwire/sdw.h
@@ -886,7 +886,8 @@ struct sdw_master_ops {
  * struct sdw_bus - SoundWire bus
  * @dev: Shortcut to &bus->md->dev to avoid changing the entire code.
  * @md: Master device
- * @link_id: Link id number, can be 0 to N, unique for each Master
+ * @controller_id: system-unique controller ID. If set to -1, the bus @id will be used.
+ * @link_id: Link id number, can be 0 to N, unique for each Controller
  * @id: bus system-wide unique id
  * @slaves: list of Slaves on this bus
  * @assigned: Bitmap for Slave device numbers.
@@ -918,6 +919,7 @@ struct sdw_master_ops {
 struct sdw_bus {
 	struct device *dev;
 	struct sdw_master_device *md;
+	int controller_id;
 	unsigned int link_id;
 	int id;
 	struct list_head slaves;
-- 
2.43.0



