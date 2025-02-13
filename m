Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DEDD1C5F37;
	Thu, 13 Feb 2025 15:05:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459139; cv=none; b=n7iUzna0LTLlNabW6ieop0H5XxzfpxOqeNeeG9Dd5LjCT28Q8Yh06bbB1VgIzZWH/iwj+sn7Yy/rhK97B0ZxPX/edLypNWQVg/n3+ni4P/339+DNxP55S5tEePQagr2rCsxUMcW5x98AxMJKjbdYMCP9SLfzy+CmKJqRJwhDAqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459139; c=relaxed/simple;
	bh=avgi+V/Eo9Tsw53Y3edqflW4gFzi/J117O1TjJXxv7k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rmNNjq4QIkOjxrrNhdXXhIRlALv8aRmttSLE95kkHqCoRNSQr8r67x91Xr/wxqPnvR1jDAkfO29wNk3SRG8W+doTu530bMuBs7IPMdR9ipDYtGkNjo2WNLJL37LwRM8vNSdT1oVmiFa6CGYXuSaZkhp70Ccjhz3Kget9QPAHz1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HJarRYgC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HJarRYgC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF5EDC4CED1;
	Thu, 13 Feb 2025 15:05:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459139;
	bh=avgi+V/Eo9Tsw53Y3edqflW4gFzi/J117O1TjJXxv7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HJarRYgCTatxWuXgxAZfptggmhPCh4/qYtGa5RN8Wn7ZLtZW2pu8OW8tSANqGyL7+
	 KJBH3E5cp7W4M3Lyl//pYKndm7jPPiMy+RIYThSKaj3FquUThk/gUoX1WhTi0/Zprk
	 d7hMOf/LTUJQ71c4YvV652jFNYMFGoogT5BE6nDw=
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
Subject: [PATCH 6.13 180/443] drm/i915: Fix page cleanup on DMA remap failure
Date: Thu, 13 Feb 2025 15:25:45 +0100
Message-ID: <20250213142447.558696533@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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


