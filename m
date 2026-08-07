Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A8402F0C74;
	Fri,  7 Aug 2026 15:25:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116349; cv=none; b=hoZINWalBcvoqF3b0cavrHIy0j8Rk6ytu52YGnXfj/0F/wZTqgZyiG3tE7DM4rT5efuE+MvCM3np7xntV4tkkVdCt8H3IS9v5Dpmf9dkIvHUQ1Tl6liQbp4o8liqR3J1KgppmvLI38pceak7nMbNMMtnRcQnIzXF4Dzna0hgkUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116349; c=relaxed/simple;
	bh=D68zvlIdW6p1oLKcKFvlcWMQYKPXSuGjogSM9r24EhY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LRTRWQj5R7ic/iq8DLjGtR9A9GhRO3pN8v6BlVKVOKODa5oBay/6vh3x1uEwKwTqeRaAvmeUeezJ7RNSHgowbM8TDRUV1/bJAzmr8VeSlokd3HzbIqSbs14LRSMANDHEOcspzpS//o5jzZXSChf1VSannGjZuwH783q3WMkPHsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IxNkikpg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IxNkikpg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95EAC1F000E9;
	Fri,  7 Aug 2026 15:25:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116348;
	bh=TncqhLtq0azOIkC7lq7Jr37aDhf06iIyl5QhjEuQB2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IxNkikpgP+g8A62kHP5YzBqPGm3wEhigONaBiMRUuYNCBOFvB/rhUPaSJcW8Q32cr
	 bc93eQiOoguI4IGdj59mOY52QB4Kta5qL8Nz1PZzm7LWn1B+MBWPzLsluI0wX3oePk
	 Kb1Q8k1DAaKCJ5ATlW9bpTB+Go8EqDCWOpJ1bueg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zack Rusin <zack.rusin@broadcom.com>,
	Ian Forbes <ian.forbes@broadcom.com>
Subject: [PATCH 6.6 199/261] drm/vmwgfx: drop dma_buf reference on foreign-fd prime import
Date: Fri,  7 Aug 2026 16:39:16 +0200
Message-ID: <20260807143419.661331443@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143415.358597922@linuxfoundation.org>
References: <20260807143415.358597922@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


