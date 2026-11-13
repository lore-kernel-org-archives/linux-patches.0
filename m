Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585497;
	b=17suFhv/SVTmv68tSVhQgUm0YUdmTY265ZsAJfbPANAcbHqlkUs5DVbvCJK3/E6iYWgT
	 MMg4HRFMZDlPD76729sL/h/eA0qzG85dmz6yOj5j2Mtxyo/AXx1ErWz2tUbbnCIERZtAp
	 cDJXzA6F74QLs7WnZNtIxV7Hp7jVxDDzU6LBAkUe9nGSPKDVCJ0xZ8CvOYt5Dvhw4WaAJ
	 Rfqv4CHGrH4rNWmEIxOfiw0a7Fl4jcakInWmg79MbeubaCUQw8vlm49p5XQp47sadCYLu
	 DWaf65lORDp7wm+/cwXGFDPCMij1UzN5f3NYejqg8X/waD4bdwgtl0uNCjAJ8GGKNuw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585497;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eafF4phD525o0n0/ZbSmmDGKui+65hLHvnfOTEUA3MY=;
	b=aGrD4PcEBC/pG+pLoXE/+WFhcbSaW3j4HLH285DpLWi+r0hgHXK1SVzUyhoRV3a1jihj
	 VMN39jAMhluIPaveAJL31RFnv1t+atT2/qF+AC39koNp+VIVJHLD70IWXuQ23skHeziRs
	 Oimw0b8o0dse6ODA57vtShV+ZJo8nqmq4FCTNwz3Nwp4mSX6GBBcxlzC/9gxh7TAG/dxI
	 gV+Rwa0aIZ2ilapp5AShiYZIIdMM43yg14ZXtPKUOTRqLWfPQUiOmp7y7LKBx7N1t4RX2
	 +71rtcl6FQ5PevjrVVZJ+cocxY3+jDH5aEchZ39IJvDwQq+5d6b6I5IKAOyGKrS5EJA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="aCHp/rh5";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ABE3606AE11;
	Fri, 13 Nov 2026 15:58:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aCHp/rh5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45FBF1F000C4;
	Fri, 13 Nov 2026 15:58:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585497;
	bh=eafF4phD525o0n0/ZbSmmDGKui+65hLHvnfOTEUA3MY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aCHp/rh5+XLWT4l7Lqy8hmcCElzqRMLYWYkdSdQdUg/eRBnZigC+yWrrfTyIlPAs4
	 QblkxULPbH0Ew5sRzlX53DGrZuXLpvCGPNPwjWEvkiaHkiwMnJ2pXF5vZhHEVxiaFb
	 VsuLNlX8//sk4Gn4OAEC/U9PgeK3bpggZ+ex01FI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Evanshenf <archwse@gmail.com>,
	Icenowy Zheng <zhengxingda@iscas.ac.cn>,
	Qianhai Wu <wuqianhai@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 104/507] drm/loongson: Fix double free on BO initialization failure
Date: Fri, 13 Nov 2026 10:46:48 -0500
Message-ID: <20261113153757.849951679@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index d7441d96a0dca..88536e230c2fb 100644
--- a/drivers/gpu/drm/loongson/lsdc_ttm.c
+++ b/drivers/gpu/drm/loongson/lsdc_ttm.c
@@ -475,10 +475,8 @@ struct lsdc_bo *lsdc_bo_create(struct drm_device *ddev,
 
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



