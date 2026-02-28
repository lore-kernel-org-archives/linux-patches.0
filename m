Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D15AC36C9D3
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302206; cv=none; b=RVCZk+X5jBMsjtm0pwPbazzaqVUQmoUZfbgkOuMr9/4RyFzHjA7DPVZqdO8/SyW9e9gl/TRbWtRVThgReGWV0zoH65A+V5IZI3ebelec2L/iStfg8bG50KyTKf9Vp2fpqADi3ndrrL4UsGSOM2vSxmey3DSob3T40qqjnhXTSu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302206; c=relaxed/simple;
	bh=QcIzFBEsDGvOvzlJfwOpALPiBCuEtGndSK8hMVyt0Y8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HDlww8mreedYfdfLyWgdEu1bEbC5lpDz9soAqePcHsgzPSn7dTEv2FDCyXgwqGk+vQb1nNt0jjenUdgnUlQjvyijhCzrT9gRwHbAv94Fj1vzCja/mbW0rjfwEKCydF7Ug958oF79bZfdb2begCq3ZurCJpcWsBcKj1uLrU+xtGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PQ+Ur0tX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PQ+Ur0tX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4445BC116D0;
	Sat, 28 Feb 2026 18:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302206;
	bh=QcIzFBEsDGvOvzlJfwOpALPiBCuEtGndSK8hMVyt0Y8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PQ+Ur0tXSnJ9LPzsw0wyMbFyTtwQWvh5j76GCYgMH3KK+8JdXfTIIVIVYPe2Bdff7
	 gG7gTpF7+96fZ9aVxx12IdEfK5XYpWvq+lVvqDIGyuq15KMmWjWC9AGePs6Kk8nHoF
	 Kj9xRBtadkCkL/VjDDA1WW77dja084aeolj2Zer5N2zia+bBIamvuW0wFttANdEd60
	 Ui84jJkdd6RR1W6GztIVvXDz2wz+cZToZvVT4+5sTXgKHkyap8TrwzGhdhv8xynJDF
	 5LUhlZm23L+WQ9oKXGElkFBmqbXh+1r/BxW9/a9tBPfInZDACwKIQKiM1IM3F/VkUw
	 5Wdxj3w+tNrDA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Felix Gu <ustc.gu@gmail.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 212/283] fbdev: au1200fb: Fix a memory leak in au1200fb_drv_probe()
Date: Sat, 28 Feb 2026 13:05:54 -0500
Message-ID: <20260228180709.1583486-212-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Felix Gu <ustc.gu@gmail.com>

[ Upstream commit ce4e25198a6aaaaf36248edf8daf3d744ec8e309 ]

In au1200fb_drv_probe(), when platform_get_irq fails(), it directly
returns from the function with an error code, which causes a memory
leak.

Replace it with a goto label to ensure proper cleanup.

Fixes: 4e88761f5f8c ("fbdev: au1200fb: Fix missing IRQ check in au1200fb_drv_probe")
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/au1200fb.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/video/fbdev/au1200fb.c b/drivers/video/fbdev/au1200fb.c
index c137d6afe4840..1b05dfbd5195e 100644
--- a/drivers/video/fbdev/au1200fb.c
+++ b/drivers/video/fbdev/au1200fb.c
@@ -1732,8 +1732,10 @@ static int au1200fb_drv_probe(struct platform_device *dev)
 
 	/* Now hook interrupt too */
 	irq = platform_get_irq(dev, 0);
-	if (irq < 0)
-		return irq;
+	if (irq < 0) {
+		ret = irq;
+		goto failed;
+	}
 
 	ret = request_irq(irq, au1200fb_handle_irq,
 			  IRQF_SHARED, "lcd", (void *)dev);
-- 
2.51.0

