Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 988D45867FE;
	Wed,  9 Sep 2026 14:23:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963803; cv=none; b=ULvfjpi/CrhYtTOP4ptZlRPIGG4f00zMx/6AILzY71H45j0WmFvzojW17G0PQUsSD/jTBcHqqSffe2dk+XV9sXxw6Ys+UzDYgtUEE1eQ+eZXJ5V5nKBSQFUIVL5PsHLgSpJojrKzbxrQF9Urqndv7TwCaimxHP57KdcjTeMjJl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963803; c=relaxed/simple;
	bh=Ekb6XGPkzTZzoFCh5hPk2FsxySoQ89T2bpPqZi+H3pY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gJl/p53GUGqs3I5Z3ESOqJ/b6fqvt428XRleHPmjk0SoT1V2141lNJp+o0jdsk3irOP3IJ8JZiz84VooAx/glmRKkEhmuWCUuDrSq15jlvu6aDqAkqwy998trM/NerFvI4ynm0MuCPQeToiuXPBSyPCwtMRqMvx6rEv9qfp9PjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F365GgxW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F365GgxW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F299B1F00A3D;
	Wed,  9 Sep 2026 14:23:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963802;
	bh=QHL8IzfenM5oMDYaPxWSoCglZJ+dfq6TjOsXMudCiqs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F365GgxWZp/k0EyB8suHqLrRDW2MM2jZupOOX9MaSLKZaK2niuPQgQqLuDdMk5+1c
	 owApi+O4mKTu1qGiDaokBhN3npjcXvm8k+0XKX26KAOCkj+OzYN/WN/G/COZO/oIyq
	 VELehonfUmxc8a8LQ0b+wiDKiOLU/0A9QYuJ8hZ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antoniu Miclaus <antoniu.miclaus@analog.com>,
	David Lechner <dlechner@baylibre.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.18 203/583] iio: adc: adi-axi-adc: add data size support for AD408X backend
Date: Wed,  9 Sep 2026 15:38:08 +0200
Message-ID: <20260909134245.182564941@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Antoniu Miclaus <antoniu.miclaus@analog.com>

commit 60f6f7fd5f89c7f55991c5dc59f3ccc74cd6efd7 upstream.

The AD408X AXI core can pack the sample data on the bus using different
word widths. Expose this through the data_size_set backend operation so
that frontends can program the packet format field (bits 3:2 of the
CNTRL_3 register) according to the ADC resolution: 20-bit, 16-bit and
14-bit map to packet format values 0, 1 and 2 respectively.

Signed-off-by: Antoniu Miclaus <antoniu.miclaus@analog.com>
Reviewed-by: David Lechner <dlechner@baylibre.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/adi-axi-adc.c |   30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

--- a/drivers/iio/adc/adi-axi-adc.c
+++ b/drivers/iio/adc/adi-axi-adc.c
@@ -54,6 +54,10 @@
 #define   AXI_AD485X_PACKET_FORMAT_24BIT	0x1
 #define   AXI_AD485X_PACKET_FORMAT_32BIT	0x2
 #define   AXI_AD408X_CNTRL_3_FILTER_EN_MSK	BIT(0)
+#define   AXI_AD408X_CNTRL_3_PACKET_FORMAT_MSK	GENMASK(3, 2)
+#define   AXI_AD408X_PACKET_FORMAT_20BIT	0x0
+#define   AXI_AD408X_PACKET_FORMAT_16BIT	0x1
+#define   AXI_AD408X_PACKET_FORMAT_14BIT	0x2
 
 #define ADI_AXI_ADC_REG_SYNC_STATUS		0x0068
 #define   ADI_AXI_ADC_SYNC_STATUS_ADC_SYNC_MSK	BIT(0)
@@ -437,6 +441,31 @@ static int axi_adc_ad408x_filter_type_se
 				 AXI_AD408X_CNTRL_3_FILTER_EN_MSK);
 }
 
+static int axi_adc_ad408x_data_size_set(struct iio_backend *back,
+					unsigned int size)
+{
+	struct adi_axi_adc_state *st = iio_backend_get_priv(back);
+	unsigned int val;
+
+	switch (size) {
+	case 20:
+		val = AXI_AD408X_PACKET_FORMAT_20BIT;
+		break;
+	case 16:
+		val = AXI_AD408X_PACKET_FORMAT_16BIT;
+		break;
+	case 14:
+		val = AXI_AD408X_PACKET_FORMAT_14BIT;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return regmap_update_bits(st->regmap, ADI_AXI_ADC_REG_CNTRL_3,
+				  AXI_AD408X_CNTRL_3_PACKET_FORMAT_MSK,
+				  FIELD_PREP(AXI_AD408X_CNTRL_3_PACKET_FORMAT_MSK, val));
+}
+
 static int axi_adc_ad408x_interface_data_align(struct iio_backend *back,
 					       u32 timeout_us)
 {
@@ -661,6 +690,7 @@ static const struct iio_backend_ops adi_
 	.free_buffer = axi_adc_free_buffer,
 	.data_sample_trigger = axi_adc_data_sample_trigger,
 	.filter_type_set = axi_adc_ad408x_filter_type_set,
+	.data_size_set = axi_adc_ad408x_data_size_set,
 	.interface_data_align = axi_adc_ad408x_interface_data_align,
 	.num_lanes_set = axi_adc_num_lanes_set,
 	.debugfs_reg_access = iio_backend_debugfs_ptr(axi_adc_reg_access),


