Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585575;
	b=uas88gxjVDOGdGlt3W1uY1SKpoqHYgY9plwRIljbvwkBZpbVy/JLZWcZER97/YraGs20
	 1uvEpjYSC/Mmx4qKlHUg2eKs3LaMzOrvt2vwklCdkwD6L8GhIPVgH/0xX5K16lYQfWdn2
	 U2IHAw/euF4Lq08CFksgD7G+p0n7FM72abo2/kQIr6ATisFh9zknRGknHrSFKkw/ozz7W
	 kNowmRXDL2gm4paYJoYqAhCdgb8VlCAIGAuOzeOsJDWEOcLV2p7xeGzm6bPmJin/+912f
	 TwC6DkFxbmHoyqM/tgTE3CL7vyleNlv4BPcR0rdoYAEtwHPhb+Tfus3GzHdgt+aVOjw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585575;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Q6JiT9G0U8KvSYNcPHypoxrKV5NzbpPnpVml2NW89Yk=;
	b=1N2D4BcRPN6xRnGu51CIn9DWjzmGg0Y77/pKAUmiy/YR1nSp+fB/wV9Ht4B7TnGOuZJc
	 opneYlWXb5ogtiI0u/1DGWwXE0rtt8/jVisoTXvuGMKs/q0eAMrPj0ZTBPqoulf5dooFs
	 r7G6N8KP1W3fV61FSpYo4nob2nhrAcXh79Dkw/HcQqNqljOAa9Pdey7O+kt9Lyf6P7TTE
	 yvKk84s4DXPZdMEMxsybpOHQDK0LLHlZEKjDvonAXs5Y36+JJw9/OJbFtbY9Kt0iPHkL6
	 zphFEBeGUj8k5XBn+SzQd+fvTem0zjeKQuG1bH+mKwIbtqm3MjWlUPpZR0c5wLH3NHw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mhuXOS5l;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AA6C606D2E5;
	Fri, 13 Nov 2026 15:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mhuXOS5l
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45E561F000C5;
	Fri, 13 Nov 2026 15:59:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585575;
	bh=Q6JiT9G0U8KvSYNcPHypoxrKV5NzbpPnpVml2NW89Yk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mhuXOS5lXyb8VLI3BC/NVlBCpkFZNLlLwO82nq1+a4P4VlXF8vupcBfv3uf1PdBi+
	 sKxbHyHkJEqMp7Bk2PxJFVChVpsiv00lBr2Hi05TixDzI2N7LsEmE/NOtKIFgXXYVz
	 4PfrRn61HcyQK31RYuZXI7yZhfxO9xVlwL/8vDkQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Woodhouse <dwmw2@infradead.org>,
	Stefan Teodorescu <fane@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 208/507] KVM: nVMX: Process each host MSR entry at most once when unwinding failed VM-Entry
Date: Fri, 13 Nov 2026 10:48:32 -0500
Message-ID: <20261113153801.529749133@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 5165275128fce..a1450c55e946c 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5059,6 +5059,7 @@ static void nested_vmx_restore_host_state(struct kvm_vcpu *vcpu)
 					__func__, j, h.index, h.value);
 				goto vmabort;
 			}
+			break;
 		}
 	}
 
-- 
2.53.0



