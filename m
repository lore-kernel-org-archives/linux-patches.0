Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829128;
	b=YeRd3Os0pPrt48C1EQcvmtzaflfTOm8Qj4TC65H5BE42m8EGmQ8YTmRL/VzCeVq4J7FK
	 R0CcRHwIScMaR6qjlHleSgOTHtELhSeyMVobXAzYI9lvJQ2WV+L3GdowdKaXUvutlYq31
	 wPeoFdBbc2hWOFSJUAZnMmjrLSyqHDvFUgdSRiKYkrhrrGEWiNjKxUYwZpbMDhG+PSXOR
	 5YYzbIiCoUlxGzM/EdCmDrd11sOcflhP5cDsrmvGPkZhw/PTMMH44cxxUCV0823On/w30
	 6v4AB/5is0OXKdqAHwYv3jB+Yb8AQHG47dwpLDy428eh8FThOnUh8QbdwUuW3qRNvkQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829128;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Rz1VtUONunsZm4/779mlFpzH1cHsvzAEkdsuZsY1VIM=;
	b=Y2oQkd25qw3EAOiOMcFp0kFOBUR8OoX7qlQOTey3m379T3J2cUrTlx5KYhaT6Zn3dppw
	 Uojnm3qn4MxwbV7PwTPIuh3z1/BFl6gUBDt+IRUZID+ScAe9cYgkrSD+Arv2NuKzEKgs7
	 1LcERnOsPFh1Kgvl90FutuZ1DvZ/EEi9wOhBI90oVofYX4XENTNPP1o11RyiXS4xVn+GU
	 jWOsw7Xqw0jufcU+6SivS6CnMkzNOe8717Wi48qLye20f1chjpiH31uCmSh3VuJrRqpoE
	 +IHoaNv8cPesj1rnGVx89XUTkQR3DmTWaEw49PtJfkdcfaEUaVgGATZGecGSIKK3vsA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Mglx6/1h";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46C08607350D;
	Wed,  4 Nov 2026 21:52:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Mglx6/1h
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4F4F1F00919;
	Wed,  4 Nov 2026 21:52:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829128;
	bh=Rz1VtUONunsZm4/779mlFpzH1cHsvzAEkdsuZsY1VIM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Mglx6/1hc1E/kvr80V5ZFIQa+UubRM6N1iJ5MQH8O3jbmv26XNGIXKQna7RX0FoqO
	 Fw257y4n3AXWiDeZ/ztstGZooeZfNNbglqbCpSbBDgUIv8vuCygqICvKV/fIA8rPB5
	 0B70nn3DZg5FIsIcnzZRHxHbM2bdMiEmnY10Qgxw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 7.3 463/547] KVM: x86/mmu: Bug the VM if KVM attempts to walk more levels than the MMU has
Date: Wed,  4 Nov 2026 16:10:47 -0500
Message-ID: <20261104211051.508541187@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

commit 115f9405a2ed6d78ee7ad8436bdd638743f6d1d4 upstream.

Extend the "EFER.LMA && !CR4.PAE" check, which exists largely to guard
against KVM configuring a paging32 MMU with more than 2 levels of paging,
with a very explicit check for exactly that: that KVM isn't trying to walk
more levels of paging than the MMU template provides.  I.e. harden KVM
against all bugs that would cause KVM to generates accesses beyond the
bounds of guest_walker's arrays, regardless of how KVM ended up with the
misconfigured MMU.

Note, don't use w->cpu_role.base.level directly as the paging64 template
only provides two levels of page tables for PAE paging on 32-bit hosts, and
handles the third level by manually emulating the PDPTR access.

Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260902232028.2767071-4-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/mmu/paging_tmpl.h |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -367,13 +367,14 @@ retry_walk:
 	pte_access = ~0;
 
 	/*
-	 * Queue a page fault for injection if this assertion fails, as callers
-	 * assume that walker.fault contains sane info on a walk failure.  I.e.
-	 * avoid making the situation worse by inducing even worse badness
-	 * between when the assertion fails and when KVM kicks the vCPU out to
-	 * userspace (because the VM is bugged).
+	 * Queue a page fault for injection if any of the below assertions fail,
+	 * as callers assume that walker.fault contains sane info on a walk
+	 * failure.  I.e. avoid making the situation worse by inducing even
+	 * worse badness between when the assertion fails and when KVM kicks
+	 * the vCPU out to userspace (because the VM is bugged).
 	 */
-	if (KVM_BUG_ON(is_long_mode(vcpu) && !is_pae(vcpu), vcpu->kvm))
+	if (KVM_BUG_ON(is_long_mode(vcpu) && !is_pae(vcpu), vcpu->kvm) ||
+	    KVM_BUG_ON(walker->max_level > PT_MAX_FULL_LEVELS, vcpu->kvm))
 		goto error;
 
 	++walker->level;


