Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2A22268FD8;
	Tue,  8 Apr 2025 11:51:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113102; cv=none; b=Wu6xgrYpC2mUj8XCgmeF6YPlicRPS/owGfEt5pFYZ6aL0hxHPVM5FrSw3wfgx4vgywRapmWg1VhczqKRdHGrJtPkYq/hnJUAD1QNhjHIDi1IEHrUaoe4Iw87LwN9gLGfQ0hUB4frZTO4HRL98mxqzbUmE22uPBNJ6i0sNDVy1bk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113102; c=relaxed/simple;
	bh=DhLIR0hHdXwqh3Hqqznynz4rXPAlBGUk9QS36Yw6c4A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZcfpjEmaTscOTIE/SCkdAKan4ybelL2k5gOQevSz7VM2G7JL8bOXm+CwV+k5a4citUn7wqShJVCOIITgeKQu+Qv7O3XxAkaPSAwfRNF4Cir+wWA/QLx+NBVh6nTfse4GdmmYIzvAglue17kuX2EYvkonRoNy/f/gZQnV/sSNB7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ikXXFZ49; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ikXXFZ49"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 790C4C4CEE5;
	Tue,  8 Apr 2025 11:51:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113101;
	bh=DhLIR0hHdXwqh3Hqqznynz4rXPAlBGUk9QS36Yw6c4A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ikXXFZ49jsGaV4g2leGTab1pVS0rd/9oFPCzE5WZS1adJOMqKH63KNvb82SId/j6G
	 d6yO7/xdqLwCJdRQ557SNDkT0CsLKP6iCu6dB5N9CacqRfljL94GH/s9Oh33IU2qDI
	 3bfnqDBUI4FuaABG+ecvAwqqFVwH2B4ZQjc4mzrw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Anderson <sean.anderson@linux.dev>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 035/268] drm: xlnx: zynqmp: Fix max dma segment size
Date: Tue,  8 Apr 2025 12:47:26 +0200
Message-ID: <20250408104829.447159701@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104828.499967190@linuxfoundation.org>
References: <20250408104828.499967190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



