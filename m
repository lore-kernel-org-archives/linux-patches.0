Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4402D32C929;
	Fri, 17 Oct 2025 15:21:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714461; cv=none; b=I6kEkRIjFIdt5WmGc9a2oE0hQIbpJEX/pTZV5yWBJvLSrRlHh/t8TDOIRsJj0m7jjE8Tbo6XT37Aidb5mmdv0YJ342uEwUgiTOiGY8vUAbfKgaiFE04/YsLBr54SROkICqoeeXFPnECxqwzadz6mx7FVfPnAIbTUMAHE4hsmK04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714461; c=relaxed/simple;
	bh=78sxnaqOKe6qW5ilkTmMvN+u2viJCFDBVtMzzPIXokM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ADd/J8n3Smln+jYYQIzMUSHQ/ZhwA3bPaeQf7TkMat0rnSbKIQEvyRybuXoE6rk+beUAqUKDmK+mFhUcqPiwglP7gHc8w/C0diYj7Fi9wiV2Uv1V/K3qIwMMPvCl9bPVBU5bUi3hpOGX1PkgXtuP+r9aFQ0fQmIMgO6wpXyBJwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CVYIbKbV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CVYIbKbV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C25CAC4CEE7;
	Fri, 17 Oct 2025 15:21:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714461;
	bh=78sxnaqOKe6qW5ilkTmMvN+u2viJCFDBVtMzzPIXokM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CVYIbKbVfMgCduP+jWNnG/RT34/PWdTxNHkJn3PdXCn/NWJNwY0jpfOt70Y0N0/7q
	 kjcIvIDQt4gvykdIcVkXDVZ8wE3Y8Mb++bqkA3/t2uzRterMTVY0yIpDV3WQNO83Lg
	 w9/OgPE7vVwbLJpXJIHw9Q/0ZhNq32M8fPIC5bvY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandar Gerasimovski <aleksandar.gerasimovski@belden.com>,
	Marius Cristea <marius.cristea@microchip.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Rene Straub <mailto:rene.straub@belden.com>
Subject: [PATCH 6.12 136/277] iio/adc/pac1934: fix channel disable configuration
Date: Fri, 17 Oct 2025 16:52:23 +0200
Message-ID: <20251017145152.091752201@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 


