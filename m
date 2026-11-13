Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591045;
	b=XbtWnlMevR9FY/jzYCFh4bGIQJa+bFjZuN5uB3TdmUR/mRSQ/0raqdGF79cCIBsCi7R6
	 cdV5lM3IRbCWs5hrR4W0CXAweitZmIH772ZgPSE78ZO0Mxw0Vk6uCK7ZRBtodjzuQh44U
	 19xd+FwL1U778R6VdhbLdz8E8NpZlDB4JM7R5AdNk35+eVxneTsPMTXi9p52QEUo3WoSL
	 T38cQFpT2toRV35EiDqZOex0vfLt/j7OLKAcNXvWV0l64eX7p5sBG0nzw6c1Qb3kjsJrM
	 3NWEtsK9mKjR6Kb5bD26CHWY1bABNOTFyhdNUpoHtYlyXdCMM5Qf0N1HafNneV6RqGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591045;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=p0w4RMBexFG2qE3hI4LY0QbIsDhsKkPddsLS8X7YZX4=;
	b=h2+ayWAnvrgc1vGPWjjJi4ebqG0elAQU8d3oslyVLpeTBO89tvJZCN6f4GhCRjSiEunv
	 NdLAb4gluc9qf0BPGjSrgIkMLeesfFWdRYmhHnNqhNogetMRicOmrthlSOPSRkqjWSu5C
	 rvSns+HSiWLtbO2U0QqAguKeRWtTJcWX8lm1x7V+xsw+pQozgT5TIs3Wgt1wpUDd+cStW
	 r5PlqCqsjwak+DWtIy3/OoVwcIoYcVlgGRKQTmw3wDHtSFYXfSoxt0veOgDti32REtLeq
	 bEf55E1di0P3xI4bna7ljTtgbBgfYL1p9rXRJGdt2j+v6um01L1ATTwM0kpmeztNMLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ss01ODtW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B10B8606B471;
	Fri, 13 Nov 2026 17:30:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ss01ODtW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DC1B1F000C4;
	Fri, 13 Nov 2026 17:30:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591045;
	bh=p0w4RMBexFG2qE3hI4LY0QbIsDhsKkPddsLS8X7YZX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ss01ODtWdOkg+w0FMPaxQp9goVBgc6jQb4tEP2g8BDMPxzMqJ1897VJ/hvPxFd11g
	 QL0zIAcSPcPmEBEmRvtMsv32ZwR53prwJF8g4YJhbW7FOJsuyik5DcTN8XP26KA+xK
	 1yqxaDuR5T0jzK+UtoGhqMAjXYI+6hrXYcwRjzio=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Evanshenf <archwse@gmail.com>,
	Icenowy Zheng <zhengxingda@iscas.ac.cn>,
	Qianhai Wu <wuqianhai@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 210/670] drm/loongson: Fix double free on BO initialization failure
Date: Fri, 13 Nov 2026 10:46:14 -0500
Message-ID: <20261113153819.051074855@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



