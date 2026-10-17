Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3683F3AEB39;
	Sat, 17 Oct 2026 16:46:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255597; cv=none; b=dpv7UnYPDeHj1XmLMnDOqD684ADCxv2bIyl4TjGz0ZzDBR+xTY1+rVKOiJ55GV8rHJ/RLE37zh792S2oUlA8lOjCoI0Y5uGW4s+H8PomkM7Yh4QMoT6YILOV4abzpRYQWDJcWNXnPN1jZ82nPykc2PXqpo8HUZfcuzh3C0IF63A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255597; c=relaxed/simple;
	bh=YYUdpwhSMrhiX9lgyiN3ZJJwQ2/HoBFZ76BCTc14v7Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HYKZouLcpZKF/kysXRvnJLjcu1CO6/mcv6Jdjv0yFj8i8YuAw4PNn1Pidm11ykkzTitZLGt7wlC9P7m1loRfBW3ogrB49WPKhyDzBCOKEk0c/t80UovaMBKAhfgtia8te9ocUwh0KTR5ti2xxP1c3onABOWNPl8XadMVf1F1T0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sUzHDPLb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sUzHDPLb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A54F1F000C4;
	Sat, 17 Oct 2026 16:46:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255596;
	bh=lncF+LhgekRnGUzOCceu2HUdT3yM6/tSY2HLxvztQKk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sUzHDPLb22cDCSzpWzDTniigwZs/TdwP7nNC0iadMCxsphLYeG4OZVPqW3jkFoWra
	 TZ7+HOQcb/RxxoHaj+7URadYMs9NIYuZ99Tsh9pyk9Zl29DBXFZDTgfamwjmPRf5li
	 OXrXhMD2jA8GTAtadT/4xPgxm2wYZ7FirOrvLKAA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Christoph Schlameuss <schlameuss@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 827/869] KVM: s390: Fix FOLL_*/FAULT_FLAG_* confusion
Date: Sat, 17 Oct 2026 18:01:08 +0200
Message-ID: <20261017160058.084822094@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Claudio Imbrenda <imbrenda@linux.ibm.com>

[ Upstream commit 5f9df945d4e862979b50e4ecaba3dc81fb06e8ed ]

Pass the right type of flag to vcpu_dat_fault_handler(); it expects a
FOLL_* flag (in particular FOLL_WRITE), but FAULT_FLAG_WRITE is passed
instead.

This still works because they happen to have the same integer value,
but it's a mistake, thus the fix.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Fixes: 05066cafa925 ("s390/mm/fault: Handle guest-related program interrupts in KVM")
Acked-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Steffen Eiden <seiden@linux.ibm.com>
Reviewed-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kvm/kvm-s390.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 87f4ae9e3b7e6..c11e579e23313 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -4748,12 +4748,12 @@ static void kvm_s390_assert_primary_as(struct kvm_vcpu *vcpu)
  * @vcpu: the vCPU whose gmap is to be fixed up
  * @gfn: the guest frame number used for memslots (including fake memslots)
  * @gaddr: the gmap address, does not have to match @gfn for ucontrol gmaps
- * @flags: FOLL_* flags
+ * @foll: FOLL_* flags
  *
  * Return: 0 on success, < 0 in case of error.
  * Context: The mm lock must not be held before calling. May sleep.
  */
-int __kvm_s390_handle_dat_fault(struct kvm_vcpu *vcpu, gfn_t gfn, gpa_t gaddr, unsigned int flags)
+int __kvm_s390_handle_dat_fault(struct kvm_vcpu *vcpu, gfn_t gfn, gpa_t gaddr, unsigned int foll)
 {
 	struct kvm_memory_slot *slot;
 	unsigned int fault_flags;
@@ -4767,13 +4767,13 @@ int __kvm_s390_handle_dat_fault(struct kvm_vcpu *vcpu, gfn_t gfn, gpa_t gaddr, u
 	if (!slot || slot->flags & KVM_MEMSLOT_INVALID)
 		return vcpu_post_run_addressing_exception(vcpu);
 
-	fault_flags = flags & FOLL_WRITE ? FAULT_FLAG_WRITE : 0;
+	fault_flags = foll & FOLL_WRITE ? FAULT_FLAG_WRITE : 0;
 	if (vcpu->arch.gmap->pfault_enabled)
-		flags |= FOLL_NOWAIT;
+		foll |= FOLL_NOWAIT;
 	vmaddr = __gfn_to_hva_memslot(slot, gfn);
 
 try_again:
-	pfn = __kvm_faultin_pfn(slot, gfn, flags, &writable, &page);
+	pfn = __kvm_faultin_pfn(slot, gfn, foll, &writable, &page);
 
 	/* Access outside memory, inject addressing exception */
 	if (is_noslot_pfn(pfn))
@@ -4789,7 +4789,7 @@ int __kvm_s390_handle_dat_fault(struct kvm_vcpu *vcpu, gfn_t gfn, gpa_t gaddr, u
 			return 0;
 		vcpu->stat.pfault_sync++;
 		/* Could not setup async pfault, try again synchronously */
-		flags &= ~FOLL_NOWAIT;
+		foll &= ~FOLL_NOWAIT;
 		goto try_again;
 	}
 	/* Any other error */
@@ -4809,7 +4809,7 @@ int __kvm_s390_handle_dat_fault(struct kvm_vcpu *vcpu, gfn_t gfn, gpa_t gaddr, u
 	return rc;
 }
 
-static int vcpu_dat_fault_handler(struct kvm_vcpu *vcpu, unsigned long gaddr, unsigned int flags)
+static int vcpu_dat_fault_handler(struct kvm_vcpu *vcpu, unsigned long gaddr, unsigned int foll)
 {
 	unsigned long gaddr_tmp;
 	gfn_t gfn;
@@ -4834,18 +4834,18 @@ static int vcpu_dat_fault_handler(struct kvm_vcpu *vcpu, unsigned long gaddr, un
 		}
 		gfn = gpa_to_gfn(gaddr_tmp);
 	}
-	return __kvm_s390_handle_dat_fault(vcpu, gfn, gaddr, flags);
+	return __kvm_s390_handle_dat_fault(vcpu, gfn, gaddr, foll);
 }
 
 static int vcpu_post_run_handle_fault(struct kvm_vcpu *vcpu)
 {
-	unsigned int flags = 0;
+	unsigned int foll = 0;
 	unsigned long gaddr;
 	int rc;
 
 	gaddr = current->thread.gmap_teid.addr * PAGE_SIZE;
 	if (kvm_s390_cur_gmap_fault_is_write())
-		flags = FAULT_FLAG_WRITE;
+		foll = FOLL_WRITE;
 
 	switch (current->thread.gmap_int_code) {
 	case 0:
@@ -4887,7 +4887,7 @@ static int vcpu_post_run_handle_fault(struct kvm_vcpu *vcpu)
 			send_sig(SIGSEGV, current, 0);
 		if (rc != -ENXIO)
 			break;
-		flags = FAULT_FLAG_WRITE;
+		foll = FOLL_WRITE;
 		fallthrough;
 	case PGM_PROTECTION:
 	case PGM_SEGMENT_TRANSLATION:
@@ -4897,7 +4897,7 @@ static int vcpu_post_run_handle_fault(struct kvm_vcpu *vcpu)
 	case PGM_REGION_SECOND_TRANS:
 	case PGM_REGION_THIRD_TRANS:
 		kvm_s390_assert_primary_as(vcpu);
-		return vcpu_dat_fault_handler(vcpu, gaddr, flags);
+		return vcpu_dat_fault_handler(vcpu, gaddr, foll);
 	default:
 		KVM_BUG(1, vcpu->kvm, "Unexpected program interrupt 0x%x, TEID 0x%016lx",
 			current->thread.gmap_int_code, current->thread.gmap_teid.val);
-- 
2.53.0



