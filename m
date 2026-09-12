Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3188437F313;
	Sat, 12 Sep 2026 11:47:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789213669; cv=none; b=LqtfKXEkQBOap0P7YPskyhXjiL/wtY69eWm1DsDIslEC1Mg5LTCo60Cd+ZHU7ZwfpBUZ8pSSeLAWOzKO1wcwyE6VUvCHz6AyK3hSeO8OaFitYfYmE3n9tPYPHkRMpU15NX4UEKig9FH7EGJ2i7Kwf9RXpz7QLA/nZzmaILQ3xfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789213669; c=relaxed/simple;
	bh=l4+sJgxlJXMRc+ZG125VB4YQVoB34S4+WPLzMOvwJ0k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uAW2PNBnT2PPhVDHBBhRZc03n4WEjpXRqPcoh9p7Ed3o7PXQelCcVhHQgWxbU05KaklbmWVZOXR99YwgJydGW/gbN3b9IHRo90SOxyRpBg3s5WEBS8U+Fs/2UySS4dG6PvJ1jNhUe0u+ZuyTacHqZgFDy8tREMioRhYrYp9OZgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d+X+zawb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d+X+zawb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A39C61F000FF;
	Sat, 12 Sep 2026 11:47:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789213667;
	bh=rLmLd59xnSufSFPt3RDmzTiFgKRdQdsk9pT8sv/yIss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d+X+zawb2meaXqbtbXNKBFuL2vWBo+oLlFqIW4+0ZeMoPOUKZEOQugcBmcxrUampj
	 yhXTKeoI0gJSiAbsLmIe1u/gZEJs0TAzsGsXBrehZzXbk+0Kp4n+BPLHGNXPir8ALv
	 pVEobvzcurYns9cQlxcp0PNDNPtu2vExh/UVMSJU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>
Subject: [PATCH 6.12 0168/1376] KVM: s390: Take srcu when importing watchpoint data
Date: Sat, 12 Sep 2026 08:43:14 +0200
Message-ID: <20260912065611.295724260@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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
@@ -4393,8 +4393,10 @@ int kvm_arch_vcpu_ioctl_set_guest_debug(
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


