Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC42658039F;
	Wed,  9 Sep 2026 14:25:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963931; cv=none; b=WD9Kg3OxNz20QKue2mY5BgEvgSwVLfbdbFLRYEZAd3WI+0UDJQY5cyo6gEc+PfTd/8hImWwCEx9/OxY8lui1ENrt7+gBVxnLWoY9/F/N3TJIJbJmMWqvdc2RMKcvsYsaz8lGJwta0rDHvplc0G67Y7lkZR+HxGebnwJQq9ql3dk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963931; c=relaxed/simple;
	bh=Na4JytZDac9wEo3fd6uCjeFLul7Pin/PAtW+AYMxdUg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O6kYzrBZmV3nN1Wd5HuJAVD5e0vgQfgg/PWbxCTrSJo1lhwrK0Q/cYXVhPCe44213T9hpgRdpfE2ZQ13AhemmTVqe0f64VFr9477p+W6TC4QSjMfQD/K0dp7COkC+r8QDt/th41Ti1CSaDV/IAaSB+EovIdDMQ7ZGuG6KPtI/kU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N1PNW3zU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N1PNW3zU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 430431F00A3A;
	Wed,  9 Sep 2026 14:25:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963929;
	bh=yZCdQEv7YoUdR7nFn4/pq1qCkk8K18kGqDYYXQpoBb4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N1PNW3zUuQHypmD5sXZGmFPgUKBnYddfr2TY7MbPdUb91NopfjhueMHKyCn/u6o+P
	 6j8RnwFcBsn78JGKg7V9469ZJiIQZn2rIUaOuo8+qRiELC7lYkrv4AzpHKAiy9xcDq
	 vNbnV8FzOOT9JBH2KSqhWWKVPo21adAM/gIChWUU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>
Subject: [PATCH 6.18 248/583] KVM: s390: Zero initialize irq in reinject_machine_check
Date: Wed,  9 Sep 2026 15:38:53 +0200
Message-ID: <20260909134246.713540818@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

From: Christian Borntraeger <borntraeger@linux.ibm.com>

commit b239410c7653ff6781d4cf1d63cfc52a1bb71788 upstream.

kvm_s390_reinject_machine_check() fills cr14, mcic, ext_damage_code and
failing_storage_address of the on-stack struct kvm_s390_irq, but struct
kvm_s390_mchk_info also has a pad word and a 16 byte fixed_logout array.
struct mcck_volatile_info carries no logout data, so there is nothing to
copy there and both stay whatever was on the stack.

__inject_mchk() then memcpy()s fixed_logout into the vcpu local
interrupt state unconditionally. This will reach the guest during
deliver and userspace during migration.

Reflecting zeroes is the correct behaviour here, as KVM has no logout
data for a reinjected machine check.

This needs a host machine check while the cpu is in SIE so not trivial
to trigger.

Fixes: 4d62fcc0b692 ("KVM: s390: Inject machine check into the guest")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Message-ID: <20260805110455.7200-4-borntraeger@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/kvm/interrupt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/s390/kvm/interrupt.c
+++ b/arch/s390/kvm/interrupt.c
@@ -2864,7 +2864,7 @@ void kvm_s390_reinject_machine_check(str
 				     struct mcck_volatile_info *mcck_info)
 {
 	struct kvm_s390_interrupt_info inti;
-	struct kvm_s390_irq irq;
+	struct kvm_s390_irq irq = {};
 	struct kvm_s390_mchk_info *mchk;
 	union mci mci;
 	__u64 cr14 = 0;         /* upper bits are not used */


