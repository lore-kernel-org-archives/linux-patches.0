Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1151B1F4FCF;
	Wed,  6 Nov 2024 12:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896637; cv=none; b=LZdjDSqO2G2Pj7DP6QzG/eCUTtnb3s5gUk1sAozVjoS4qbxTeDXEMBuyN6CDdjOmRGcYIuj5lc24ASzX/6rApZRPekWT3HkpPR53GLKKw7PRmIoYMPOQTSRS1vGDg3QKpaG7GvX7ACZCINhFPuJfr2IN/hRpzqbP/9ok5i/j/vI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896637; c=relaxed/simple;
	bh=8m798v4KnFmRc7zWn6ysjrampWpwQyLrFTRqgpiys+U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SPAPI8pVUFa6D3dWClG4nVDEdztUijeAz8QEPdW1QEm+ZCAQILFHlG6dspEiJiVDVKXPE8Jt8knsZbJ54X3xcYfVlpcg6VePH6hifD+Vp/2LZrnMGsA7z//ZYAyLmSHStMCW3Spwo1dlNw7rEMOXvNH9Q36WAQWJQqwaiPNhiPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BdRzzNXz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BdRzzNXz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B782C4CECD;
	Wed,  6 Nov 2024 12:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896636;
	bh=8m798v4KnFmRc7zWn6ysjrampWpwQyLrFTRqgpiys+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BdRzzNXz9LdBPnP84775E+W+5CoN5WMRdUzoQg/esBBshRWn+OOfB+LSfX/fpR6xi
	 HNzfHGPDXUNRoHUj6AqTNh8GyUXPgz/2MKWNWMiCmfVaanJMKR+c9cpQUxYlZ44/Sq
	 UW/lp9G/QsoNqNUp4tD0srKpg9YexgiUl6nysGM0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 022/110] KVM: s390: gaccess: Refactor access address range check
Date: Wed,  6 Nov 2024 13:03:48 +0100
Message-ID: <20241106120303.775545766@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120303.135636370@linuxfoundation.org>
References: <20241106120303.135636370@linuxfoundation.org>
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

From: Janis Schoetterl-Glausch <scgl@linux.ibm.com>

[ Upstream commit 7faa543df19bf62d4583a64d3902705747f2ad29 ]

Do not round down the first address to the page boundary, just translate
it normally, which gives the value we care about in the first place.
Given this, translating a single address is just the special case of
translating a range spanning a single page.

Make the output optional, so the function can be used to just check a
range.

Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Message-Id: <20211126164549.7046-3-scgl@linux.ibm.com>
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Stable-dep-of: e8061f06185b ("KVM: s390: gaccess: Check if guest address is in memslot")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kvm/gaccess.c | 122 +++++++++++++++++++++++-----------------
 1 file changed, 69 insertions(+), 53 deletions(-)

diff --git a/arch/s390/kvm/gaccess.c b/arch/s390/kvm/gaccess.c
index 9f80d95a43770..9b9bfc333e62d 100644
--- a/arch/s390/kvm/gaccess.c
+++ b/arch/s390/kvm/gaccess.c
@@ -794,35 +794,74 @@ static int low_address_protection_enabled(struct kvm_vcpu *vcpu,
 	return 1;
 }
 
-static int guest_page_range(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar,
-			    unsigned long *pages, unsigned long nr_pages,
-			    const union asce asce, enum gacc_mode mode)
+/**
+ * guest_range_to_gpas() - Calculate guest physical addresses of page fragments
+ * covering a logical range
+ * @vcpu: virtual cpu
+ * @ga: guest address, start of range
+ * @ar: access register
+ * @gpas: output argument, may be NULL
+ * @len: length of range in bytes
+ * @asce: address-space-control element to use for translation
+ * @mode: access mode
+ *
+ * Translate a logical range to a series of guest absolute addresses,
+ * such that the concatenation of page fragments starting at each gpa make up
+ * the whole range.
+ * The translation is performed as if done by the cpu for the given @asce, @ar,
+ * @mode and state of the @vcpu.
+ * If the translation causes an exception, its program interruption code is
+ * returned and the &struct kvm_s390_pgm_info pgm member of @vcpu is modified
+ * such that a subsequent call to kvm_s390_inject_prog_vcpu() will inject
+ * a correct exception into the guest.
+ * The resulting gpas are stored into @gpas, unless it is NULL.
+ *
+ * Note: All fragments except the first one start at the beginning of a page.
+ *	 When deriving the boundaries of a fragment from a gpa, all but the last
+ *	 fragment end at the end of the page.
+ *
+ * Return:
+ * * 0		- success
+ * * <0		- translation could not be performed, for example if  guest
+ *		  memory could not be accessed
+ * * >0		- an access exception occurred. In this case the returned value
+ *		  is the program interruption code and the contents of pgm may
+ *		  be used to inject an exception into the guest.
+ */
+static int guest_range_to_gpas(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar,
+			       unsigned long *gpas, unsigned long len,
+			       const union asce asce, enum gacc_mode mode)
 {
 	psw_t *psw = &vcpu->arch.sie_block->gpsw;
+	unsigned int offset = offset_in_page(ga);
+	unsigned int fragment_len;
 	int lap_enabled, rc = 0;
 	enum prot_type prot;
+	unsigned long gpa;
 
 	lap_enabled = low_address_protection_enabled(vcpu, asce);
-	while (nr_pages) {
+	while (min(PAGE_SIZE - offset, len) > 0) {
+		fragment_len = min(PAGE_SIZE - offset, len);
 		ga = kvm_s390_logical_to_effective(vcpu, ga);
 		if (mode == GACC_STORE && lap_enabled && is_low_address(ga))
 			return trans_exc(vcpu, PGM_PROTECTION, ga, ar, mode,
 					 PROT_TYPE_LA);
-		ga &= PAGE_MASK;
 		if (psw_bits(*psw).dat) {
-			rc = guest_translate(vcpu, ga, pages, asce, mode, &prot);
+			rc = guest_translate(vcpu, ga, &gpa, asce, mode, &prot);
 			if (rc < 0)
 				return rc;
 		} else {
-			*pages = kvm_s390_real_to_abs(vcpu, ga);
-			if (kvm_is_error_gpa(vcpu->kvm, *pages))
+			gpa = kvm_s390_real_to_abs(vcpu, ga);
+			if (kvm_is_error_gpa(vcpu->kvm, gpa))
 				rc = PGM_ADDRESSING;
 		}
 		if (rc)
 			return trans_exc(vcpu, rc, ga, ar, mode, prot);
-		ga += PAGE_SIZE;
-		pages++;
-		nr_pages--;
+		if (gpas)
+			*gpas++ = gpa;
+		offset = 0;
+		ga += fragment_len;
+		len -= fragment_len;
 	}
 	return 0;
 }
@@ -831,10 +870,10 @@ int access_guest(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar, void *data,
 		 unsigned long len, enum gacc_mode mode)
 {
 	psw_t *psw = &vcpu->arch.sie_block->gpsw;
-	unsigned long nr_pages, gpa, idx;
-	unsigned long pages_array[2];
+	unsigned long nr_pages, idx;
+	unsigned long gpa_array[2];
 	unsigned int fragment_len;
-	unsigned long *pages;
+	unsigned long *gpas;
 	int need_ipte_lock;
 	union asce asce;
 	int rc;
@@ -846,30 +885,28 @@ int access_guest(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar, void *data,
 	if (rc)
 		return rc;
 	nr_pages = (((ga & ~PAGE_MASK) + len - 1) >> PAGE_SHIFT) + 1;
-	pages = pages_array;
-	if (nr_pages > ARRAY_SIZE(pages_array))
-		pages = vmalloc(array_size(nr_pages, sizeof(unsigned long)));
-	if (!pages)
+	gpas = gpa_array;
+	if (nr_pages > ARRAY_SIZE(gpa_array))
+		gpas = vmalloc(array_size(nr_pages, sizeof(unsigned long)));
+	if (!gpas)
 		return -ENOMEM;
 	need_ipte_lock = psw_bits(*psw).dat && !asce.r;
 	if (need_ipte_lock)
 		ipte_lock(vcpu);
-	rc = guest_page_range(vcpu, ga, ar, pages, nr_pages, asce, mode);
+	rc = guest_range_to_gpas(vcpu, ga, ar, gpas, len, asce, mode);
 	for (idx = 0; idx < nr_pages && !rc; idx++) {
-		gpa = pages[idx] + offset_in_page(ga);
-		fragment_len = min(PAGE_SIZE - offset_in_page(gpa), len);
+		fragment_len = min(PAGE_SIZE - offset_in_page(gpas[idx]), len);
 		if (mode == GACC_STORE)
-			rc = kvm_write_guest(vcpu->kvm, gpa, data, fragment_len);
+			rc = kvm_write_guest(vcpu->kvm, gpas[idx], data, fragment_len);
 		else
-			rc = kvm_read_guest(vcpu->kvm, gpa, data, fragment_len);
+			rc = kvm_read_guest(vcpu->kvm, gpas[idx], data, fragment_len);
 		len -= fragment_len;
-		ga += fragment_len;
 		data += fragment_len;
 	}
 	if (need_ipte_lock)
 		ipte_unlock(vcpu);
-	if (nr_pages > ARRAY_SIZE(pages_array))
-		vfree(pages);
+	if (nr_pages > ARRAY_SIZE(gpa_array))
+		vfree(gpas);
 	return rc;
 }
 
@@ -906,8 +943,6 @@ int access_guest_real(struct kvm_vcpu *vcpu, unsigned long gra,
 int guest_translate_address(struct kvm_vcpu *vcpu, unsigned long gva, u8 ar,
 			    unsigned long *gpa, enum gacc_mode mode)
 {
-	psw_t *psw = &vcpu->arch.sie_block->gpsw;
-	enum prot_type prot;
 	union asce asce;
 	int rc;
 
@@ -915,23 +950,7 @@ int guest_translate_address(struct kvm_vcpu *vcpu, unsigned long gva, u8 ar,
 	rc = get_vcpu_asce(vcpu, &asce, gva, ar, mode);
 	if (rc)
 		return rc;
-	if (is_low_address(gva) && low_address_protection_enabled(vcpu, asce)) {
-		if (mode == GACC_STORE)
-			return trans_exc(vcpu, PGM_PROTECTION, gva, 0,
-					 mode, PROT_TYPE_LA);
-	}
-
-	if (psw_bits(*psw).dat && !asce.r) {	/* Use DAT? */
-		rc = guest_translate(vcpu, gva, gpa, asce, mode, &prot);
-		if (rc > 0)
-			return trans_exc(vcpu, rc, gva, 0, mode, prot);
-	} else {
-		*gpa = kvm_s390_real_to_abs(vcpu, gva);
-		if (kvm_is_error_gpa(vcpu->kvm, *gpa))
-			return trans_exc(vcpu, rc, gva, PGM_ADDRESSING, mode, 0);
-	}
-
-	return rc;
+	return guest_range_to_gpas(vcpu, gva, ar, gpa, 1, asce, mode);
 }
 
 /**
@@ -940,17 +959,14 @@ int guest_translate_address(struct kvm_vcpu *vcpu, unsigned long gva, u8 ar,
 int check_gva_range(struct kvm_vcpu *vcpu, unsigned long gva, u8 ar,
 		    unsigned long length, enum gacc_mode mode)
 {
-	unsigned long gpa;
-	unsigned long currlen;
+	union asce asce;
 	int rc = 0;
 
+	rc = get_vcpu_asce(vcpu, &asce, gva, ar, mode);
+	if (rc)
+		return rc;
 	ipte_lock(vcpu);
-	while (length > 0 && !rc) {
-		currlen = min(length, PAGE_SIZE - (gva % PAGE_SIZE));
-		rc = guest_translate_address(vcpu, gva, ar, &gpa, mode);
-		gva += currlen;
-		length -= currlen;
-	}
+	rc = guest_range_to_gpas(vcpu, gva, ar, NULL, length, asce, mode);
 	ipte_unlock(vcpu);
 
 	return rc;
-- 
2.43.0



