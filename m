Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 272F6330B2E;
	Fri, 17 Oct 2025 15:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760716504; cv=none; b=uYtQ49EaVZsdEETRb5OrUpSpqcAiDQl1eXk7DEJ30fBHe9yZskhkSj9xIzfgVAqQZL7ynxnZAFF8/EvsbEbf1bvn2IOTc2Tfa9SNo1tbfu7MSHSO4WOlEZ0vEHReQVtnZHCCOJ1O67TgRCEx9BpKYvrw6i0JdxDrRpKqS+WPEDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760716504; c=relaxed/simple;
	bh=G6jyDXm09ma55RMnvWp4wfuPzomf4M3W9lRKTBtV4PM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LYKJWThPf06VRYoJxt3eoOaReDPVwdvtCkchKbvWgQRzGmJyO6UJ1ZhrOCzQk7tR7TYjIKf4Yr6wzho1c0gmrnlw9QD4hmtGgwLstsRs/0CJvBHOtL831EAZTkGOFoQWghUDvpb8p4JI0bCuxjgCn4uPRWu3N7GGMb5i1OE6QZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gxr3eUHn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gxr3eUHn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A001BC113D0;
	Fri, 17 Oct 2025 15:55:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760716504;
	bh=G6jyDXm09ma55RMnvWp4wfuPzomf4M3W9lRKTBtV4PM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gxr3eUHnssTg1s/Gwq88rzJfiHk42yJkqqDX0l9U3PhGFjL9Vs4JZOqtj8129YdkX
	 nrQe2F5JOSjyxe+srcfyA3/myE3/Ym3/dF7o4FXCdIg0487Vyvsh3LOuaucx4Q9gor
	 28yRVjMAN/PnjbCbB5rl1W1hR0aNRs+4rWrsD4+I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pratyush Yadav <pratyush@kernel.org>,
	Santhosh Kumar K <s-k6@ti.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.15 212/276] spi: cadence-quadspi: Flush posted register writes before INDAC access
Date: Fri, 17 Oct 2025 16:55:05 +0200
Message-ID: <20251017145150.203042791@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145142.382145055@linuxfoundation.org>
References: <20251017145142.382145055@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pratyush Yadav <pratyush@kernel.org>

commit 29e0b471ccbd674d20d4bbddea1a51e7105212c5 upstream.

cqspi_indirect_read_execute() and cqspi_indirect_write_execute() first
set the enable bit on APB region and then start reading/writing to the
AHB region. On TI K3 SoCs these regions lie on different endpoints. This
means that the order of the two operations is not guaranteed, and they
might be reordered at the interconnect level.

It is possible for the AHB write to be executed before the APB write to
enable the indirect controller, causing the transaction to be invalid
and the write erroring out. Read back the APB region write before
accessing the AHB region to make sure the write got flushed and the race
condition is eliminated.

Fixes: 140623410536 ("mtd: spi-nor: Add driver for Cadence Quad SPI Flash Controller")
CC: stable@vger.kernel.org
Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
Signed-off-by: Pratyush Yadav <pratyush@kernel.org>
Signed-off-by: Santhosh Kumar K <s-k6@ti.com>
Message-ID: <20250905185958.3575037-2-s-k6@ti.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-cadence-quadspi.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/spi/spi-cadence-quadspi.c
+++ b/drivers/spi/spi-cadence-quadspi.c
@@ -694,6 +694,7 @@ static int cqspi_indirect_read_execute(s
 	reinit_completion(&cqspi->transfer_complete);
 	writel(CQSPI_REG_INDIRECTRD_START_MASK,
 	       reg_base + CQSPI_REG_INDIRECTRD);
+	readl(reg_base + CQSPI_REG_INDIRECTRD); /* Flush posted write. */
 
 	while (remaining > 0) {
 		if (!wait_for_completion_timeout(&cqspi->transfer_complete,
@@ -834,6 +835,8 @@ static int cqspi_indirect_write_execute(
 	reinit_completion(&cqspi->transfer_complete);
 	writel(CQSPI_REG_INDIRECTWR_START_MASK,
 	       reg_base + CQSPI_REG_INDIRECTWR);
+	readl(reg_base + CQSPI_REG_INDIRECTWR); /* Flush posted write. */
+
 	/*
 	 * As per 66AK2G02 TRM SPRUHY8F section 11.15.5.3 Indirect Access
 	 * Controller programming sequence, couple of cycles of


