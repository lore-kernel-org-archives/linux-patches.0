Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 674034F7CD8;
	Tue, 13 Oct 2026 12:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893116; cv=none; b=dFzkaI7MTNR6SllOluUMmgGzpgDJPzI7FagbEaV0yRusYn/E7D479cdsfTX25LJSyrlfyx3IHRTPD7U/voUMYsoakLZnva+VcZ44TBGsm+kyKTDrG7CbFMb/Bj9s8oZLqA8AoM5tyTTZFc2w8ywJXc0Qz8/Fuh84C8xGXrOYB8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893116; c=relaxed/simple;
	bh=DCD4oqRZCkg9bpesUrkScU0qKSiXi7LssN2BMUSe3Mk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=It1zJYONQC8vPwXyCbQ9zmH1tXUo1L12VDFokWyWHyz7+knd1zzLDkSIepLu/pWHoRP+sGh8CXefpZeKc4Kxr9tbHrLafHqs4n3ri0gEMS/GkNVYSM/I0fbbhzyCPYyCiFqcx02UFeQloqg6dkwnSlIwjMmQWvrnsOl9vxvLZ0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zrvRvYBK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zrvRvYBK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE94E1F000FF;
	Tue, 13 Oct 2026 12:05:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893115;
	bh=irjDjW0J7cAcuWJLcOabD6ug5oidvFR9OdALDajTnSk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zrvRvYBKwjGDTh5oXLfSDpfLXxep0745v3kUIxUVBdfHxLFRPnNqr/FXqheVJ6MKi
	 YMfSDH0qJmrG/mlkyT8gX97iq/e+Jn9ondkCQgzf9exP3h90RSSnLPVeL8I8zMv1RF
	 KVrPgtJuvnmpMyC5Wj9rAC88AQgpgURZmL8r32nk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	intel-xe@lists.freedesktop.org,
	Matthew Auld <matthew.auld@intel.com>,
	Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>
Subject: [PATCH 6.18 119/621] drm/xe: Fix stale pinned_link entry when fb-pin performs the final unpin
Date: Tue, 13 Oct 2026 13:31:54 +0200
Message-ID: <20261013112923.683767048@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

From: Thomas Hellström <thomas.hellstrom@linux.intel.com>

commit cf238c067eaae1cbfb00738e29219b9568d2313e upstream.

xe_bo_pin_external() and xe_bo_unpin_external() maintain the bo's
pinned_link list membership in xe->pinned.late.external, based on
whether the current call is the outermost pin or the final unpin.
However, the same external bo's pin_count can also be raised and
lowered directly by __xe_pin_fb_vma()/__xe_unpin_fb_vma(), which pin
the bo as a display scanout buffer without going through
xe_bo_pin_external()/xe_bo_unpin_external() at all, and have no
notion of, or ownership over, pinned_link.

If a bo is pinned both externally (e.g. dma-buf export) and as an fb,
and the external unpin happens first, xe_bo_unpin_external() correctly
observes pin_count > 1 and leaves the bo on pinned_link. When the fb
unpin later performs the true last unpin (pin_count 1 -> 0), it never
touches pinned_link, leaving the bo linked on xe->pinned.late.external
indefinitely. Once the bo is subsequently freed, this stale list entry
points into freed memory, corrupting the list and risking a
use-after-free the next time the list is walked or spliced.

The backup object pin/unpin sites in xe_bo_notifier_prepare_pinned()/
xe_bo_notifier_unprepare_pinned() have the same bypass characteristic,
though they never add their bo to a pinned list, so are not affected
by this particular list-corruption issue.

Move the pinned_link removal into xe_bo_account_unpin(), which already
runs on every unpin path (kernel, external, framebuffer, backup
object) right before the true 1 -> 0 pin_count transition. Since
list_del_init() only operates on the node itself, this removal is
list-agnostic and safe to perform regardless of which list (external
or kernel_bo_present) the bo happens to be linked on, or which code
path is performing the final unpin. Drop the now-redundant explicit
list_del_init() calls in xe_bo_unpin_external() and xe_bo_unpin().

v2:
- New patch

v3:
- Rebased on changes to previous patch.

Fixes: 44e694958b95 ("drm/xe/display: Implement display support")
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: intel-xe@lists.freedesktop.org
Cc: <stable@vger.kernel.org> # v6.8+
Reviewed-by: Matthew Auld <matthew.auld@intel.com>
Reviewed-by: Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>
Assisted-by: LLM
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Link: https://patch.msgid.link/20261002100830.12297-3-thomas.hellstrom@linux.intel.com
(cherry picked from commit ca58d36a1f93af586ee93b340c9f9fd81312cc01)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_bo.c |   25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

--- a/drivers/gpu/drm/xe/xe_bo.c
+++ b/drivers/gpu/drm/xe/xe_bo.c
@@ -466,12 +466,27 @@ static void xe_bo_account_pin(struct xe_
  * ttm_bo_unpin(), so that the check against the true 1->0 transition sees
  * the pin count that is about to be released. See xe_bo_account_pin() for
  * why imported bos are excluded.
+ *
+ * On the true last unpin, also removes @bo from whichever pinned-bo list
+ * (external or kernel_bo_present) it may currently be linked on, since a
+ * bo's final unpin can happen through a pin path (e.g. framebuffer,
+ * backup object) that has no notion of, or ownership over, that list.
+ * This is safe and list-agnostic: list_del_init() only needs the node
+ * itself, not knowledge of which list it is threaded through, and is a
+ * no-op if @bo is not linked.
  */
 static void xe_bo_account_unpin(struct xe_bo *bo)
 {
 	struct xe_device *xe = xe_bo_device(bo);
+	bool last_unpin = bo->ttm.pin_count == 1;
+
+	if (last_unpin && !list_empty(&bo->pinned_link)) {
+		spin_lock(&xe->pinned.lock);
+		list_del_init(&bo->pinned_link);
+		spin_unlock(&xe->pinned.lock);
+	}
 
-	if (bo->ttm.pin_count == 1 && bo->ttm.ttm && ttm_tt_is_populated(bo->ttm.ttm) &&
+	if (last_unpin && bo->ttm.ttm && ttm_tt_is_populated(bo->ttm.ttm) &&
 	    !xe_ttm_bo_is_imported(&bo->ttm))
 		xe_ttm_tt_account_add(xe, bo->ttm.ttm);
 }
@@ -2940,11 +2955,6 @@ void xe_bo_unpin_external(struct xe_bo *
 	xe_assert(xe, xe_bo_is_pinned(bo));
 	xe_assert(xe, xe_bo_is_user(bo));
 
-	spin_lock(&xe->pinned.lock);
-	if (bo->ttm.pin_count == 1 && !list_empty(&bo->pinned_link))
-		list_del_init(&bo->pinned_link);
-	spin_unlock(&xe->pinned.lock);
-
 	xe_bo_unpin_account(bo);
 
 	/*
@@ -2963,10 +2973,7 @@ void xe_bo_unpin(struct xe_bo *bo)
 	xe_assert(xe, xe_bo_is_pinned(bo));
 
 	if (mem_type_is_vram(place->mem_type) || bo->flags & XE_BO_FLAG_GGTT) {
-		spin_lock(&xe->pinned.lock);
 		xe_assert(xe, !list_empty(&bo->pinned_link));
-		list_del_init(&bo->pinned_link);
-		spin_unlock(&xe->pinned.lock);
 
 		if (bo->backup_obj) {
 			if (xe_bo_is_pinned(bo->backup_obj))


