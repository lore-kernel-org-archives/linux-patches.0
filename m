Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831819;
	b=EwoDYIrPVWDGTlu4uZ3I3ZpDctNsY8VTKzaAuZH3JChQYGeZpL94pDYI2jmJBZ6mupzk
	 CgBpv2gtHfcwuTg750ruw3HVYGJlnPheKh+TKdVSh3oh2BXRLlmNFzjH5tjbfxxuMO6uo
	 dwM7Dcgl2W5M6AxRLnYUG1HA7pvPjxjF2XT04YubaETcWsyY308E736tF4UUsQP8HPZVw
	 76C/4F200+a2y8Vs3HZ6riyJ+2py3l/hPa/4+1tMc+KBs6kPY2IVd0gtFFX5ghRFY6D3j
	 xanoiuKMOZOm+UWHg6ph1sCKU7mqrPij+xQpO8UwlANtaKbNFohWaM5GQZJavo74AVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831819;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=647kDBaZEnDL8PtZo2JffOwWfUjjoW4Xmc+IhFCfX4Y=;
	b=GKa+WYzIf7Tfc5ZTpJDYZaR9lTx7mAamVnhBN8AfqX2jGtL4ihoid0TUsdhFNsSDA6pI
	 zC4LWgknW3CxmZr19uLrTH/qzBvmOeoA0FFA8kgnSXzsRYO6noqrQhXBdb0ViRbImDmr/
	 7Q6aaTrv+Tsxh3LS7cXmErNCu18sX7Z8xy0B1avYxOHm/yylQn99hQfco3k9alGaGAHli
	 +D4LDhUpO97ynkkfFHftk5uptx5/EUTLo107mqnLwbGnL4uw/H8Wr9eioD5idV4TJScKs
	 wlPHv9kBoWNA6vhcmX7Z249xPjlz/oSCnlH7Z3/vklvM6Yy8ZRb8doVKM/Ezos02Ysg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xF2riPOm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92CD5606A847;
	Wed,  4 Nov 2026 22:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xF2riPOm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BEF41F000C1;
	Wed,  4 Nov 2026 22:36:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831819;
	bh=647kDBaZEnDL8PtZo2JffOwWfUjjoW4Xmc+IhFCfX4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xF2riPOmJ7stxgJjA+vVVX+iS4I4bnCsIRHqsKsp/rzIoSxZCep8kL3mW6Feklqob
	 YI+WcTreyvNy4MbMyc0DFQFkYQEXKVNEOD27AbPf7amamS6gtJMVasLNZKyUORSbGV
	 jiJaKuAzNIioVdDRaOrmdT4g8eceVoybtuloxYjw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.18 0931/1005] KVM: x86/mmu: Bug the VM if KVM attempts to walk more levels than the MMU has
Date: Wed,  4 Nov 2026 16:11:04 -0500
Message-ID: <20261104211109.212622348@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -349,13 +349,14 @@ retry_walk:
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


