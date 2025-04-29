Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 726AC1DF73C;
	Tue, 29 Apr 2025 17:08:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946522; cv=none; b=Sy6GUja6uYWATneucRHXj7aPgSk9+H7i8hHmM5mHb4ATG+35Vv7b96wg9dfkA6BuIX13Me+CwwmEM6qOt75bntzJCZuQnnBfujqqdZrDMaqzbkvGqhyKqWQvT1mCu8ZI/XRiY3w9wzZaG31m/ni6LWsAxmXQkfBKIWk+FBJfYxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946522; c=relaxed/simple;
	bh=zXML0l1YcaPLvzLWC/WCwJ1VO1TxyOk2gJRT2Fm8Hl0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ibFUXmQIFp9RBLLQx7ulbWHeMCg2+XSBFNmGEvFDuMIO2HdeH7DctJtxQKjBdE0jTBknSc7eUzgUjOEQLfcWeXIIWdV4uC8PW3VS7N915N3urIl09qaxIeVBzcMKESUdAFjzNaWhsQujFoosKJ7JxQzjMqwDP6rAHfX/lk3LisQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dAs3TynG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dAs3TynG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2C78C4CEE3;
	Tue, 29 Apr 2025 17:08:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946522;
	bh=zXML0l1YcaPLvzLWC/WCwJ1VO1TxyOk2gJRT2Fm8Hl0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dAs3TynGsZIK15IzNyYfZA5XFCPcXiYQOPxM+4VcRNOmbMlVpdR7c9nFsl+GOCLiP
	 nS8vJRMy/mpsLdnisU4sKVMr6+0egndoKNe6mIdkppeT3f4KvIPTsaUj/ccyenQS5x
	 7rn7ahbP3VGhhrcPB2vEfuJibWPdiafxK2ldK/H0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tamura Dai <kirinode0@gmail.com>,
	Carlos Song <carlos.song@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 295/311] spi: spi-imx: Add check for spi_imx_setupxfer()
Date: Tue, 29 Apr 2025 18:42:12 +0200
Message-ID: <20250429161133.080746316@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index eeb7d082c2472..c43fb496da956 100644
--- a/drivers/spi/spi-imx.c
+++ b/drivers/spi/spi-imx.c
@@ -1695,9 +1695,12 @@ static int spi_imx_transfer_one(struct spi_controller *controller,
 				struct spi_device *spi,
 				struct spi_transfer *transfer)
 {
+	int ret;
 	struct spi_imx_data *spi_imx = spi_controller_get_devdata(spi->controller);
 
-	spi_imx_setupxfer(spi, transfer);
+	ret = spi_imx_setupxfer(spi, transfer);
+	if (ret < 0)
+		return ret;
 	transfer->effective_speed_hz = spi_imx->spi_bus_clk;
 
 	/* flush rxfifo before transfer */
-- 
2.39.5



