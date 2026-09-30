Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D710836A033;
	Wed, 30 Sep 2026 18:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793445; cv=none; b=WQq6pxDBX72p1l24wNkmlNf9u7cDtUTL7A60DbZnm7dFfRu3SrUpuP0I+2k1GF7Z8xIQQT4dZEtmu3POZlHzTkGgJ/6UYrZa0BmsTVmIFhl9cls586CCAkuKU4arTooc9m/5Lvgq+xrgX9pEYW/IUul5CKm1P2XRkvBKXZFEJ3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793445; c=relaxed/simple;
	bh=1TgMXYh1y/0bZXCymyKuX8TLZ5bsahbaCCg43fYXWiY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tLH5yJsRNRjJIcvdLDe9EGbfnkbJ24dgt0KV42IszrQ6L3fuKuBQTUo+8r+pYV2TaiuCT6FxXLrZh3LentcQFeV/Mg5FoUQXFjPUdqijmzqLfNfzzXc13tJUjYiJRKLJx0U9vMNmK3+QgOlMB0rkRFfFjpPG8fNC7GHEcZ9jNvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HUFqA9MX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HUFqA9MX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CD521F000FF;
	Wed, 30 Sep 2026 18:37:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793443;
	bh=miMgj519Fq5cQFbA78l2NTY+yq6KIkqIZ0TJN0OdHso=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HUFqA9MXKdVvoa6QMeiNQiVL4iOfJszA7qsvAdQTs5Ss/iq0mmyUJdmYTwPH801dz
	 2GUvtB8ZIINGmKVN5K4InrMGfwd1xvtWUsUAlHQRTViasmj/U1S9wrg6I8YIDL7W4G
	 qQ1guIrjq1prFXhGmn9KFzrLH2V7IBQ3sIlmXXUs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Marek=20Marczykowski-G=C3=B3recki?= <marmarek@invisiblethingslab.com>,
	Christoph Hellwig <hch@lst.de>,
	Robert Beckett <bob.beckett@collabora.com>,
	=?UTF-8?q?Szymon=20Aceda=C5=84ski?= <accek@invisiblethingslab.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 6.18 256/395] drm/xe: Limit sg segment size to PAGE_SIZE on Xen PV
Date: Wed, 30 Sep 2026 17:28:38 +0200
Message-ID: <20260930152346.207244810@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Szymon Acedański <accek@invisiblethingslab.com>

commit 141008dec73521ccf64878517460cec8b3297251 upstream.

Fix display corruption on Xen PV dom0, where DMA buffers are not
guaranteed machine-contiguous, in which case bounce buffering kicks
in, breaking xe's memory coherency assumptions.

Apply the same workaround i915 carries in i915_sg_segment_size() since
commit 78a07fe777c4 ("drm/i915: stop abusing swiotlb_max_segment").

Fixes: dd08ebf6c352 ("drm/xe: Introduce a new DRM driver for Intel GPUs")
Reported-by: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
Closes: https://gitlab.freedesktop.org/drm/xe/kernel/-/work_items/8382
Link: https://lore.kernel.org/xen-devel/aYtznP_tT6xNPwf-@mail-itl/
Link: https://lore.kernel.org/all/20221020110308.1582518-1-hch@lst.de/ # i915 counterpart
Cc: Christoph Hellwig <hch@lst.de>
Cc: Robert Beckett <bob.beckett@collabora.com>
Cc: stable@vger.kernel.org # v6.8+
Signed-off-by: Szymon Acedański <accek@invisiblethingslab.com>
Reviewed-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Link: https://patch.msgid.link/20260916173030.3223833-1-accek@invisiblethingslab.com
(cherry picked from commit 77f704158f099b952681f207478a22d5b8218edb)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_bo.h |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

--- a/drivers/gpu/drm/xe/xe_bo.h
+++ b/drivers/gpu/drm/xe/xe_bo.h
@@ -9,6 +9,8 @@
 #include <drm/drm_prime.h>
 #include <drm/ttm/ttm_tt.h>
 
+#include <xen/xen.h>
+
 #include "xe_bo_types.h"
 #include "xe_macros.h"
 #include "xe_validation.h"
@@ -481,6 +483,23 @@ static inline unsigned int xe_sg_segment
 	struct scatterlist __maybe_unused sg;
 	size_t max = BIT_ULL(sizeof(sg.length) * 8) - 1;
 
+	/*
+	 * For Xen PV guests pages aren't contiguous in DMA (machine) address
+	 * space.  The DMA API takes care of that both in dma_alloc_* (by
+	 * calling into the hypervisor to make the pages contiguous) and in
+	 * dma_map_* (by bounce buffering).  But xe (like i915, see commit
+	 * 78a07fe777c4) ignores the coherency aspects of the DMA API and thus
+	 * can't cope with bounce buffering actually happening, so add a hack
+	 * here to force small allocations and mappings when running in PV
+	 * mode on Xen.
+	 *
+	 * Note this will still break if bounce buffering is required for other
+	 * reasons, like confidential computing hypervisors or PCIe root ports
+	 * with addressing limitations.
+	 */
+	if (xen_pv_domain())
+		return PAGE_SIZE;
+
 	max = min_t(size_t, max, dma_max_mapping_size(dev));
 
 	/*


