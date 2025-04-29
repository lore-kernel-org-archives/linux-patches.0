Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26007155A4E;
	Tue, 29 Apr 2025 18:18:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950737; cv=none; b=UWAbadFFpPXUJqLFwDffRbwiMYrNk3MBOwuTI96WtyK37eytQpPzEoH4OjRoJgdj6/SQmVgYAVlw9U60Tb7gfgeYBYB11HCDOIUl8erD3gzXg+DOYotpHvtuBBx062f6X0maLqSjtAbNxT+ZGkc4JP0PXVp84sXaQT6Fn4N4B+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950737; c=relaxed/simple;
	bh=MQV7VVe4djKJN83oYg9O7vWRqIxiHRe6ayCPmwPct7Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MbsvyLuFVl3Zto5jpjfjo5eya/V7oq5pNABu1a3EV+sdjurxfy2n17PjZqhUW0FqHy2Xhkzf6MA+hJg5ZOPeEsiUZ/GxfUka5ysl8s9dCSNiu4PIhlMfVPRokFUDpyagF+5VytxVQv//RhEL9AcBsfpD498CVAkFuft2C6ekdfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aNOQiLwA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aNOQiLwA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94FDAC4CEE3;
	Tue, 29 Apr 2025 18:18:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950737;
	bh=MQV7VVe4djKJN83oYg9O7vWRqIxiHRe6ayCPmwPct7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aNOQiLwApzHBw0+cBuhSGFU8BJk8iDOoi6RLKmp0ZpSS9gCUjbfkAU4ikLt1b9kpF
	 34LOpfo0K3GoBqC6o+2HY7td1KISq/ThR3WQFzjT3ejtpMMMn6DRLHqB/QyEzMi9c4
	 LoOh9Q9xyTIt8HyM4Xu9NcCujtywDwye2xKvJx5c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tamura Dai <kirinode0@gmail.com>,
	Carlos Song <carlos.song@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 188/204] spi: spi-imx: Add check for spi_imx_setupxfer()
Date: Tue, 29 Apr 2025 18:44:36 +0200
Message-ID: <20250429161107.076426913@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161059.396852607@linuxfoundation.org>
References: <20250429161059.396852607@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tamura Dai <kirinode0@gmail.com>

[ Upstream commit 951a04ab3a2db4029debfa48d380ef834b93207e ]

Add check for the return value of spi_imx_setupxfer().
spi_imx->rx and spi_imx->tx function pointer can be NULL when
spi_imx_setupxfer() return error, and make NULL pointer dereference.

 Unable to handle kernel NULL pointer dereference at virtual address 0000000000000000
 Call trace:
  0x0
  spi_imx_pio_transfer+0x50/0xd8
  spi_imx_transfer_one+0x18c/0x858
  spi_transfer_one_message+0x43c/0x790
  __spi_pump_transfer_message+0x238/0x5d4
  __spi_sync+0x2b0/0x454
  spi_write_then_read+0x11c/0x200

Signed-off-by: Tamura Dai <kirinode0@gmail.com>
Reviewed-by: Carlos Song <carlos.song@nxp.com>
Link: https://patch.msgid.link/20250417011700.14436-1-kirinode0@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-imx.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-imx.c b/drivers/spi/spi-imx.c
index daa32bde61556..da4442954375b 100644
--- a/drivers/spi/spi-imx.c
+++ b/drivers/spi/spi-imx.c
@@ -1614,10 +1614,13 @@ static int spi_imx_transfer_one(struct spi_controller *controller,
 				struct spi_device *spi,
 				struct spi_transfer *transfer)
 {
+	int ret;
 	struct spi_imx_data *spi_imx = spi_controller_get_devdata(spi->controller);
 	unsigned long hz_per_byte, byte_limit;
 
-	spi_imx_setupxfer(spi, transfer);
+	ret = spi_imx_setupxfer(spi, transfer);
+	if (ret < 0)
+		return ret;
 	transfer->effective_speed_hz = spi_imx->spi_bus_clk;
 
 	/* flush rxfifo before transfer */
-- 
2.39.5



