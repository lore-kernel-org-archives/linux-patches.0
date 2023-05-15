Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D55ADF40
	for <patches@lists.linux.dev>; Mon, 15 May 2023 16:38:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8345AC433D2;
	Mon, 15 May 2023 16:38:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684168710;
	bh=Mmt7n6/bL0fEivpxUSetOXviowAfVnF+KwqWtXG5aPs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yRdB8KtCgQ4Z+FLwJkeInFRcxbE/v5WAabG07T6IefbIaxPNWN7p5M1pTuUmyo1gD
	 qSU1x5FA19i9yR9wYLETgle3HHckJIhTyofwc3HDc24mkIvjfryIHvYjftwSxw4jd2
	 F5bc+w+ECs+6OBO9Twgl+RWIZRsgo8U4jl8QXPbU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathias Krause <minipli@grsecurity.net>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 4.19 017/191] KVM: nVMX: Emulate NOPs in L2, and PAUSE if its not intercepted
Date: Mon, 15 May 2023 18:24:14 +0200
Message-Id: <20230515161707.829276877@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161707.203549282@linuxfoundation.org>
References: <20230515161707.203549282@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sean Christopherson <seanjc@google.com>

commit 4984563823f0034d3533854c1b50e729f5191089 upstream.

Extend VMX's nested intercept logic for emulated instructions to handle
"pause" interception, in quotes because KVM's emulator doesn't filter out
NOPs when checking for nested intercepts.  Failure to allow emulation of
NOPs results in KVM injecting a #UD into L2 on any NOP that collides with
the emulator's definition of PAUSE, i.e. on all single-byte NOPs.

For PAUSE itself, honor L1's PAUSE-exiting control, but ignore PLE to
avoid unnecessarily injecting a #UD into L2.  Per the SDM, the first
execution of PAUSE after VM-Entry is treated as the beginning of a new
loop, i.e. will never trigger a PLE VM-Exit, and so L1 can't expect any
given execution of PAUSE to deterministically exit.

  ... the processor considers this execution to be the first execution of
  PAUSE in a loop. (It also does so for the first execution of PAUSE at
  CPL 0 after VM entry.)

All that said, the PLE side of things is currently a moot point, as KVM
doesn't expose PLE to L1.

Note, vmx_check_intercept() is still wildly broken when L1 wants to
intercept an instruction, as KVM injects a #UD instead of synthesizing a
nested VM-Exit.  That issue extends far beyond NOP/PAUSE and needs far
more effort to fix, i.e. is a problem for the future.

Fixes: 07721feee46b ("KVM: nVMX: Don't emulate instructions in guest mode")
Cc: Mathias Krause <minipli@grsecurity.net>
Cc: stable@vger.kernel.org
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Link: https://lore.kernel.org/r/20230405002359.418138-1-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/vmx/vmx.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -13878,6 +13878,21 @@ static int vmx_check_intercept(struct kv
 		/* FIXME: produce nested vmexit and return X86EMUL_INTERCEPTED.  */
 		break;
 
+	case x86_intercept_pause:
+		/*
+		 * PAUSE is a single-byte NOP with a REPE prefix, i.e. collides
+		 * with vanilla NOPs in the emulator.  Apply the interception
+		 * check only to actual PAUSE instructions.  Don't check
+		 * PAUSE-loop-exiting, software can't expect a given PAUSE to
+		 * exit, i.e. KVM is within its rights to allow L2 to execute
+		 * the PAUSE.
+		 */
+		if ((info->rep_prefix != REPE_PREFIX) ||
+		    !nested_cpu_has2(vmcs12, CPU_BASED_PAUSE_EXITING))
+			return X86EMUL_CONTINUE;
+
+		break;
+
 	/* TODO: check more intercepts... */
 	default:
 		break;


