Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 343BE3E49DD;
	Tue, 21 Jul 2026 17:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653680; cv=none; b=m6JsDT7LIpbP+jBltt31grHuojTNMSASK+NsO6mylMe9iym5G37yGxGSgEdT8+lcZwxiJrkR5CBeQNfAgQd33nLECG43wTrBCgrjkI2vBh8cTUAshXP2wf3ItaDDiuzlTlbRi0opGnTrpr6sxHlqpJ+EVQRbkt9x+dGnvluq1uY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653680; c=relaxed/simple;
	bh=oDWlRfp3lIWlP76doOacc96bWqwifAcudb/RyoPd7Iw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SL3RBpUzMRajcOs4z7i84uN5+gaHVlSVVzd9pVJi5PD3bt4cZI5WWEqxDw1vO2De9eBG8kVOSSvcOHLaxDWyG+KQmdB0FZul931vqZ+yx6mr8zt4PIS9EKGFzOoyXbVR259cHMTheD1HaNqjE3BX4e8BTERdZ2iIfnyRGS59G2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b7o6NAZ3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b7o6NAZ3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9518C1F000E9;
	Tue, 21 Jul 2026 17:07:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653679;
	bh=D063N1kv7NFPTboWXLwrK6dLk8NBECUE4Z1pztg2Rz4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b7o6NAZ3u4dXFhnyJ1P4C8CT2/OtGK8uVz1Sfb6btCk745FN2/PBWDErCyU6it4vS
	 cvcARoPWxtkrJej+xNkyu7BkSdtzoWT7lyudkVngNZk8/pwtcU56ut+3NphnJFS6gC
	 zPJ6n3lMqBvmdY79MZDKbqWzGWl09JRfYtRaSByE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Ariana Lazar <ariana.lazar@microchip.com>,
	David Lechner <dlechner@baylibre.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1417/2077] iio: dac: mcp47feb02: Fix passing uninitialized vref1_uV for no Vref1 case
Date: Tue, 21 Jul 2026 17:18:10 +0200
Message-ID: <20260721152626.224863504@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ariana Lazar <ariana.lazar@microchip.com>

[ Upstream commit e74c0d0eef7e1fa9fd387b81b2787b4581e0b11c ]

Ensure that if a device has Vref1 but reading the regulator returns an
error, mcp47feb02_init_ctrl_regs() is not called with an uninitialized
vref1_uV value. Also add a device_property_present() check for the Vref1
supply before reading the regulator.

Fixes: dd154646d292 ("iio: dac: mcp47feb02: Fix Vref validation [1-999] case")
Reported-by: Dan Carpenter <error27@gmail.com>
Closes: https://lore.kernel.org/all/adiPnla0M5EzvgD-@stanley.mountain/
Signed-off-by: Ariana Lazar <ariana.lazar@microchip.com>
Reviewed-by: David Lechner <dlechner@baylibre.com>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/dac/mcp47feb02.c | 37 +++++++++++++++++++++---------------
 1 file changed, 22 insertions(+), 15 deletions(-)

diff --git a/drivers/iio/dac/mcp47feb02.c b/drivers/iio/dac/mcp47feb02.c
index faccb804a5ed54..5f84b46ec6f3d2 100644
--- a/drivers/iio/dac/mcp47feb02.c
+++ b/drivers/iio/dac/mcp47feb02.c
@@ -1136,26 +1136,33 @@ static int mcp47feb02_probe(struct i2c_client *client)
 
 	vdd_uV = ret;
 
-	ret = devm_regulator_get_enable_read_voltage(dev, "vref");
-	if (ret > 0) {
-		vref_uV = ret;
+	if (device_property_present(dev, "vref-supply")) {
+		vref_uV = devm_regulator_get_enable_read_voltage(dev, "vref");
+		if (vref_uV < 0)
+			return vref_uV;
+
+		if (vref_uV == 0)
+			return dev_err_probe(dev, -EINVAL, "Vref is 0 uV.\n");
+
 		data->use_vref = true;
 	} else {
 		vref_uV = 0;
-		dev_dbg(dev, "using internal band gap as voltage reference.\n");
-		dev_dbg(dev, "Vref is unavailable.\n");
+		dev_dbg(dev, "Using internal band gap as voltage reference.\n");
 	}
 
-	if (chip_features->have_ext_vref1) {
-		ret = devm_regulator_get_enable_read_voltage(dev, "vref1");
-		if (ret > 0) {
-			vref1_uV = ret;
-			data->use_vref1 = true;
-		} else {
-			vref1_uV = 0;
-			dev_dbg(dev, "using internal band gap as voltage reference 1.\n");
-			dev_dbg(dev, "Vref1 is unavailable.\n");
-		}
+	if (chip_features->have_ext_vref1 &&
+	    device_property_present(dev, "vref1-supply")) {
+		vref1_uV = devm_regulator_get_enable_read_voltage(dev, "vref1");
+		if (vref1_uV < 0)
+			return vref1_uV;
+
+		if (vref1_uV == 0)
+			return dev_err_probe(dev, -EINVAL, "Vref1 is 0 uV.\n");
+
+		data->use_vref1 = true;
+	} else {
+		vref1_uV = 0;
+		dev_dbg(dev, "Using internal band gap as voltage reference 1.\n");
 	}
 
 	ret = mcp47feb02_init_ctrl_regs(data);
-- 
2.53.0



