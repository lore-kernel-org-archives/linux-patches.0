Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B921352019;
	Thu, 20 Aug 2026 15:01:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238075; cv=none; b=Qf5yTDWW0+wzQCAdA85Q6pHf6cYaP9Fu8pPjeFMD8huqeEu5yghCsGM0/Udxe3fTRdZ37m5tUsjskrTJaB60z0YstVs7Bz+wVIhMbm/Vv1t7JAi3yJgpLi3x4YhBbaxXDlM8IOzczigcnWnxQQeUKg4ABQLmevhWwimK3mcFqgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238075; c=relaxed/simple;
	bh=3kW0zmVYNzEWnpML2n90D49ICSHpce3OuQJBGaWbIHw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lHgtAlprAPSkTRqVEZkFI/ZbkSmp+bJdhHXkQzqf3e5Maje2KGkSGYaPDCI91bPuN5Km0gRDJd0a1kwwV9cAnb8AxZxmFlZtsl/OJexXfI82fS9zN4C87sNxAQ4hZjcaffuU639rAcs8QsJuNk0griRpyTGjHHKjMSwWvq8G4wA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u6GyuTmv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u6GyuTmv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7732E1F00A3A;
	Thu, 20 Aug 2026 15:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238074;
	bh=+LIvKzCB73GcB3lcuY8+4G+YWV+MXarWe6mCsx65frc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u6GyuTmvOYKKNdLlxYN4LPYIfapItDmZp0anzhEPkiqzBjDC6hRLy5wMSpVIwCx9g
	 +whLc/kuC6NQAUPhTB+nKqBuWPN6drFDdX8/ZNOIgGO6VhMtf+exFZPY2eiELfNwZ8
	 iviIaJspTz6dU6pMYIPgeAlipZVHNNf5g/q6iICk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pedro Demarchi Gomes <pedrodemargomes@gmail.com>,
	Boris Brezillon <boris.brezillon@collabora.com>,
	"Christian A. Ehrhardt" <lk@c--e.de>
Subject: [PATCH 7.1 016/228] drm/shmem_helper: Check VMA boundaries for PMD mappings
Date: Thu, 20 Aug 2026 16:52:38 +0200
Message-ID: <20260820145244.959673500@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian A. Ehrhardt <lk@c--e.de>

commit 617bbd08714857c1613d7c550d43a9092ec0fb97 upstream.

In the ->huge_fault handler do not install a PMD huge page
mapping if the huge page exceeds the boundaries of the VMA.

All other ->huge_fault handlers have similar checks and the
resulting mapping will trigger a VM_BUG_ON_VMA() if it ever
reaches copy_pmd_range().

Cc: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
Cc: Boris Brezillon <boris.brezillon@collabora.com>
Cc: stable@vger.kernel.org
Fixes: fc3bbf34e643 ("drm/shmem-helper: Fix huge page mapping in fault handler")
Signed-off-by: Christian A. Ehrhardt <lk@c--e.de>
Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
Link: https://patch.msgid.link/20260622215718.1532689-1-lk@c--e.de
Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_gem_shmem_helper.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/drm_gem_shmem_helper.c
+++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
@@ -577,9 +577,13 @@ static vm_fault_t try_insert_pfn(struct
 #ifdef CONFIG_ARCH_SUPPORTS_PMD_PFNMAP
 	} else if (order == PMD_ORDER) {
 		unsigned long paddr = pfn << PAGE_SHIFT;
+		struct vm_area_struct *vma = vmf->vma;
+		unsigned long start = ALIGN_DOWN(vmf->address, PMD_SIZE);
+		unsigned long end = start + PMD_SIZE;
+		bool in_range = vma->vm_start <= start && end <= vma->vm_end;
 		bool aligned = (vmf->address & ~PMD_MASK) == (paddr & ~PMD_MASK);
 
-		if (aligned &&
+		if (aligned && in_range &&
 		    folio_test_pmd_mappable(page_folio(pfn_to_page(pfn)))) {
 			vm_fault_t ret;
 


