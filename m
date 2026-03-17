Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 919821E2834;
	Tue, 17 Mar 2026 17:23:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773768210; cv=none; b=STWvlss3lZyJReWUAuiYDul2uuAG+Cd/6y4Bkp4jZjHTAY9aIu6I6shBQ7XmQS28zQqGWkoySWdkUNN7WVfwk3MTB99h27Bc3T7NMmIs6ju7MAVHAzPv6dPXcXblGxXyr56R2+vOYCYbIcEjpJrw480edJmrKY18U7V7XBD1XOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773768210; c=relaxed/simple;
	bh=GCWPjywACiO1LyNiel5PcW42uZ7ppgt7/impWQASw3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YSqRh37E9Z2pbpOH5hMrVttawD2/9walx2nDqRU4QoLWXpCdr5ejVVvN/T6QnxAC9/g+MKsDWJWk7mIRUxdDAim6sDs+TgtZ3bzQzUh6ASMkMZEmw7OuqUrv9s326ew3gcw46kLKRI8mBVTjp6Y6AkotvKrFEAET3ChKumBJrzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=axIcf5SN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="axIcf5SN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03C8CC4CEF7;
	Tue, 17 Mar 2026 17:23:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773768210;
	bh=GCWPjywACiO1LyNiel5PcW42uZ7ppgt7/impWQASw3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=axIcf5SNg01EXDsBCi5evapDFltOEfaPOq6axlJU2/CzCoMCEfPFhvJeoBAw4Tv8M
	 VJSVYXMTdfFKgiQMB33wpKpA91Fj+2pJGoMZLC5bsZQdouYYeG9VWelKRb76ALVDIb
	 FctvRMUEku1acoku0+WNmnULisCkJ1D0p2m6SdBg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Rob Clark <robin.clark@oss.qualcomm.com>
Subject: [PATCH 6.18 258/333] drm/msm: Fix dma_free_attrs() buffer size
Date: Tue, 17 Mar 2026 17:34:47 +0100
Message-ID: <20260317163008.938509952@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Fourier <fourier.thomas@gmail.com>

commit e4eb6e4dd6348dd00e19c2275e3fbaed304ca3bd upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/msm/adreno/a2xx_gpummu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/msm/adreno/a2xx_gpummu.c
+++ b/drivers/gpu/drm/msm/adreno/a2xx_gpummu.c
@@ -78,7 +78,7 @@ static void a2xx_gpummu_destroy(struct m
 {
 	struct a2xx_gpummu *gpummu = to_a2xx_gpummu(mmu);
 
-	dma_free_attrs(mmu->dev, TABLE_SIZE, gpummu->table, gpummu->pt_base,
+	dma_free_attrs(mmu->dev, TABLE_SIZE + 32, gpummu->table, gpummu->pt_base,
 		DMA_ATTR_FORCE_CONTIGUOUS);
 
 	kfree(gpummu);


