Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5945C15855C;
	Thu, 13 Feb 2025 15:04:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459068; cv=none; b=jsenluwG7iiAfUh0OB2nekKjbiqZ8TPU3q0Rz/6x3KLf4RUF5qJjFkgDzjKaOPE+WPN/pYECFE5OzX2YYFbpirx81+FAuj9F7SOWU+Iv0CBaIQqHYD2IhHLuZY2xw3VBhNrJJ9v5+4Seio+IEtFyKTicx4T0OkQNAjrb3g6Bul4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459068; c=relaxed/simple;
	bh=fCmDXBtzURRHS+JffZoYiWL8MFJBGKUikLbFMI7gonY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CitmzhqKJzNeGSuz2tdk6//4QDzXRgjIJts6it/6WwL9AUSEb4EDhgS9f2px5ZScFUMqBQiTVMwYZi7qoXFEJ5gjAbygh4HwgqTrJxdE2IR27BBvTbJ3yr3zqsqyHWJwaoh7NC7GOv/GsF0cnP+iSHjabVG32ZsMbrhrErxVdiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VmhH06ov; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VmhH06ov"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54F44C4CEE5;
	Thu, 13 Feb 2025 15:04:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459067;
	bh=fCmDXBtzURRHS+JffZoYiWL8MFJBGKUikLbFMI7gonY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VmhH06ovzhwlvWTGKpMJr5dDR519Sxbvb2NTmtflkI2GH8CNSqT4P6xlV8cenox03
	 HMkNVNQp5Yyv/qcjVc1jK3fSWC1ZsQ65NeNyTSof6x2ACkt0I7y5SYw2kQVExPP/+e
	 ZwqM5ofyP30gom/+lX93hTBnxFM54AlXFLjHKRLI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Xu Yang <xu.yang_2@nxp.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 6.13 158/443] perf: imx9_perf: Introduce AXI filter version to refactor the driver and better extension
Date: Thu, 13 Feb 2025 15:25:23 +0100
Message-ID: <20250213142446.693607434@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xu Yang <xu.yang_2@nxp.com>

commit f3edf03a4c59e59e52c0c1fd958f64a76a038302 upstream.

The imx93 is the first supported DDR PMU that supports read transaction,
write transaction and read beats events which corresponding respecitively
to counter 2, 3 and 4.

However, transaction-based AXI match has low accuracy when get total bits
compared to beats-based. And imx93 doesn't assign AXI_ID to each master.
So axi filter is not used widely on imx93. This could be regards as AXI
filter version 1.

To improve the AXI filter capability, imx95 supports 1 read beats and 3
write beats event which corresponding respecitively to counter 2-5. imx95
also detailed AXI_ID allocation so that most of the master could be count
individually. This could be regards as AXI filter version 2.

This will introduce AXI filter version to refactor the driver and support
better extension, such as coming imx943. This is also a potential fix on
imx91 when configure axi filter.

Fixes: 44798fe136dc ("perf: imx_perf: add support for i.MX91 platform")
Cc: stable@vger.kernel.org
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Xu Yang <xu.yang_2@nxp.com>
Link: https://lore.kernel.org/r/20241212065708.1353513-1-xu.yang_2@nxp.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/perf/fsl_imx9_ddr_perf.c |   33 +++++++++++++++++++++++++--------
 1 file changed, 25 insertions(+), 8 deletions(-)

--- a/drivers/perf/fsl_imx9_ddr_perf.c
+++ b/drivers/perf/fsl_imx9_ddr_perf.c
@@ -63,8 +63,21 @@
 
 static DEFINE_IDA(ddr_ida);
 
+/*
+ * V1 support 1 read transaction, 1 write transaction and 1 read beats
+ * event which corresponding respecitively to counter 2, 3 and 4.
+ */
+#define DDR_PERF_AXI_FILTER_V1		0x1
+
+/*
+ * V2 support 1 read beats and 3 write beats events which corresponding
+ * respecitively to counter 2-5.
+ */
+#define DDR_PERF_AXI_FILTER_V2		0x2
+
 struct imx_ddr_devtype_data {
 	const char *identifier;		/* system PMU identifier for userspace */
+	unsigned int filter_ver;	/* AXI filter version */
 };
 
 struct ddr_pmu {
@@ -83,24 +96,27 @@ struct ddr_pmu {
 
 static const struct imx_ddr_devtype_data imx91_devtype_data = {
 	.identifier = "imx91",
+	.filter_ver = DDR_PERF_AXI_FILTER_V1
 };
 
 static const struct imx_ddr_devtype_data imx93_devtype_data = {
 	.identifier = "imx93",
+	.filter_ver = DDR_PERF_AXI_FILTER_V1
 };
 
 static const struct imx_ddr_devtype_data imx95_devtype_data = {
 	.identifier = "imx95",
+	.filter_ver = DDR_PERF_AXI_FILTER_V2
 };
 
-static inline bool is_imx93(struct ddr_pmu *pmu)
+static inline bool axi_filter_v1(struct ddr_pmu *pmu)
 {
-	return pmu->devtype_data == &imx93_devtype_data;
+	return pmu->devtype_data->filter_ver == DDR_PERF_AXI_FILTER_V1;
 }
 
-static inline bool is_imx95(struct ddr_pmu *pmu)
+static inline bool axi_filter_v2(struct ddr_pmu *pmu)
 {
-	return pmu->devtype_data == &imx95_devtype_data;
+	return pmu->devtype_data->filter_ver == DDR_PERF_AXI_FILTER_V2;
 }
 
 static const struct of_device_id imx_ddr_pmu_dt_ids[] = {
@@ -155,7 +171,7 @@ static const struct attribute_group ddr_
 struct imx9_pmu_events_attr {
 	struct device_attribute attr;
 	u64 id;
-	const void *devtype_data;
+	const struct imx_ddr_devtype_data *devtype_data;
 };
 
 static ssize_t ddr_pmu_event_show(struct device *dev,
@@ -307,7 +323,8 @@ ddr_perf_events_attrs_is_visible(struct
 	if (!eattr->devtype_data)
 		return attr->mode;
 
-	if (eattr->devtype_data != ddr_pmu->devtype_data)
+	if (eattr->devtype_data != ddr_pmu->devtype_data &&
+	    eattr->devtype_data->filter_ver != ddr_pmu->devtype_data->filter_ver)
 		return 0;
 
 	return attr->mode;
@@ -624,11 +641,11 @@ static int ddr_perf_event_add(struct per
 	hwc->idx = counter;
 	hwc->state |= PERF_HES_STOPPED;
 
-	if (is_imx93(pmu))
+	if (axi_filter_v1(pmu))
 		/* read trans, write trans, read beat */
 		imx93_ddr_perf_monitor_config(pmu, event_id, counter, cfg1, cfg2);
 
-	if (is_imx95(pmu))
+	if (axi_filter_v2(pmu))
 		/* write beat, read beat2, read beat1, read beat */
 		imx95_ddr_perf_monitor_config(pmu, event_id, counter, cfg1, cfg2);
 


