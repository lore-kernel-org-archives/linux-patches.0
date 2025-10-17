Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AE4132C93B;
	Fri, 17 Oct 2025 15:37:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715447; cv=none; b=AvNKj65nbM3noppz1e2HkM+czgQyTwlC2z6L+Yy+4Y6EACt+kSVdVeviDtePotR1vP9qNQOeaqYoZJ1l93CXnIfKvzPAqob3DSfsbKMk9Z7/lQ1rhrAHPxw51u075KKla3UJ0Sq5a0+VCHT/pVQJOkQUCj98vz/x7xNbNeU9aAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715447; c=relaxed/simple;
	bh=rmkrG0yAP7PbTHayt5mBz3B7t8YJ2SBAeeWkIk3CIuw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mW/ShNCEUfXETYiq83brqpAUTFsnQi5OUVBIkgSwu80bHnlfC7L4tuadTf59cXXYgezxEFK3x8vNy6+rbC+9/60sIVondYCECCmIjjBAcFkm/TpkgJgGNNpOvq89owoa9GtMzHEgo/MSrh1LlPwDnBmGcooxI8zF1SQzmItOBzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o/inRzd9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o/inRzd9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DB37C113D0;
	Fri, 17 Oct 2025 15:37:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715447;
	bh=rmkrG0yAP7PbTHayt5mBz3B7t8YJ2SBAeeWkIk3CIuw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o/inRzd919gJicAWVbk2n3ZXOqRow3OBnXsoJbqrbFeZKHuNe6GKPgrHubv2A2X5F
	 DMr4Khbb0QPfDMRJj9pz6PssrydBNF3sNfaPqQL09FlKKXY2oli8UpO5P83wpsSsmf
	 xYl3651OCXuJDoEytgiv8RCAya2DYbaQXLObVWw4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandar Gerasimovski <aleksandar.gerasimovski@belden.com>,
	Marius Cristea <marius.cristea@microchip.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Rene Straub <mailto:rene.straub@belden.com>
Subject: [PATCH 6.17 219/371] iio/adc/pac1934: fix channel disable configuration
Date: Fri, 17 Oct 2025 16:53:14 +0200
Message-ID: <20251017145210.011265772@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksandar Gerasimovski <aleksandar.gerasimovski@belden.com>

commit 3c63ba1c430af1c0dcd68dd36f2246980621dcba upstream.

There are two problems with the chip configuration in this driver:
- First, is that writing 12 bytes (ARRAY_SIZE(regs)) would anyhow
  lead to a config overflow due to HW auto increment implementation
  in the chip.
- Second, the i2c_smbus_write_block_data write ends up in writing
  unexpected value to the channel_dis register, this is because
  the smbus size that is 0x03 in this case gets written to the
  register. The PAC1931/2/3/4 data sheet does not really specify
  that block write is indeed supported.

This problem is probably not visible on PAC1934 version where all
channels are used as the chip is properly configured by luck,
but in our case whenusing PAC1931 this leads to nonfunctional device.

Fixes: 0fb528c8255b (iio: adc: adding support for PAC193x)
Suggested-by: Rene Straub <mailto:rene.straub@belden.com>
Signed-off-by: Aleksandar Gerasimovski <aleksandar.gerasimovski@belden.com>
Reviewed-by: Marius Cristea <marius.cristea@microchip.com>
Link: https://patch.msgid.link/20250811130904.2481790-1-aleksandar.gerasimovski@belden.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/pac1934.c |   20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

--- a/drivers/iio/adc/pac1934.c
+++ b/drivers/iio/adc/pac1934.c
@@ -88,6 +88,7 @@
 #define PAC1934_VPOWER_3_ADDR			0x19
 #define PAC1934_VPOWER_4_ADDR			0x1A
 #define PAC1934_REFRESH_V_REG_ADDR		0x1F
+#define PAC1934_SLOW_REG_ADDR			0x20
 #define PAC1934_CTRL_STAT_REGS_ADDR		0x1C
 #define PAC1934_PID_REG_ADDR			0xFD
 #define PAC1934_MID_REG_ADDR			0xFE
@@ -1265,8 +1266,23 @@ static int pac1934_chip_configure(struct
 	/* no SLOW triggered REFRESH, clear POR */
 	regs[PAC1934_SLOW_REG_OFF] = 0;
 
-	ret =  i2c_smbus_write_block_data(client, PAC1934_CTRL_STAT_REGS_ADDR,
-					  ARRAY_SIZE(regs), (u8 *)regs);
+	/*
+	 * Write the three bytes sequentially, as the device does not support
+	 * block write.
+	 */
+	ret = i2c_smbus_write_byte_data(client, PAC1934_CTRL_STAT_REGS_ADDR,
+					regs[PAC1934_CHANNEL_DIS_REG_OFF]);
+	if (ret)
+		return ret;
+
+	ret = i2c_smbus_write_byte_data(client,
+					PAC1934_CTRL_STAT_REGS_ADDR + PAC1934_NEG_PWR_REG_OFF,
+					regs[PAC1934_NEG_PWR_REG_OFF]);
+	if (ret)
+		return ret;
+
+	ret = i2c_smbus_write_byte_data(client, PAC1934_SLOW_REG_ADDR,
+					regs[PAC1934_SLOW_REG_OFF]);
 	if (ret)
 		return ret;
 


