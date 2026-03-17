Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E74C29D26C;
	Tue, 17 Mar 2026 17:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773766879; cv=none; b=Qxum+mkdJF3vYGYUtA9wYBATEgP/yAR6pEtZlVj0cRpHUoDqzJUrQh+fLtpM9IX/YW4DPlipS747Xw9Uq0pqyNAeJbRVY9ksrzEkG9aNgG8nfwaGxv446OI2Ooc1ZxUDjxmwlvMg0/uvmQgFvAh7ydAkFalyNoVYxiLpvUkH5W0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773766879; c=relaxed/simple;
	bh=nTJLi7O7e23OSpcxdI29al9Xs3E0aVb+glje55nG6Aw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q2Mwizzq2IxZWic0yA69iLTUEPrr/imPGyIbx1vZO/PLpoXD3H4tnory83VhreWjELevLtdram2u1SFPlnCGJcEtdqqPI+HGLF7MaoAbWRf81PgVZvhXibvBU/OA0DO8H4ZWm5hn9GBjaLBrGbsxWFAfnCENG55iwEOpYs5hVRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ucxJjc2J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ucxJjc2J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D036C4CEF7;
	Tue, 17 Mar 2026 17:01:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773766879;
	bh=nTJLi7O7e23OSpcxdI29al9Xs3E0aVb+glje55nG6Aw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ucxJjc2JVYHGKr4426JLIAIWdTUih3lSGqiq0qV6i2UR11FELI7KO+u3WGLwj/lny
	 OxEZN7JCGRGDd2czsb3Af8Odmu8+WEB0Ln9kij8EV6Me0pXnLPsASOduI93G/sfTxB
	 DtrV1dntloIqV8uyFgTzUwHT47UJbv/e/GlIf3aY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Rob Clark <robin.clark@oss.qualcomm.com>
Subject: [PATCH 6.19 308/378] drm/msm: Fix dma_free_attrs() buffer size
Date: Tue, 17 Mar 2026 17:34:25 +0100
Message-ID: <20260317163018.332487369@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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


