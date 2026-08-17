Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DB252E7BD6;
	Mon, 17 Aug 2026 15:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786980151; cv=none; b=o0JRys7OMb5K5KZ47dt/LQoTX6jEdQWPHHDmVqw0lR6dl1UocbbbO7o/ia8rpJ2XgnZaQS8m0tbfbYybwM6iqH8A7H43OnuACytRjpB+q+jYuBrtEYMvnfCKvFyCcausWXrosn3tq14keDaD4TXseEtS+2x0+6Xmod2/itHFdig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786980151; c=relaxed/simple;
	bh=IZpQSFstF4XyRQ3FEAg/BtmUBfI49PlQ6BcEIL9iAX0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NWN/GtdrwygC2y/EsSUu6YbUx8iSAZRev69aiIS7qWSkaSJ8THvBjd9wpCB7X2sDnTfR2ApI0R18s3XUzH2SZkOg/DMoG+01VJRXda2QmqNf1D/9vrxyA/dki3OOSphLcb1F8Kq22YBCLn0cpS3jeptiNfAYwRDZCU8/lMzSKMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c6BZSDyg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c6BZSDyg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 657411F000E9;
	Mon, 17 Aug 2026 15:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786980149;
	bh=pBaI2rxh0q+QCyMqH7DO5vGzAzSi5cAPsQb5aRIwBNY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c6BZSDygtiYyJhWTWXnOg6+C/aD3xCXsDPigLWgsO9Sj+KUGVD28f/YkHjAWJNQAE
	 Qq51jZkQyr8AlNKkdQl8J7Ia5C53snK0viUw2sudy4q5cOJxe758jYKAZKnBxnW7gj
	 t+B947kCw4Ka7PIk6XD0lDL1c31Lk+VvrUsRWE9M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zack Rusin <zack.rusin@broadcom.com>,
	Ian Forbes <ian.forbes@broadcom.com>
Subject: [PATCH 6.1 472/609] drm/vmwgfx: drop dma_buf reference on foreign-fd prime import
Date: Mon, 17 Aug 2026 15:32:48 +0200
Message-ID: <20260817132559.766074835@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/vmwgfx/ttm_object.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/vmwgfx/ttm_object.c
+++ b/drivers/gpu/drm/vmwgfx/ttm_object.c
@@ -551,14 +551,17 @@ int ttm_prime_fd_to_handle(struct ttm_ob
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
 	ret = ttm_ref_object_add(tfile, base, NULL, false);
 
+out:
 	dma_buf_put(dma_buf);
 
 	return ret;


