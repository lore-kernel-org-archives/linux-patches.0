Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D968226983B;
	Tue,  8 Apr 2025 12:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116310; cv=none; b=R76DK7jvwjs/mysMbVfh2Du1ZZXGL4YaA9PvkKCk7T82QGmLj8yX8yh3nTAzbMXmn9f6Dze2O50Vu4wJ4oMYEhL5kNGEE+6hsyadDgLagorAyBbSq/9Sd3Ri4X7y3LgNDZofYBO23m0Q5Kl+ZqkHJ14yia8CEnKXWAA7xl5yRa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116310; c=relaxed/simple;
	bh=EF68BGLcdJtGmI3Q+pVBZUdzFaM+UKahO6ZirxJg2iQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EXwHrtOcUJll0IOtbW3htTo6e1C1m9CGUs981aK3uJhE7faikkM6JygoUlCd4jja0/N96uB0zH1h9chIygY0LgT43BCDHv4G00STRLSRV+Pd0WhYNh5wtDanHpSdMSzGlGtOBhgJ37LWE2aEE1vYjejFvKaS3WhKy21ywY+y8y4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dKDwEJyN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dKDwEJyN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AF7BC4CEE5;
	Tue,  8 Apr 2025 12:45:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116310;
	bh=EF68BGLcdJtGmI3Q+pVBZUdzFaM+UKahO6ZirxJg2iQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dKDwEJyN8Sg0c/8JyRl2NeiTuNOQenCS0eBaDIWUhw6XMoG3BX4X4TGGn9upQDYsV
	 WfMY62Tsa+01VWZ2PPtXCnZbJuHdMdA0hO840NlIRloNm1GHNq7ULv+64jc4FpYilC
	 i/FSE7rg0YFwGh1ok+jxTNVMus5+AXL4edaT77NA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Anderson <sean.anderson@linux.dev>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 053/423] drm: xlnx: zynqmp: Fix max dma segment size
Date: Tue,  8 Apr 2025 12:46:19 +0200
Message-ID: <20250408104846.984319467@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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
index f5781939de9c3..a25b22238e3d2 100644
--- a/drivers/gpu/drm/xlnx/zynqmp_dpsub.c
+++ b/drivers/gpu/drm/xlnx/zynqmp_dpsub.c
@@ -231,6 +231,8 @@ static int zynqmp_dpsub_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
+	dma_set_max_seg_size(&pdev->dev, DMA_BIT_MASK(32));
+
 	/* Try the reserved memory. Proceed if there's none. */
 	of_reserved_mem_device_init(&pdev->dev);
 
-- 
2.39.5



