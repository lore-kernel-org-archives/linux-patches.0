Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94A9515CAD
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 13:58:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0276FC433C1;
	Tue,  8 Nov 2022 13:58:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667915925;
	bh=2XjGshoWrTJuBzN+PUbWGKdrgMGcQm2scPE/qJE8gLM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tMgVr4JbjCzYg5FyAKldo2nhaXedfGL+xjJMNxKnSRJGkyYTzuRIiavSw5YjCwYNN
	 HowjnqbVGuBBKOltwus7Zjy6tDw2DAXGfLlZPfc3WYRgKqMnfFF2Oz995O12EzFwEF
	 BYZ5sW5emaBC6udaQr5zPsPKzrbC4Xqo5x3BOaj0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Maxim Levitsky <mlevitsk@redhat.com>,
	"Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 005/144] KVM: x86: Trace re-injected exceptions
Date: Tue,  8 Nov 2022 14:38:02 +0100
Message-Id: <20221108133345.577514942@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133345.346704162@linuxfoundation.org>
References: <20221108133345.346704162@linuxfoundation.org>
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

[ Upstream commit a61d7c5432ac5a953bbcec17af031661c2bd201d ]

Trace exceptions that are re-injected, not just those that KVM is
injecting for the first time.  Debugging re-injection bugs is painful
enough as is, not having visibility into what KVM is doing only makes
things worse.

Delay propagating pending=>injected in the non-reinjection path so that
the tracing can properly identify reinjected exceptions.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
Message-Id: <25470690a38b4d2b32b6204875dd35676c65c9f2.1651440202.git.maciej.szmigiero@oracle.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Stable-dep-of: 5623f751bd9c ("KVM: x86: Treat #DBs from the emulator as fault-like (code and DR7.GD=1)")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/trace.h | 12 ++++++++----
 arch/x86/kvm/x86.c   | 16 +++++++++-------
 2 files changed, 17 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index 03ebe368333e..c41506ed8c7d 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -355,25 +355,29 @@ TRACE_EVENT(kvm_inj_virq,
  * Tracepoint for kvm interrupt injection:
  */
 TRACE_EVENT(kvm_inj_exception,
-	TP_PROTO(unsigned exception, bool has_error, unsigned error_code),
-	TP_ARGS(exception, has_error, error_code),
+	TP_PROTO(unsigned exception, bool has_error, unsigned error_code,
+		 bool reinjected),
+	TP_ARGS(exception, has_error, error_code, reinjected),
 
 	TP_STRUCT__entry(
 		__field(	u8,	exception	)
 		__field(	u8,	has_error	)
 		__field(	u32,	error_code	)
+		__field(	bool,	reinjected	)
 	),
 
 	TP_fast_assign(
 		__entry->exception	= exception;
 		__entry->has_error	= has_error;
 		__entry->error_code	= error_code;
+		__entry->reinjected	= reinjected;
 	),
 
-	TP_printk("%s (0x%x)",
+	TP_printk("%s (0x%x)%s",
 		  __print_symbolic(__entry->exception, kvm_trace_sym_exc),
 		  /* FIXME: don't print error_code if not present */
-		  __entry->has_error ? __entry->error_code : 0)
+		  __entry->has_error ? __entry->error_code : 0,
+		  __entry->reinjected ? " [reinjected]" : "")
 );
 
 /*
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 8648799d48f8..c171ca2bb85a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9010,6 +9010,11 @@ int kvm_check_nested_events(struct kvm_vcpu *vcpu)
 
 static void kvm_inject_exception(struct kvm_vcpu *vcpu)
 {
+	trace_kvm_inj_exception(vcpu->arch.exception.nr,
+				vcpu->arch.exception.has_error_code,
+				vcpu->arch.exception.error_code,
+				vcpu->arch.exception.injected);
+
 	if (vcpu->arch.exception.error_code && !is_protmode(vcpu))
 		vcpu->arch.exception.error_code = false;
 	static_call(kvm_x86_queue_exception)(vcpu);
@@ -9067,13 +9072,6 @@ static int inject_pending_event(struct kvm_vcpu *vcpu, bool *req_immediate_exit)
 
 	/* try to inject new event if pending */
 	if (vcpu->arch.exception.pending) {
-		trace_kvm_inj_exception(vcpu->arch.exception.nr,
-					vcpu->arch.exception.has_error_code,
-					vcpu->arch.exception.error_code);
-
-		vcpu->arch.exception.pending = false;
-		vcpu->arch.exception.injected = true;
-
 		if (exception_type(vcpu->arch.exception.nr) == EXCPT_FAULT)
 			__kvm_set_rflags(vcpu, kvm_get_rflags(vcpu) |
 					     X86_EFLAGS_RF);
@@ -9087,6 +9085,10 @@ static int inject_pending_event(struct kvm_vcpu *vcpu, bool *req_immediate_exit)
 		}
 
 		kvm_inject_exception(vcpu);
+
+		vcpu->arch.exception.pending = false;
+		vcpu->arch.exception.injected = true;
+
 		can_inject = false;
 	}
 
-- 
2.35.1



