Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 852FC1DF24B;
	Wed,  6 Nov 2024 12:08:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730894912; cv=none; b=o8Jp7TVPJepLfbNgQg9tXB4D7CzbL+GwCeR/HJS+j47HRfvsmCn9/IzS6bYlqrh4QKPjwTxENsUNMs2yv2rfVEsUQULh0GuW9lcJnBmgxR2+DDMnr+tm1sJSuCJEiCYprZ0CmKgMVkgrqqxCka5Nw5U9V6bSDLOGU/0bP0fxtgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730894912; c=relaxed/simple;
	bh=DR1RLQR18gwfhm11vMTowKd4myGXcj5k2i/ONdm75v8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UGYfZE54wrkm6MoHN6w7YtLU9Tp92lvw583txoEX2GzSrNZvTdbXf1RPW+GL+wZFoCzqEcHsxx2sb2/TlVNDXQTrCnM6Fh5+2OHPhd730GDSiNM3lZ9uy2AZ7yPLZKClhTkbQS82lycLtXyqkdgpuO7fOV5wPtJOXt7vgbA71l0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mRlGawdt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mRlGawdt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08F1CC4CECD;
	Wed,  6 Nov 2024 12:08:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730894912;
	bh=DR1RLQR18gwfhm11vMTowKd4myGXcj5k2i/ONdm75v8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mRlGawdt3QdoEw8IMMEzyLbzgmSKfqgXlSgNl/2monLs8YsOAceitLq3ZwrYUnHHE
	 m7zzhjHxSLZx+G19WwF4PjOWaDO48bfCppX3spSyjsOWRHgQGsHvC/NbXs8kiHBdWt
	 ZKAqbH37PxDLefXbCPJylpzlChcEQBKOKMSUamoY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 040/350] spi: ppc4xx: handle irq_of_parse_and_map() errors
Date: Wed,  6 Nov 2024 12:59:28 +0100
Message-ID: <20241106120321.877028768@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 58765a62fc15b..8a1290fb4dd9d 100644
--- a/drivers/spi/spi-ppc4xx.c
+++ b/drivers/spi/spi-ppc4xx.c
@@ -495,6 +495,9 @@ static int spi_ppc4xx_of_probe(struct platform_device *op)
 
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



