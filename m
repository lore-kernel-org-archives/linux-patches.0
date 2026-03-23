Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A5AE12CDA5;
	Mon, 23 Mar 2026 16:22:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282937; cv=none; b=doR709PR1yUJQUgQ9JWYl9pWCdqRvdbnJpWOxhrfCHGNZlzq8ZfTD9mdBHhrV9yeBS1PoYbt+vQzMLFavBfXR4IBkXwtie5QH4Re/H/26q580+tIW+Vej/xj9FZB7o1AM4ZGuOgtJldnqWdOKV4WpFvfsRLSGfylEAj/l/T0Wjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282937; c=relaxed/simple;
	bh=ql1C9y9yNEtrUXFoWW91kfu1m2OlJ4UDRNxXBB+yg34=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iczTRHKJ5V7RyaW21uXdLOAzz+i19bOEUnweaFfyLtUGvOWEE+M2ogMcoqrAODdTK3M1TO0mSLDsIi19ERFyEC49e/ETRDk7Uu4yP+W27t8VtR/OfaPYQGxCbYmOOR5bjsqYVp72MttKnpaPqt3ur45wopnAEJcpL3WNBqo7aOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=acLQmQ9s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="acLQmQ9s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0929C4CEF7;
	Mon, 23 Mar 2026 16:22:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282937;
	bh=ql1C9y9yNEtrUXFoWW91kfu1m2OlJ4UDRNxXBB+yg34=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=acLQmQ9saFi9dyPKFxhjjaftRfVCS7WJwlhL64iVZFzgff0jOH3e7rsPDXNHZfO1s
	 TFFhTNSj+e19NIIwINn8UaQ17fKBlh7FRwnEoIDUF09RIWfvWO4mJ40PP0Oq+3ZHGV
	 18Z1TFgqmhz+WYZjovw7zVCHaZ4EfCSGdbF+0xbw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 342/481] drm/msm: Fix dma_free_attrs() buffer size
Date: Mon, 23 Mar 2026 14:45:24 +0100
Message-ID: <20260323134533.434562575@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


