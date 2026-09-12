Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48DF537EFE2;
	Sat, 12 Sep 2026 19:36:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789241782; cv=none; b=fyk7AYSc/51DXDkT0FciDQK1e25LRhnI5Iilbe8010MbXXTaZ4cWibveVR61dbuSfniXeKhpuWRHssYMfEzvFKvl5uNk4ls8qbVgfo3Zuq3U7KYbjPuc3ZLBVFfHq7fTQpquO4hcDIm+oanBs/vhlYJgDA9hlzT6yJcwPTbqu1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789241782; c=relaxed/simple;
	bh=9r0VMy0dzTpC6yaUOl1wkufUwJWf0qgOQI0IKdsdIsU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JOca/FVOl2PqsX1nfKHIrd6/F02sbKmcIvyaD+6D7Hm1sSWwn0xfwQJ35mUBOYhJB7cOGjf/a5U4q1jn6XuThltkWKJTbKoTpiT2nkg3/yZ8ldBRAVIj3PMthPpUz29WJGS9llF5uloHHPqFuc+zbl/ZCDBr6Lt6A0JmWK6vk+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o1dfnyQB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o1dfnyQB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E97A1F000FF;
	Sat, 12 Sep 2026 19:36:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789241780;
	bh=zFCs9KWCoV5MOskZlS2ray2l5igWRKyFQLY8IVzLglg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o1dfnyQBswaAeOcWQ/5IBRkz0rLK29Gn30xi/JPnC2fn6443K7n6jPDe2hNHxwVmE
	 3AUEXENsCsaHkAL3DS8KRWWSB7sAXNu3hLN+pqNFIU/de5P+XS/fdI++SNJPS+vsWa
	 vtvYm1lqTw40keucJzMK3mcAsCo5o2+Pi18T8kDc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zack Rusin <zack.rusin@broadcom.com>,
	Ian Forbes <ian.forbes@broadcom.com>,
	Alexander Martyniuk <alexevgmart@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 207/798] drm/vmwgfx: drop dma_buf reference on foreign-fd prime import
Date: Sat, 12 Sep 2026 08:57:15 +0200
Message-ID: <20260912065521.840885120@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zack Rusin <zack.rusin@broadcom.com>

commit f739416dc555fa205a785e5135d73fa39b26f35d upstream.

ttm_prime_fd_to_handle() returns -ENOSYS when the imported fd's
dma_buf->ops do not match the ttm_object_device's ops, but does so
without releasing the reference acquired by dma_buf_get().  Any
unprivileged renderD client passing a non-vmwgfx prime fd through the
DRM_VMW_GB_SURFACE_REF{,_EXT} path leaks one dma_buf reference per
call and indefinitely pins the foreign exporter's GEM resources.

Funnel the error path through the existing dma_buf_put() so the
reference is always dropped.

Fixes: 65981f7681ab ("drm/ttm: Add a minimal prime implementation for ttm base objects")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4.7
Signed-off-by: Zack Rusin <zack.rusin@broadcom.com>
Reviewed-by: Ian Forbes <ian.forbes@broadcom.com>
Link: https://patch.msgid.link/20260505222728.519626-6-zack.rusin@broadcom.com
Signed-off-by: Alexander Martyniuk <alexevgmart@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vmwgfx/ttm_object.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/vmwgfx/ttm_object.c b/drivers/gpu/drm/vmwgfx/ttm_object.c
index 16077785ad47e..39ddb74ad07f9 100644
--- a/drivers/gpu/drm/vmwgfx/ttm_object.c
+++ b/drivers/gpu/drm/vmwgfx/ttm_object.c
@@ -658,14 +658,17 @@ int ttm_prime_fd_to_handle(struct ttm_object_file *tfile,
 	if (IS_ERR(dma_buf))
 		return PTR_ERR(dma_buf);
 
-	if (dma_buf->ops != &tdev->ops)
-		return -ENOSYS;
+	if (dma_buf->ops != &tdev->ops) {
+		ret = -ENOSYS;
+		goto out;
+	}
 
 	prime = (struct ttm_prime_object *) dma_buf->priv;
 	base = &prime->base;
 	*handle = base->handle;
 	ret = ttm_ref_object_add(tfile, base, TTM_REF_USAGE, NULL, false);
 
+out:
 	dma_buf_put(dma_buf);
 
 	return ret;
-- 
2.53.0



