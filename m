Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046362;
	b=2aGLMuZyvQF+NRFPa0OEHI8jVLJIwaGzrlwZaRK8RDVkYbwUS0WMuAgtGxhC3HtsCPi5
	 muc/UWu1E1ZOqA5R4CMyLICN0yCpfvGl44iCxHBBIf77L/weEy6rGABDlwCM8nDs6JMh6
	 mvkkq1bYyKL6Ocnff/zmPZ05J2C//W4w9BFuHGru0SmvW7bkuKanIRp+SiHmnicStCJ7u
	 T2bkkEzmc311ZyFo00dW9BAXLhX5qjjoQe1wGEgNu6JORanVO9vZ/Ly6wi6xwo4p/jW26
	 AeCQ1F0e8x3PSykwdcI9MnkWoO/t6WTOEsz87BYGlcu6hbpr7HqYgFfdLKCZxeQfd4w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046362;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Yx2/CJWBPFHVai1GxTvim+oiyIvz8sawrCHkYuusz5g=;
	b=4EZUZ59qh0t/kSFlMvQj4q8vxG5VqGZl5mxcTLWfEPXLtkMtn0X5JkVyNavcncmHbdV9
	 EPgJhzNI7NGjTeAOxdGB1tQDIbJ+kkliqQk0rDJwbTaMLqyBs51JLSJiUSuXrlIATGeqf
	 bdT49xa1ETZEKRQ/PIb+bdaXNYrQr5mS1ZskYQhRse9DTFug+QPZCa++x+/Dh5+75NEgZ
	 MM/Hbzp1E17i0Xqc4iJ78x6bnC2GKFyHWVPBPwcW0xDK9Prfst9lkfxqgo+0bPZ7oHrbp
	 kP31O3ny1v0+SkEDWBum97EQxxhmlpU/g+erciVCfRxCrpdbpjCk5LSwsk1SKLkLWpQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TbhclnS+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F37C606A320;
	Wed, 18 Nov 2026 23:59:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TbhclnS+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6D091F000C4;
	Wed, 18 Nov 2026 23:59:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046362;
	bh=Yx2/CJWBPFHVai1GxTvim+oiyIvz8sawrCHkYuusz5g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TbhclnS+a+NsANKs5oNatCIutC3lYAKgNgO/Nl7o7XZZM7W8kDSCzY/m/fuU7ozUW
	 UvNRAx5rMIPAdzM1PyTSnJoyQ7OA8XaiYpwpQFJnYQy8IYQbwPR408q98LkZCpC95L
	 X+xd8mtowOmFAVSEwAaOHpe6n5T6/vgGzXXxDl80=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Woodhouse <dwmw2@infradead.org>,
	Stefan Teodorescu <fane@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1247/2857] KVM: nVMX: Process each host MSR entry at most once when unwinding failed VM-Entry
Date: Wed, 18 Nov 2026 15:38:01 +0100
Message-ID: <20261118150246.447959145@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index fdca4b97ab9a6..96eedbc0ace67 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4766,6 +4766,7 @@ static void nested_vmx_restore_host_state(struct kvm_vcpu *vcpu)
 					__func__, j, h.index, h.value);
 				goto vmabort;
 			}
+			break;
 		}
 	}
 
-- 
2.53.0



