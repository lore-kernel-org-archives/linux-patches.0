Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54F952571C1;
	Thu, 17 Apr 2025 18:28:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914496; cv=none; b=Z/7jBK3ui05/yxIKHLzEJdJnNoS96pYOp8syNPMmtW9mfP6aOd3jYjen/A4LZuHJrIYI+r8JqYClXCJ1W9pHo6yIAFf+dFXuGejpfjToIkKCZ4TqgfKizWBWVm5DK0uHjMogQibODmf81msP42P3l044J4CA9hFhQpNGvFpX3xE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914496; c=relaxed/simple;
	bh=/3nhgv+zQU1E9Hc24JtSkoV722nja+o3aX0A5TTrBFU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mN6I2ucrj7tMUa6y7L+yMOVNDV4N4L0ovHYFsB+PWWgGe63F2jwOONC28Q2r7a+UChNESfEuLl3xI5NK4R2DAnvR7faAlaiO1xrmnfeiiWkd8RXFVGJs8Mg8SKtKXwRt8UIA00gTpt7M64p/6g+aznHOV6Yv9EGOTgVhM6Jk63U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GPP2tJMW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GPP2tJMW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCED8C4CEE4;
	Thu, 17 Apr 2025 18:28:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914496;
	bh=/3nhgv+zQU1E9Hc24JtSkoV722nja+o3aX0A5TTrBFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GPP2tJMW0maof6XH4K8xC4azhNrxvabYzounq7p9pjZYc6qxP+i9Nv4NxUT90H6JA
	 EarWVdejoub2u7b7e+mo6Pp46PYfOn14MShGSpNBZZW7ByUnKz6Z01hy6gAgeV1uFj
	 PtDnTD88hsBucr3P3imwEHW3FRADX8NN2bYSyZtk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricardo Ribalda <ribalda@chromium.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.13 234/414] media: nuvoton: Fix reference handling of ece_node
Date: Thu, 17 Apr 2025 19:49:52 +0200
Message-ID: <20250417175120.842274764@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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


