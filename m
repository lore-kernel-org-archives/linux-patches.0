Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA2151D0954;
	Wed,  2 Oct 2024 13:25:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875529; cv=none; b=RfzZQIHiiGuGk1TzmU7CQWAYpeqogpBTCdSCsTUN7viyTrc4iSgZr72MZr5T9JKfVtzVf0Q/DBO7cbTSdoukCo4M+Toht8G95kD8ZDzLViu0HDuTBtj7Vh7XwN1b7ewUlyVwz3olrEDp1XTewOgAffWBUbX7QFOo6IzPcHF1mE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875529; c=relaxed/simple;
	bh=EKHzJ+RdPXj0HwPffFi8KU47Pu1c2MqDBMJsst+Gkxk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uY5tZciaGcK6gWprmKpTjua97Cym5XPjypifPN97VBLnbr5KCmFoHJakfy5eTPQzT15diESRykrcC7n2nbEvqbvVA6BvcWE9cgSkpk2SMvbLJVmRa3fRGeiCOgXjVGe+ST0D6cH7+4IR/qcc1JREjV1TL348mQHV6+GHsQWaOpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZFIlklzR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZFIlklzR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 602DCC4CEC5;
	Wed,  2 Oct 2024 13:25:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875529;
	bh=EKHzJ+RdPXj0HwPffFi8KU47Pu1c2MqDBMJsst+Gkxk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZFIlklzRft+tiY3SyRgPfQHZ4KHbhNuEOOIGBqIZA1iua5I6PIZdULONtJrfpC9D+
	 VIp3Fh0zK1qaE0uBF05tJUSuXcgk1UlRQnFeDHcIx+r9Ie/8QPpdrayK2lvMC5dLoU
	 Vo7sD7EJo5mZRnWuFiV5avZo4wNZaHoeYuyXxiiM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 133/695] spi: ppc4xx: handle irq_of_parse_and_map() errors
Date: Wed,  2 Oct 2024 14:52:11 +0200
Message-ID: <20241002125827.790406591@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ma Ke <make24@iscas.ac.cn>

[ Upstream commit 0f245463b01ea254ae90e1d0389e90b0e7d8dc75 ]

Zero and negative number is not a valid IRQ for in-kernel code and the
irq_of_parse_and_map() function returns zero on error.  So this check for
valid IRQs should only accept values > 0.

Fixes: 44dab88e7cc9 ("spi: add spi_ppc4xx driver")
Signed-off-by: Ma Ke <make24@iscas.ac.cn>
Link: https://patch.msgid.link/20240724084047.1506084-1-make24@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-ppc4xx.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/spi/spi-ppc4xx.c b/drivers/spi/spi-ppc4xx.c
index 942c3117ab3a9..01fdecbf132d6 100644
--- a/drivers/spi/spi-ppc4xx.c
+++ b/drivers/spi/spi-ppc4xx.c
@@ -413,6 +413,9 @@ static int spi_ppc4xx_of_probe(struct platform_device *op)
 
 	/* Request IRQ */
 	hw->irqnum = irq_of_parse_and_map(np, 0);
+	if (hw->irqnum <= 0)
+		goto free_host;
+
 	ret = request_irq(hw->irqnum, spi_ppc4xx_int,
 			  0, "spi_ppc4xx_of", (void *)hw);
 	if (ret) {
-- 
2.43.0



