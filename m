Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B33C3439343;
	Thu, 30 Jul 2026 14:39:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422352; cv=none; b=U6HayKm+nzK6WG/zEJmMDiSsZlxtRItiusneD26A1fcuyjVd9wXT38DU2pjYHRGN1U+JLHVeEBcmBLzHqxR2oPF0lI5RxN3ikiNzjVRtN363wGe3juGSNv/M5vjMj/cfpRZyBzLUoyAuOIkJvYSed1wpQBcnnfvHluZePWKQASg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422352; c=relaxed/simple;
	bh=N7F8wol/DLDO+w/5mpO+9PDS1PTEJUlsCD02znO/Rhk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=M0otzTV1q7XVF/E7YtbFCDVkGfmCqIHgmnhOsdOkSLJUAJuljjeIN7wuv1AkPQwrFPootuYajUjJSJK7oc71ODqm99kTgHmxscozaT5caDDPw1iipqWpViJ7o6guu3WW5U0iOj+4+mrFOHl3sypMbeFaRmQ/kzSTYqsOKpOZzyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M2M/8uxi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M2M/8uxi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 012E51F000E9;
	Thu, 30 Jul 2026 14:39:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422351;
	bh=674XPwHvl4dQ77HC6xilNfILMe9YNkxoQu35Av7rHp0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M2M/8uxiqFi3HmkmCAdGvFwZv1ftEFJmpraIcOJFRagmIYrv2mbtJNiIQqQyzJaGy
	 yU12o7+jQWRExkpYXTPkn9U62iSs9bE/iIUivN940qF6RkiB/BLKzNs46IwV93OYnv
	 RppLAATrwVnMSzUoNiOL/v2aE8DAv8jydZfZqzp8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Brost <matthew.brost@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>,
	Arvind Yadav <arvind.yadav@intel.com>,
	Tejas Upadhyay <tejas.upadhyay@intel.com>
Subject: [PATCH 7.1 406/744] drm/xe/madvise: Skip invalidation for purgeable state updates
Date: Thu, 30 Jul 2026 16:11:19 +0200
Message-ID: <20260730141452.920989022@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arvind Yadav <arvind.yadav@intel.com>

commit 57441577bac3637473da2c9644336eaa0ac5732f upstream.

Purgeable state updates only change VMA/BO metadata. They do not zap
PTEs when switching between DONTNEED and WILLNEED. PTEs are zapped
later if the BO is actually purged.

xe_vm_invalidate_madvise_range() waits on the VM dma-resv before checking
vma->skip_invalidation. Since purgeable madvise marks all affected VMAs to
skip invalidation, this wait is unnecessary and can stall on unrelated
in-flight work.

Skip the invalidate path entirely for purgeable state updates.

v2:
  - Replace inline 'args->type != DRM_XE_VMA_ATTR_PURGEABLE_STATE'
    check with a small helper madvise_range_needs_invalidation().
    (Himal)

Suggested-by: Matthew Brost <matthew.brost@intel.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Cc: Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>
Signed-off-by: Arvind Yadav <arvind.yadav@intel.com>
Reviewed-by: Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>
Link: https://patch.msgid.link/20260526135447.2973029-1-arvind.yadav@intel.com
Signed-off-by: Tejas Upadhyay <tejas.upadhyay@intel.com>
Fixes: ada7486c5668 ("drm/xe: Implement madvise ioctl for xe")
Cc: <stable@vger.kernel.org> # v6.18+
(cherry picked from commit 134377098b9c14abd31c3bcac00c9653f0f0c4c3)
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_vm_madvise.c |   19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/xe/xe_vm_madvise.c
+++ b/drivers/gpu/drm/xe/xe_vm_madvise.c
@@ -332,6 +332,20 @@ static int xe_vm_invalidate_madvise_rang
 	return err;
 }
 
+/**
+ * madvise_range_needs_invalidation() - Check whether madvise needs invalidation
+ * @args: madvise ioctl arguments
+ *
+ * Purgeable state updates only touch VMA/BO metadata. PTEs stay valid and are
+ * zapped only if the BO is later purged.
+ *
+ * Return: true when the update needs PTE invalidation.
+ */
+static bool madvise_range_needs_invalidation(const struct drm_xe_madvise *args)
+{
+	return args->type != DRM_XE_VMA_ATTR_PURGEABLE_STATE;
+}
+
 static bool madvise_args_are_sane(struct xe_device *xe, const struct drm_xe_madvise *args)
 {
 	if (XE_IOCTL_DBG(xe, !args))
@@ -708,8 +722,9 @@ int xe_vm_madvise_ioctl(struct drm_devic
 	madvise_funcs[attr_type](xe, vm, madvise_range.vmas, madvise_range.num_vmas, args,
 				 &details);
 
-	err = xe_vm_invalidate_madvise_range(vm, madvise_range.addr,
-					     madvise_range.addr + args->range);
+	if (madvise_range_needs_invalidation(args))
+		err = xe_vm_invalidate_madvise_range(vm, madvise_range.addr,
+						     madvise_range.addr + args->range);
 
 	if (madvise_range.has_svm_userptr_vmas)
 		xe_svm_notifier_unlock(vm);


