Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053313;
	b=NCgq7y0eScnOWWjVQuVAIWsTwdPi+1o8wxlSyrBQZqTWMN5VvG2IFgT32WYrjDBfZiYK
	 J9d/vxL9196oo/1LUlU/gVeonHAKAAd5/rMopGYAIrwmUzYJsOu6ugWThbxlwncE3BjJO
	 I6eRCIOM2Zvg4slkDw4+4Pfpp6jsx1FGDQtujkY1mLProDd7ZZGKjtW5ySK7pfgIsHtr2
	 gQc7MFDcspLU2ttc+mLzisfGpRYmYdUk9MC9ZGroSQ2siLJowrMv0M4NsxW9+tkIGa+G7
	 IzdIPIeZfvaRproNmW09sjIaygLZFRWC3DeuPS+q7W5nfrtXZib3YKbyRymdMShFVCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053313;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bew8pu1WujLHlprQIsxH+JhqHPZa/WDSZsinDlHyib0=;
	b=CgOQsh3W6pEckMEBHxLWrcqEymliKlfa5nhywxTKKCVPwP+SNyTbtuohsG2ef8Qy+kdu
	 8HrsXGG+1MmdpzKRQ7XqAztCTkwCgzLvzUpEi2hS0JL1qljRhUXqdqCvTs10iV755jCuK
	 knCMZWvvI5mxZtDGx2ShGmZ0aLnklQvnAbjIsTqy/7+zTBkwQLiOm/D6GaIeYbG5w87nO
	 EzVGsv4su3i1fExf4hToCrLwngrYzRDElWmWE3tFOyVv7SozCwJIj3zzK+gtiWpYhZTnZ
	 4nKznPmW51bo1bbUJgazwidKCZ21bsszabYigffJ6x+VCH16aFEUXPCwaHBgNa25XvQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p+ExlNZ3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00843606A32A;
	Thu, 19 Nov 2026 01:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p+ExlNZ3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41FC01F000C5;
	Thu, 19 Nov 2026 01:55:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053312;
	bh=bew8pu1WujLHlprQIsxH+JhqHPZa/WDSZsinDlHyib0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p+ExlNZ3Ltzy69/FB0S3oENU5hn1nHmZiy/4NN5bbPufFBwwuKGj2R+JsHc6VDo1Y
	 4gYXiYK5WBA9Hv+NrnWqeWcg6km4AP8xryDGhFHxezvJPhp/Qxak0oubPJ8LDcjmDA
	 fgUN4Isq9k5A428uDjgeQGfmiyjqtOnDaGIIEDL8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Woodhouse <dwmw2@infradead.org>,
	Stefan Teodorescu <fane@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0874/2214] KVM: x86: Conditionally resched when restarting REP string emulation
Date: Wed, 18 Nov 2026 15:42:30 +0100
Message-ID: <20261118150047.097904619@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit ae85ac25eb671d174811cc3101549448671fd505 ]

When restarting emulation, e.g. of a REP-prefixed string instruction,
conditionally reschedule as emulating guest writes can be deceptively slow
and expensive, e.g. when shadow paging is in use and each write can trigger
write tracking.

In a perfect world, restarting emulation (or not) would be less arbitrary,
e.g. would honor not only host events (NEED_RESCHED, signals, etc.) but
also guest events (e.g. by checking kvm_vcpu_has_events()).  Unfortunately,
as pointed out by Sashiko, pio_in_emulated()'s read-ahead logic is baked
into the restart logic, as KVM relies on restarting emulation to drain the
cache and avoid duplicate reads from the I/O port.  I.e. re-entering the
guest on kvm_vcpu_has_events() or __xfer_to_guest_mode_work_pending() would
introduce architecturally-incorrect, guest-visible changes.

Fixes: 5cd21917da24 ("KVM: x86 emulator: restart string instruction without going back to a guest.")
Cc: stable@vger.kernel.org
Cc: David Woodhouse <dwmw2@infradead.org>
Reported-by: Stefan Teodorescu <fane@google.com>
Suggested-by: Stefan Teodorescu <fane@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-ID: <20261028173638.1765329-1-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/x86.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ccbd27f496488..34ca96e302c38 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8271,10 +8271,12 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 	} else if (vcpu->arch.complete_userspace_io) {
 		writeback = false;
 		r = 0;
-	} else if (r == EMULATION_RESTART)
+	} else if (r == EMULATION_RESTART) {
+		cond_resched();
 		goto restart;
-	else
+	} else {
 		r = 1;
+	}
 
 	if (writeback) {
 		unsigned long rflags = static_call(kvm_x86_get_rflags)(vcpu);
-- 
2.53.0



