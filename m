Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62F792C237E;
	Wed, 28 Jan 2026 15:36:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614575; cv=none; b=S77yoPpd2keNTmklGNnyu/EEZieZFdqkzYojkgvKyErIA9emlyoOJj28ES4e1n/mHoAMbghfMJjb0L5CsF88QyIVQ7c8x2S3+p8PDNzxAQuIlWzKUjamqHY0hC+yohS3k0oa6XnPpaDza+7gdCr0AP58kL9/fMEzozzcJLUqd/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614575; c=relaxed/simple;
	bh=HBwpQFiAkOgq8qbeS0YIOlppzfAVwRh56TozFd1Okqg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dsjtfsO3mBOrMDI+SxJ6mP9c9NQclniZS9FfSPao484X2B3pUAFQxwffZXV1//ypZKvx7plphAsjUEubiOgeOjKxsmw6BICunpeaQI6FWXtyiWcdh1m0QUqSeKV832U5JkOe+izc+K1/cNaWYaFOTUWyG7r4XCXOX7ZYfDIWx6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l7F/lOuJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l7F/lOuJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 664F7C4CEF1;
	Wed, 28 Jan 2026 15:36:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614575;
	bh=HBwpQFiAkOgq8qbeS0YIOlppzfAVwRh56TozFd1Okqg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l7F/lOuJY83QySeRt2z3huYgXxKGrD4FLBXrCRXKYjsnQgbkACsX1Vq+fLe80XY0a
	 tGnN+/OYhS+rUSweF+BLvlQXJCpxCyhqiCQYQo7rMVMayrSZskzffRic6ei2L+52TO
	 hdmopdIl1EIPIQZbmS7R8jxe99mShUw4ZcDfSQDk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Cooper <andrew.cooper3@citrix.com>,
	Marco Elver <elver@google.com>,
	Alexander Potapenko <glider@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Jann Horn <jannh@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 146/254] x86/kfence: avoid writing L1TF-vulnerable PTEs
Date: Wed, 28 Jan 2026 16:22:02 +0100
Message-ID: <20260128145350.067454164@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.698118637@linuxfoundation.org>
References: <20260128145344.698118637@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Cooper <andrew.cooper3@citrix.com>

commit b505f1944535f83d369ae68813e7634d11b990d3 upstream.

For native, the choice of PTE is fine.  There's real memory backing the
non-present PTE.  However, for XenPV, Xen complains:

  (XEN) d1 L1TF-vulnerable L1e 8010000018200066 - Shadowing

To explain, some background on XenPV pagetables:

  Xen PV guests are control their own pagetables; they choose the new
  PTE value, and use hypercalls to make changes so Xen can audit for
  safety.

  In addition to a regular reference count, Xen also maintains a type
  reference count.  e.g.  SegDesc (referenced by vGDT/vLDT), Writable
  (referenced with _PAGE_RW) or L{1..4} (referenced by vCR3 or a lower
  pagetable level).  This is in order to prevent e.g.  a page being
  inserted into the pagetables for which the guest has a writable mapping.

  For non-present mappings, all other bits become software accessible,
  and typically contain metadata rather a real frame address.  There is
  nothing that a reference count could sensibly be tied to.  As such, even
  if Xen could recognise the address as currently safe, nothing would
  prevent that frame from changing owner to another VM in the future.

  When Xen detects a PV guest writing a L1TF-PTE, it responds by
  activating shadow paging.  This is normally only used for the live phase
  of migration, and comes with a reasonable overhead.

KFENCE only cares about getting #PF to catch wild accesses; it doesn't
care about the value for non-present mappings.  Use a fully inverted PTE,
to avoid hitting the slow path when running under Xen.

While adjusting the logic, take the opportunity to skip all actions if the
PTE is already in the right state, half the number PVOps callouts, and
skip TLB maintenance on a !P -> P transition which benefits non-Xen cases
too.

Link: https://lkml.kernel.org/r/20260106180426.710013-1-andrew.cooper3@citrix.com
Fixes: 1dc0da6e9ec0 ("x86, kfence: enable KFENCE for x86")
Signed-off-by: Andrew Cooper <andrew.cooper3@citrix.com>
Tested-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jann Horn <jannh@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/kfence.h |   29 ++++++++++++++++++++++++-----
 1 file changed, 24 insertions(+), 5 deletions(-)

--- a/arch/x86/include/asm/kfence.h
+++ b/arch/x86/include/asm/kfence.h
@@ -42,10 +42,34 @@ static inline bool kfence_protect_page(u
 {
 	unsigned int level;
 	pte_t *pte = lookup_address(addr, &level);
+	pteval_t val;
 
 	if (WARN_ON(!pte || level != PG_LEVEL_4K))
 		return false;
 
+	val = pte_val(*pte);
+
+	/*
+	 * protect requires making the page not-present.  If the PTE is
+	 * already in the right state, there's nothing to do.
+	 */
+	if (protect != !!(val & _PAGE_PRESENT))
+		return true;
+
+	/*
+	 * Otherwise, invert the entire PTE.  This avoids writing out an
+	 * L1TF-vulnerable PTE (not present, without the high address bits
+	 * set).
+	 */
+	set_pte(pte, __pte(~val));
+
+	/*
+	 * If the page was protected (non-present) and we're making it
+	 * present, there is no need to flush the TLB at all.
+	 */
+	if (!protect)
+		return true;
+
 	/*
 	 * We need to avoid IPIs, as we may get KFENCE allocations or faults
 	 * with interrupts disabled. Therefore, the below is best-effort, and
@@ -53,11 +77,6 @@ static inline bool kfence_protect_page(u
 	 * lazy fault handling takes care of faults after the page is PRESENT.
 	 */
 
-	if (protect)
-		set_pte(pte, __pte(pte_val(*pte) & ~_PAGE_PRESENT));
-	else
-		set_pte(pte, __pte(pte_val(*pte) | _PAGE_PRESENT));
-
 	/*
 	 * Flush this CPU's TLB, assuming whoever did the allocation/free is
 	 * likely to continue running on this CPU.


