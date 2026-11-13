Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591118;
	b=nQFzs30JteS6jNwvCVktUwRov32WY+N2WndrmJDVz13c3emryF7WUQs4SANxDfHeJKp+
	 hkvK6f6e08rib6sRV+cUoQO/Xo3vAuvWKektI+/h4bUc0wteUI4cvILJwrNlSpxQTg4ms
	 aFhJ21EaBXQhh3CKnnou034RZY6RFeGDpV7/DECkXQHif48DzqocY1NJQ0iy1c+ekvjXH
	 p41tdVfLL77kGegipx6SPrBLiV48QTr1qV/E+4tnAwgk7U3TiAbya+RJytRvLIF+abz+0
	 +kuXy9pa+FWfKTQPU5VQEYNLA2F2zpaCDoXxc/HmfxMwAvqVt+nHmXixio/DSdNEcMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591118;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SJpmLj6tFo1FmcmeOOAdgAHCEtHEUTWjTXuXJ2ANhDU=;
	b=Rn3Q8VE75QV9SI9fqzmTvecbxdvFOBX1WPmEAK3KtxbVWkXfWiaHFZbieB0IZRMklbc/
	 k7/R7/p3PIWugo03FDVLEXHN8Xi+2ce6CMPz/ncLGBXC2TJVc15+heFAPACMkCVJcAymI
	 7wMUm0ynLq7SkaA4h/Ktbln0gpp5Q0QzwantsWGmd2HbyvsQFNjC3XfwIOGJS2LpndGkk
	 nF1IMYQ9jgMH8UaXVvdchbWzMDA3Av+DkkHUQyGD7acaOvV0Ac8/QIDl0Vko8plZdVLr9
	 uHS6yjiRmaaQbSmEJAZh+t71SMHXKtmF73jfm7XpBPDe5VjeHsV+hMPbYhhCox20cTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aZmBg2eI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72A52606A88C;
	Fri, 13 Nov 2026 17:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aZmBg2eI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EAD91F000C4;
	Fri, 13 Nov 2026 17:31:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591118;
	bh=SJpmLj6tFo1FmcmeOOAdgAHCEtHEUTWjTXuXJ2ANhDU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aZmBg2eIVx2gyI/BVcqfvHKz2drBD3QNGRujyMeAVYCa+MF/umKgXsHS91AVkE9dF
	 5Gt1NqlFbaycR9mOb4HdUdF8mchySbUt6tJ0/mFIgosxhCQ6IzMcZvBUQyEoEDNT6E
	 ldQRvnvMn/GAP+jWE2LDYFmRdjex1mgbiA3mVSbI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Woodhouse <dwmw2@infradead.org>,
	Stefan Teodorescu <fane@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 268/670] KVM: nVMX: Process each host MSR entry at most once when unwinding failed VM-Entry
Date: Fri, 13 Nov 2026 10:47:12 -0500
Message-ID: <20261113153820.976144336@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit c33ef9d334059f7cb167569ed7b4779752fe4425 ]

Add a missing "break" in the inner for-loop of the open coded mess that
unwinds MSRs back to the pre-VM-Enter state when VMLAUNCH/VMRESUME VM-Fails
due to a consistency check that is caught by hardware but missed by KVM.
I.e. move on to the next MSR in the VM-Entry load list after performing a
write using a value found in the VM-Exit load list.  Processing *every*
matching entry in the VM-Exit load list makes the processing quadratic,
which is problematic if the load lists are full of MSRs that are expensive
to emulate.  E.g. writing APIC_BASE triggers kvm_recalculate_apic_map() and
a whole pile of unnecessary work.

Functionally, arbitrarily restoring the value of the first matching entry
is "fine", because none of this is architecturally correct: the load lists
are never supposed to have been used in the first place.  In practice, it's
likely a moot point as no well-behaved VMM will have multiple, diverging
entries in the load lists.

Fixes: bd18bffca353 ("KVM: nVMX: restore host state in nested_vmx_vmexit for VMFail")
Cc: stable@vger.kernel.org
Cc: David Woodhouse <dwmw2@infradead.org>
Reported-by: Stefan Teodorescu <fane@google.com>
Suggested-by: Stefan Teodorescu <fane@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-ID: <20261027185917.1478906-1-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/vmx/nested.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index c2aae9db372d1..88654327a7072 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4968,6 +4968,7 @@ static void nested_vmx_restore_host_state(struct kvm_vcpu *vcpu)
 					__func__, j, h.index, h.value);
 				goto vmabort;
 			}
+			break;
 		}
 	}
 
-- 
2.53.0



