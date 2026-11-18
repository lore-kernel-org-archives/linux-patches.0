Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037646;
	b=SwPUiIc/xLFfLryTwcB+s0i0VyZbUDHlQ9xmLNiZ624OLXT6EYqW8LpzO8ZKMHObiouE
	 CGtvSD2RNL3c+RTtMwEyzRnr+kFcJWp//T7vLv+7njQFktIM/OMlBRwa82gWkrj8oQ/RB
	 o2d+igxNdEFj1nTJrDnjPyC2+ROKbtNwg+H2yALSdTvVhgNyQamISgTinE3xcV3UE/P3l
	 sqJc+g5v9wEoGyHem+76rvWKBciPUcf8YlKzjqkmC8v2QUAJqLBQr+cbwGb+2VQhxJ1nc
	 2RDR+RdYodPE+nh+kEWqXRfnVBlGZUteV56s6pKsRTbadvqnzclbXlBEEZjZApmYC9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037646;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/+xDXKmUkxCABBNBtBkJoDIjzvcla6pX1TwSmu5+V0Y=;
	b=SjdsmPgUqsoEPOH+jvTV4Mkz9iaWco6RHj1lcvDOrIaV8SdhV/RngaERNF7+ppYNOnqH
	 Vkq5ZFoUj6aX9D0l+Ho9KWXrYT5gedQG+pzxJpvDEn4llYgBWw8oe3/233L22C6UzdTuN
	 KRYOsqP7kD9HskevDWOviSTdnhuBO+qcl/dmlu1dwxo6Mrx5AphUdBMP9moj9VG1drna3
	 nV5l9I8z7jq6bE3ZO4Rx/h9m8meN9hUtncAJ1JHS6NwWPx1Z7uMHhj51Pmqyy14vBl6Fr
	 RHJTPHTYEqQGz9DxBAwGtAIFfTeI0e/2SrG63i/AYq6o1r1o9ZZMtMHfllCvOkcpgyQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G831gnbM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5394E606A31C;
	Wed, 18 Nov 2026 21:34:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G831gnbM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A49511F000C4;
	Wed, 18 Nov 2026 21:34:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037646;
	bh=/+xDXKmUkxCABBNBtBkJoDIjzvcla6pX1TwSmu5+V0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G831gnbMZl765cKylyheNDnnlTcirXqPBFphKElqqyvkXPhXmX1p2vn9ONDWoCWXJ
	 C0pjlwJElOCrmoy2UbEOUELARNhSSzcxgo5BkE0u5UjeHcCe2zX/gFCiHJ7VTHh/oZ
	 FBPNXg9N9l3RLb6KS6/eKFyP/l+Tr/SA/TnWGQKI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Evanshenf <archwse@gmail.com>,
	Icenowy Zheng <zhengxingda@iscas.ac.cn>,
	Qianhai Wu <wuqianhai@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1428/3318] drm/loongson: Fix double free on BO initialization failure
Date: Wed, 18 Nov 2026 15:34:10 +0100
Message-ID: <20261118150403.574393102@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index bf79dc55afa49..f0562ff87bb22 100644
--- a/drivers/gpu/drm/loongson/lsdc_ttm.c
+++ b/drivers/gpu/drm/loongson/lsdc_ttm.c
@@ -480,10 +480,8 @@ struct lsdc_bo *lsdc_bo_create(struct drm_device *ddev,
 
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



