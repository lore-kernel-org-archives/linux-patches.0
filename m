Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22D3222B8BD;
	Mon, 10 Mar 2025 17:29:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627746; cv=none; b=qqhFeYnt0sc9QzrG37H+Fd5VT6m9elSF0Dj19y51HkV2txk5QGyOlxCexItwBgo5xaBbasNfUGHL1nSJMQu+wFl7rzS+aC9cMTuLHHbpXzCPDPBjfBF4QFVGCLBiBplKIgy8KkvvAXKjcnz3/BMRehaVTjvJhL3MZX+k25CidjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627746; c=relaxed/simple;
	bh=P8w0EUESsupqAXa9REAYQF3tOOxAkklGFrNSjv1vcVs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pM43aWHA2PHgD4d6zF7QF3i8UIlGFa2erWN4EkOS/x/OwrsEqBkerK/p6tEjWS1FoeK1ra3/0RGPivgnatVSzijWPSvwV2bTj/IqmC/dUxG7bazGKtfLU3L4qDzOLBD0EMXAEfeMYeaerGYPrvcfqP4ySfdmIfUMVGNAJX/9aUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jBByCuCX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jBByCuCX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1F49C4CEE5;
	Mon, 10 Mar 2025 17:29:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627746;
	bh=P8w0EUESsupqAXa9REAYQF3tOOxAkklGFrNSjv1vcVs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jBByCuCXbTH1KVOn+DODVuYOHmC4kEYit03eS3IubOkLdKqeBsGoOZCpSvbrd5dWs
	 WpMvE1IE5h1rx8tTIAo/M4drK3EGPzh+IiR/Db/9K3tYy+4CzDyrm+r8DyNLa9j8Cz
	 htvjdhZdXT9r3B5DnGN/W/yxH6sqPC2JLRDINzgU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Ravi Bangoria <ravi.bangoria@amd.com>
Subject: [PATCH 6.12 235/269] KVM: x86: Snapshot the hosts DEBUGCTL after disabling IRQs
Date: Mon, 10 Mar 2025 18:06:28 +0100
Message-ID: <20250310170507.052998604@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
References: <20250310170457.700086763@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4993,7 +4993,6 @@ void kvm_arch_vcpu_load(struct kvm_vcpu
 
 	/* Save host pkru register if supported */
 	vcpu->arch.host_pkru = read_pkru();
-	vcpu->arch.host_debugctl = get_debugctlmsr();
 
 	/* Apply any externally detected TSC adjustments (due to suspend) */
 	if (unlikely(vcpu->arch.tsc_offset_adjustment)) {
@@ -10965,6 +10964,8 @@ static int vcpu_enter_guest(struct kvm_v
 		set_debugreg(0, 7);
 	}
 
+	vcpu->arch.host_debugctl = get_debugctlmsr();
+
 	guest_timing_enter_irqoff();
 
 	for (;;) {


