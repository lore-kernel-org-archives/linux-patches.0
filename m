Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86F5E2D1F4E;
	Tue,  6 Jan 2026 17:47:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721620; cv=none; b=n42pe+GlFBABalB/W8ShiX/frUggs/5JhJDzW5EhpmdZ7Pz0lMdf0ipmtirhaOGy4TteeyvUfqlkb/yCQzv7NBW5Rol4RyTo+ivy5X/AII8bmcmCApmsct8KL/i6ySzxPXPJL//E68Eu+ktzq4/QYw1+5PD+fxRgSdPff2L0jUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721620; c=relaxed/simple;
	bh=RByyTSiesJQXphUpfKVl+bKECoD2qOcU/CNzizwYm7w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YFd6MqsO5jgIxVbi7+i5/Jb9p+YJX2ZPkcwIAzkj2o3IRMrvcqWKe1xHqc3s8V1qa2nrJnB8hbRxBSSXMm0YzIRoOJJLYo3mFeLPWFjuJYCCqGktu74sI07iF9N3RLCVRq6uZflF1rVCJawUWMi1IkOTMUKk1YPtVE32Idy9k8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VPHa+ss4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VPHa+ss4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9A6CC116C6;
	Tue,  6 Jan 2026 17:46:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721620;
	bh=RByyTSiesJQXphUpfKVl+bKECoD2qOcU/CNzizwYm7w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VPHa+ss4sOxIF+aemc0etUOb7vdoK+O6GUXat6aZh4oovO2rvoAnseoPsAe1Ot8jF
	 AIZOpdZDDu6YkLx39Z512VG1Ng1kpWkFw1/oNz2T2DWZXudPz6uboVJHmmy+SWM7le
	 CLkLaRefBLC5E/w1noxtH58CnSvNH93t+icwqkFc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Hartmayer <mhartmay@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 008/312] KVM: s390: Fix gmap_helper_zap_one_page() again
Date: Tue,  6 Jan 2026 18:01:22 +0100
Message-ID: <20260106170548.152444548@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Claudio Imbrenda <imbrenda@linux.ibm.com>

[ Upstream commit 2f393c228cc519ddf19b8c6c05bf15723241aa96 ]

A few checks were missing in gmap_helper_zap_one_page(), which can lead
to memory corruption in the guest under specific circumstances.

Add the missing checks.

Fixes: 5deafa27d9ae ("KVM: s390: Fix to clear PTE when discarding a swapped page")
Cc: stable@vger.kernel.org
Reported-by: Marc Hartmayer <mhartmay@linux.ibm.com>
Tested-by: Marc Hartmayer <mhartmay@linux.ibm.com>
Acked-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
[ adapted ptep_zap_softleaf_entry() and softleaf_from_pte() calls to ptep_zap_swap_entry() and pte_to_swp_entry() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/mm/gmap_helpers.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/arch/s390/mm/gmap_helpers.c
+++ b/arch/s390/mm/gmap_helpers.c
@@ -47,6 +47,7 @@ static void ptep_zap_swap_entry(struct m
 void gmap_helper_zap_one_page(struct mm_struct *mm, unsigned long vmaddr)
 {
 	struct vm_area_struct *vma;
+	unsigned long pgstev;
 	spinlock_t *ptl;
 	pgste_t pgste;
 	pte_t *ptep;
@@ -65,9 +66,13 @@ void gmap_helper_zap_one_page(struct mm_
 	if (pte_swap(*ptep)) {
 		preempt_disable();
 		pgste = pgste_get_lock(ptep);
+		pgstev = pgste_val(pgste);
 
-		ptep_zap_swap_entry(mm, pte_to_swp_entry(*ptep));
-		pte_clear(mm, vmaddr, ptep);
+		if ((pgstev & _PGSTE_GPS_USAGE_MASK) == _PGSTE_GPS_USAGE_UNUSED ||
+		    (pgstev & _PGSTE_GPS_ZERO)) {
+			ptep_zap_swap_entry(mm, pte_to_swp_entry(*ptep));
+			pte_clear(mm, vmaddr, ptep);
+		}
 
 		pgste_set_unlock(ptep, pgste);
 		preempt_enable();


