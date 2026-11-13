Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590229;
	b=TCnubl6SEA94NYZO5+zBOhizUBDodBXCE3L4k+NZnKM199yoIpeXBTB8t8RgLk1l+4AD
	 YcgDRz6Qmbc0pbfkHcQC07GxyPVT1CQpLHq0uuw9brsirI2Sx7cVm0OK67QjNmhvaCrk9
	 oj4QMd6/b2cRvnSrYGSH5WnReU7F9gjr28bpwWQVsuUM7tF6wK2vOujYxkbQRhVMFSUvy
	 gF0TTut2zkiqRBdgeRD9xC37+YfeN90ek5XmifmYmBFzGC5YR5gLCWtHpdtfFcr8q2sGr
	 CC2K1Hbq+ZPuMyj/gxPVg6LeNcPboSy5MLw/UMRFZDugEp4Uv1wAiZxSKJIzsPgxvRw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590229;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7uT+xuDihQiWpwk+wTA2Tpe1j9oq7tXMJcPDO16tiqo=;
	b=4C2Chf1HkPPxxlCXtduhD9ruCATSJvi6q9JF1iItPirpmTZXAAWZS+wa/EMoTVyjdPUK
	 AVhm1JLYn5AaGXe5JNWltZ6qjLpxMXp8InSXA7/EHLCDopPKN0VvAK8IbdEY1glj+m2KJ
	 WB+ydngPjI892NQX2yFw9LrhpvboasMAjQk4N3MeMs0Pnjle/cfzCTgzgAng1ndYg+Cc7
	 5JJxUGHpj8E84CluJqXarnH/vmB632sTqpy07abmjU5V/IuMGyvtYRXjJzgBmWivqCuZv
	 sVMC/zmMSMmkC4cP6YFoFMMvU/vj+Wq2kRX5TTorg8Czn9gx4luZX4YkeDg1ZyZdOtg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zzcAfh8N;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 805BA606A8BA;
	Fri, 13 Nov 2026 17:17:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zzcAfh8N
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D52C1F000C4;
	Fri, 13 Nov 2026 17:17:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590229;
	bh=7uT+xuDihQiWpwk+wTA2Tpe1j9oq7tXMJcPDO16tiqo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zzcAfh8NVpgpUb3dFqT7C8t7rhPYqDkBDz2HLH9cKDHR0XSsgNx+p/gk+HFrpNiLb
	 NiTi0gf0X6fhPvQlVF5OA5vpb7mWYCl1SkUI4gwsc4VhzcmnsJl5WrQmyen/OPv6jF
	 i+Lrz5Y2zqza0+hAmaRAdwbNmVsNoOgTaXJxN+xs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Evanshenf <archwse@gmail.com>,
	Icenowy Zheng <zhengxingda@iscas.ac.cn>,
	Qianhai Wu <wuqianhai@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 227/686] drm/loongson: Fix double free on BO initialization failure
Date: Fri, 13 Nov 2026 10:46:00 -0500
Message-ID: <20261113153828.711920085@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Evanshenf <archwse@gmail.com>

[ Upstream commit f086dbdeb6e56510e158a853d752c6d8ed9e0674 ]

If ttm_bo_init_validate() fails, it drops the buffer object's reference
and cleans it up through the supplied destroy callback. lsdc_bo_destroy()
releases the GEM object and frees the enclosing lsdc_bo, so freeing it
again in lsdc_bo_create() causes a double free on a synchronous failure
path.

Let TTM own the cleanup after initialization has started and return the
error directly. Keep the explicit free on drm_gem_object_init() failure,
which occurs before ownership is passed to TTM.

Tested on LS7A2000 by making drm_vma_offset_add() return -ENOSPC for one
selected dumb-buffer creation. The error reached userspace, the destroy
callback ran once, and no handle was published or tracked BO retained.
Normal buffer creation, zeroing, mapping, readback and release passed.

AI assistance was used for the ownership analysis, fix, fault-injection
tools, build and test execution.

Fixes: f39db26c5428 ("drm: Add kms driver for loongson display controller")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Evanshenf <archwse@gmail.com>
Reviewed-by: Icenowy Zheng <zhengxingda@iscas.ac.cn>
Reviewed-by: Qianhai Wu <wuqianhai@loongson.cn>
Reviewed-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Icenowy Zheng <zhengxingda@iscas.ac.cn>
Link: https://patch.msgid.link/20261003093415.e64386de1e64-1-archwse@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/loongson/lsdc_ttm.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/loongson/lsdc_ttm.c b/drivers/gpu/drm/loongson/lsdc_ttm.c
index 2e42c6970c9fd..e8805a2a0db43 100644
--- a/drivers/gpu/drm/loongson/lsdc_ttm.c
+++ b/drivers/gpu/drm/loongson/lsdc_ttm.c
@@ -474,10 +474,8 @@ struct lsdc_bo *lsdc_bo_create(struct drm_device *ddev,
 
 	ret = ttm_bo_init_validate(bdev, tbo, bo_type, &lbo->placement, 0,
 				   false, sg, resv, lsdc_bo_destroy);
-	if (ret) {
-		kfree(lbo);
+	if (ret)
 		return ERR_PTR(ret);
-	}
 
 	return lbo;
 }
-- 
2.53.0



