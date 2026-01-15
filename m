Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4C5B349B0A;
	Thu, 15 Jan 2026 16:56:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496185; cv=none; b=MVlcBGnvbCa3gLiEIcE3sH3vZoUsAVW7oHqPgMjDZD6kKVclsYTJLeUX84Z4061Usxh99A8wzqbu+jF6iFPcAeo/XmyNV6wPft9GSiqll1pQtP9YPMu5OGFLY3wRgDwPhnJoyDFYtNk+rrT2Rf3/My2rkgBmGT99scX5D5OuheY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496185; c=relaxed/simple;
	bh=B0krKJYWuO/eZG/ObEX9iQUE6eRFo4XlO01X+gh4m7w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dNIa2ZEsw15E1FH69AGAlnuXn32xd/XF4RlYlnQqZKtROWNZ8p2YNlv49F8TgAxHbatoXGXklutCt+R/+VNKwLH8SHdNmBWXHOMJdc6z7FGTeniXDPclgwACBRn3rPdSxVZ2ZZoWlvk0Zg/eceDjVgDVPYKmzmnRSzMRQnjtWgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xMr73f+e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xMr73f+e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 693AAC116D0;
	Thu, 15 Jan 2026 16:56:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496184;
	bh=B0krKJYWuO/eZG/ObEX9iQUE6eRFo4XlO01X+gh4m7w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xMr73f+eUmNaa+kbLRwPKeBoKr58AP0zjOjvyeRf7cv4q0LiD2TNjSSEmdQ15Iii8
	 h1a51pfaV0P7ttOcO40mPHPpav5KhFS5Vw2yeTa9FrDh6ruOLCybChbclar273sRzV
	 Cg0uSoSbFGaeiV+YKScpGHhv8qNZblw2OAFjiq+g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Even Xu <even.xu@intel.com>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 075/181] HID: Intel-thc-hid: Intel-thc: Fix wrong register reading
Date: Thu, 15 Jan 2026 17:46:52 +0100
Message-ID: <20260115164205.030777748@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
References: <20260115164202.305475649@linuxfoundation.org>
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

From: Even Xu <even.xu@intel.com>

[ Upstream commit f39006965dd37e7be823dba6ca484adccc7a4dff ]

Correct the read register for the setting of max input size and
interrupt delay.

Fixes: 22da60f0304b ("HID: Intel-thc-hid: Intel-thc: Introduce interrupt delay control")
Fixes: 45e92a093099 ("HID: Intel-thc-hid: Intel-thc: Introduce max input size control")
Signed-off-by: Even Xu <even.xu@intel.com>
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/intel-thc-hid/intel-thc/intel-thc-dev.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/intel-thc-hid/intel-thc/intel-thc-dev.c b/drivers/hid/intel-thc-hid/intel-thc/intel-thc-dev.c
index 636a683065015..7e220a4c5ded7 100644
--- a/drivers/hid/intel-thc-hid/intel-thc/intel-thc-dev.c
+++ b/drivers/hid/intel-thc-hid/intel-thc/intel-thc-dev.c
@@ -1593,7 +1593,7 @@ int thc_i2c_set_rx_max_size(struct thc_device *dev, u32 max_rx_size)
 	if (!max_rx_size)
 		return -EOPNOTSUPP;
 
-	ret = regmap_read(dev->thc_regmap, THC_M_PRT_SW_SEQ_STS_OFFSET, &val);
+	ret = regmap_read(dev->thc_regmap, THC_M_PRT_SPI_ICRRD_OPCODE_OFFSET, &val);
 	if (ret)
 		return ret;
 
@@ -1662,7 +1662,7 @@ int thc_i2c_set_rx_int_delay(struct thc_device *dev, u32 delay_us)
 	if (!delay_us)
 		return -EOPNOTSUPP;
 
-	ret = regmap_read(dev->thc_regmap, THC_M_PRT_SW_SEQ_STS_OFFSET, &val);
+	ret = regmap_read(dev->thc_regmap, THC_M_PRT_SPI_ICRRD_OPCODE_OFFSET, &val);
 	if (ret)
 		return ret;
 
-- 
2.51.0



