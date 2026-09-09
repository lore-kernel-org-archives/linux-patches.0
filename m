Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23C12550DA6;
	Wed,  9 Sep 2026 14:01:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962472; cv=none; b=tRmlzISYB18+AEX5xUR7j8A7YySI97X6Y2p/vn+3UJ4XG/IfVSTHHaN5aY7xuxojKL38oqSiCgCA97ye/+gafHX5ai7nUqip/f13y+K22VqRyTYORGzmYEH8qddm0G9+TIzCrJTddOKcFZK/MIfpuOAT6ygWO65nV9Fak4J1U/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962472; c=relaxed/simple;
	bh=Cwd5IIktKW7TSLa+asfk92i09oPYi7XWL8hzY61+jS4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WGhjnzpkHAeHOetpIGG36mTXo0NiEluWZlu+HbcTFla/0gCfim08dqHMsfM+wgGdyyUftuR3FCOwAn+rVkrcI9mOqPyiGHW5UWAQWdx7qKBlMZ22LZWGIju9YkADdSSqhcYAbA5oiPJdjqtEGXn3YM7sA6AV4WefHrfhUIr6tGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZmqZvvdq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZmqZvvdq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E7301F00A3A;
	Wed,  9 Sep 2026 14:01:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962470;
	bh=qxc6Kxy6MU6SQjRrLtCd6h5K97PO82dZrjD7JGk0aX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZmqZvvdqWxBFAvGjVM64Ao+cvHqHyK2ZYAZwicvWKq9vVSNKMOrBuUINnaE2eXTC6
	 erWU70Wg5/hb7Cy69b5aypNy5rxoJaiOVnbxgRoJThK+vQkdfsrK0wglqewZSKlCtt
	 jmEKtsljJuVl61IUPWY5eCtHyNX7xj7C7XU4ye2A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antoniu Miclaus <antoniu.miclaus@analog.com>,
	David Lechner <dlechner@baylibre.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 7.2 260/556] iio: adc: adi-axi-adc: add data size support for AD408X backend
Date: Wed,  9 Sep 2026 15:39:00 +0200
Message-ID: <20260909134239.675052751@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -53,6 +53,10 @@
 #define   AXI_AD485X_PACKET_FORMAT_24BIT	0x1
 #define   AXI_AD485X_PACKET_FORMAT_32BIT	0x2
 #define   AXI_AD408X_CNTRL_3_FILTER_EN_MSK	BIT(0)
+#define   AXI_AD408X_CNTRL_3_PACKET_FORMAT_MSK	GENMASK(3, 2)
+#define   AXI_AD408X_PACKET_FORMAT_20BIT	0x0
+#define   AXI_AD408X_PACKET_FORMAT_16BIT	0x1
+#define   AXI_AD408X_PACKET_FORMAT_14BIT	0x2
 
 #define ADI_AXI_ADC_REG_SYNC_STATUS		0x0068
 #define   ADI_AXI_ADC_SYNC_STATUS_ADC_SYNC_MSK	BIT(0)
@@ -436,6 +440,31 @@ static int axi_adc_ad408x_filter_type_se
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
@@ -659,6 +688,7 @@ static const struct iio_backend_ops adi_
 	.free_buffer = axi_adc_free_buffer,
 	.data_sample_trigger = axi_adc_data_sample_trigger,
 	.filter_type_set = axi_adc_ad408x_filter_type_set,
+	.data_size_set = axi_adc_ad408x_data_size_set,
 	.interface_data_align = axi_adc_ad408x_interface_data_align,
 	.num_lanes_set = axi_adc_num_lanes_set,
 	.debugfs_reg_access = iio_backend_debugfs_ptr(axi_adc_reg_access),


