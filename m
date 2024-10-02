Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC8631D2239;
	Wed,  2 Oct 2024 14:29:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879355; cv=none; b=ss1OwKhD1yruZ4PiIBjjtu3jRtiaXMUBRPpupsbivDmJPnRaL9RqcGpSNJ6a0nwzrkRkrJ2D/4ZS4XE6bATOVXKiVeqtSwp3MjnYNc5UZG1QCDHsd5m6ZSgdmUpN+iFEeQkvYsAqxlv5Yb1WnJmzcYuB1nqRDfe7zrXjn5x2wY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879355; c=relaxed/simple;
	bh=tY94KjcZrYPGhKmfOGeCTW333zXCdopRSyKb4ANhfuo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IX6v2DKydpcPGbLsqziR8/+0bBgjR4cnTVP0lWI+DpVlE8gv8UJZ6pU6ICTdQuvxpCd2psrYeUvSn6NoSicuY6j7agiHZ26ktiYWHjOjM5GA/2OJs4QLmy0bWX2fpCSrSQnSF1u7Z9ET5eDW/VOkKitGzEWLS6062edc4ixV5vA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2Shrhv/o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2Shrhv/o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39169C4CEC2;
	Wed,  2 Oct 2024 14:29:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879355;
	bh=tY94KjcZrYPGhKmfOGeCTW333zXCdopRSyKb4ANhfuo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2Shrhv/ouu3CV4wEUjLGLn2mBy/rbiNQZ1uOjDU6TzKjclbr+pM9achm1MI56nkYV
	 dJtLBthc70oGEBszH6jdZPpMFA2weANhyX/mAcPaqNzbta2BjzIGNJda7X5jL30Pke
	 H9xN/EZcCbiDFqBhYCMweOLgMn/RT4laOgzNWPQQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 089/538] spi: ppc4xx: handle irq_of_parse_and_map() errors
Date: Wed,  2 Oct 2024 14:55:28 +0200
Message-ID: <20241002125755.738693822@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index e982d3189fdce..0d698580194e9 100644
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



