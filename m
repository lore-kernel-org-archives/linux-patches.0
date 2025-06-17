Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E88BB2EF2BB;
	Tue, 17 Jun 2025 15:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175656; cv=none; b=YXk5yeemtGkxsaYWamXtoQITIhwZOYI/C5edARQn9/w738llnqk3hE9p9o1eq7TLfeNy8W/Fe4HC0i8Islw7wpzAHtPuweSkjyYBNFvWwLKT0N5TToFuGOYax1t95UGwTbzy0V7gUEUHA7JWsTJ6eJMK3I2BIvy+z8PIVijb4zs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175656; c=relaxed/simple;
	bh=C9Gz+J43UljSNoAb8wDj0BoiJaXCtYhUfyR1XhK10Wg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=epKBT1Yg/orzYMdIqPK8asl6Y8bojjPyN50LMYztTOtIPBjD51r/PzAwn/M4G0y0aAlEzfJm7Is/W4QrTMwNeu7A1Opc88MEW7KJMxeuLmP4ruOBL5LgqkwBfPiVaD/WnLyzWCmQcHlAv21D0n8kFUZ2Dysdjbwv6G/s3VMYDKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MWyDFVfU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MWyDFVfU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E90C9C4CEE3;
	Tue, 17 Jun 2025 15:54:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175655;
	bh=C9Gz+J43UljSNoAb8wDj0BoiJaXCtYhUfyR1XhK10Wg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MWyDFVfUw5JCCtVxYXSr1zj4qwITUkyRaQnKusaEcYD3at16FsNzz6bQFvbcQbn1E
	 leOLRZ98ad8V9/jZriIDBjvUaADa4qreOUB/57tF32n1kRkIpSdMuIzyQiuU1WO3ZB
	 Nrey/WoiGntxRCFEFprcjoTaw1MGEz/3tAP9HVM4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Steven Price <steven.price@arm.com>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 110/780] drm/panthor: Fix the panthor_gpu_coherency_init() error path
Date: Tue, 17 Jun 2025 17:16:58 +0200
Message-ID: <20250617152455.985744233@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Boris Brezillon <boris.brezillon@collabora.com>

[ Upstream commit 938aaed555f3add76531cd204e2d4128ecb84ace ]

The panthor_gpu_coherency_init() call has been moved around, but the
error path hasn't been adjusted accordingly. Make sure we undo what
has been done before this call in case of failure.

Fixes: 7d5a3b22f5b5 ("drm/panthor: Call panthor_gpu_coherency_init() after PM resume()")
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/dri-devel/4da470aa-4f84-460e-aff8-dabc8cc4da15@stanley.mountain/T/#t
Reviewed-by: Steven Price <steven.price@arm.com>
Reviewed-by: Liviu Dudau <liviu.dudau@arm.com>
Link: https://lore.kernel.org/r/20250414130120.581274-1-boris.brezillon@collabora.com
Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panthor/panthor_device.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/panthor/panthor_device.c b/drivers/gpu/drm/panthor/panthor_device.c
index c73c1608d6e68..1e8811c6716df 100644
--- a/drivers/gpu/drm/panthor/panthor_device.c
+++ b/drivers/gpu/drm/panthor/panthor_device.c
@@ -245,7 +245,7 @@ int panthor_device_init(struct panthor_device *ptdev)
 
 	ret = panthor_gpu_coherency_init(ptdev);
 	if (ret)
-		return ret;
+		goto err_unplug_gpu;
 
 	ret = panthor_mmu_init(ptdev);
 	if (ret)
-- 
2.39.5



