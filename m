Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 587B73FF883;
	Tue, 31 Mar 2026 16:40:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975252; cv=none; b=jrF8JB5OMmv3K+QzixHr5zdWrmE+facJNDacYmFRtFQFnthU68D+k8SSG2/e/Zhkb9O61mVtgqM48e8YR0KksbtsESjcITSZ7P048VTCDDAatXcuY7A0+mLwRNdBuyItj0wdLn8krVUP5bwSc885J6AVPCiKQVseMw0wWIx7C/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975252; c=relaxed/simple;
	bh=sejuvBTYCJcP7lFxsINjYoEuuGxU+SR7kAxvxY0JmJY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HU5EkYyp9QEmWfExmLOvMypmlebLDa39PR4MdXd0kWo4DEUN/vID1YfSyxR6t7ZwQBlrsn00qxfDpkMxBp3QxP+WiFPYTfDxA4LISsYsgtUF5nLDoqW/pJvEro4OQFuaTTVwRlScf/FFBtCFpNLcJYi1A+WHjVZ5oFx8vY3pdaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l1S2+FYl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l1S2+FYl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E201EC19423;
	Tue, 31 Mar 2026 16:40:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975252;
	bh=sejuvBTYCJcP7lFxsINjYoEuuGxU+SR7kAxvxY0JmJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l1S2+FYlNomr5OB2lBtWnUv/9Q+fSi9ODH/ET/BCAFYl5bhNagJlV0DFTrMpDhyid
	 Y8gAga7NRANDt6Q0M80a5RZpL6m8s7UCu5Zq/HmC5rZLwZPXCyeyuH/mkmm9itlNdN
	 X70NB7EBkG1u4btQicaHenNf+Jcv9dMoT0EI6GWg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 6.19 222/342] KVM: arm64: Discard PC update state on vcpu reset
Date: Tue, 31 Mar 2026 18:20:55 +0200
Message-ID: <20260331161807.141212915@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Zyngier <maz@kernel.org>

commit 1744a6ef48b9a48f017e3e1a0d05de0a6978396e upstream.

Our vcpu reset suffers from a particularly interesting flaw, as it
does not correctly deal with state that will have an effect on the
execution flow out of reset.

Take the following completely random example, never seen in the wild
and that never resulted in a couple of sleepless nights: /s

- vcpu-A issues a PSCI_CPU_OFF using the SMC conduit

- SMC being a trapped instruction (as opposed to HVC which is always
  normally executed), we annotate the vcpu as needing to skip the
  next instruction, which is the SMC itself

- vcpu-A is now safely off

- vcpu-B issues a PSCI_CPU_ON for vcpu-A, providing a starting PC

- vcpu-A gets reset, get the new PC, and is sent on its merry way

- right at the point of entering the guest, we notice that a PC
  increment is pending (remember the earlier SMC?)

- vcpu-A skips its first instruction...

What could possibly go wrong?

Well, I'm glad you asked. For pKVM as a NV guest, that first instruction
is extremely significant, as it indicates whether the CPU is booting
or resuming. Having skipped that instruction, nothing makes any sense
anymore, and CPU hotplugging fails.

This is all caused by the decoupling of PC update from the handling
of an exception that triggers such update, making it non-obvious
what affects what when.

Fix this train wreck by discarding all the PC-affecting state on
vcpu reset.

Fixes: f5e30680616ab ("KVM: arm64: Move __adjust_pc out of line")
Cc: stable@vger.kernel.org
Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Reviewed-by: Joey Gouly <joey.gouly@arm.com>
Link: https://patch.msgid.link/20260312140850.822968-1-maz@kernel.org
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/reset.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -247,6 +247,20 @@ void kvm_reset_vcpu(struct kvm_vcpu *vcp
 			kvm_vcpu_set_be(vcpu);
 
 		*vcpu_pc(vcpu) = target_pc;
+
+		/*
+		 * We may come from a state where either a PC update was
+		 * pending (SMC call resulting in PC being increpented to
+		 * skip the SMC) or a pending exception. Make sure we get
+		 * rid of all that, as this cannot be valid out of reset.
+		 *
+		 * Note that clearing the exception mask also clears PC
+		 * updates, but that's an implementation detail, and we
+		 * really want to make it explicit.
+		 */
+		vcpu_clear_flag(vcpu, PENDING_EXCEPTION);
+		vcpu_clear_flag(vcpu, EXCEPT_MASK);
+		vcpu_clear_flag(vcpu, INCREMENT_PC);
 		vcpu_set_reg(vcpu, 0, reset_state.r0);
 	}
 


