Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D39A32BF2F;
	Mon, 27 Oct 2025 18:48:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761590882; cv=none; b=Y5llov+hGdm0MlCp+702NDM6pq2I2dnyUhTXy6jkfp4mwWCc5C3CusU4giWp1nHBH8mpG7sMCWkGhoWGql/E694SAt5T0Ntn2N2e4X0MXopKQPFo+0FxnMPYbG45/JwA+WFtqs3IXCm74tt+i7zQ1US7qGKQNA6YqmY8XjIzMHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761590882; c=relaxed/simple;
	bh=JFzprf0XW+H8l8s9QaucaWPAUBfns+onFY3f/qxtYEg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g6OdYitLQmDLlpMwJ6VuiHngDjWgTWRVwL6YAf8toAnpEQGnkqbu3irbSIb8Cu+dNap8wEwTxuoZES4eV4aYjNOQomO2Ak3qMSn6zQ1NcUmUZqh3Pyin4RRrjDXDA3WzXsD4uHKe5Q+5w8XL9pYwryQjt7p2ON/BqeoLZ9hH1ug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nqRMJeBI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nqRMJeBI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5111C4CEF1;
	Mon, 27 Oct 2025 18:48:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761590882;
	bh=JFzprf0XW+H8l8s9QaucaWPAUBfns+onFY3f/qxtYEg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nqRMJeBI2eEtv5HC+26z0hNzzJIiQdL+rEg6g/AVpcIGMzb1H2wkv4Clc+G7TLIyu
	 o2CtA8HsB+iVNowXSMRG05YI7Vn9lm4lPMQmJSs7Ar0QOGYW2PhC3NTqGFNJMOfCH/
	 Mtq9hMHstNO+UgRJG3ROZ5qBgp4IiLaYfugYBMRk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pratyush Yadav <pratyush@kernel.org>,
	Santhosh Kumar K <s-k6@ti.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 211/224] spi: cadence-quadspi: Flush posted register writes before INDAC access
Date: Mon, 27 Oct 2025 19:35:57 +0100
Message-ID: <20251027183514.404674585@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183508.963233542@linuxfoundation.org>
References: <20251027183508.963233542@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pratyush Yadav <pratyush@kernel.org>

[ Upstream commit 29e0b471ccbd674d20d4bbddea1a51e7105212c5 ]

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
[ applied changes to drivers/mtd/spi-nor/cadence-quadspi.c instead of drivers/spi/spi-cadence-quadspi.c ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/spi-nor/cadence-quadspi.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/mtd/spi-nor/cadence-quadspi.c
+++ b/drivers/mtd/spi-nor/cadence-quadspi.c
@@ -523,6 +523,7 @@ static int cqspi_indirect_read_execute(s
 	reinit_completion(&cqspi->transfer_complete);
 	writel(CQSPI_REG_INDIRECTRD_START_MASK,
 	       reg_base + CQSPI_REG_INDIRECTRD);
+	readl(reg_base + CQSPI_REG_INDIRECTRD); /* Flush posted write. */
 
 	while (remaining > 0) {
 		if (!wait_for_completion_timeout(&cqspi->transfer_complete,
@@ -633,6 +634,8 @@ static int cqspi_indirect_write_execute(
 	reinit_completion(&cqspi->transfer_complete);
 	writel(CQSPI_REG_INDIRECTWR_START_MASK,
 	       reg_base + CQSPI_REG_INDIRECTWR);
+	readl(reg_base + CQSPI_REG_INDIRECTWR); /* Flush posted write. */
+
 	/*
 	 * As per 66AK2G02 TRM SPRUHY8F section 11.15.5.3 Indirect Access
 	 * Controller programming sequence, couple of cycles of


