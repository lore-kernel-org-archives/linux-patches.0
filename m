Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 810861C07C8;
	Tue, 15 Oct 2024 12:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997130; cv=none; b=ajrbIxJlA5Cud8w8pPjUSFOGFn0vKS4a6B1I3ygFFYol1app4blz/ReIk3q11eswaB3D7ibVcdhoVNAO3ckf87lQRlCBTkWDj4QR5H2C9tEvrKmh7wSZ2o+Eg1onNjoNyN0Ao6XBcLnsX1A5JDaiL7PtmoBAR5MXgh+ZU3SL0G0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997130; c=relaxed/simple;
	bh=jJXLgQLq5TfHyFGpgvr9J9/IrD68CzJZO2B6eZe93Rw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sgmeC/No299XOiV9rpgJYiIz/3QcJX5HLW2fQtUhpeStp1jJGUGmUmdE6PHz6dgLCJFxPn3BwaUZZXkOURfpOJSpQC0ZiJDObXqPzvLSrtNwZ9XS+Bg3injTGpim2PeCtwriPLKi4VHwfMeaJ+hfcl7nQem+GKdKsyg5ty/dvQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0XsMNeGu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0XsMNeGu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7965C4CEC6;
	Tue, 15 Oct 2024 12:58:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997130;
	bh=jJXLgQLq5TfHyFGpgvr9J9/IrD68CzJZO2B6eZe93Rw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0XsMNeGuUXNMG8packbvpyJ7vGcrUOmvlt5zdJZUW5FFChQYPs7pM8jTWoQWA2L6P
	 pVPlTjbDpJPb62avW+RJBdpT/Vf6VwV8bUuenGUq7JslCilqIBulXDMn5DBpJX41oF
	 AsNkOYlgfpayclRMkGcFuy3RZG/ALqhCE1Fq4S/o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 095/518] spi: ppc4xx: handle irq_of_parse_and_map() errors
Date: Tue, 15 Oct 2024 14:39:59 +0200
Message-ID: <20241015123920.668179373@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 4200b12fc347f..bfcfafda3eb1c 100644
--- a/drivers/spi/spi-ppc4xx.c
+++ b/drivers/spi/spi-ppc4xx.c
@@ -411,6 +411,9 @@ static int spi_ppc4xx_of_probe(struct platform_device *op)
 
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



