Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 749EE1E9078;
	Tue, 15 Oct 2024 11:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992522; cv=none; b=gu81URV6Kso/ei1se6bz5eE9DQCchpC4X9EYbsOQfLHRl2OO/RIjrkw+iph5xi0jImE/JJyMkAtRwFm+ihQEfBmzO1q350tuW49Pioir1tzK+/H24P9nktbluqrR+j395UaVG+E2TFrrpPxAnzZqQei5yYvnU5zhdhA50PNbtDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992522; c=relaxed/simple;
	bh=zDAYsjQbcY64oGv8R3lz2/k8zFf+kXsaaIi+Y0zz4ec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i7a1OieVCeiLf+SFnOGLBKVY+ZdXLem5Q+rL3v+cZ1Ip1J68KJ+8PhSkaGNBqmArkegtme/VZfjodlu2/YZ015rSypLx2lkavPQOvq/6acl8WoramceYZXa897nas+rpfnDwBqkV8MmLrHqrVlVv/bRYQ/Vhgp3Mz7E40x4joV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hYXa5W/O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hYXa5W/O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D843EC4CEC6;
	Tue, 15 Oct 2024 11:42:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992522;
	bh=zDAYsjQbcY64oGv8R3lz2/k8zFf+kXsaaIi+Y0zz4ec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hYXa5W/OHRYdaHs4yNZIYr+ITk2T6PzMpaC/ttGkj2LyqRPlrOeTRrgydCEkPnTgf
	 RzOWdV1pWLLbqe3EhZHAu8gNmAUDY7nkFOtI9IxqNP3g3lKm73SgrrIl3+cdCYD1YY
	 0MIyiLlJxHHt86qH2qAqF3wWjMKefnwqtB2N0YGQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 139/691] spi: ppc4xx: handle irq_of_parse_and_map() errors
Date: Tue, 15 Oct 2024 13:21:27 +0200
Message-ID: <20241015112445.871842783@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 1179a1115137f..edfe0896046f9 100644
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



