Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590313;
	b=TtFyztOZdMkjOqAOlIFS7Y5AxkK08pBscIRXiSpjtecbaZ7d2qHiQ0W0krurcZDZJqLE
	 /VLzHoNS+IRjNmkx3YbEOEj+g4POxydMTGa4+sGV19wK446VTW2TnH7GerZzlKRAU9zY2
	 BMeSazJbvyzjwy55Me0nGBv4lOPM3Ckuo5ENtQRAP28vO4JpEgzIHfcqJsQRPltf/VWKs
	 hTxXbijUJKlsDuPDYCl5fQ40J1DXrB0wwqwpEEWZ/v1rUom5a8lDAFlM6wxJx5YqbLE04
	 WUl6e9584Pkk828tBSb2iwoR7om3yUOWnwRqWEsGOGPe/1ahXVVk6d87PvKJe3YU52A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590313;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wFb80sg1LijFBxyl2NLy7bhSB9gXk6oReFY4VYebEFE=;
	b=zc4bkkDhEzCvRV4y1HuegM/DpKMFitLKUidvZc7rQ4pw3orHBDoefmfnZXpkdKHpI5J8
	 hzdUB++XzgyzhbWP58dyNCThHvEVmGUe3XyoBqP4qsHAgFFtT/esJu734MMm3nwDtCojw
	 1OWedRlu13f+Qdhri5Tp9NvVIfes9RNuBEB/+cuyAS5jv6UW7etTfFV87DifYiP4YBgvB
	 ierdj7xeK1cGVNd1Tug3Q9h1YldyeUuRE5Qjz0LMp7KZ32kZsGYcz/q/bXGPO7yl3aioR
	 +COwn0a+HRs7w1V02QV0dHiz7as8GzS/Uf9o+biK4UWp/dPIqUUTzw4/dD++83Fi4+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oPdf8HEZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B500607D2EA;
	Fri, 13 Nov 2026 17:18:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oPdf8HEZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 478741F000C7;
	Fri, 13 Nov 2026 17:18:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590313;
	bh=wFb80sg1LijFBxyl2NLy7bhSB9gXk6oReFY4VYebEFE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oPdf8HEZjY8XYjKUSWkujsUY6C0B54Q7pjISkJWFgod+wBlnbIoo89nB2MLYTvPpH
	 zuVr/fbVy9Wsj/WgkCWkpx5MpclxMNF0qA4cyw1XQEoLlJ4ZiOJy9aygJsX1MIfeQX
	 Dbi3XVOdmeke5ZVe5WnQ5iBE52KdcNtTRRcHmbjc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Woodhouse <dwmw2@infradead.org>,
	Stefan Teodorescu <fane@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 297/686] KVM: nVMX: Process each host MSR entry at most once when unwinding failed VM-Entry
Date: Fri, 13 Nov 2026 10:47:10 -0500
Message-ID: <20261113153831.020879858@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index ab1558f1f9f8d..ffca5fef5b5ea 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5136,6 +5136,7 @@ static void nested_vmx_restore_host_state(struct kvm_vcpu *vcpu)
 					__func__, j, h.index, h.value);
 				goto vmabort;
 			}
+			break;
 		}
 	}
 
-- 
2.53.0



