Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D93302F28;
	Mon, 10 Mar 2025 17:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627069; cv=none; b=Jcyu2vQLNKBh9mLMQZZoGFcihxNJS6CDxbhCVTBXNbl2lDRV9x8Slqd9oL+/lel9feRMu2JTivHPln3u0prkj64a0GpcMCRUef+mzA+iV5cJruyhtbrOr9VIv54G3+X6VKmCkLI63wCHgYnUyWzMtJUFYss/iM/MIiEZZ7c9d3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627069; c=relaxed/simple;
	bh=QmrS8jk5qbpb3vu5J6QFNSoCOmr6zGz54TaMG4fusIc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VxNHeZYBNPZCIDtyqZ8Xcq8K8XYzrNj+JfflLpvO4tAunUK0c9DCB2+Rda1EXNM/+xhZMPW/XSGJO9dhULMauBlHC5l3MqqSJpwdyT+tcRueOztDv4/y9IBVVgKJwEpoRft3qRjK7dF1Xqth0nQ8cFxkCMr86StTRCdkSThslIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HQcROO8B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HQcROO8B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63462C4CEE5;
	Mon, 10 Mar 2025 17:17:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627069;
	bh=QmrS8jk5qbpb3vu5J6QFNSoCOmr6zGz54TaMG4fusIc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HQcROO8BWYQ9IL8fquKTIaC0VZhRzM7uhcl0+fk+Yum15qvvfWopV5LsPIjPzPja2
	 oixbZfPIzr4b1KLH9gGNaYQ51wc9dCe1FywTeqTSa+NahXJN3ApMyTnLeY6sYKOt1A
	 JgMgP8XoJDeXA1e5cyeOQDCSQ73ODFWOu0yzrw60=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Ravi Bangoria <ravi.bangoria@amd.com>
Subject: [PATCH 6.13 178/207] KVM: x86: Snapshot the hosts DEBUGCTL after disabling IRQs
Date: Mon, 10 Mar 2025 18:06:11 +0100
Message-ID: <20250310170454.864976884@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170447.729440535@linuxfoundation.org>
References: <20250310170447.729440535@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

commit 189ecdb3e112da703ac0699f4ec76aa78122f911 upstream.

Snapshot the host's DEBUGCTL after disabling IRQs, as perf can toggle
debugctl bits from IRQ context, e.g. when enabling/disabling events via
smp_call_function_single().  Taking the snapshot (long) before IRQs are
disabled could result in KVM effectively clobbering DEBUGCTL due to using
a stale snapshot.

Cc: stable@vger.kernel.org
Reviewed-and-tested-by: Ravi Bangoria <ravi.bangoria@amd.com>
Link: https://lore.kernel.org/r/20250227222411.3490595-6-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/x86.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4976,7 +4976,6 @@ void kvm_arch_vcpu_load(struct kvm_vcpu
 
 	/* Save host pkru register if supported */
 	vcpu->arch.host_pkru = read_pkru();
-	vcpu->arch.host_debugctl = get_debugctlmsr();
 
 	/* Apply any externally detected TSC adjustments (due to suspend) */
 	if (unlikely(vcpu->arch.tsc_offset_adjustment)) {
@@ -10961,6 +10960,8 @@ static int vcpu_enter_guest(struct kvm_v
 		set_debugreg(0, 7);
 	}
 
+	vcpu->arch.host_debugctl = get_debugctlmsr();
+
 	guest_timing_enter_irqoff();
 
 	for (;;) {


