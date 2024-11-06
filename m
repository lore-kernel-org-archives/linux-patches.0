Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C4801F6687;
	Wed,  6 Nov 2024 12:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897895; cv=none; b=otOS28kSvWcZ1hE99hiFgpSvZ3TxvjsiV7jMZ2gUinRpopfqhAWC8LN44kjGV2ksr4GZ/j2I7r0Y2ugUygRG7pg6HWkYhMQrCaMtpp+hhmSCP9YWqPJ5qmz1DgQerlFn2YMy8jTH3o30T2IhZjWAuHOj/lvx4AlFffj+E65J8Ok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897895; c=relaxed/simple;
	bh=vLqfXKpkXuqzxQ0MFY482nIJNixMTJ0RZvS+rUZKYq0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jco1REQH/eLxYjn6kFYtrJHyCDtq4Thwx8FIZZb/0F0sD9HFHDr4DG3ps8cTw/A7bOdEutMT1wRnjlu1Te5w956IMedwfP8Xf8gRd4t7laVbqs8jkIvyp2ZwZWlXH4wUrGlvH4CiWrdK0R4n7tgJpwibWr29NyaGTT/fIunMCMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u7wKCX6R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u7wKCX6R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90133C4CED4;
	Wed,  6 Nov 2024 12:58:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897895;
	bh=vLqfXKpkXuqzxQ0MFY482nIJNixMTJ0RZvS+rUZKYq0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u7wKCX6RIE51tI9kzYlTAzflq0IY5XePEIQS1abfppGdPur3X/aTwd3TMeSS67SP0
	 IsXPCXw2VWgKTJhHL64TE1qeBIPcGYBcn16Q2d9jzXIXzsj9et/k84niSzN5vbBIxJ
	 twCx0otFw3mR8VliaXbs73SNR8hNOZvaJqCuuSfo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 055/462] spi: ppc4xx: handle irq_of_parse_and_map() errors
Date: Wed,  6 Nov 2024 12:59:08 +0100
Message-ID: <20241106120332.877068210@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 738a1e4e445e2..9e72ee73c2f61 100644
--- a/drivers/spi/spi-ppc4xx.c
+++ b/drivers/spi/spi-ppc4xx.c
@@ -492,6 +492,9 @@ static int spi_ppc4xx_of_probe(struct platform_device *op)
 
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



