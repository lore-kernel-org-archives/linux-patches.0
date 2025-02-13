Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F7BE13D8A4;
	Thu, 13 Feb 2025 14:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457724; cv=none; b=i1SoeQxBmOnDv1C8KgP2htoruisqNbbpM1NnrvQH/1zGoXZ3wKjzwZIqdXDvbLes6tYyWJ22Uw/dLNuBGjAFpR1VBWtTgAj0vp6BeeDCdl9Hof+FUF3y9jLb/qIzgCDhe4gFz6vZD0Hh0A2d0kXrzUgawCMqg9nTKtJz/jBlveU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457724; c=relaxed/simple;
	bh=Np7teSEyhjwSN9Im41U03ugF3EGycp0eoKggnHO/6vM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Vr8pi5XpmXYicxTU5g+m61U4UH7WA/QouB71Dp6UIBvxtDJyJtDePe2Exe1KdXsWVF9xIc2YoEZXmBtV1NEm16uHdGnuvcpH/fwdcFj/di2awzI7ao2ekL04CByVU2RDQ4DyDaz/7AnCM4sDo88Q7ZJY1bep9TT38Llh8kW5XgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XvhV2Lkp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XvhV2Lkp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08B88C4CED1;
	Thu, 13 Feb 2025 14:42:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739457724;
	bh=Np7teSEyhjwSN9Im41U03ugF3EGycp0eoKggnHO/6vM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XvhV2Lkp7irObCWHYuvpIU7+8rLsDarivPkkIbpvU0I42VkTo/ObPxX2g8wgmEHFD
	 6EwCbcRt8mOf8c4aPfFpIqGpyYwck2jsLAJg4JqKRhFAp5y8yTr/8Pnpco47HSGmOZ
	 HT3jrMH9yczXhIRgH0N/UsxcKaharAKbX4BMOMCY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ville Syrjala <ville.syrjala@linux.intel.com>,
	Vidya Srinivas <vidya.srinivas@intel.com>,
	Brian Geffon <bgeffon@google.com>,
	Tomasz Figa <tfiga@google.com>,
	Jonathan Cavitt <jonathan.cavitt@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 6.12 163/422] drm/i915: Fix page cleanup on DMA remap failure
Date: Thu, 13 Feb 2025 15:25:12 +0100
Message-ID: <20250213142442.836126299@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brian Geffon <bgeffon@google.com>

commit fa6182c8b13ebfdc70ebdc09161a70dd8131f3b1 upstream.

When converting to folios the cleanup path of shmem_get_pages() was
missed. When a DMA remap fails and the max segment size is greater than
PAGE_SIZE it will attempt to retry the remap with a PAGE_SIZEd segment
size. The cleanup code isn't properly using the folio apis and as a
result isn't handling compound pages correctly.

v2 -> v3:
(Ville) Just use shmem_sg_free_table() as-is in the failure path of
shmem_get_pages(). shmem_sg_free_table() will clear mapping unevictable
but it will be reset when it retries in shmem_sg_alloc_table().

v1 -> v2:
(Ville) Fixed locations where we were not clearing mapping unevictable.

Cc: stable@vger.kernel.org
Cc: Ville Syrjala <ville.syrjala@linux.intel.com>
Cc: Vidya Srinivas <vidya.srinivas@intel.com>
Link: https://gitlab.freedesktop.org/drm/i915/kernel/-/issues/13487
Link: https://lore.kernel.org/lkml/20250116135636.410164-1-bgeffon@google.com/
Fixes: 0b62af28f249 ("i915: convert shmem_sg_free_table() to use a folio_batch")
Signed-off-by: Brian Geffon <bgeffon@google.com>
Suggested-by: Tomasz Figa <tfiga@google.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250127204332.336665-1-bgeffon@google.com
Reviewed-by: Jonathan Cavitt <jonathan.cavitt@intel.com>
Tested-by: Vidya Srinivas <vidya.srinivas@intel.com>
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
(cherry picked from commit 9e304a18630875352636ad52a3d2af47c3bde824)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/gem/i915_gem_shmem.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/drivers/gpu/drm/i915/gem/i915_gem_shmem.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_shmem.c
@@ -209,8 +209,6 @@ static int shmem_get_pages(struct drm_i9
 	struct address_space *mapping = obj->base.filp->f_mapping;
 	unsigned int max_segment = i915_sg_segment_size(i915->drm.dev);
 	struct sg_table *st;
-	struct sgt_iter sgt_iter;
-	struct page *page;
 	int ret;
 
 	/*
@@ -239,9 +237,7 @@ rebuild_st:
 		 * for PAGE_SIZE chunks instead may be helpful.
 		 */
 		if (max_segment > PAGE_SIZE) {
-			for_each_sgt_page(page, sgt_iter, st)
-				put_page(page);
-			sg_free_table(st);
+			shmem_sg_free_table(st, mapping, false, false);
 			kfree(st);
 
 			max_segment = PAGE_SIZE;


