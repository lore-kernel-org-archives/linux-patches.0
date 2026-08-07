Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 920B835A38C;
	Fri,  7 Aug 2026 15:23:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116182; cv=none; b=OpGZtURPqybSFsHoqCqP6Dk8B5HbaIQiKA1IG2gf3zH6n6IZwf0QBDVQy8JPlcLevdbDihr2o3d5B7rATSrLwWMTwG8cuMc2guXrTcXI8/nQFzxD6QkJNc+VOUgbiv/3rh4uCkNMRjQxIRpnKcrqSZxypEkWfo6cN1arEYGUsFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116182; c=relaxed/simple;
	bh=NmxB2gfG0eIBDBSNVGQjwMnCv8b1H3nGkVDonP8OOK8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KPiipneQQduZYmw0BkOgW0L906S0FhDQ8MUt2l60D2+PptX+OAhsFT7ny4Itz5coFjmWs86RoBCaIeyHEzTChHZSX7HXmpxB3LjZ52hMzD0KH8Iovs1DOpUjFBp1fqJ7Zvf3Euq1oJhO8jy/B1DlY1NRyx7WPwi9HtMxBRd1VvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y0jgXNam; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y0jgXNam"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC7DF1F00A3D;
	Fri,  7 Aug 2026 15:23:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116181;
	bh=xXfCZGqNIFfX3jn81SuK5Tc4yDDhmlw1kyPx+IXSjTU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y0jgXNam5EFs1u/2FEmehc4qZ4+y/t+CxB0+NsEUdAj/+pZMwfqlCK8qhyj5vQeQG
	 gzOGWOUgwPKNXU97XlEZ7sQ+gHccpahZChHdXi+li+Kt3lvZqarOmnVLfUAj3XM8bj
	 CoKwPjM/64VtktVw2JoNKdQBrGpI51sHuhogVQFM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vijaya Krishna Nivarthi <vijaya.nivarthi@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.6 141/261] spi: qcom-qspi: Correct max DMA length to avoid 64K boundary failure
Date: Fri,  7 Aug 2026 16:38:18 +0200
Message-ID: <20260807143418.406533798@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143415.358597922@linuxfoundation.org>
References: <20260807143415.358597922@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vijaya Krishna Nivarthi <vijaya.nivarthi@oss.qualcomm.com>

commit 90ef2f2961c2dc55957dafe2f53b3efdb4675efc upstream.

The maximum size for a DMA data descriptor is 64KB-1 because the size
field in HW is 16 bits wide. For this reason, transfers fail at 64KB
and beyond.

Lower max_dma_len to 60KB so larger transfers are split into multiple
DMA blocks and do not hit the failing 64KB boundary. 60KB is chosen as
a safe round number below the 64KB-1 hardware limit while satisfying
alignment requirements.

Tested on x1e80100 (Hamoa) with SPI-NOR flash (/dev/mtd0):

Without patch:
  dd if=/dev/mtd0 of=/tmp/spi_dump.bin bs=32768 count=2  # works
  dd if=/dev/mtd0 of=/tmp/spi_dump.bin bs=65536 count=1  # fails

With patch:
  dd if=/dev/mtd0 of=/tmp/spi_dump.bin bs=65536 count=1  # works

Fixes: b5762d95607e ("spi: spi-qcom-qspi: Add DMA mode support")
Cc: stable@vger.kernel.org
Signed-off-by: Vijaya Krishna Nivarthi <vijaya.nivarthi@oss.qualcomm.com>
Link: https://patch.msgid.link/20260722092358.459943-1-vnivarth@qti.qualcomm.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-qcom-qspi.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/spi/spi-qcom-qspi.c
+++ b/drivers/spi/spi-qcom-qspi.c
@@ -759,7 +759,8 @@ static int qcom_qspi_probe(struct platfo
 		return dev_err_probe(dev, ret, "could not set DMA mask\n");
 
 	host->max_speed_hz = 300000000;
-	host->max_dma_len = 65536; /* as per HPG */
+	/* as per HPG, it is 64KB, limit to 60KB to avoid boundary condition failures */
+	host->max_dma_len = 0xf000;
 	host->dma_alignment = QSPI_ALIGN_REQ;
 	host->num_chipselect = QSPI_NUM_CS;
 	host->bus_num = -1;


