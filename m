Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D45502C181;
	Mon, 23 Mar 2026 14:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275685; cv=none; b=lt9wmvO/dVf7KOgM5P4P9YJCTUSaSH8s5J/S8z0+DN/Mqu8BZsx6wdXayAp2/fSoGcdtW1O1M55HDt3vZ6NhVEH3h1IiQtTElsk0Yc0Lc+4Gm6uE5PbIGKd7DLbMkGBCkKWV37SdNzU1uHQFlECh/mo7Ve3d7/FoktRr0WMfMdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275685; c=relaxed/simple;
	bh=lTfUry8QNHCfJJakiPFiu4dgzDs5U41CA5JTHMnVqZ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=STi+GTHwvR8HxGOk/M420r3tupzCrrdHXaNLKfNO7/NPjmQFymubiH5cpl7Yr8+EV1sL5Xnyoh+iuyoOSr6W2mSVY4IeUJo4tM7WreLv980f/QrEazvAl6eCqh2BX9PALrxnbyGLwuQXzy23WTINeISKrA9PS5I0PIDUSv+yqvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sqVew1GP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sqVew1GP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63F7BC4CEF7;
	Mon, 23 Mar 2026 14:21:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774275685;
	bh=lTfUry8QNHCfJJakiPFiu4dgzDs5U41CA5JTHMnVqZ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sqVew1GPrInlgqbTR6MhIJg4sPDdD/AvXLPjn78EkQ5S3LwrTatuAW8l3IyOW2n46
	 R6rduUx5gSc1zJ4ZTcT2quDaQPk+30sOZlfOj6OsYAVNMaz0oE5lhQEyeYSKQ+u5gA
	 p/q21OWaY9D2Yx3HRx4Qhut4pNdFSrz1L2VW8hKc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Rob Clark <robin.clark@oss.qualcomm.com>
Subject: [PATCH 6.12 182/460] drm/msm: Fix dma_free_attrs() buffer size
Date: Mon, 23 Mar 2026 14:42:58 +0100
Message-ID: <20260323134531.014257239@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -79,7 +79,7 @@ static void a2xx_gpummu_destroy(struct m
 {
 	struct a2xx_gpummu *gpummu = to_a2xx_gpummu(mmu);
 
-	dma_free_attrs(mmu->dev, TABLE_SIZE, gpummu->table, gpummu->pt_base,
+	dma_free_attrs(mmu->dev, TABLE_SIZE + 32, gpummu->table, gpummu->pt_base,
 		DMA_ATTR_FORCE_CONTIGUOUS);
 
 	kfree(gpummu);


