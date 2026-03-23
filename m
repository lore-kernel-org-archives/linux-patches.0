Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83B5A241C8C;
	Mon, 23 Mar 2026 15:11:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278687; cv=none; b=f8yY+VTeGwE83PaIAU90/785d6xHrUCmvc4XlbHwMGHNcvpZ6eHVo76jo7PBfTyRIT6JKQQMMaAoccXrBjDNz93QZ8KFlfRMWvAyrCm6DGFWjVBJjmflAZU4vNBoDONK4Y+toipAJ0KxDxMLWydujrj/qmAk/Lp/cTBpkc0Eqf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278687; c=relaxed/simple;
	bh=3szvZSBTab8kMfayGYS9wFNp8M6Fy2oeWK8UNUSVda8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RY0nN1UxN18H+FWiqArPnfdJVr4isDLMGvRoLpRWP0tjYr+KJf3PuFdzc6caRB4h4SmpnnLY/lJAdgbT5/wtGoYvhM/IaVc/BvvoQ+DftuIxihvEBMgGfgiLkZKzgU8X/VncxmSsHFf6m4hFgVMZFI8OIFS4a6BcJCmmIQWXop0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cjtG/FA0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cjtG/FA0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0749EC4CEF7;
	Mon, 23 Mar 2026 15:11:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774278687;
	bh=3szvZSBTab8kMfayGYS9wFNp8M6Fy2oeWK8UNUSVda8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cjtG/FA0M+i5CpWxlWSNVnl9ztr6JIvQsz2gQPp3CsZmu/mn1pJkvgswiAIDd+gpT
	 HIoyInsj8Z32qKNKyL2ylBljWOLjixkEIeF7VTOuvll4vCrQIqnqAee+IWjH2EY5lw
	 Mny1jR+CHGx3HXWROf86/GR7ncIJjiiJ2087oupA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 388/567] drm/msm: Fix dma_free_attrs() buffer size
Date: Mon, 23 Mar 2026 14:45:08 +0100
Message-ID: <20260323134543.455463858@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Fourier <fourier.thomas@gmail.com>

[ Upstream commit e4eb6e4dd6348dd00e19c2275e3fbaed304ca3bd ]

The gpummu->table buffer is alloc'd with size TABLE_SIZE + 32 in
a2xx_gpummu_new() but freed with size TABLE_SIZE in
a2xx_gpummu_destroy().

Change the free size to match the allocation.

Fixes: c2052a4e5c99 ("drm/msm: implement a2xx mmu")
Cc: <stable@vger.kernel.org>
Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/707340/
Message-ID: <20260226095714.12126-2-fourier.thomas@gmail.com>
Signed-off-by: Rob Clark <robin.clark@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/msm/msm_gpummu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/msm/msm_gpummu.c
+++ b/drivers/gpu/drm/msm/msm_gpummu.c
@@ -76,7 +76,7 @@ static void msm_gpummu_destroy(struct ms
 {
 	struct msm_gpummu *gpummu = to_msm_gpummu(mmu);
 
-	dma_free_attrs(mmu->dev, TABLE_SIZE, gpummu->table, gpummu->pt_base,
+	dma_free_attrs(mmu->dev, TABLE_SIZE + 32, gpummu->table, gpummu->pt_base,
 		DMA_ATTR_FORCE_CONTIGUOUS);
 
 	kfree(gpummu);


