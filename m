Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC5F43D0907;
	Tue, 21 Jul 2026 17:39:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655582; cv=none; b=SkmYRN70yjdhkXWs3Nr2gD9Ql1pFycmw2AwujMJHKTrlbHYoXYIrmjMUvCefNH/f26tpBjl38UfKd2GxszZVWhbuLVo4J7TwFZuWd5R3Zvt5vt4SS/+pkKs7qFGZ1K79ppfWx9hh4OTp79DKZYD/OFXk0oE9AfVWeDsUW2YpJO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655582; c=relaxed/simple;
	bh=5o45y9xRA04evcRDFB7lq9JbMDcke8Wis0HGmfg8yQg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=F4yHvchaQ7syvgA3LYm60vpjpb1HuqMS3tB6o9tfvG4X6qOfyVIjcXsj7VrWOfxVsz8VOLFHPLXp+KDuhLa9xQ+cYP3D3TjDGnzmZz0wqOyr0KhBlVG1croKxppC+cywH14N92o/NKHOwYxV5Gieilyzpz9Y5QpR9ae1u54qcec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wLEY7S7u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wLEY7S7u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D0601F000E9;
	Tue, 21 Jul 2026 17:39:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655580;
	bh=NOK7ey5vXhbXzYFg03tPZtN1B0kCRpLoF2OGoEt1eyk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wLEY7S7ujpr73RWGbQEog9cfYUE3vuInjCtdpuVz1siRmRQBa9JLiQaXMIkUFmD+3
	 X/X3q898L+uCQE84tbfrjnj8TC0M8MW5Vt6GUlNvZ0FxMRi1r1RA9YBdp8VYepIf4A
	 TuoVeoEeVA/FmAK3BBTu4G715vH72wVL+e3qqueI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Brost <matthew.brost@intel.com>,
	Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0064/1611] drm/gpusvm: Reject VMAs with VM_IO or VM_PFNMAP when creating SVM ranges
Date: Tue, 21 Jul 2026 17:03:00 +0200
Message-ID: <20260721152516.270191512@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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
index 853ca57800d3ab..4cde5bf4aedd86 100644
--- a/drivers/gpu/drm/drm_gpusvm.c
+++ b/drivers/gpu/drm/drm_gpusvm.c
@@ -944,6 +944,11 @@ drm_gpusvm_range_find_or_insert(struct drm_gpusvm *gpusvm,
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



