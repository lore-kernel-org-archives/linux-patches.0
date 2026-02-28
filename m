Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92FE021B9F5;
	Sat, 28 Feb 2026 17:58:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301539; cv=none; b=HKn9iyda4HLHiifML/9DsUTWw49jF68EYnsUK4iVhim18qV9TxSEyAqdsmxzoaLrkyGKsQ/ZSlWbYcqR727Yq8IaceHmagWCwut8AudjHzbg4wTXMw5ZFkZHv6blhq9Pay2zUU1ucHqBi8zfe3fntDrwwJUQBsewrALks2QbGz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301539; c=relaxed/simple;
	bh=dKiC0icjXP1TlfS6TPltT1637LnsHXjHUdGIYuZnsoM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FhHMB7MvUli41NWX1qFUQaSI6d9iJ6BgmbXgTeh0i3HB7vX6qvC7d8Ee/3bjZvc1fm7M2Lfl98mmfuz/0zbeFAhM9nnb1X6JiRRTBhOH9zg/VY1pHXqcOSmF8OClkL7F1U9Gb2GeqIoFj2dWlwcyKPSjmhM3NhwqJkBuUbgrkoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XThuNM4F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XThuNM4F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8341C19425;
	Sat, 28 Feb 2026 17:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301539;
	bh=dKiC0icjXP1TlfS6TPltT1637LnsHXjHUdGIYuZnsoM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XThuNM4Fk/49UvzqnlKAX/JD1ZLGxU2NXGo8g+IY7/3OJySjLZ2EDRPU4soqsAadd
	 aXcvkOCaTDPICb9iwzXQURi+Rt8F6IneybifmnpeixJO5e+by3+xNk3asNIykXW9kQ
	 nMNvTBgn4C9j9bviQfrT1AIiGNMfbwkojLtm4tk1ZylRiKjvL5rV5SfO+FaL0Wzonh
	 Onfa64e+21Q13dsPeyHH0pImyR/Pi4cEvn8wT08A0D3vsVLnIst6q2unM0s7qMdS4f
	 A70H/MwsstkV2x/cc9CZjAQelvrHMcVQPma4L6FgmRDNewC0DICrvaJpEOyXSrxdlq
	 8jL0D6Slc8c1A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Thomas Fourier <fourier.thomas@gmail.com>,
	stable@vger.kernel.org,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 721/752] fbdev: vt8500lcdfb: fix missing dma_free_coherent()
Date: Sat, 28 Feb 2026 12:47:12 -0500
Message-ID: <20260228174750.1542406-721-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Thomas Fourier <fourier.thomas@gmail.com>

[ Upstream commit 88b3b9924337336a31cefbe99a22ed09401be74a ]

fbi->fb.screen_buffer is allocated with dma_alloc_coherent() but is not
freed if the error path is reached.

Fixes: e7b995371fe1 ("video: vt8500: Add devicetree support for vt8500-fb and wm8505-fb")
Cc: <stable@vger.kernel.org>
Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/vt8500lcdfb.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/video/fbdev/vt8500lcdfb.c b/drivers/video/fbdev/vt8500lcdfb.c
index b08a6fdc53fd2..85c7a99a7d648 100644
--- a/drivers/video/fbdev/vt8500lcdfb.c
+++ b/drivers/video/fbdev/vt8500lcdfb.c
@@ -369,7 +369,7 @@ static int vt8500lcd_probe(struct platform_device *pdev)
 	if (fbi->palette_cpu == NULL) {
 		dev_err(&pdev->dev, "Failed to allocate palette buffer\n");
 		ret = -ENOMEM;
-		goto failed_free_io;
+		goto failed_free_mem_virt;
 	}
 
 	irq = platform_get_irq(pdev, 0);
@@ -432,6 +432,9 @@ static int vt8500lcd_probe(struct platform_device *pdev)
 failed_free_palette:
 	dma_free_coherent(&pdev->dev, fbi->palette_size,
 			  fbi->palette_cpu, fbi->palette_phys);
+failed_free_mem_virt:
+	dma_free_coherent(&pdev->dev, fbi->fb.fix.smem_len,
+			  fbi->fb.screen_buffer, fbi->fb.fix.smem_start);
 failed_free_io:
 	iounmap(fbi->regbase);
 failed_free_res:
-- 
2.51.0

