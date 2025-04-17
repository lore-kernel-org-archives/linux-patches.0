Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F7E2256C79;
	Thu, 17 Apr 2025 18:50:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915816; cv=none; b=Hi7Kxo1NzecH58bF6na85K8ARxE1rPBJM9p9o4a/kDbrZrzxTmsj/vfkCcW4m1iNT3n3mSkD26IGro0DtuQ1QHU/Z+rpZNjrRCergN8GF5nqn6RWxqx9TZowEofcrb6LGOU1+SDtqIoZKWyEGy3RIs/VfaBO2OU0AzPQUav/Q+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915816; c=relaxed/simple;
	bh=2imkWe3GnjqIzu9hFkjrE5orcQ2FsbTSH0GAchxTgbU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TUV/dSweL1A/FIxxwUoXNa0RekffWcDUfgtOqcrFeXmRemh8x+8N1hLLDIpiNw7lfrI7KVS1OTDebI3OqGRAjtc79XiNIEDbM2r4IIkwuPqih8en3d6y0OLtDlzeCSjSmJC0HdybY47ZNKO1fWIOqBCyzNGNE+lc+DMBDAvw0Vg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O/x2T3Td; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O/x2T3Td"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD25DC4CEE4;
	Thu, 17 Apr 2025 18:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915816;
	bh=2imkWe3GnjqIzu9hFkjrE5orcQ2FsbTSH0GAchxTgbU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O/x2T3Td+eUKSVgO4n2ZngvH2A6JEA8naxf00JgPk+8P9066ugV2X8ezIi9Hu4e2h
	 BkZIO1cLKIkP6V8bX9YWYqbvxfGm0pR93zJUiLVgSZWtEcCV+sZjAlUs6mYJviyHRS
	 jfxYz2rNcFkAk+Y0DdYRM/Sw0DiGVJBsK2VEOv00=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricardo Ribalda <ribalda@chromium.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.12 222/393] media: nuvoton: Fix reference handling of ece_node
Date: Thu, 17 Apr 2025 19:50:31 +0200
Message-ID: <20250417175116.514134862@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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
@@ -1650,8 +1650,8 @@ rel_ctrl_handler:
 
 static int npcm_video_ece_init(struct npcm_video *video)
 {
+	struct device_node *ece_node __free(device_node) = NULL;
 	struct device *dev = video->dev;
-	struct device_node *ece_node;
 	struct platform_device *ece_pdev;
 	void __iomem *regs;
 
@@ -1671,7 +1671,6 @@ static int npcm_video_ece_init(struct np
 			dev_err(dev, "Failed to find ECE device\n");
 			return -ENODEV;
 		}
-		of_node_put(ece_node);
 
 		regs = devm_platform_ioremap_resource(ece_pdev, 0);
 		if (IS_ERR(regs)) {


