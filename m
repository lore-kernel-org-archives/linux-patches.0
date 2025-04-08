Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E7F6224AEB;
	Tue,  8 Apr 2025 12:35:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115720; cv=none; b=NxNYiV8z30asolI5ypuw6YBGACZbhnteip8zeEwlB6ZBi+xLVZOuWYHIV/5rftqnDRwGL3n81yN1fZTtW7jnRvk0tRCcnmLlsd5IWnjT/f571SkItWp8k8nbZUsb5DvMQKv98OTy5EyVS+K6ZnafYVerfj9UXbdD/2QU3PQXy9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115720; c=relaxed/simple;
	bh=hDqjKlV7X1YJbp2gFiDVmDPs8n7MKiYUBYkFnqgx1/8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gtkklpONif+gi9rcDVzTzEAeOUJhYfDtuPA30sHREailCPn33q5Gu3qHFXbam6KxVyIJIXRNPIazacuBSNPPhh168sKdI4PCOdZDwjhdNXzOHB2m77VRtMb48upgD+QpStIvhIl7rHiIIr4kxYn4a5FcYbx1zm68ow/BjWcdeUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SWbuVCp/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SWbuVCp/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F18CEC4CEE5;
	Tue,  8 Apr 2025 12:35:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115720;
	bh=hDqjKlV7X1YJbp2gFiDVmDPs8n7MKiYUBYkFnqgx1/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SWbuVCp/D0arJJ7zo55TINZxXorH/CR5UutjgnpBxdOZ6RLouHiYbwTeCjDyVst0/
	 GtzhiPFAgbnUhDiQUMboUo2oRrXK4/gpAMJ8khP4wp0gdGJFpzTnL8ZY7ta1CgpcQk
	 Lrjzrqs2OpJo38ToKwNhtLCHdNYBJj6B/t5VkUNk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Anderson <sean.anderson@linux.dev>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 030/204] drm: xlnx: zynqmp: Fix max dma segment size
Date: Tue,  8 Apr 2025 12:49:20 +0200
Message-ID: <20250408104821.213640108@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.266892317@linuxfoundation.org>
References: <20250408104820.266892317@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>

[ Upstream commit 28b529a98525123acd37372a04d21e87ec2edcf7 ]

Fix "mapping sg segment longer than device claims to support" warning by
setting the max segment size.

Fixes: d76271d22694 ("drm: xlnx: DRM/KMS driver for Xilinx ZynqMP DisplayPort Subsystem")
Reviewed-by: Sean Anderson <sean.anderson@linux.dev>
Tested-by: Sean Anderson <sean.anderson@linux.dev>
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250115-xilinx-formats-v2-10-160327ca652a@ideasonboard.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xlnx/zynqmp_dpsub.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/xlnx/zynqmp_dpsub.c b/drivers/gpu/drm/xlnx/zynqmp_dpsub.c
index fcaa958d841c9..f34d4ec1d92f3 100644
--- a/drivers/gpu/drm/xlnx/zynqmp_dpsub.c
+++ b/drivers/gpu/drm/xlnx/zynqmp_dpsub.c
@@ -205,6 +205,8 @@ static int zynqmp_dpsub_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
+	dma_set_max_seg_size(&pdev->dev, DMA_BIT_MASK(32));
+
 	/* Try the reserved memory. Proceed if there's none. */
 	of_reserved_mem_device_init(&pdev->dev);
 
-- 
2.39.5



