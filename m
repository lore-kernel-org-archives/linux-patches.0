Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6148C210F58;
	Wed, 19 Mar 2025 14:36:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395013; cv=none; b=jxYw1KooL6MQhq9GoECSuE6I4Z6s1DvQ8HEGpsBP5Ecc3yFxN3KQrO1hZkmPd6ph0eOab8G+2F2jH6rWxwiEmUuC1biH2Bdd6cMwHinn/q4K7TYWprlXg/PiHlnBUjlULfplzvKwobeUuTKESK4x3zDSg7oK2UK767FqUcDbcXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395013; c=relaxed/simple;
	bh=iq94qkHdhrKyYJMN61Zrf3JOhsSXDXIUpLak6JkPNhM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gx9zm0JWmdMor2pmd03Ba6KwLNEiUNRSjlYOlFuroRygBTuuqy2V2ZFixpxz0IOpiWBjYs2IXZrglAXKvOJSX5eQJOm2otr+3h42w0is9hk3sOzLT5Myjy2woJF0O4Sj243rbkgkKoBWOExdQwVBvK3Bd3zGG3z9exhX8FI2Pv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jXDBTY/w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jXDBTY/w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38716C4CEE4;
	Wed, 19 Mar 2025 14:36:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395013;
	bh=iq94qkHdhrKyYJMN61Zrf3JOhsSXDXIUpLak6JkPNhM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jXDBTY/w21lr8nn2YfZX7akpbaO59JTXKaSRnayXH8LpZjTiCjbdbNeg7FG0m8b8/
	 JCjNpRjkYbwfTbW20sg2O4ps5FVebusi/zpOFN0Q3ZVZEU+Ff4REXexZUQV1vzV9t+
	 QRNGoMO5vOCdj1QarVLNdb/2X5BfK1R/tEpdMtrE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Kelley <mhklinux@outlook.com>,
	Saurabh Sengar <ssengar@linux.microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 024/231] drm/hyperv: Fix address space leak when Hyper-V DRM device is removed
Date: Wed, 19 Mar 2025 07:28:37 -0700
Message-ID: <20250319143027.422884325@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143026.865956961@linuxfoundation.org>
References: <20250319143026.865956961@linuxfoundation.org>
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

From: Michael Kelley <mhklinux@outlook.com>

[ Upstream commit aed709355fd05ef747e1af24a1d5d78cd7feb81e ]

When a Hyper-V DRM device is probed, the driver allocates MMIO space for
the vram, and maps it cacheable. If the device removed, or in the error
path for device probing, the MMIO space is released but no unmap is done.
Consequently the kernel address space for the mapping is leaked.

Fix this by adding iounmap() calls in the device removal path, and in the
error path during device probing.

Fixes: f1f63cbb705d ("drm/hyperv: Fix an error handling path in hyperv_vmbus_probe()")
Fixes: a0ab5abced55 ("drm/hyperv : Removing the restruction of VRAM allocation with PCI bar size")
Signed-off-by: Michael Kelley <mhklinux@outlook.com>
Reviewed-by: Saurabh Sengar <ssengar@linux.microsoft.com>
Tested-by: Saurabh Sengar <ssengar@linux.microsoft.com>
Link: https://lore.kernel.org/r/20250210193441.2414-1-mhklinux@outlook.com
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Message-ID: <20250210193441.2414-1-mhklinux@outlook.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/hyperv/hyperv_drm_drv.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/hyperv/hyperv_drm_drv.c b/drivers/gpu/drm/hyperv/hyperv_drm_drv.c
index ff93e08d5036d..5f02a5a39ab4a 100644
--- a/drivers/gpu/drm/hyperv/hyperv_drm_drv.c
+++ b/drivers/gpu/drm/hyperv/hyperv_drm_drv.c
@@ -154,6 +154,7 @@ static int hyperv_vmbus_probe(struct hv_device *hdev,
 	return 0;
 
 err_free_mmio:
+	iounmap(hv->vram);
 	vmbus_free_mmio(hv->mem->start, hv->fb_size);
 err_vmbus_close:
 	vmbus_close(hdev->channel);
@@ -172,6 +173,7 @@ static void hyperv_vmbus_remove(struct hv_device *hdev)
 	vmbus_close(hdev->channel);
 	hv_set_drvdata(hdev, NULL);
 
+	iounmap(hv->vram);
 	vmbus_free_mmio(hv->mem->start, hv->fb_size);
 }
 
-- 
2.39.5



