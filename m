Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3F363C1D79;
	Sat, 12 Sep 2026 07:26:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197968; cv=none; b=cnFQMNIRBOtOKzwNzkmaQccSxdkLydW/hHlYgAihBMDcYzNBS6ecVPeXqR2Akx/36mYzr2c8kKVHanNRP5vr5aYAQvzJ9PqcHhaSgMT7CAd6gGr3q8VqufYDGIcHaI+PbfJ71AjKeouD9jY6yfnkildAzOullJYLLCZGFw099IU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197968; c=relaxed/simple;
	bh=D1yOxiYuRVgEGc4rMwLyC+ZEpXB/i3KkM9jynne+pJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PnuaabXOYTSBdpzRbsNp/+dicjVOGHLHLTiR8wKV2sFap5VONG+QgJ3SVzRs9T9Sm8+DZzS5wFkGJXELnL+qItsxAf9M0Z3WP5C2N3VcMvGpR3gi/xk5pAsL8EKS2sZzRCiwxtEMaRmDYzbcmWilszxb8K4J/4zJgI6ghlAIo9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uvs19kox; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uvs19kox"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7E301F000FF;
	Sat, 12 Sep 2026 07:26:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197967;
	bh=FYcassWwM15ionSeUcgF55Oz1xQa+RgADOiv6/JRuyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uvs19koxEyLx+arie407zgExfjXNY2UZ0MU3u/9s+x11kT+N5B5VnxRzxYA1K2OHt
	 b2GxKAteqCPpIUY7oyay6UOtybn32AtV4P6COYXp+rjmjiw/0fqchtv2yRQpk4owEl
	 zFzMuOv5QJ8ogVYhcr0SfyKt69OzM6Ky/1waMyhQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akari Tsuyukusa <akkun11.open@gmail.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0285/1815] iommu/mediatek-v1: Fix off-by-one in MT2701_LARB_NR_MAX
Date: Sat, 12 Sep 2026 08:33:55 +0200
Message-ID: <20260912065655.652473367@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Akari Tsuyukusa <akkun11.open@gmail.com>

[ Upstream commit aebaa93f3da1572877579c2e15ebf27be2dcc7fb ]

The mt2701_m4u_in_larb[] array contains 4 (for LARB0 to LARB3)
elements, meaning mt2701_m4u_to_larb() can legitimately return 3.
The current check `if (larbid >= MT2701_LARB_NR_MAX)` incorrectly
rejects valid LARB3 with -EINVAL.

Fix this off-by-one error by updating MT2701_LARB_NR_MAX to 4.

Note that this does not cause immediate issues with the current
mt2701.dtsi and mt7623n.dtsi because it only defines 3 LARBs:
    mediatek,larbs = <&larb0 &larb1 &larb2>;
Thus, larbid never reaches 3 in the existing upstream device tree.

Fixes: de78657e16f4 ("iommu/mediatek: Fix NULL pointer dereference when printing dev_name")
Signed-off-by: Akari Tsuyukusa <akkun11.open@gmail.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/mtk_iommu_v1.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/mtk_iommu_v1.c b/drivers/iommu/mtk_iommu_v1.c
index ac97dd2868d4b..e907c99531423 100644
--- a/drivers/iommu/mtk_iommu_v1.c
+++ b/drivers/iommu/mtk_iommu_v1.c
@@ -88,7 +88,7 @@ struct dma_iommu_mapping {
 /* MTK generation one iommu HW only support 4K size mapping */
 #define MT2701_IOMMU_PAGE_SHIFT			12
 #define MT2701_IOMMU_PAGE_SIZE			(1UL << MT2701_IOMMU_PAGE_SHIFT)
-#define MT2701_LARB_NR_MAX			3
+#define MT2701_LARB_NR_MAX			4
 
 /*
  * MTK m4u support 4GB iova address space, and only support 4K page
-- 
2.53.0



