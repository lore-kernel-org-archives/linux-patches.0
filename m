Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47AA87B
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:00:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E6D1C433C1;
	Wed, 23 Nov 2022 09:00:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669194030;
	bh=9cJ+fxkL6zOlayxwoUVL+FNV/aissM9/bng/J+hQd6s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hsy3b30agxbGfa8LONXoiFLss8sNhcamT2SZXJjjwuFC5bkFlGp6+mtwe6t61TNEZ
	 i8GYWlP2F6rQYfU5N+RHEDuwOxkEuoWLkQyazOBCU0sY+eUgHD9x3ozNTECsTlJTAv
	 aQHtcJL209E/UyJ5cC7GraYteNXOnReXRBhC1HA0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Auld <matthew.auld@intel.com>,
	Lionel Landwerlin <lionel.g.landwerlin@intel.com>,
	Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	"Michael J. Ruhl" <michael.j.ruhl@intel.com>,
	Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Subject: [PATCH 4.14 21/88] drm/i915/dmabuf: fix sg_table handling in map_dma_buf
Date: Wed, 23 Nov 2022 09:50:18 +0100
Message-Id: <20221123084549.233824364@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084548.535439312@linuxfoundation.org>
References: <20221123084548.535439312@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Matthew Auld <matthew.auld@intel.com>

commit f90daa975911961b65070ec72bd7dd8d448f9ef7 upstream.

We need to iterate over the original entries here for the sg_table,
pulling out the struct page for each one, to be remapped. However
currently this incorrectly iterates over the final dma mapped entries,
which is likely just one gigantic sg entry if the iommu is enabled,
leading to us only mapping the first struct page (and any physically
contiguous pages following it), even if there is potentially lots more
data to follow.

Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/7306
Fixes: 1286ff739773 ("i915: add dmabuf/prime buffer sharing support.")
Signed-off-by: Matthew Auld <matthew.auld@intel.com>
Cc: Lionel Landwerlin <lionel.g.landwerlin@intel.com>
Cc: Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Cc: Michael J. Ruhl <michael.j.ruhl@intel.com>
Cc: <stable@vger.kernel.org> # v3.5+
Reviewed-by: Michael J. Ruhl <michael.j.ruhl@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20221028155029.494736-1-matthew.auld@intel.com
(cherry picked from commit 28d52f99bbca7227008cf580c9194c9b3516968e)
Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/i915_gem_dmabuf.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/i915/i915_gem_dmabuf.c
+++ b/drivers/gpu/drm/i915/i915_gem_dmabuf.c
@@ -55,13 +55,13 @@ static struct sg_table *i915_gem_map_dma
 		goto err_unpin_pages;
 	}
 
-	ret = sg_alloc_table(st, obj->mm.pages->nents, GFP_KERNEL);
+	ret = sg_alloc_table(st, obj->mm.pages->orig_nents, GFP_KERNEL);
 	if (ret)
 		goto err_free;
 
 	src = obj->mm.pages->sgl;
 	dst = st->sgl;
-	for (i = 0; i < obj->mm.pages->nents; i++) {
+	for (i = 0; i < obj->mm.pages->orig_nents; i++) {
 		sg_set_page(dst, sg_page(src), src->length, 0);
 		dst = sg_next(dst);
 		src = sg_next(src);


