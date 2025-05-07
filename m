Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0A55214813;
	Wed,  7 May 2025 18:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746643808; cv=none; b=SKiXK4qmivvtlGPOmACR5Of+njxpCHdvpZnUH2RtCJZOWtt9Rpk889S3FKS/UEd2Xx+kzFKqA95uTnaxlQ+HsUMvSkKE9UHXpuGEC5jvmCIkFkPTXcEdrQRWXY150Tmz81/pxWk+HY46cCo1PV2CMBxk3wE27kUCORlmw1a0y2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746643808; c=relaxed/simple;
	bh=tEp2dOwBdyqt6++z2QyXJZDw/wj5xNqcyNQTqwNIFeQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pfPiG01BgporXhXn1KbOQi1JAYQPtOPfRgTrxFBFWwrEBp2teuYaCktYcpH0YL4HG2g2m5bdFxWWSRihCa4de5xj4fmVR9G942dX7yx9cFa4VURPGZaAba++7VjzPkNCNkNcNTTasGZ/KnnALRSuwDktY/BsaCah/myqlcvGFoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P9EeYHZf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P9EeYHZf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB86EC4CEE2;
	Wed,  7 May 2025 18:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746643807;
	bh=tEp2dOwBdyqt6++z2QyXJZDw/wj5xNqcyNQTqwNIFeQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P9EeYHZfDkplqjyI7+Mb4xHjhXRXDyBI7qOZVlQNU2W+RdjRMMM8ekDNvPJiPwGtD
	 S33INTbO7Kt93y+BGX2fQuR1u35YEgiCJnUMlbgOBjHGSdVBfXoxW4+j4Kpg1Ojadm
	 HsgCB8yI02Y8BKRqoWaDRSJUFd7vM1Bti+KyiAH8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaron Kling <webgeek1234@gmail.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.14 024/183] spi: tegra114: Dont fail set_cs_timing when delays are zero
Date: Wed,  7 May 2025 20:37:49 +0200
Message-ID: <20250507183825.666183188@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183824.682671926@linuxfoundation.org>
References: <20250507183824.682671926@linuxfoundation.org>
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

From: Aaron Kling <webgeek1234@gmail.com>

commit 4426e6b4ecf632bb75d973051e1179b8bfac2320 upstream.

The original code would skip null delay pointers, but when the pointers
were converted to point within the spi_device struct, the check was not
updated to skip delays of zero. Hence all spi devices that didn't set
delays would fail to probe.

Fixes: 04e6bb0d6bb1 ("spi: modify set_cs_timing parameter")
Cc: stable@vger.kernel.org
Signed-off-by: Aaron Kling <webgeek1234@gmail.com>
Link: https://patch.msgid.link/20250423-spi-tegra114-v1-1-2d608bcc12f9@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-tegra114.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/spi/spi-tegra114.c
+++ b/drivers/spi/spi-tegra114.c
@@ -728,9 +728,9 @@ static int tegra_spi_set_hw_cs_timing(st
 	u32 inactive_cycles;
 	u8 cs_state;
 
-	if (setup->unit != SPI_DELAY_UNIT_SCK ||
-	    hold->unit != SPI_DELAY_UNIT_SCK ||
-	    inactive->unit != SPI_DELAY_UNIT_SCK) {
+	if ((setup->unit && setup->unit != SPI_DELAY_UNIT_SCK) ||
+	    (hold->unit && hold->unit != SPI_DELAY_UNIT_SCK) ||
+	    (inactive->unit && inactive->unit != SPI_DELAY_UNIT_SCK)) {
 		dev_err(&spi->dev,
 			"Invalid delay unit %d, should be SPI_DELAY_UNIT_SCK\n",
 			SPI_DELAY_UNIT_SCK);


