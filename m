Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 849E4269D01;
	Tue,  8 Apr 2025 12:12:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114332; cv=none; b=Of2UPKbON4QxBXizxyezyslXJVZeYlCFY4EDZlkwTNNKtL0dsVBwVrPPsjkNukNUTf3wt2FAftbh0i8wWTFEqpCCDS4cMBl97vJIhp7k8+3rXyFXZykerf4A5URB3HIREPLEtQL7KzjpKVfhd8jLv+rro1VVsKAidp0ZuF3U26w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114332; c=relaxed/simple;
	bh=Zure017i/Nrw/JU9/tYsjtqHN20f8674ZrioCHSEaBo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=plLjzTnlhnE0OoLuLMnDeiuMTfi5AsqdJpU3yXxVgVcmNk9rId4VNT44BbzhdgTkdMMjo6fRbAAAH/QOnvN4+iAsgYzxkvV2yX0V5TBcYNRmntC6NxXDlS/zmVbV8pwnXCGcnZlnLk831VLeE9+4OBRo0tBg0DJEpLWPo79dphg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CC7pVfIw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CC7pVfIw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13117C4CEE5;
	Tue,  8 Apr 2025 12:12:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114332;
	bh=Zure017i/Nrw/JU9/tYsjtqHN20f8674ZrioCHSEaBo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CC7pVfIwDrcme7mYSyBi05tE/6wqga01HUM6xSCjIMNJS8wKCzePxYmHz+e4O3qX5
	 bL5cQfsU6aBNme9c/3XSfFqCbkeLO1OTtILJLrAklCSJpwpsUpx5JQKQoMqdyGXet2
	 no5ux94qPeiJktt2nbk8lYTod6v7WwN6xX8ClrVY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Anderson <sean.anderson@linux.dev>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 067/499] drm: xlnx: zynqmp: Fix max dma segment size
Date: Tue,  8 Apr 2025 12:44:39 +0200
Message-ID: <20250408104852.900353353@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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
index 07c4d184e7a1f..5f9228ab4f1f0 100644
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



