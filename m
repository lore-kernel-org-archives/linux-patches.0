Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56760230BFC;
	Mon, 10 Mar 2025 17:24:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627495; cv=none; b=Zyc8jBN1asrRiNYmFWMVCGLms+thyHOWkQv3md/17IXNExNZFazEcj7a07cRVaIEE72vtrLpxA2y4YI2fqzouK1wPX+cQXyWxzaHlROsdmmyV7wpjU3nHEujUtHPww1f8+8HoTySxmHoIYlkXK4PL2RJp/aPTyrL3qGy8NLRFmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627495; c=relaxed/simple;
	bh=3GtKC88MkMEWg8JcFl8seEWIe670AcMck2S1M6e1duY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SI/s286ASXPB7TqObd+akxI/5Q2/v5qzckc3/sZvilcW41BVemIYJoTTcU8Zh1MhyBY2NBFULgLz5UNqoOpk2EiddX8N2+M+zQ+mWbje9jKiFwvLOpmbdDnjjzgyLqERUDTsby7POgMSdd/nwMcrAba4qhjnOmVkcYLAWGiHs1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yGOD9Aml; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yGOD9Aml"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2C62C4CEE5;
	Mon, 10 Mar 2025 17:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627495;
	bh=3GtKC88MkMEWg8JcFl8seEWIe670AcMck2S1M6e1duY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yGOD9AmlmSA9dfPFwHVW1QKGTGDCzErLX9VKdTppN1pmACfIXsydTMzuk1+e/drjj
	 TfVFVPTu0B1Bz4d5zTTvaCmLebiv4RtTc7gnAcignnC6RU/LTvri/DFjdNa7L0WUzd
	 X/7AQ8XOaSr6hEr6UTdChDjNVgU+26NadjbA3UG8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Auld <matthew.auld@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Tejas Upadhyay <tejas.upadhyay@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 6.12 117/269] drm/xe/userptr: properly setup pfn_flags_mask
Date: Mon, 10 Mar 2025 18:04:30 +0100
Message-ID: <20250310170502.384258816@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
References: <20250310170457.700086763@linuxfoundation.org>
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

From: Matthew Auld <matthew.auld@intel.com>

commit 475d06e00b7496c7915d87f7ae67af26738e4649 upstream.

Currently we just leave it uninitialised, which at first looks harmless,
however we also don't zero out the pfn array, and with pfn_flags_mask
the idea is to be able set individual flags for a given range of pfn or
completely ignore them, outside of default_flags. So here we end up with
pfn[i] & pfn_flags_mask, and if both are uninitialised we might get back
an unexpected flags value, like asking for read only with default_flags,
but getting back write on top, leading to potentially bogus behaviour.

To fix this ensure we zero the pfn_flags_mask, such that hmm only
considers the default_flags and not also the initial pfn[i] value.

v2 (Thomas):
 - Prefer proper initializer.

Fixes: 81e058a3e7fd ("drm/xe: Introduce helper to populate userptr")
Signed-off-by: Matthew Auld <matthew.auld@intel.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Thomas Hellström <thomas.hellstrom@intel.com>
Cc: <stable@vger.kernel.org> # v6.10+
Reviewed-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Reviewed-by: Tejas Upadhyay <tejas.upadhyay@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250226174748.294285-2-matthew.auld@intel.com
(cherry picked from commit dd8c01e42f4c5c1eaf02f003d7d588ba6706aa71)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_hmm.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

--- a/drivers/gpu/drm/xe/xe_hmm.c
+++ b/drivers/gpu/drm/xe/xe_hmm.c
@@ -203,13 +203,20 @@ int xe_hmm_userptr_populate_range(struct
 {
 	unsigned long timeout =
 		jiffies + msecs_to_jiffies(HMM_RANGE_DEFAULT_TIMEOUT);
-	unsigned long *pfns, flags = HMM_PFN_REQ_FAULT;
+	unsigned long *pfns;
 	struct xe_userptr *userptr;
 	struct xe_vma *vma = &uvma->vma;
 	u64 userptr_start = xe_vma_userptr(vma);
 	u64 userptr_end = userptr_start + xe_vma_size(vma);
 	struct xe_vm *vm = xe_vma_vm(vma);
-	struct hmm_range hmm_range;
+	struct hmm_range hmm_range = {
+		.pfn_flags_mask = 0, /* ignore pfns */
+		.default_flags = HMM_PFN_REQ_FAULT,
+		.start = userptr_start,
+		.end = userptr_end,
+		.notifier = &uvma->userptr.notifier,
+		.dev_private_owner = vm->xe,
+	};
 	bool write = !xe_vma_read_only(vma);
 	unsigned long notifier_seq;
 	u64 npages;
@@ -236,19 +243,14 @@ int xe_hmm_userptr_populate_range(struct
 		return -ENOMEM;
 
 	if (write)
-		flags |= HMM_PFN_REQ_WRITE;
+		hmm_range.default_flags |= HMM_PFN_REQ_WRITE;
 
 	if (!mmget_not_zero(userptr->notifier.mm)) {
 		ret = -EFAULT;
 		goto free_pfns;
 	}
 
-	hmm_range.default_flags = flags;
 	hmm_range.hmm_pfns = pfns;
-	hmm_range.notifier = &userptr->notifier;
-	hmm_range.start = userptr_start;
-	hmm_range.end = userptr_end;
-	hmm_range.dev_private_owner = vm->xe;
 
 	while (true) {
 		hmm_range.notifier_seq = mmu_interval_read_begin(&userptr->notifier);


