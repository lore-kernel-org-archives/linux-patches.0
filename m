Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CD212CCC0;
	Tue, 27 May 2025 16:58:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365097; cv=none; b=sTWnx3PM6mXhBjxkX8C91fqOXOhsyDy5GXFf4ECupisO0PYTbZ9tMhkkTI3xfolEdXp1yPr/DGt7SOJh+6dxJ84nDEjZu1oAB+dRX9qKC5ZUs1lGCKs0SA4f+3ml3m78MGIHz/q2LHxWSeQSs5J4owbrWJQ1XpiAypqBk1HLz+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365097; c=relaxed/simple;
	bh=gS+sbUqkcP7WkX4sCqpaQa29lHEWlb4u/LDhsa8DUvs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dkQVFlWTVlTLRpZ9aYJbOMVKcVGW6/THHlm37QA26Tzy6XBoFi0fu4jzC1m0r36xxkK7r0+KsDR63DwELzE/Ya9FoYqcbMkkELn/ZX1HR41i0otHZoX+ID1BNh0RskTOKnvjlE3yO7mHPf3t2GPmpA8X2AHlkD9sd7sO7VY01EQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wIj4+O7B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wIj4+O7B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8263BC4CEEB;
	Tue, 27 May 2025 16:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365097;
	bh=gS+sbUqkcP7WkX4sCqpaQa29lHEWlb4u/LDhsa8DUvs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wIj4+O7BpLMC15kP7ssmfKGVeg2qz7z43QxNI73mK96WaeHx2QEZqfIaP0Us7Jxi6
	 dEzqaV5sengMbIcS1FrVF37+1GJnNPmJmdA2YjUssulxrcITUXhACHCuXqi5RupGk1
	 EKDspqLY74x4iJ9gzNK0xx4FN/0HnVy/bVQlDQlE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Janne Grunau <j@jannau.net>,
	Alyssa Rosenzweig <alyssa@rosenzweig.io>,
	Sven Peter <sven@svenpeter.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 265/626] soc: apple: rtkit: Use high prio work queue
Date: Tue, 27 May 2025 18:22:38 +0200
Message-ID: <20250527162455.777778868@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Janne Grunau <j@jannau.net>

[ Upstream commit 22af2fac88fa5dbc310bfe7d0b66d4de3ac47305 ]

rtkit messages as communication with the DCP firmware for framebuffer
swaps or input events are time critical so use WQ_HIGHPRI to prevent
user space CPU load to increase latency.
With kwin_wayland 6's explicit sync mode user space load was able to
delay the IOMFB rtkit communication enough to miss vsync for surface
swaps. Minimal test scenario is constantly resizing a glxgears
Xwayland window.

Signed-off-by: Janne Grunau <j@jannau.net>
Reviewed-by: Alyssa Rosenzweig <alyssa@rosenzweig.io>
Link: https://lore.kernel.org/r/20250226-apple-soc-misc-v2-3-c3ec37f9021b@svenpeter.dev
Signed-off-by: Sven Peter <sven@svenpeter.dev>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/apple/rtkit.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/soc/apple/rtkit.c b/drivers/soc/apple/rtkit.c
index e6d940292c9fb..00d59a81db88b 100644
--- a/drivers/soc/apple/rtkit.c
+++ b/drivers/soc/apple/rtkit.c
@@ -667,7 +667,7 @@ struct apple_rtkit *apple_rtkit_init(struct device *dev, void *cookie,
 	rtk->mbox->rx = apple_rtkit_rx;
 	rtk->mbox->cookie = rtk;
 
-	rtk->wq = alloc_ordered_workqueue("rtkit-%s", WQ_MEM_RECLAIM,
+	rtk->wq = alloc_ordered_workqueue("rtkit-%s", WQ_HIGHPRI | WQ_MEM_RECLAIM,
 					  dev_name(rtk->dev));
 	if (!rtk->wq) {
 		ret = -ENOMEM;
-- 
2.39.5



