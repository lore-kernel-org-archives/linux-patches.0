Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B50C13A411;
	Thu, 13 Jun 2024 11:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279965; cv=none; b=Fo+JuBe78KbqX4OQhB4OdKpHDCg/IcsXOapyfghrHxPgQFoALY5kbkfc9MWdXsqJ12Se6r0D6R06TM8eO5Qf0TgR648RpYg7Mu4VO4z4h3WkV9gEjE1YvV2FDK/8GZ1bml0eoDW5WJBA93Goi6hemFpFsnok4n94fg4RECGauVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279965; c=relaxed/simple;
	bh=tC3fdMQTBXNSCOHC5eUd+Tb5Pn1W6wAtNsZlHA8WyY8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=clAhuUgEmbUGswVs584yifCny+qd1qFV7Hjmf/Ie6wO+3Oltwdi45Fah5eYtziqcBN65yiDP3k/2iV3wrkeG4+aTJyxjVWSNVDRArK4SZnMKQ8gM2H2Mo+STzMWHRJHo/yXv0RkFOST1Pq0j11iV40KPPc8gS0VPsY9ohOzW4Zs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MnFJZczO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MnFJZczO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84158C2BBFC;
	Thu, 13 Jun 2024 11:59:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279964;
	bh=tC3fdMQTBXNSCOHC5eUd+Tb5Pn1W6wAtNsZlHA8WyY8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MnFJZczOP233I5GqDgkZlyBKnbzg2Ez6cctKGBVka2zWyPA5hGB8N1BaM3RHmbXj7
	 J8bga3Jt/rI41N9TFDjsdatzqjL3piveS3GYOn6jZkFezKW77UVbFzodsSY2zTq1dW
	 vK3wq3sTI3Ff9XZbvUrqrLko1TT2aDWRKxVlD3no=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 097/202] soundwire: cadence/intel: simplify PDI/port mapping
Date: Thu, 13 Jun 2024 13:33:15 +0200
Message-ID: <20240613113231.511118619@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.759341286@linuxfoundation.org>
References: <20240613113227.759341286@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit 57a34790cd2cab02c3336fe96cfa33b9b65ed2ee ]

The existing Linux code uses a 1:1 mapping between ports and PDIs, but
still has an independent allocation of ports and PDIs.

Let's simplify the code and remove the port layer by only using PDIs.

This patch does not change any functionality, just removes unnecessary
code.

This will also allow for further simplifications where the PDIs are
not dynamically allocated but instead described in a topology file.

Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20190916192348.467-5-pierre-louis.bossart@linux.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Stable-dep-of: 8ee1b439b154 ("soundwire: cadence: fix invalid PDI offset")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/cadence_master.c | 110 ++++--------------------
 drivers/soundwire/cadence_master.h |  32 ++-----
 drivers/soundwire/intel.c          | 133 ++++++-----------------------
 3 files changed, 51 insertions(+), 224 deletions(-)

diff --git a/drivers/soundwire/cadence_master.c b/drivers/soundwire/cadence_master.c
index f7d0f63921dc2..62b8f233cdcf8 100644
--- a/drivers/soundwire/cadence_master.c
+++ b/drivers/soundwire/cadence_master.c
@@ -869,7 +869,8 @@ int sdw_cdns_pdi_init(struct sdw_cdns *cdns,
 		      struct sdw_cdns_stream_config config)
 {
 	struct sdw_cdns_streams *stream;
-	int offset, i, ret;
+	int offset;
+	int ret;
 
 	cdns->pcm.num_bd = config.pcm_bd;
 	cdns->pcm.num_in = config.pcm_in;
@@ -936,18 +937,6 @@ int sdw_cdns_pdi_init(struct sdw_cdns *cdns,
 	stream->num_pdi = stream->num_bd + stream->num_in + stream->num_out;
 	cdns->num_ports += stream->num_pdi;
 
-	cdns->ports = devm_kcalloc(cdns->dev, cdns->num_ports,
-				   sizeof(*cdns->ports), GFP_KERNEL);
-	if (!cdns->ports) {
-		ret = -ENOMEM;
-		return ret;
-	}
-
-	for (i = 0; i < cdns->num_ports; i++) {
-		cdns->ports[i].assigned = false;
-		cdns->ports[i].num = i + 1; /* Port 0 reserved for bulk */
-	}
-
 	return 0;
 }
 EXPORT_SYMBOL(sdw_cdns_pdi_init);
@@ -1239,13 +1228,11 @@ static struct sdw_cdns_pdi *cdns_find_pdi(struct sdw_cdns *cdns,
  * sdw_cdns_config_stream: Configure a stream
  *
  * @cdns: Cadence instance
- * @port: Cadence data port
  * @ch: Channel count
  * @dir: Data direction
  * @pdi: PDI to be used
  */
 void sdw_cdns_config_stream(struct sdw_cdns *cdns,
-			    struct sdw_cdns_port *port,
 			    u32 ch, u32 dir, struct sdw_cdns_pdi *pdi)
 {
 	u32 offset, val = 0;
@@ -1253,89 +1240,26 @@ void sdw_cdns_config_stream(struct sdw_cdns *cdns,
 	if (dir == SDW_DATA_DIR_RX)
 		val = CDNS_PORTCTRL_DIRN;
 
-	offset = CDNS_PORTCTRL + port->num * CDNS_PORT_OFFSET;
+	offset = CDNS_PORTCTRL + pdi->num * CDNS_PORT_OFFSET;
 	cdns_updatel(cdns, offset, CDNS_PORTCTRL_DIRN, val);
 
-	val = port->num;
+	val = pdi->num;
 	val |= ((1 << ch) - 1) << SDW_REG_SHIFT(CDNS_PDI_CONFIG_CHANNEL);
 	cdns_writel(cdns, CDNS_PDI_CONFIG(pdi->num), val);
 }
 EXPORT_SYMBOL(sdw_cdns_config_stream);
 
 /**
- * cdns_get_num_pdi() - Get number of PDIs required
- *
- * @cdns: Cadence instance
- * @pdi: PDI to be used
- * @num: Number of PDIs
- * @ch_count: Channel count
- */
-static int cdns_get_num_pdi(struct sdw_cdns *cdns,
-			    struct sdw_cdns_pdi *pdi,
-			    unsigned int num, u32 ch_count)
-{
-	int i, pdis = 0;
-
-	for (i = 0; i < num; i++) {
-		if (pdi[i].assigned)
-			continue;
-
-		if (pdi[i].ch_count < ch_count)
-			ch_count -= pdi[i].ch_count;
-		else
-			ch_count = 0;
-
-		pdis++;
-
-		if (!ch_count)
-			break;
-	}
-
-	if (ch_count)
-		return 0;
-
-	return pdis;
-}
-
-/**
- * sdw_cdns_get_stream() - Get stream information
- *
- * @cdns: Cadence instance
- * @stream: Stream to be allocated
- * @ch: Channel count
- * @dir: Data direction
- */
-int sdw_cdns_get_stream(struct sdw_cdns *cdns,
-			struct sdw_cdns_streams *stream,
-			u32 ch, u32 dir)
-{
-	int pdis = 0;
-
-	if (dir == SDW_DATA_DIR_RX)
-		pdis = cdns_get_num_pdi(cdns, stream->in, stream->num_in, ch);
-	else
-		pdis = cdns_get_num_pdi(cdns, stream->out, stream->num_out, ch);
-
-	/* check if we found PDI, else find in bi-directional */
-	if (!pdis)
-		pdis = cdns_get_num_pdi(cdns, stream->bd, stream->num_bd, ch);
-
-	return pdis;
-}
-EXPORT_SYMBOL(sdw_cdns_get_stream);
-
-/**
- * sdw_cdns_alloc_stream() - Allocate a stream
+ * sdw_cdns_alloc_pdi() - Allocate a PDI
  *
  * @cdns: Cadence instance
  * @stream: Stream to be allocated
- * @port: Cadence data port
  * @ch: Channel count
  * @dir: Data direction
  */
-int sdw_cdns_alloc_stream(struct sdw_cdns *cdns,
-			  struct sdw_cdns_streams *stream,
-			  struct sdw_cdns_port *port, u32 ch, u32 dir)
+struct sdw_cdns_pdi *sdw_cdns_alloc_pdi(struct sdw_cdns *cdns,
+					struct sdw_cdns_streams *stream,
+					u32 ch, u32 dir)
 {
 	struct sdw_cdns_pdi *pdi = NULL;
 
@@ -1348,18 +1272,16 @@ int sdw_cdns_alloc_stream(struct sdw_cdns *cdns,
 	if (!pdi)
 		pdi = cdns_find_pdi(cdns, stream->num_bd, stream->bd);
 
-	if (!pdi)
-		return -EIO;
-
-	port->pdi = pdi;
-	pdi->l_ch_num = 0;
-	pdi->h_ch_num = ch - 1;
-	pdi->dir = dir;
-	pdi->ch_count = ch;
+	if (pdi) {
+		pdi->l_ch_num = 0;
+		pdi->h_ch_num = ch - 1;
+		pdi->dir = dir;
+		pdi->ch_count = ch;
+	}
 
-	return 0;
+	return pdi;
 }
-EXPORT_SYMBOL(sdw_cdns_alloc_stream);
+EXPORT_SYMBOL(sdw_cdns_alloc_pdi);
 
 MODULE_LICENSE("Dual BSD/GPL");
 MODULE_DESCRIPTION("Cadence Soundwire Library");
diff --git a/drivers/soundwire/cadence_master.h b/drivers/soundwire/cadence_master.h
index 1a67728c5000f..3e963614a216b 100644
--- a/drivers/soundwire/cadence_master.h
+++ b/drivers/soundwire/cadence_master.h
@@ -28,23 +28,6 @@ struct sdw_cdns_pdi {
 	enum sdw_stream_type type;
 };
 
-/**
- * struct sdw_cdns_port: Cadence port structure
- *
- * @num: port number
- * @assigned: port assigned
- * @ch: channel count
- * @direction: data port direction
- * @pdi: pdi for this port
- */
-struct sdw_cdns_port {
-	unsigned int num;
-	bool assigned;
-	unsigned int ch;
-	enum sdw_data_direction direction;
-	struct sdw_cdns_pdi *pdi;
-};
-
 /**
  * struct sdw_cdns_streams: Cadence stream data structure
  *
@@ -95,8 +78,8 @@ struct sdw_cdns_stream_config {
  * struct sdw_cdns_dma_data: Cadence DMA data
  *
  * @name: SoundWire stream name
- * @nr_ports: Number of ports
- * @port: Ports
+ * @stream: stream runtime
+ * @pdi: PDI used for this dai
  * @bus: Bus handle
  * @stream_type: Stream type
  * @link_id: Master link id
@@ -104,8 +87,7 @@ struct sdw_cdns_stream_config {
 struct sdw_cdns_dma_data {
 	char *name;
 	struct sdw_stream_runtime *stream;
-	int nr_ports;
-	struct sdw_cdns_port **port;
+	struct sdw_cdns_pdi *pdi;
 	struct sdw_bus *bus;
 	enum sdw_stream_type stream_type;
 	int link_id;
@@ -171,10 +153,10 @@ void sdw_cdns_debugfs_init(struct sdw_cdns *cdns, struct dentry *root);
 int sdw_cdns_get_stream(struct sdw_cdns *cdns,
 			struct sdw_cdns_streams *stream,
 			u32 ch, u32 dir);
-int sdw_cdns_alloc_stream(struct sdw_cdns *cdns,
-			  struct sdw_cdns_streams *stream,
-			  struct sdw_cdns_port *port, u32 ch, u32 dir);
-void sdw_cdns_config_stream(struct sdw_cdns *cdns, struct sdw_cdns_port *port,
+struct sdw_cdns_pdi *sdw_cdns_alloc_pdi(struct sdw_cdns *cdns,
+					struct sdw_cdns_streams *stream,
+					u32 ch, u32 dir);
+void sdw_cdns_config_stream(struct sdw_cdns *cdns,
 			    u32 ch, u32 dir, struct sdw_cdns_pdi *pdi);
 
 int sdw_cdns_pcm_set_stream(struct snd_soc_dai *dai,
diff --git a/drivers/soundwire/intel.c b/drivers/soundwire/intel.c
index a2da04946f0b4..9ac45e6dbe9df 100644
--- a/drivers/soundwire/intel.c
+++ b/drivers/soundwire/intel.c
@@ -609,66 +609,6 @@ static int intel_post_bank_switch(struct sdw_bus *bus)
  * DAI routines
  */
 
-static struct sdw_cdns_port *intel_alloc_port(struct sdw_intel *sdw,
-					      u32 ch, u32 dir, bool pcm)
-{
-	struct sdw_cdns *cdns = &sdw->cdns;
-	struct sdw_cdns_port *port = NULL;
-	int i, ret = 0;
-
-	for (i = 0; i < cdns->num_ports; i++) {
-		if (cdns->ports[i].assigned)
-			continue;
-
-		port = &cdns->ports[i];
-		port->assigned = true;
-		port->direction = dir;
-		port->ch = ch;
-		break;
-	}
-
-	if (!port) {
-		dev_err(cdns->dev, "Unable to find a free port\n");
-		return NULL;
-	}
-
-	if (pcm) {
-		ret = sdw_cdns_alloc_stream(cdns, &cdns->pcm, port, ch, dir);
-		if (ret)
-			goto out;
-
-		intel_pdi_shim_configure(sdw, port->pdi);
-		sdw_cdns_config_stream(cdns, port, ch, dir, port->pdi);
-
-		intel_pdi_alh_configure(sdw, port->pdi);
-
-	} else {
-		ret = sdw_cdns_alloc_stream(cdns, &cdns->pdm, port, ch, dir);
-	}
-
-out:
-	if (ret) {
-		port->assigned = false;
-		port = NULL;
-	}
-
-	return port;
-}
-
-static void intel_port_cleanup(struct sdw_cdns_dma_data *dma)
-{
-	int i;
-
-	for (i = 0; i < dma->nr_ports; i++) {
-		if (dma->port[i]) {
-			dma->port[i]->pdi->assigned = false;
-			dma->port[i]->pdi = NULL;
-			dma->port[i]->assigned = false;
-			dma->port[i] = NULL;
-		}
-	}
-}
-
 static int intel_hw_params(struct snd_pcm_substream *substream,
 			   struct snd_pcm_hw_params *params,
 			   struct snd_soc_dai *dai)
@@ -676,9 +616,11 @@ static int intel_hw_params(struct snd_pcm_substream *substream,
 	struct sdw_cdns *cdns = snd_soc_dai_get_drvdata(dai);
 	struct sdw_intel *sdw = cdns_to_intel(cdns);
 	struct sdw_cdns_dma_data *dma;
+	struct sdw_cdns_pdi *pdi;
 	struct sdw_stream_config sconfig;
 	struct sdw_port_config *pconfig;
-	int ret, i, ch, dir;
+	int ch, dir;
+	int ret;
 	bool pcm = true;
 
 	dma = snd_soc_dai_get_dma_data(dai, substream);
@@ -691,38 +633,31 @@ static int intel_hw_params(struct snd_pcm_substream *substream,
 	else
 		dir = SDW_DATA_DIR_TX;
 
-	if (dma->stream_type == SDW_STREAM_PDM) {
-		/* TODO: Check whether PDM decimator is already in use */
-		dma->nr_ports = sdw_cdns_get_stream(cdns, &cdns->pdm, ch, dir);
+	if (dma->stream_type == SDW_STREAM_PDM)
 		pcm = false;
-	} else {
-		dma->nr_ports = sdw_cdns_get_stream(cdns, &cdns->pcm, ch, dir);
-	}
 
-	if (!dma->nr_ports) {
-		dev_err(dai->dev, "ports/resources not available\n");
-		return -EINVAL;
+	/* FIXME: We would need to get PDI info from topology */
+	if (pcm)
+		pdi = sdw_cdns_alloc_pdi(cdns, &cdns->pcm, ch, dir);
+	else
+		pdi = sdw_cdns_alloc_pdi(cdns, &cdns->pdm, ch, dir);
+
+	if (!pdi) {
+		ret = -EINVAL;
+		goto error;
 	}
 
-	dma->port = kcalloc(dma->nr_ports, sizeof(*dma->port), GFP_KERNEL);
-	if (!dma->port)
-		return -ENOMEM;
+	/* do run-time configurations for SHIM, ALH and PDI/PORT */
+	intel_pdi_shim_configure(sdw, pdi);
+	intel_pdi_alh_configure(sdw, pdi);
+	sdw_cdns_config_stream(cdns, ch, dir, pdi);
 
-	for (i = 0; i < dma->nr_ports; i++) {
-		dma->port[i] = intel_alloc_port(sdw, ch, dir, pcm);
-		if (!dma->port[i]) {
-			ret = -EINVAL;
-			goto port_error;
-		}
-	}
 
 	/* Inform DSP about PDI stream number */
-	for (i = 0; i < dma->nr_ports; i++) {
-		ret = intel_config_stream(sdw, substream, dai, params,
-					  dma->port[i]->pdi->intel_alh_id);
-		if (ret)
-			goto port_error;
-	}
+	ret = intel_config_stream(sdw, substream, dai, params,
+				  pdi->intel_alh_id);
+	if (ret)
+		goto error;
 
 	sconfig.direction = dir;
 	sconfig.ch_count = ch;
@@ -737,32 +672,22 @@ static int intel_hw_params(struct snd_pcm_substream *substream,
 	}
 
 	/* Port configuration */
-	pconfig = kcalloc(dma->nr_ports, sizeof(*pconfig), GFP_KERNEL);
+	pconfig = kcalloc(1, sizeof(*pconfig), GFP_KERNEL);
 	if (!pconfig) {
 		ret =  -ENOMEM;
-		goto port_error;
+		goto error;
 	}
 
-	for (i = 0; i < dma->nr_ports; i++) {
-		pconfig[i].num = dma->port[i]->num;
-		pconfig[i].ch_mask = (1 << ch) - 1;
-	}
+	pconfig->num = pdi->num;
+	pconfig->ch_mask = (1 << ch) - 1;
 
 	ret = sdw_stream_add_master(&cdns->bus, &sconfig,
-				    pconfig, dma->nr_ports, dma->stream);
-	if (ret) {
+				    pconfig, 1, dma->stream);
+	if (ret)
 		dev_err(cdns->dev, "add master to stream failed:%d\n", ret);
-		goto stream_error;
-	}
-
-	kfree(pconfig);
-	return ret;
 
-stream_error:
 	kfree(pconfig);
-port_error:
-	intel_port_cleanup(dma);
-	kfree(dma->port);
+error:
 	return ret;
 }
 
@@ -782,8 +707,6 @@ intel_hw_free(struct snd_pcm_substream *substream, struct snd_soc_dai *dai)
 		dev_err(dai->dev, "remove master from stream %s failed: %d\n",
 			dma->stream->name, ret);
 
-	intel_port_cleanup(dma);
-	kfree(dma->port);
 	return ret;
 }
 
-- 
2.43.0



