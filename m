Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E8DA1494B8;
	Mon, 12 Aug 2024 16:35:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723480516; cv=none; b=AgyXv3RHd7AC10O2S2eshRgLtSvbJ/du99bArnUnEIchNIrKyWQ1aZ77skCuYRVxe8ADv5SYeUUOY50Owg1YjRujP+a7zguyWBd+2qIIhUWCGLjqZKT5d6ziIMawf6BtvsjG+rwFlCRnKRXRyG3Kri2D0P36H7rDK5PXTnILV4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723480516; c=relaxed/simple;
	bh=GUfnwlCme03LAGWov74rlEcJ7UdD+cd5t0X45THrzI4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZVnAWfigZsLjAqtzlXJUK4pTlkRGGCh/92Vp+c4O8eAuiOGxZannbpjJ0Gdx4ong+HUnSRgFa+fdy6ruV175U/EEOcfTr05L0K6EGknPEqTIKzGDSybXRn8AMGNi4sXqhycJJdmDD7n7HRIrxKOQ0Iui5NkPu+DSZXkXZr+/KbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2YJ8ht8D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2YJ8ht8D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE565C32782;
	Mon, 12 Aug 2024 16:35:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723480516;
	bh=GUfnwlCme03LAGWov74rlEcJ7UdD+cd5t0X45THrzI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2YJ8ht8DMbaAyCMSpFvb++b6I91+V+Jh/lR9idFhWcRK9NTFiJ9t/2pVTMzvRqDum
	 9/bT0QJGwkn/vb6ltyCZ+fnc8mSsD6G54wC5X1PB6JvicgLv8W5GjUSMjNtL/tyn73
	 SUGZLb1jXF8ISXM8pD26hePxYSNI/3fnOOs6tsyc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>
Subject: [PATCH 6.10 188/263] usb: typec: fsa4480: Check if the chip is really there
Date: Mon, 12 Aug 2024 18:03:09 +0200
Message-ID: <20240812160153.743353645@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@linaro.org>

commit e885f5f1f2b43575aa8e4e31404132d77d6663d1 upstream.

Currently, the driver will happily register the switch/mux devices, and
so long as the i2c master doesn't complain, the user would never know
there's something wrong.

Add a device id check (based on [1]) and return -ENODEV if the read
fails or returns nonsense.

Checking the value on a Qualcomm SM6115P-based Lenovo Tab P11 tablet,
the ID mentioned in the datasheet does indeed show up:
 fsa4480 1-0042: Found FSA4480 v1.1 (Vendor ID = 0)

[1] https://www.onsemi.com/pdf/datasheet/fsa4480-d.pdf

Fixes: 1dc246320c6b ("usb: typec: mux: Add On Semi fsa4480 driver")
Cc: stable <stable@kernel.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20240729-topic-fs4480_check-v3-1-f5bf732d3424@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/mux/fsa4480.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/drivers/usb/typec/mux/fsa4480.c
+++ b/drivers/usb/typec/mux/fsa4480.c
@@ -13,6 +13,10 @@
 #include <linux/usb/typec_dp.h>
 #include <linux/usb/typec_mux.h>
 
+#define FSA4480_DEVICE_ID	0x00
+ #define FSA4480_DEVICE_ID_VENDOR_ID	GENMASK(7, 6)
+ #define FSA4480_DEVICE_ID_VERSION_ID	GENMASK(5, 3)
+ #define FSA4480_DEVICE_ID_REV_ID	GENMASK(2, 0)
 #define FSA4480_SWITCH_ENABLE	0x04
 #define FSA4480_SWITCH_SELECT	0x05
 #define FSA4480_SWITCH_STATUS1	0x07
@@ -251,6 +255,7 @@ static int fsa4480_probe(struct i2c_clie
 	struct typec_switch_desc sw_desc = { };
 	struct typec_mux_desc mux_desc = { };
 	struct fsa4480 *fsa;
+	int val = 0;
 	int ret;
 
 	fsa = devm_kzalloc(dev, sizeof(*fsa), GFP_KERNEL);
@@ -268,6 +273,15 @@ static int fsa4480_probe(struct i2c_clie
 	if (IS_ERR(fsa->regmap))
 		return dev_err_probe(dev, PTR_ERR(fsa->regmap), "failed to initialize regmap\n");
 
+	ret = regmap_read(fsa->regmap, FSA4480_DEVICE_ID, &val);
+	if (ret || !val)
+		return dev_err_probe(dev, -ENODEV, "FSA4480 not found\n");
+
+	dev_dbg(dev, "Found FSA4480 v%lu.%lu (Vendor ID = %lu)\n",
+		FIELD_GET(FSA4480_DEVICE_ID_VERSION_ID, val),
+		FIELD_GET(FSA4480_DEVICE_ID_REV_ID, val),
+		FIELD_GET(FSA4480_DEVICE_ID_VENDOR_ID, val));
+
 	/* Safe mode */
 	fsa->cur_enable = FSA4480_ENABLE_DEVICE | FSA4480_ENABLE_USB;
 	fsa->mode = TYPEC_STATE_SAFE;


