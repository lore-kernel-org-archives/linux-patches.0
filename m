Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C77F58039F;
	Wed,  9 Sep 2026 14:25:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963928; cv=none; b=TXYoM1allvLH+l8tIz+137eaqrpfUS00Hs0zGghdF12sHpr6Ut49VbdDsNOUwa0EoWA/OunzkBlcrHcB1GzImEDLgsRAppkt2hbEJbyj6IRmKsve43aeu7M1TLBRnWMJxTUh4zHQvHDmzWVVAo0xfxCqE8MavhV/U41MJiYVJVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963928; c=relaxed/simple;
	bh=cSIccKztY8qd9nBLioUmyZ5ZwqEClnPJxX7RYR7xe7E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OFbp+sARhe82BXqsLm1toj10aODb1/hqRqQdvfSZ0RNeFjpQ/nvFOYVD3AaIsBm/BOaYMxuZoB03t9O8X5rHZgtGd5iOCpVUI/IQVYGqjTSogfplIyEsmA0TwxoqeckUNL/CQGzVTVmySZkLXhBX09NYMudHwXyfad0MsQQm0VM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sT49n5GY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sT49n5GY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D01D1F00A3A;
	Wed,  9 Sep 2026 14:25:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963926;
	bh=mYm7og5rpgX499qLzqYGK1Wn6Isvt0LzMDdVGiWLefQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sT49n5GYgNm4+khd/4awyblv5LMcOkUlJ3PaXjPDwQpG9XKSOm8lfU2DLxL82mL2g
	 mZ+vSuFzc/C9YRSLbEE/uLmpKLWFCTIlRcUhG9HYro0fcs87t+AYQ8KaTgK9p6Dm/2
	 hwr1/m4MYKlwX2ZxepJ94fXrQdpbQ4GF0+QhJ8tA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>
Subject: [PATCH 6.18 247/583] KVM: s390: Take srcu when importing watchpoint data
Date: Wed,  9 Sep 2026 15:38:52 +0200
Message-ID: <20260909134246.684016183@linuxfoundation.org>
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

commit a4e482def8533ebace517d9f67f1465841b1f982 upstream.

__import_wp_info() backs up the original guest memory contents of a
watchpoint with read_guest_abs(), which is kvm_read_guest() and therefore
resolves the memslot via __kvm_memslots(). That requires kvm->srcu (or
kvm->slots_lock) to be held, otherwise a concurrent memslot update can
free the memslots array under us once its SRCU grace period has elapsed.

As this is not fast path, following lock ordering (mutex first, then
srcu) take the big hammer and hold the srcu for the full import.

Fixes: 27291e2165b6 ("KVM: s390: hardware support for guest debugging")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Message-ID: <20260805110455.7200-7-borntraeger@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/kvm/kvm-s390.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -4445,8 +4445,10 @@ int kvm_arch_vcpu_ioctl_set_guest_debug(
 		/* enforce guest PER */
 		kvm_s390_set_cpuflags(vcpu, CPUSTAT_P);
 
-		if (dbg->control & KVM_GUESTDBG_USE_HW_BP)
-			rc = kvm_s390_import_bp_data(vcpu, dbg);
+		if (dbg->control & KVM_GUESTDBG_USE_HW_BP) {
+			scoped_guard(srcu, &vcpu->kvm->srcu)
+				rc = kvm_s390_import_bp_data(vcpu, dbg);
+		}
 	} else {
 		kvm_s390_clear_cpuflags(vcpu, CPUSTAT_P);
 		vcpu->arch.guestdbg.last_bp = 0;


