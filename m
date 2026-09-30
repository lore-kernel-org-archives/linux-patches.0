Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA0173624BF;
	Wed, 30 Sep 2026 17:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787776; cv=none; b=h8o9zrSBdd9kHf/lae3/EmLIdRzPCkEo5upuHcNM6yvH2v8QW3J5lJke+IPaEbO0/gPfl6zVcopah8tZPl+VX31EnN8mY+s7oTV4U4giPw1oNwj85l6kDTgHqrAh7UtrmQc32BfNMl4mn7QRUmQUJ57//EYHxH18ONtAZv4ybvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787776; c=relaxed/simple;
	bh=D08bNgiEV/iulRHBzIZLKghocECLp8dMwhN0VsIaX7c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nitEUwwyvDcfXrQjXhPNUCDIHu2yYaT6ChpHqsdTJlBc6ABqJ35ri52I+f40Hoq0V1CfgO91s69fT2VkzlILou98xj1u80u38t5hnv9RCVCP1FTddG2j95fLZdVrqx4MSvAcmQWr6vIg9j53tGm5r3K2S7IGPnZX3wK9tqMjWm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g4LKkfPd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g4LKkfPd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3F511F0089B;
	Wed, 30 Sep 2026 17:02:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787774;
	bh=A6FhqbnWYpzpHHeJuqkNYon7BYgp76NfBGmmW6TynaE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g4LKkfPdcgqZ1JKiokIDMJUVI/HwhBPox6gc/xo2vk2S1bbbsYvqU8CLsBbXGlhh6
	 EatsYZ0MZvjFZwcMun0eVMhHrife6wqkPEKdZBNLqCjAXzJCe6ob3vdxT2oDdx2kQx
	 m9+htrLjadffV1a6d8nch5ackkTVjQKujPB7LoaI=
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
Subject: [PATCH 7.2 304/457] drm/xe: Limit sg segment size to PAGE_SIZE on Xen PV
Date: Wed, 30 Sep 2026 17:26:49 +0200
Message-ID: <20260930152352.591133973@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
 #include "xe_ggtt.h"
 #include "xe_macros.h"
@@ -574,6 +576,23 @@ static inline unsigned int xe_sg_segment
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


