Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AA971A4F1F;
	Thu, 15 Aug 2024 14:28:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732088; cv=none; b=Pa7fJBdYzhIUTCBX0f4aGxkaEVrpQLj04R67bibU9wIEtq/vbXFxGEv0YE+PReEAylCsXljNUusCK00QhQ9M9xrJkJkMV5hjmeX7M6FKM/1o0yqiVFWo/GYk/ohZEb/08wwF9cgFEZmm0DPlfEUXJeINdex3ZVpAzkk1bWeKyYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732088; c=relaxed/simple;
	bh=8JgdGXLYrH5Nfijaae7egC34tctCmaftybd8EKFhDDo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RPDQFpgbAmdfhNY8W3pp0tkzAMHL+aJc6GXXZT5O7ho9ZOa8K8Y8d5LH9+r+WosCjvEh+Nn3+BpPk4reCpssynROIjr903MDCqHIkVWL7vIBpSETNPiU6p3X8b91PWwZR6I1Jtk20j1kVQpz9/+2sy82ivMerXiiKSYIxQHCkXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mRQxCWBK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mRQxCWBK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 557EFC4AF0D;
	Thu, 15 Aug 2024 14:28:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732087;
	bh=8JgdGXLYrH5Nfijaae7egC34tctCmaftybd8EKFhDDo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mRQxCWBK/18Tj8M0Snqc2I1tHUh9NEfsi1tIlbbGVKKFe967h1g/pvUItI0ZBUFtj
	 Lr4AZOImrzEOVl6SzUWzvwhlK8lmWJH8njFbn0J8HU2R0akwwpuoCOO2tBd00lDfW8
	 vKhG0jxyPf6zeyzrWvXPPOApIBc8CnavsWTnuVG8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Christian Borntraeger <borntraeger@de.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 070/352] KVM: s390: pv: avoid stalls when making pages secure
Date: Thu, 15 Aug 2024 15:22:16 +0200
Message-ID: <20240815131921.948731199@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Claudio Imbrenda <imbrenda@linux.ibm.com>

[ Upstream commit f0a1a0615a6ff6d38af2c65a522698fb4bb85df6 ]

Improve make_secure_pte to avoid stalls when the system is heavily
overcommitted. This was especially problematic in kvm_s390_pv_unpack,
because of the loop over all pages that needed unpacking.

Due to the locks being held, it was not possible to simply replace
uv_call with uv_call_sched. A more complex approach was
needed, in which uv_call is replaced with __uv_call, which does not
loop. When the UVC needs to be executed again, -EAGAIN is returned, and
the caller (or its caller) will try again.

When -EAGAIN is returned, the path is the same as when the page is in
writeback (and the writeback check is also performed, which is
harmless).

Fixes: 214d9bbcd3a672 ("s390/mm: provide memory management functions for protected KVM guests")
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
Link: https://lore.kernel.org/r/20210920132502.36111-5-imbrenda@linux.ibm.com
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Stable-dep-of: 3f29f6537f54 ("s390/uv: Don't call folio_wait_writeback() without a folio reference")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/uv.c     | 29 +++++++++++++++++++++++------
 arch/s390/kvm/intercept.c |  5 +++++
 2 files changed, 28 insertions(+), 6 deletions(-)

diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
index c811b2313100b..422765c81dd69 100644
--- a/arch/s390/kernel/uv.c
+++ b/arch/s390/kernel/uv.c
@@ -186,7 +186,7 @@ static int make_secure_pte(pte_t *ptep, unsigned long addr,
 {
 	pte_t entry = READ_ONCE(*ptep);
 	struct page *page;
-	int expected, rc = 0;
+	int expected, cc = 0;
 
 	if (!pte_present(entry))
 		return -ENXIO;
@@ -202,12 +202,25 @@ static int make_secure_pte(pte_t *ptep, unsigned long addr,
 	if (!page_ref_freeze(page, expected))
 		return -EBUSY;
 	set_bit(PG_arch_1, &page->flags);
-	rc = uv_call(0, (u64)uvcb);
+	/*
+	 * If the UVC does not succeed or fail immediately, we don't want to
+	 * loop for long, or we might get stall notifications.
+	 * On the other hand, this is a complex scenario and we are holding a lot of
+	 * locks, so we can't easily sleep and reschedule. We try only once,
+	 * and if the UVC returned busy or partial completion, we return
+	 * -EAGAIN and we let the callers deal with it.
+	 */
+	cc = __uv_call(0, (u64)uvcb);
 	page_ref_unfreeze(page, expected);
-	/* Return -ENXIO if the page was not mapped, -EINVAL otherwise */
-	if (rc)
-		rc = uvcb->rc == 0x10a ? -ENXIO : -EINVAL;
-	return rc;
+	/*
+	 * Return -ENXIO if the page was not mapped, -EINVAL for other errors.
+	 * If busy or partially completed, return -EAGAIN.
+	 */
+	if (cc == UVC_CC_OK)
+		return 0;
+	else if (cc == UVC_CC_BUSY || cc == UVC_CC_PARTIAL)
+		return -EAGAIN;
+	return uvcb->rc == 0x10a ? -ENXIO : -EINVAL;
 }
 
 /*
@@ -260,6 +273,10 @@ int gmap_make_secure(struct gmap *gmap, unsigned long gaddr, void *uvcb)
 	mmap_read_unlock(gmap->mm);
 
 	if (rc == -EAGAIN) {
+		/*
+		 * If we are here because the UVC returned busy or partial
+		 * completion, this is just a useless check, but it is safe.
+		 */
 		wait_on_page_writeback(page);
 	} else if (rc == -EBUSY) {
 		/*
diff --git a/arch/s390/kvm/intercept.c b/arch/s390/kvm/intercept.c
index 8bf72a323e4fa..8f13943c9160d 100644
--- a/arch/s390/kvm/intercept.c
+++ b/arch/s390/kvm/intercept.c
@@ -535,6 +535,11 @@ static int handle_pv_uvc(struct kvm_vcpu *vcpu)
 	 */
 	if (rc == -EINVAL)
 		return 0;
+	/*
+	 * If we got -EAGAIN here, we simply return it. It will eventually
+	 * get propagated all the way to userspace, which should then try
+	 * again.
+	 */
 	return rc;
 }
 
-- 
2.43.0



