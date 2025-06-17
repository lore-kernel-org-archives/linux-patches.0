Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E39872F2351;
	Tue, 17 Jun 2025 15:51:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175518; cv=none; b=WU7e44r+4lQS0JcR9VPmJrSsm5GxJrELocgyg8nKgOlg2bvJNep27qOlSD/JxcZjIUwmZZJH7NoBqynbAZhLp2ngdwjSGn7f0O/QbV0A3i52o226bIkZ6dqZIKYXn0FmvQTVSRrSORpZpqvNRn3GbQRxOrB68sRzhG4xvbvAu+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175518; c=relaxed/simple;
	bh=T4cNAhwazs/YrWR6jKZc67L1YqH8jjG+V8Qe67J6p8k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mCPZs4m/whGKvanwBW8QpCYcBWHRrMPYrpo09GQtd2puOdrIqP1qqtL4vfUmrGibFGNYyXWU8rOJC0cfkZqhA2dCu99Dt6hdTZeWqK6piWTevz4AkD5ry30IXLeoKWYxuDGKOMW/nOCh/9T4Pr7ZR7EHdaYsne6CCfuI/80Z344=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LDoQKUz0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LDoQKUz0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55E0CC4CEE3;
	Tue, 17 Jun 2025 15:51:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175517;
	bh=T4cNAhwazs/YrWR6jKZc67L1YqH8jjG+V8Qe67J6p8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LDoQKUz029JZyljXuJ2XAH2ujV3dMZp+5a1KYFe0X0rxH7upudPSv6J0PITj0uOMb
	 C64oslm2kDX+p0bAVW3nd5QbiNLNxbCaGzgo1XO+ACEdDUgs/SIssxCID2AaBzhVl1
	 6aX4/AVyvdOlpLXhWycqJc+51zL2GV/Bfi9hy67s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabor Juhos <j4g8y7@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 078/780] spi: spi-qpic-snand: use kmalloc() for OOB buffer allocation
Date: Tue, 17 Jun 2025 17:16:26 +0200
Message-ID: <20250617152454.686648654@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gabor Juhos <j4g8y7@gmail.com>

[ Upstream commit f48d80503504257682e493dc17408f2f0b47bcfa ]

The qcom_spi_ecc_init_ctx_pipelined() function allocates zeroed
memory for the OOB buffer, then it fills the buffer with '0xff'
bytes right after the allocation. In this case zeroing the memory
during allocation is superfluous, so use kmalloc() instead of
kzalloc() to avoid that.

Signed-off-by: Gabor Juhos <j4g8y7@gmail.com>
Link: https://patch.msgid.link/20250320-qpic-snand-kmalloc-v1-1-94e267550675@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 65cb56d49f6e ("spi: spi-qpic-snand: validate user/chip specific ECC properties")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-qpic-snand.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-qpic-snand.c b/drivers/spi/spi-qpic-snand.c
index 94948c8781e83..924aa8461963f 100644
--- a/drivers/spi/spi-qpic-snand.c
+++ b/drivers/spi/spi-qpic-snand.c
@@ -261,7 +261,7 @@ static int qcom_spi_ecc_init_ctx_pipelined(struct nand_device *nand)
 	ecc_cfg = kzalloc(sizeof(*ecc_cfg), GFP_KERNEL);
 	if (!ecc_cfg)
 		return -ENOMEM;
-	snandc->qspi->oob_buf = kzalloc(mtd->writesize + mtd->oobsize,
+	snandc->qspi->oob_buf = kmalloc(mtd->writesize + mtd->oobsize,
 					GFP_KERNEL);
 	if (!snandc->qspi->oob_buf) {
 		kfree(ecc_cfg);
-- 
2.39.5



