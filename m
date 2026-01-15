Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C021C3A35A4;
	Thu, 15 Jan 2026 17:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496730; cv=none; b=VhC98VBOpP8803fJqegTnZQOme8OWwumT456kqm51rat2rLKqqg4VURXAfnK3EtQ6uGZPcq2u0kjAbAjLBNvcb5KNCQHTf+Oka3MLoskm+8bTVowVSV35v3w3vUPICvJDZC7Rtra0hVRaEShO/llUQGn46FMsa6n3HkGzn8BANw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496730; c=relaxed/simple;
	bh=tNjTr2ZV0Nvb0MOHXkx9EaCTqTpxFm03+hekWwXYd3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oOz1cPzUOzGIbXRjFe6fgc+tcsX4LCTMO070t6yUojN1JIvx3GWQPYaptcU6+4/TfMuVQKC5s6/Gu/zRhC7SQQVi81Ef7Jk9hn5wNGXvCpr6NUsXkfzAW+NDUPgidi1trnUw38aZbh2a0Y1hRQPmhp1tjsEST/+MSeQzg8Lmhm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EkX8E2du; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EkX8E2du"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DC51C116D0;
	Thu, 15 Jan 2026 17:05:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496730;
	bh=tNjTr2ZV0Nvb0MOHXkx9EaCTqTpxFm03+hekWwXYd3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EkX8E2du1fK4DxZvgvRLwavxu26WdvzZKJX60qds6NIYfyeleSc+nl5UwytJjlro6
	 IcHDuWPUOTfc2NmzA8mkGX1HRr1D9xakJV2iAHFw81Sza8avai7jmrcEE+TVZmFOx0
	 wGoz73OUxm1wwr974QF1xB6Z2L8OckOGcI4fd7oI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mateusz Litwin <mateusz.litwin@nokia.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 116/119] spi: cadence-quadspi: Prevent lost complete() call during indirect read
Date: Thu, 15 Jan 2026 17:48:51 +0100
Message-ID: <20260115164156.148225718@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164151.948839306@linuxfoundation.org>
References: <20260115164151.948839306@linuxfoundation.org>
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

From: Mateusz Litwin <mateusz.litwin@nokia.com>

[ Upstream commit d67396c9d697041b385d70ff2fd59cb07ae167e8 ]

A race condition exists between the read loop and IRQ `complete()` call.
An interrupt could call the complete() between the inner loop and
reinit_completion(), potentially losing the completion event and causing
an unnecessary timeout. Moving reinit_completion() before the loop
prevents this. A premature signal will only result in a spurious wakeup
and another wait cycle, which is preferable to waiting for a timeout.

Signed-off-by: Mateusz Litwin <mateusz.litwin@nokia.com>
Link: https://patch.msgid.link/20251218-cqspi_indirect_read_improve-v2-1-396079972f2a@nokia.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-cadence-quadspi.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-cadence-quadspi.c b/drivers/spi/spi-cadence-quadspi.c
index aca3681d32ea1..e1d64a9a34462 100644
--- a/drivers/spi/spi-cadence-quadspi.c
+++ b/drivers/spi/spi-cadence-quadspi.c
@@ -758,6 +758,7 @@ static int cqspi_indirect_read_execute(struct cqspi_flash_pdata *f_pdata,
 	readl(reg_base + CQSPI_REG_INDIRECTRD); /* Flush posted write. */
 
 	while (remaining > 0) {
+		ret = 0;
 		if (use_irq &&
 		    !wait_for_completion_timeout(&cqspi->transfer_complete,
 						 msecs_to_jiffies(CQSPI_READ_TIMEOUT_MS)))
@@ -770,6 +771,14 @@ static int cqspi_indirect_read_execute(struct cqspi_flash_pdata *f_pdata,
 		if (cqspi->slow_sram)
 			writel(0x0, reg_base + CQSPI_REG_IRQMASK);
 
+		/*
+		 * Prevent lost interrupt and race condition by reinitializing early.
+		 * A spurious wakeup and another wait cycle can occur here,
+		 * which is preferable to waiting until timeout if interrupt is lost.
+		 */
+		if (use_irq)
+			reinit_completion(&cqspi->transfer_complete);
+
 		bytes_to_read = cqspi_get_rd_sram_level(cqspi);
 
 		if (ret && bytes_to_read == 0) {
@@ -802,7 +811,6 @@ static int cqspi_indirect_read_execute(struct cqspi_flash_pdata *f_pdata,
 		}
 
 		if (use_irq && remaining > 0) {
-			reinit_completion(&cqspi->transfer_complete);
 			if (cqspi->slow_sram)
 				writel(CQSPI_REG_IRQ_WATERMARK, reg_base + CQSPI_REG_IRQMASK);
 		}
-- 
2.51.0



