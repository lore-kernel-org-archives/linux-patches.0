Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AA5E19FA90;
	Thu, 15 Aug 2024 13:43:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729409; cv=none; b=dvBl1wZiUS0azBJysEchGOJtdv8i8bxKPtiuNMo8Tf74ESVPItRGEsG8ZHcygsaQv0RdoDZA3pkJ2l1WvVPfF9Us633V1J31ucngC6x9uouJs+a48aAOOjFwKYF6SfU2N++GY5KzyIOdu9tlRmDN3JhH7vN/rLlN44JzHN4q33o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729409; c=relaxed/simple;
	bh=cfbQIZCsBgouHfMgHRm4rPP1JUKC8pVCpcyNBsGK0Cg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Eq9oqqC4TP0/yS473weJKc6Fptf33DYfNl0kjmWNX7pAxeaqtQTKvg6X7iHNiw0J19gwNPuFIaDwyp1QLDHiALmgEPZR/p4OFra5x+NdvCcsF0BNfiG8IGXoWF4XVzA3+lqMvpTfFPXwn9FR7KaywibBj5+ypkBnqPBu6bFhcH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NBQpcwHo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NBQpcwHo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD961C32786;
	Thu, 15 Aug 2024 13:43:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729409;
	bh=cfbQIZCsBgouHfMgHRm4rPP1JUKC8pVCpcyNBsGK0Cg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NBQpcwHoEtxkZhjbebxdUkZ2rfZ4nvgzK3rTxRfIt37JUySTm/FjnH6vOz4wAjNIw
	 IlVlc1x5/HhowKtdSYOXbrQAx8LfmBPufLK611SncfUbnSNX0fvwe2fIfw3hgcWmup
	 poEEYflAehzVyJ2yzpMmAUeOttC4lpFhxBVVYrCE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Christian Borntraeger <borntraeger@de.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 088/484] KVM: s390: pv: avoid stalls when making pages secure
Date: Thu, 15 Aug 2024 15:19:06 +0200
Message-ID: <20240815131944.686323484@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index f95ccbd396925..09b80d371409b 100644
--- a/arch/s390/kernel/uv.c
+++ b/arch/s390/kernel/uv.c
@@ -165,7 +165,7 @@ static int make_secure_pte(pte_t *ptep, unsigned long addr,
 {
 	pte_t entry = READ_ONCE(*ptep);
 	struct page *page;
-	int expected, rc = 0;
+	int expected, cc = 0;
 
 	if (!pte_present(entry))
 		return -ENXIO;
@@ -181,12 +181,25 @@ static int make_secure_pte(pte_t *ptep, unsigned long addr,
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
@@ -239,6 +252,10 @@ int gmap_make_secure(struct gmap *gmap, unsigned long gaddr, void *uvcb)
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
index 458b42b50b8cb..79e6f016c22fc 100644
--- a/arch/s390/kvm/intercept.c
+++ b/arch/s390/kvm/intercept.c
@@ -537,6 +537,11 @@ static int handle_pv_uvc(struct kvm_vcpu *vcpu)
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



