Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27B7828E0;
	Fri,  7 Aug 2026 15:21:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116066; cv=none; b=jjZZUBj1wY1z9v+Vixx/fH0mKjDSCI2yeyd0iC0ywJd7eqvzGEAFOno29Q5GRycK2zkSnVNbgeP/zvzKR5j3BFW/g+gMq8ldR4L8EJ1YDpdRzvyHudFRlIJtF/rYsphAA86bwQLBkTTgr/hiVL+FQkshhX8BFnB01swfLRCvY+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116066; c=relaxed/simple;
	bh=8MeDKsEcYOqlGTxjBzCOS3xqB6X8MpaOPgpS5h0b5/g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SprY2LfmIk071dgv0pQuop/7ewJFNT3L82iuxvSd+gFQen7kHSALO3f/ED1suoGW0q2zuIRzShslPV75b5qXEHxDO8OkJ44mb0j38T8LRhKiJjfL/Hjmo+w6yfYYKCjTBWL88HoLFxfUAVx5HGB5TNa0NR5vf06S9cfGvNRZt54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OMhBDH+v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OMhBDH+v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 845CC1F00A3A;
	Fri,  7 Aug 2026 15:21:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116065;
	bh=0+j2KCKl7T0oOHh3fo45HeJGhRxA6guRuXOQR1iD3TE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OMhBDH+vQyCWYYbiWm+/mKIySqjkW42D15ElX9+SiJXkha91EzWgIgw2OvTBk2gPd
	 TQq1eMbXD0qPdsIZHS6uOF1ucELHWEgRIWQsU8iz3ELNxI9E+BOuMi+S3zFEqC62PK
	 NXnGzLjiQYfeC6vRsKlAosDp+Krs0xzyEpPxK6z8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Farhan Ali <alifm@linux.ibm.com>
Subject: [PATCH 6.6 099/261] KVM: s390: pci: Validate AIBV and AISB before pinning guest pages
Date: Fri,  7 Aug 2026 16:37:36 +0200
Message-ID: <20260807143417.517494742@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143415.358597922@linuxfoundation.org>
References: <20260807143415.358597922@linuxfoundation.org>
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

From: Farhan Ali <alifm@linux.ibm.com>

commit 868d32ac72cba21c5c6d8a66a814b7c25a3a5c01 upstream.

The AIBV holds one bit per MSI-X vector for a given function. The size of
the bit vector is derived from the NOI and the AIBVO. If the size of the
AIBV exceeds a single page boundary, then reject the request as we cannot
safely pin the guest AIBV.

Similarly reject the request if the AISB address is not 8-byte aligned as
the architecture requires doubleword alignment for the summary bit address.
Since the AISBO can address up to 64 bits, the size of the AISB can only be
8 bytes for the function. This also ensures the AISB doesn't exceed a
single page boundary.

Fixes: 3c5a1b6f0a18 ("KVM: s390: pci: provide routines for enabling/disabling interrupt forwarding")
Cc: stable@vger.kernel.org
Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
Tested-by: Matthew Rosato <mjrosato@linux.ibm.com>
Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/kvm/pci.c |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

--- a/arch/s390/kvm/pci.c
+++ b/arch/s390/kvm/pci.c
@@ -225,7 +225,7 @@ static int kvm_s390_pci_aif_enable(struc
 				   bool assist)
 {
 	struct page *pages[1], *aibv_page, *aisb_page = NULL;
-	unsigned int msi_vecs, idx;
+	unsigned int msi_vecs, idx, size;
 	struct zpci_gaite *gaite;
 	unsigned long hva, bit;
 	struct kvm *kvm;
@@ -252,6 +252,14 @@ static int kvm_s390_pci_aif_enable(struc
 		return gisc;
 
 	/* Replace AIBV address */
+	size = BITS_TO_LONGS(msi_vecs + fib->fmt0.aibvo) * sizeof(unsigned long);
+	npages = DIV_ROUND_UP((fib->fmt0.aibv & ~PAGE_MASK) + size, PAGE_SIZE);
+	/* AIBV cannot span more than 1 page */
+	if (npages > 1) {
+		rc = -EINVAL;
+		goto out;
+	}
+
 	idx = srcu_read_lock(&kvm->srcu);
 	hva = gfn_to_hva(kvm, gpa_to_gfn((gpa_t)fib->fmt0.aibv));
 	npages = pin_user_pages_fast(hva, 1, FOLL_WRITE | FOLL_LONGTERM, pages);
@@ -267,6 +275,12 @@ static int kvm_s390_pci_aif_enable(struc
 
 	/* Pin the guest AISB if one was specified */
 	if (fib->fmt0.sum == 1) {
+		/* AISB must be dword aligned */
+		if (fib->fmt0.aisb & 0x7) {
+			rc = -EINVAL;
+			goto unpin1;
+		}
+
 		idx = srcu_read_lock(&kvm->srcu);
 		hva = gfn_to_hva(kvm, gpa_to_gfn((gpa_t)fib->fmt0.aisb));
 		npages = pin_user_pages_fast(hva, 1, FOLL_WRITE | FOLL_LONGTERM,


