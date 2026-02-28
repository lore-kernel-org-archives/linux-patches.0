Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A79C139B974
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:16:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302610; cv=none; b=d4A8A3c3clrsymYXublg/h8lNyGuVeFEczMS4iySKNLgtLNt9W3h41F7mOu8T8cINPY/mhB7aZ9tVywcjuYDgOIU+7y58zYeKTOmuaHYuoCvMFPj17Rk5gE8IT/sNKI351IfFOB6HfqmL8BxJjs9zKDXBwWKD4aTGl5ZHYMrG+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302610; c=relaxed/simple;
	bh=k1oheUIR7E0MJ/UsBSmsbkCKqljoOvBgxuJAFkVzAWU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YhayrrjghB+gHHNpJTkiLwTJqpCHNdgyCGGiHsiQr0hB7mMntHGXnoxRhNYvnIgFPZIgJOSlHP6dZVE48es6pZGzV4qgVRTIiDhyoAACRHJ0Yz9l6IqWl0RpUmJ2VsuyUS17X0SfU06HjcQLq9bYe2uj8psifSkLJMwoHVTpePg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YbqNLZ1a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YbqNLZ1a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18BC5C19424;
	Sat, 28 Feb 2026 18:16:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302610;
	bh=k1oheUIR7E0MJ/UsBSmsbkCKqljoOvBgxuJAFkVzAWU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YbqNLZ1aaLHaKCLT0jSykkD1x7MgvLvoZT/tSDp/8qdvghPfIV7kAlrbTbp3+wEMg
	 efRKOxtu8FsCGrkhqwWAwTsapO1PH7Ly/KlpTWaglNk+mmpyLZs3KPG2nWZ6K6U3LX
	 hIiF/23iDGhEMguGE10O7q8wM9nRtvefs0xcp6gZ932zxNcC7p8tvLVDMhnmjuz8x6
	 CmTsHL3oZrdWVARA9Mhtz7+04FWmePiOMpv2NDV8u+gkH4KikIqcinjZLYCziItALL
	 XJ9k8bW5wIjzLGiZNy1DJo3o8oOlMbwWB0DMOOTJLktQKrhMbK2GqqD/fUhgK+nP+C
	 faTA8IjstFZEg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Felix Gu <ustc.gu@gmail.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 126/164] fbdev: au1200fb: Fix a memory leak in au1200fb_drv_probe()
Date: Sat, 28 Feb 2026 13:14:25 -0500
Message-ID: <20260228181505.1600663-126-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181505.1600663-1-sashal@kernel.org>
References: <20260228181505.1600663-1-sashal@kernel.org>
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
index 80f54111baec1..ec1d86f253904 100644
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

