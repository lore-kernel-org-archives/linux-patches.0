Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037724;
	b=r93EaY+DTjwE3Iq5cGDTtVJ3E/U4QwWDRcRyBrTA3rizJpLqZMChzQKBY6sybSQxo8oV
	 ElzfFfuFOdYebEYWM5H6/gjmzENa4b7S7kPCah/mtvBzF3hx8kGv09v66W4WnCWckh40p
	 qfNJngLO29bzMC4Ggw5J74CRpm4MsWWUg6KO5ci3vfYp3xCy+pNs/+tCSenmOeCV2Zpzh
	 7GASJRh31r/Hqn2K7E0VKvvp10WWr5ROcbRHSv8X8ApP9y3YPOfE58QfsKP1Ja5g/UAKO
	 vHGsaxQtHBKrknEMYxyIpP2FI4pYoE6SLDo/g7ALr42n4ozr3fW/GZOe9nNXWVfhSng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037724;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Je3XGhhbnkdzgZdPiCf/0dSuMbdYnY+36z5sVhjkzHk=;
	b=ee2XJMPrpe7ut6aq0lVId+CvwVA+9Ed8tXWL+ab9dLm291/+lPRZLJ1F/BbLTUJsA8U+
	 rQFJzXmceMEV0jIHIlIHFpEF2ay0qIcJOTyR68Ik/a8a/IR0wm4L2+KMfd8ULRFTosTb+
	 nWwVRZ5gxOJOMEFO9uZHHfUxA74b156DYED6Bewtc31pgF7aixWz/CWKewbxvqfVeBTyk
	 KSz/WWZi6K4rXRQSnZI6Ny+EEqv4XD8XSeft+nxjj7rvna6Lj0sQzjujSeL2jLcfic+Wq
	 Q53u0CZ4mg3Tqnf65zGpBhh/L0e8m9DefTAIzR8eaPUDUNcu5E8oruUpsBjtJYOorbA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="HTUX/VKd";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78C4C606A320;
	Wed, 18 Nov 2026 21:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HTUX/VKd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE75D1F000C4;
	Wed, 18 Nov 2026 21:35:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037724;
	bh=Je3XGhhbnkdzgZdPiCf/0dSuMbdYnY+36z5sVhjkzHk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HTUX/VKd93NLFBo6MMT56ohS40QnmOLa6QBdNMfhWK+hgtt7qdL2Y4zaKqYVMJ/DO
	 XSWex7eB8A7ZM+lzYQENRxO1nuSq7pOdQJalvuZcfvapDNnVxS4f2zy/cx75fCSVo2
	 2eBib2AkCWz2aCxz5f8tM/hI9/AdMOHVchvy3jSY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Woodhouse <dwmw2@infradead.org>,
	Stefan Teodorescu <fane@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1470/3318] KVM: nVMX: Process each host MSR entry at most once when unwinding failed VM-Entry
Date: Wed, 18 Nov 2026 15:34:52 +0100
Message-ID: <20261118150404.996601398@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 38cfd4f968034..afff667c8ad9f 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4841,6 +4841,7 @@ static void nested_vmx_restore_host_state(struct kvm_vcpu *vcpu)
 					__func__, j, h.index, h.value);
 				goto vmabort;
 			}
+			break;
 		}
 	}
 
-- 
2.53.0



