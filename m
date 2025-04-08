Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D88A3267F4A;
	Tue,  8 Apr 2025 11:16:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111007; cv=none; b=jD7Wt/X8yw5zdvtbJqsT697FgNPXh8chHKQ5auqugpyQG9qSo8W3AxAHv7a+11WDgybKombWZ76rpMExpul6mdau9zcN1zWNTGg6cumdR8Gw8qpW5u0wapj6hKXVhJweotQ2YWYuw7nLBmL4WKHUMph/gxugPHGdVhkicvioEqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111007; c=relaxed/simple;
	bh=SkP0eDvzL+rMWWj1StdaYlXGPUl8FEQRWskJcYNIzWs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MtgVyhuGChMo0YiEMg0A5f/0zRBv+Mw03Qu8BE12Qb2a6VPsV0SVLUYN1Wsp7GvIJ/9DlSiDQUDZ0UHSIJ0gqRox6SZuhtb0EcIJBqintKCHjc1Q36ag8B1j6/UgxzUSZDr7ahWXlwpzsG1xpcqDC3Um0cGEmcsDxeA3iKQWkS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CbM8HSJp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CbM8HSJp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 048D6C4CEE5;
	Tue,  8 Apr 2025 11:16:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111007;
	bh=SkP0eDvzL+rMWWj1StdaYlXGPUl8FEQRWskJcYNIzWs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CbM8HSJp0lu0z3xsX/oNywh3ocy9fBfywvoxgGZPv/JN5Z7NYcA0MaOqxGtBu56S4
	 8/QmMEWyRaB/ydMdNdUkBe4AzYS3pIwRDA0wBJal0IfhvScgvnzLyKSFd9HxbQ1/OS
	 aL259SDdJ6vCqmWN6hYnLyW47lhkoKKa5+U6m83U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Anderson <sean.anderson@linux.dev>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 275/731] drm: xlnx: zynqmp: Fix max dma segment size
Date: Tue,  8 Apr 2025 12:42:52 +0200
Message-ID: <20250408104920.673463257@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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
index f953ca48a9303..3a9544b97bc53 100644
--- a/drivers/gpu/drm/xlnx/zynqmp_dpsub.c
+++ b/drivers/gpu/drm/xlnx/zynqmp_dpsub.c
@@ -201,6 +201,8 @@ static int zynqmp_dpsub_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
+	dma_set_max_seg_size(&pdev->dev, DMA_BIT_MASK(32));
+
 	/* Try the reserved memory. Proceed if there's none. */
 	of_reserved_mem_device_init(&pdev->dev);
 
-- 
2.39.5



