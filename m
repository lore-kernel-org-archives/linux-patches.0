Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30263530DE5;
	Wed,  9 Sep 2026 14:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962492; cv=none; b=BhIEs83CezmPrglEGlLDPLFKHkannuqFqxqiTwQS+s3KVfTlfVn9hVZdVhM5kGzA0jNvTPIW/W6OqfcrfebqD+CrmZv+h8EpNuu/u2Jk89p0hipVeqEaPMp4HizbzKxy75kAPmvkZHVve/cRgv4DmBx26Zt4WZi4ZXBmbQUR8M4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962492; c=relaxed/simple;
	bh=P29t46/8/4SrB3/jTSgZ2IwLza641DnN+b8iyPCxdHE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YABWwfgBwcs3sCOLGbxLicpBiu5OIAkr8NozA+g6AAzNC9KdpXLIKOGCR9wXF0oM6Elhs0SZFfxTOYyy4INKMnYom6vCmy0RJTDRzUk9cYJDIGNf9DV/4U4IJaFzKqfI4IcbUvq+2YsJL07A7sPSYs6QjFHsVVSw6MjOmOhDv9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O1toLg5w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O1toLg5w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 888551F00A3D;
	Wed,  9 Sep 2026 14:01:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962491;
	bh=NTtypndYEffcmXm+XLXW3NA7X6LZKW5Wvviz35zU2b0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O1toLg5wT9Vr6L6SDphbjoirYEHkLL+k8iCSX2//SszSiEHJ4TkzWX1PdkgXJHNYP
	 GODhJDLbdbXVBpVeQcadceb/G0rcr6Zm5f59Savr08tAsc+jto0iOZXql1c0Y4ghn8
	 geTNtaThxHYCKQOkfYHzAP+cbaQ9I0Gzo4BvGQtY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>
Subject: [PATCH 7.2 310/556] KVM: s390: Fix memory corruption by not reinjecting CK machine checks
Date: Wed,  9 Sep 2026 15:39:50 +0200
Message-ID: <20260909134241.575602452@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Borntraeger <borntraeger@linux.ibm.com>

commit 546dde823a36d7283dcf46127c2f3d093443860f upstream.

Channel-subsystem damage machine checks are for the host channel
subsystem. The guest channel subsystem is emulated in the userspace VMM.
There is no point in forwarding such machine checks into the guest.

This also simplifies the machine check reinjection and avoids kfree of a
stack variable as reported by sashiko.  There might be still machine
checks that have the ck bit set with another bit (like instruction
damage), mask out the CK bit in s390_backup_mcck_info(), like the CP and
ED bits already are.

Fixes: 4d62fcc0b692 ("KVM: s390: Inject machine check into the guest")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Acked-by: Heiko Carstens <hca@linux.ibm.com>
Acked-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Message-ID: <20260806145835.31818-1-borntraeger@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/include/asm/nmi.h |    3 +++
 arch/s390/kernel/nmi.c      |    5 +----
 arch/s390/kvm/interrupt.c   |   24 ++++++++----------------
 3 files changed, 12 insertions(+), 20 deletions(-)

--- a/arch/s390/include/asm/nmi.h
+++ b/arch/s390/include/asm/nmi.h
@@ -22,6 +22,7 @@
 #define MCCK_CODE_SYSTEM_DAMAGE		BIT(63)
 #define MCCK_CODE_EXT_DAMAGE		BIT(63 - 5)
 #define MCCK_CODE_CP			BIT(63 - 9)
+#define MCCK_CODE_CK			BIT(63 - 11)
 #define MCCK_CODE_STG_ERROR		BIT(63 - 16)
 #define MCCK_CODE_STG_KEY_ERROR		BIT(63 - 18)
 #define MCCK_CODE_STG_DEGRAD		BIT(63 - 19)
@@ -33,6 +34,8 @@
 #define MCCK_CODE_FC_VALID		BIT(63 - 43)
 #define MCCK_CODE_CPU_TIMER_VALID	BIT(63 - 46)
 
+#define MCCK_CODE_NO_GUEST	(MCCK_CODE_CP | MCCK_CODE_EXT_DAMAGE | MCCK_CODE_CK)
+
 #ifndef __ASSEMBLER__
 
 union mci {
--- a/arch/s390/kernel/nmi.c
+++ b/arch/s390/kernel/nmi.c
@@ -344,8 +344,7 @@ static void notrace s390_backup_mcck_inf
 
 	sie_page = container_of(sie_block, struct sie_page, sie_block);
 	mcck_backup = &sie_page->mcck_info;
-	mcck_backup->mcic = get_lowcore()->mcck_interruption_code &
-				~(MCCK_CODE_CP | MCCK_CODE_EXT_DAMAGE);
+	mcck_backup->mcic = get_lowcore()->mcck_interruption_code & ~MCCK_CODE_NO_GUEST;
 	mcck_backup->ext_damage_code = get_lowcore()->external_damage_code;
 	mcck_backup->failing_storage_address = get_lowcore()->failing_storage_address;
 }
@@ -357,8 +356,6 @@ NOKPROBE_SYMBOL(s390_backup_mcck_info);
 #define ED_STP_ISLAND	6	/* External damage STP island check */
 #define ED_STP_SYNC	7	/* External damage STP sync check */
 
-#define MCCK_CODE_NO_GUEST	(MCCK_CODE_CP | MCCK_CODE_EXT_DAMAGE)
-
 /*
  * machine check handler.
  */
--- a/arch/s390/kvm/interrupt.c
+++ b/arch/s390/kvm/interrupt.c
@@ -3108,9 +3108,7 @@ static int set_adapter_int(struct kvm_ke
 void kvm_s390_reinject_machine_check(struct kvm_vcpu *vcpu,
 				     struct mcck_volatile_info *mcck_info)
 {
-	struct kvm_s390_interrupt_info inti;
 	struct kvm_s390_irq irq = {};
-	struct kvm_s390_mchk_info *mchk;
 	union mci mci;
 	__u64 cr14 = 0;         /* upper bits are not used */
 	int rc;
@@ -3129,20 +3127,14 @@ void kvm_s390_reinject_machine_check(str
 	if (mci.w)
 		cr14 |= CR14_WARNING_SUBMASK;
 
-	mchk = mci.ck ? &inti.mchk : &irq.u.mchk;
-	mchk->cr14 = cr14;
-	mchk->mcic = mcck_info->mcic;
-	mchk->ext_damage_code = mcck_info->ext_damage_code;
-	mchk->failing_storage_address = mcck_info->failing_storage_address;
-	if (mci.ck) {
-		/* Inject the floating machine check */
-		inti.type = KVM_S390_MCHK;
-		rc = __inject_vm(vcpu->kvm, &inti);
-	} else {
-		/* Inject the machine check to specified vcpu */
-		irq.type = KVM_S390_MCHK;
-		rc = kvm_s390_inject_vcpu(vcpu, &irq);
-	}
+	irq.u.mchk.cr14 = cr14;
+	irq.u.mchk.mcic = mcck_info->mcic;
+	irq.u.mchk.ext_damage_code = mcck_info->ext_damage_code;
+	irq.u.mchk.failing_storage_address = mcck_info->failing_storage_address;
+
+	/* Inject the machine check to specified vcpu */
+	irq.type = KVM_S390_MCHK;
+	rc = kvm_s390_inject_vcpu(vcpu, &irq);
 	WARN_ON_ONCE(rc);
 }
 


