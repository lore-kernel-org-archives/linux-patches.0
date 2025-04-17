Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39609255248;
	Thu, 17 Apr 2025 18:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913190; cv=none; b=JKY+IxNySFd5xqrSfRhTRcelIQcxtnNZ7MR4hFJJcNCJg5O7sO+yrVMdnpreBW2C8HyUzJfMS1/jY2S7F4r4J+FKGTTjOdm3YBrhyciBVolXKRPTSoVivf6R6Q/C2/gA74X+TDvp0NgqC546BvtRQWyaAYanpfkP5kc91Kx7RoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913190; c=relaxed/simple;
	bh=pGrop4howCUs0bkexn81BIl2IweJC4Frqn9kl2w7iWg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XusqiTYxJRWHOdDQtw+n9YaekpL9V40IafQq182XJr0aFLjLpizNdRgQ2e648DLHAfYyvCwq/1qofZoKL6pErNJfuPSLE2cW2pc4fhIInviB5Lux3tHHdSEPcMm/nXi0epRJ0KQd9DGhimyUC9QMG+2AuwdRaXtPjUuvIsaxgNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xy1q12hb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xy1q12hb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98606C4CEE4;
	Thu, 17 Apr 2025 18:06:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913190;
	bh=pGrop4howCUs0bkexn81BIl2IweJC4Frqn9kl2w7iWg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xy1q12hbL3bjQ0GrpvIBbzA5Lqo+Gg1/LKdZ/urSxjKGxRYr+RU+b3bHXvoZU4uNu
	 DjH3HxEHZhxUtYQciV1vPF/jIGyqE1lxzSbuqe4Em59vWYzlYfMA+5zgaslcQgzgwU
	 lkLCULTDNSNXxQ4odVhwturvToGg6Caqb3yRFUMg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricardo Ribalda <ribalda@chromium.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.14 256/449] media: nuvoton: Fix reference handling of ece_node
Date: Thu, 17 Apr 2025 19:49:04 +0200
Message-ID: <20250417175128.299230890@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ricardo Ribalda <ribalda@chromium.org>

commit 8ba4ef40ad6ca62368292a69855324213181abfb upstream.

Make sure all the code paths call of_node_put().

Instead of manually calling of_node_put, use the __free macros/helpers.

Cc: stable@vger.kernel.org
Fixes: 46c15a4ff1f4 ("media: nuvoton: Add driver for NPCM video capture and encoding engine")
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/nuvoton/npcm-video.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/media/platform/nuvoton/npcm-video.c
+++ b/drivers/media/platform/nuvoton/npcm-video.c
@@ -1648,8 +1648,8 @@ rel_ctrl_handler:
 
 static int npcm_video_ece_init(struct npcm_video *video)
 {
+	struct device_node *ece_node __free(device_node) = NULL;
 	struct device *dev = video->dev;
-	struct device_node *ece_node;
 	struct platform_device *ece_pdev;
 	void __iomem *regs;
 
@@ -1669,7 +1669,6 @@ static int npcm_video_ece_init(struct np
 			dev_err(dev, "Failed to find ECE device\n");
 			return -ENODEV;
 		}
-		of_node_put(ece_node);
 
 		regs = devm_platform_ioremap_resource(ece_pdev, 0);
 		if (IS_ERR(regs)) {


