Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEE6E8462;
	Tue, 26 Aug 2025 12:50:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756212622; cv=none; b=r0iUxJYUs7qJajXqtyV6qIo4Ik+7PyymNHMmAY845EasZjEbJZ+HmJNCaLaeMVAY48FhKR0xEyYv5OYOSuZeALpKNqmKw+Xbi2L91FDoMe/77S2vA7/K3uZthopW7GvpY25O83DCUpB90EF3Ro9d/UZjve3BGKIMFCXaPZHn9oM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756212622; c=relaxed/simple;
	bh=LkHc0ki7iSCUM0EU93hjUnosD04JgMzE2QyPh5A8wWY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uFvtpczx7DxQPM2fcYOQOc7531TUtqvr+CYIwmfeFGGyNF+UValstmGF5SXLEkscX/k0bd7SAQtc5/gGl/G8SlyshaMyEax+qA6Hfx12gXvThlx0uwFLUTaDsznawcVQiWkzyTBmqITSMlCgGxaeudTHGd8Zv7ysXCXNTahuq4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MjTdQpVt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MjTdQpVt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61744C4CEF1;
	Tue, 26 Aug 2025 12:50:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756212622;
	bh=LkHc0ki7iSCUM0EU93hjUnosD04JgMzE2QyPh5A8wWY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MjTdQpVt241ZvasZdXtNJHHRQPts9iXIkZOocEhrtJAAEuMzJAWJIuBXnOLJzVAtv
	 V4DHYycnDzBxHqvFEL3+TSKv1845KlGiPnrmcX/hbKCj9gRC482mBigRGhPsE9xD2l
	 kNWDwtkjw0HYC9sFG9pMeHxkphvULcj+lf2xlEX8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>,
	Ravi Bangoria <ravi.bangoria@amd.com>
Subject: [PATCH 6.6 040/587] KVM: x86: Snapshot the hosts DEBUGCTL after disabling IRQs
Date: Tue, 26 Aug 2025 13:03:09 +0200
Message-ID: <20250826110953.968355734@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit 189ecdb3e112da703ac0699f4ec76aa78122f911 ]

Snapshot the host's DEBUGCTL after disabling IRQs, as perf can toggle
debugctl bits from IRQ context, e.g. when enabling/disabling events via
smp_call_function_single().  Taking the snapshot (long) before IRQs are
disabled could result in KVM effectively clobbering DEBUGCTL due to using
a stale snapshot.

Cc: stable@vger.kernel.org
Reviewed-and-tested-by: Ravi Bangoria <ravi.bangoria@amd.com>
Link: https://lore.kernel.org/r/20250227222411.3490595-6-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/x86.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7aff0fe469c3..9944b32b0b30 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4823,7 +4823,6 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 
 	/* Save host pkru register if supported */
 	vcpu->arch.host_pkru = read_pkru();
-	vcpu->arch.host_debugctl = get_debugctlmsr();
 
 	/* Apply any externally detected TSC adjustments (due to suspend) */
 	if (unlikely(vcpu->arch.tsc_offset_adjustment)) {
@@ -10782,6 +10781,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		set_debugreg(0, 7);
 	}
 
+	vcpu->arch.host_debugctl = get_debugctlmsr();
+
 	guest_timing_enter_irqoff();
 
 	for (;;) {
-- 
2.50.1



