Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CD945632BC;
	Wed,  9 Sep 2026 14:01:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962495; cv=none; b=Noqwjz2oEuPJDIaQdd5NgSxtp81lml70cExog0PbWb68r58gQf9vqZ9KSsSSHxWRTS9gTgnxbc682hhiYLoqcdppWOD02QRobA/9FfnepcWfLg0K3M9fXpVbC0RwMe46DnQN53368gpAHRSaUMQr9QWLPTm8hMg9fgkFv+n24+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962495; c=relaxed/simple;
	bh=xzzBDRkiyXrxxWB2hFJEqofXPyjiwnQXTjGdRpN25C4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LgsiCAAaLGxKbC5KaffZDk7zXytFEo/0uPDjHVQEXdGgYBVW/mG+jutx1nN+HhbEqegy8hVBz+3AU6s3djILyQNC6SzXm+svD6rec9/au8c017rz3Flmv/Iv5NLh9Qa6YvsAdG52UPY50WP1PfEKu+8xhuFA2dMcN94T4afr/PM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qyRzWRu+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qyRzWRu+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6930D1F00A3E;
	Wed,  9 Sep 2026 14:01:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962493;
	bh=5PMKAOwbnT5DicsfKn5NiZFlWF9fVGkAvjfYdCPYiWo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qyRzWRu+SGZZjm6zfPQRXGj5QBPmMZQ7UQBwCKHpZVzeJru9FXuc99hVZDNi6dSI3
	 Uf+nmuraM+3o0DpdrN50KhU5Hqpm9om+/LcIVY9uYqS19/dNjjgVOrHe7b7Y3aySEr
	 MD1PmIAtgdVhb+vTgjOFFFgy0KSfhbGVsKOB8MuE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>
Subject: [PATCH 7.2 311/556] KVM: s390: keyop: use mmu_lock to read gmap->asce
Date: Wed,  9 Sep 2026 15:39:51 +0200
Message-ID: <20260909134241.610184994@linuxfoundation.org>
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

commit da07a751efa4583385f9f0f47113549fe8871242 upstream.

Every other dat_* consumer in this file (kvm_s390_get_skeys,
set_skeys, get_cmma_bits, set_cmma_bits, MEM_CLR_CMMA,
kvm_s390_fixup_prefix, kvm_test_age_gfn, kvm_age_gfn) reads
kvm->arch.gmap->asce *inside* the mmu_lock read-side. keyop is the only
outlier.

gmap->asce is mutated under write_lock(mmu_lock) by gmap_set_limit()
and keyop might use a stale asce value for walking as KVM_S390_KEYOP
and KVM_S390_VM_MEM_LIMIT_SIZE can run concurrently. This can result
in memory corruption.

Fixes: 0ee4ddc1647b ("KVM: s390: Storage key manipulation IOCTL")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Message-ID: <20260811153738.206885-2-borntraeger@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/kvm/kvm-s390.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -562,11 +562,12 @@ static void __kvm_s390_exit(void)
 static int kvm_s390_keyop(struct kvm_s390_mmu_cache *mc, struct kvm *kvm, int op,
 			  unsigned long addr, union skey skey)
 {
-	union asce asce = kvm->arch.gmap->asce;
 	gfn_t gfn = gpa_to_gfn(addr);
+	union asce asce;
 	int r;
 
 	guard(read_lock)(&kvm->mmu_lock);
+	asce = kvm->arch.gmap->asce;
 
 	switch (op) {
 	case KVM_S390_KEYOP_SSKE:


