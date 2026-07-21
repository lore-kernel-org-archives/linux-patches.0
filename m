Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E51B46AA70;
	Tue, 21 Jul 2026 15:33:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648040; cv=none; b=WN/mYD00g6eqR3NPUmYjl4XoFg5ZcTTnGx+e7Rib60j8yZNmtQLCMcwdTqWsVEUJDF9l0KJLopjL1ryxlwQJ1MULwTyi8UtfOKpHgZSK9RzWHix+Cb2RoIdL8NZYMtZDZvvTxQmTWd0MomXlbG+O+NifJbb+V+oy6any1i3iFkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648040; c=relaxed/simple;
	bh=Zb/dz9pkQvJJPAknxAMpqctXOh1KkVP+I/0kIaAoyrw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KwYtg7SkusmXeSFyF1zgkvGtuU1HKjmmqPiw1aeW7zWmPon3wu3Kws5xgNFBk986xV1duC+2MKG7Z9PXR1k1u5KSc+VTorACCHRvTinf94ns5bxUv7C/JOnWzXZ9wm331onOE9KowShM8ZZThDpFeu25frPVbhS3wzkDNu6PruI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eFcmCAlJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eFcmCAlJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A53841F000E9;
	Tue, 21 Jul 2026 15:33:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648039;
	bh=ck79/kJb+VMm7RIZ2j7cqqNrp3WtjUUo22jfPxrTKv4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eFcmCAlJJJMAl+DGRgvDCTKJw/KMTnRT15TgMrPIVh/WfREQHwHSREmVglhpkWo8m
	 GtI+Ra/FvMXJwZc/DhI1pLpQ6p9AlZnZaAF9EeoG1aGH+UnO91HW6wVStnSeqyxobz
	 LjUPVwQQMvlGC74+HPx8vmJZbvORyT518eW/YLKY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Brost <matthew.brost@intel.com>,
	Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0050/2077] drm/gpusvm: Reject VMAs with VM_IO or VM_PFNMAP when creating SVM ranges
Date: Tue, 21 Jul 2026 16:55:23 +0200
Message-ID: <20260721152553.870814106@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

From: Matthew Brost <matthew.brost@intel.com>

[ Upstream commit b82a225e57a334335a21462b75ee2223bc6efe6d ]

VMAs marked with VM_IO or VM_PFNMAP are not backed by struct page
objects, which GPUSVM requires in order to operate correctly. In
particular, get_pages() relies on hmm_range_fault() to resolve struct
pages for the target range.

Attempting to create an SVM range on such VMAs results in repeated
get_pages() failures and can lead to an infinite loop inside a driver’s
page‑fault handler. Prevent this by rejecting ranges on VM_IO or
VM_PFNMAP VMAs and returning -EIO.

Fixes: 99624bdff867 ("drm/gpusvm: Add support for GPU Shared Virtual Memory")
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Reviewed-by: Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>
Link: https://patch.msgid.link/20260325231608.25581-1-matthew.brost@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_gpusvm.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/gpu/drm/drm_gpusvm.c b/drivers/gpu/drm/drm_gpusvm.c
index 4b928fda5b127f..7993e85c05661f 100644
--- a/drivers/gpu/drm/drm_gpusvm.c
+++ b/drivers/gpu/drm/drm_gpusvm.c
@@ -1065,6 +1065,11 @@ drm_gpusvm_range_find_or_insert(struct drm_gpusvm *gpusvm,
 		goto err_notifier_remove;
 	}
 
+	if (vas->vm_flags & (VM_IO | VM_PFNMAP)) {
+		err = -EIO;
+		goto err_notifier_remove;
+	}
+
 	range = drm_gpusvm_range_find(notifier, fault_addr, fault_addr + 1);
 	if (range)
 		goto out_mmunlock;
-- 
2.53.0



