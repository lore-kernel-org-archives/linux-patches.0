Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FC9943BDCB;
	Thu, 30 Jul 2026 14:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422463; cv=none; b=g56ZA3gmOehVlKol53xj1OQRxOy6NjKQvRjGGyskJFvy7Bv/ngJRZ5vguRQ4lxXC8GieXFNcJsXHbd6qBjsW0NW/CVzcbPLy7OL0uqTIoT8oRGeYlm2UIu8FyGA7V0CXJthD4JoNCnYypl7CXb9ScVLz5NKqrrlLG8gGXpApeJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422463; c=relaxed/simple;
	bh=Uy2+UKYC8Acih0YRriOOXUGi/ziZNbwFyT1RuYA+XfQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n4XwDBWMnDHpqI+0zwNEdg9VUgIHvAb1Mw0DEJ1xqeZE1w6EPqsmLXCK5F/Exc1AEBxi28eFZ+Hd3aMGpIs/5l966fqH1HWCWFCjIjTR6v+UuMPFTq0GW0cr2nRxf+rxN2S75tck1b/ZjE3bEO7AjvPnsfRgzZZCTBWMK4aM/Y0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OVejNz/L; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OVejNz/L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB0BA1F000E9;
	Thu, 30 Jul 2026 14:41:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422462;
	bh=6hNiYzY3fw7WvBVZkZWA8ItUYYSqgEqlJeOgQBonH04=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OVejNz/LoJLvxo07uT9s371XmIY8AIOai36FXH0oyd4prQsJy8uE3tsbpirql3wXD
	 pJmoHyFs6IgDJCYLOd4VFpwLUGHMfVrM9R+VIFJaRJ/9YDIpbmx387y3U9ZXVZISmg
	 1weiggJKyEdj8A6BbUXCBTiuPWPDi7A8SsD/u0Yo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Brost <matthew.brost@intel.com>,
	Honglei Huang <honghuan@amd.com>
Subject: [PATCH 7.1 446/744] drm/gpusvm: publish dpagemap early to avoid device mapping leak on error
Date: Thu, 30 Jul 2026 16:11:59 +0200
Message-ID: <20260730141453.777597773@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Honglei Huang <honghuan@amd.com>

commit 7f708f51e3955bda0d77a0b67ab9bea6c97fea99 upstream.

drm_gpusvm_get_pages() only stored the local dpagemap into
svm_pages->dpagemap on the success path. If a later page failed (e.g.
-EOPNOTSUPP when ctx->allow_mixed is false) and jumped to err_unmap,
svm_pages->dpagemap was still NULL, so __drm_gpusvm_unmap_pages() skipped
device_unmap() and leaked the device mappings already created.

Assign svm_pages->dpagemap when the first device page is mapped so the
err_unmap path can device_unmap() those mappings.

This issue was found by Sashiko AI review.

Fixes: f70da6f99d4f ("drm/gpusvm: pull out drm_gpusvm_pages substructure")
Cc: stable@vger.kernel.org
Reviewed-by: Matthew Brost <matthew.brost@intel.com>
Signed-off-by: Honglei Huang <honghuan@amd.com>
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Link: https://patch.msgid.link/20260701062800.409248-4-honghuan@amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_gpusvm.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/drm_gpusvm.c
+++ b/drivers/gpu/drm/drm_gpusvm.c
@@ -1519,6 +1519,16 @@ map_pages:
 					err = -EAGAIN;
 					goto err_unmap;
 				}
+
+				/*
+				 * Set the dpagemap as soon as the first
+				 * device page is mapped so the err_unmap path
+				 * can device_unmap() the device mappings that
+				 * have already been created.
+				 */
+				drm_pagemap_get(dpagemap);
+				drm_pagemap_put(svm_pages->dpagemap);
+				svm_pages->dpagemap = dpagemap;
 			}
 			svm_pages->dma_addr[j] =
 				dpagemap->ops->device_map(dpagemap,
@@ -1562,12 +1572,8 @@ map_pages:
 		flags.has_dma_mapping = true;
 	}
 
-	if (pagemap) {
+	if (pagemap)
 		flags.has_devmem_pages = true;
-		drm_pagemap_get(dpagemap);
-		drm_pagemap_put(svm_pages->dpagemap);
-		svm_pages->dpagemap = dpagemap;
-	}
 
 	/* WRITE_ONCE pairs with READ_ONCE for opportunistic checks */
 	WRITE_ONCE(svm_pages->flags.__flags, flags.__flags);


