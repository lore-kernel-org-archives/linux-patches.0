Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591121;
	b=DOkKSpoQwvZKKGKtnbYlb2JCGv5u3701rR7CoRTZ7MPWMJZfjYGrrEvja4g0dkoNhHE8
	 hsD8cOobfwDTTlwTmKxloScydnkFq3ICcCMu+HYl22ulODTUWUk0uwLrjLCWeS2ahY8Lf
	 8/rgZj+BIhpNhSMfPPyKIsbINjSuPVYgd75OKSgz03VLSbGoI4wR/cu5SorHJkVZow6+f
	 hgYfpD9NIrJV7Xr2sc2Lfo6RVqZc+w1NDgVU54IFU7PNH5mZb3BeGS1q74jgdh+5HGscu
	 mkeeJsT0qahf9S1+Yyz0o5KjTpRp4L8VBzFJOFiD/+qbCaMW49QjTj0S3quohMjzvCA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591121;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pwBTXxHGxCWHQnvQiB3XfK8pL/ZKj2UBe2sBlVr/eb4=;
	b=mBmypstEiyBD0ml9evaPK4p0qt87k8WRrp8dMgjCwp+y+fhh1giCgKcJSdT8FJsT2B2W
	 PAevgSBplLoyTbJaJYjlp1bHCPMfcej1pq5k6fZbEas9Aa4H1j5Ha8OD8OXyyVzhZiC+T
	 M65CpDby3WdCCy4Tp9N8uEyBKOeNtl49XNKnhVreEgUhNIAcce6rbTg03deaxijPe/W11
	 NISfMFhwJM6VLk/JO8gahUml8kFhVLwElIkxmsgRTOfO7ox+K/NtH7NXoOXI+5rxAfcEo
	 KacCTVqhW8npdePVEbGnhy4Fy5bOCKiGkUBurKD0wadjIxYBs4QuEZFdC2DekBRt7pQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XuAHh8+3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E610E606A88C;
	Fri, 13 Nov 2026 17:32:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XuAHh8+3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 975BC1F000C6;
	Fri, 13 Nov 2026 17:32:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591120;
	bh=pwBTXxHGxCWHQnvQiB3XfK8pL/ZKj2UBe2sBlVr/eb4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XuAHh8+3MoOZG2U6uykQWtEVFwcz8ncTUCISTQXd+Qk5wdtp6YZ6jyaH9eylxK2GX
	 ZiqWSTKd/a7gC5QHcybnvYMiAHSu9SwZzoYC1MFqeVlgEfz3kkNzeOq20VJt/8XkHD
	 1XMp2rkFABW5bP5k+DdPBfnsqmxD3Ys7AnFWdujw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Teodorescu <fane@google.com>,
	Oren Yomtov <thenameisoren@gmail.com>,
	Chris Mason <mason@kernel.org>,
	Yosry Ahmed <yosry@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 270/670] KVM: x86: Unconditionally reset MMU context when emulating INIT
Date: Fri, 13 Nov 2026 10:47:14 -0500
Message-ID: <20261113153821.047236436@linuxfoundation.org>
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

[ Upstream commit c7c288d178cb0b78d3464a616b16b1aa0b316049 ]

Force an MMU reset when emulating an INIT even if paging was already
disabled, as the MMU page role includes guest_mode (L2), i.e. an INIT while
L2 is running with CR0.PG=0 will result in KVM running L1 with a stale MMU
context.

Alternatively, the reset could be scoped strictly to paging being enabled
or L2 being active, but SMM is also encoded in the page role.  Even though
it _should_ be impossible for the vCPU to be INIT'd while SMM is active,
there's zero value in not handling SMM.  At that point, the only scenario
where KVM _doesn't_ need to reset the MMU context is on an INIT with the
vCPU running in Real Mode or Unpaged Protect Mode, and while INIT in those
modes is somewhat common, it's far from a hot path and re-initializing the
MMU is not expensive, especially when the role isn't changing (KVM elides
most of the re-configuration in that case).

Note, like the Fixes commit, this bug only affects nested SVM as INIT is an
unconditional intercept on VMX, i.e. it's impossible to emulate INIT while
L2 is active.

Temporarily keep the guest TLB flush when CR0.PG is being cleared even
though it is fully redundant with the flush that is emitted on all INIT
events (KVM itself only does RESET when a vCPU is being created, i.e. when
CR0.PG must be '0').

Fixes: ed129ec9057f ("KVM: x86: forcibly leave nested mode on vCPU reset")
Reported-by: Stefan Teodorescu <fane@google.com>
Reported-by: Oren Yomtov <thenameisoren@gmail.com>
Reported-by: Chris Mason <mason@kernel.org>
Cc: stable@vger.kernel.org
Cc: Yosry Ahmed <yosry@kernel.org>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-ID: <20261022015407.279870-2-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/x86.c | 25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 627b5f53d1684..ee3b528ec1e27 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11796,18 +11796,23 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	kvm_x86_call(set_efer)(vcpu, 0);
 	kvm_x86_call(update_exception_bitmap)(vcpu);
 
+	if (old_cr0 & X86_CR0_PG)
+		kvm_make_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu);
+
 	/*
-	 * On the standard CR0/CR4/EFER modification paths, there are several
-	 * complex conditions determining whether the MMU has to be reset and/or
-	 * which PCIDs have to be flushed.  However, CR0.WP and the paging-related
-	 * bits in CR4 and EFER are irrelevant if CR0.PG was '0'; and a reset+flush
-	 * is needed anyway if CR0.PG was '1' (which can only happen for INIT, as
-	 * CR0 will be '0' prior to RESET).  So we only need to check CR0.PG here.
+	 * Unconditionally reset the MMU, even though super strictly speaking,
+	 * a MMU reset is only necessary if and only one of the page role bits
+	 * is changing.  All of the CR0/CR4/EFER bits effectively get covered
+	 * by checking CR0.PG=1, as CR0.WP and the paging-related bits in CR4
+	 * and EFER are irrelevant if CR0.PG was '0'.  Subtly, if the vCPU was
+	 * in guest mode (L2) or SMM (although emulating INIT in SMM _should_
+	 * be impossible), an MMU reset is also necessary as "guest mode" and
+	 * "smm" are both encoded in the shadow page role.  As a result, the
+	 * only scenarios where an MMU reset is *not* needed is if the vCPU is
+	 * in Real Mode or Unpaged Protected Mode, and micro-optimizing those
+	 * paths are not worth the risk of running with a stale MMU context.
 	 */
-	if (old_cr0 & X86_CR0_PG) {
-		kvm_make_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu);
-		kvm_mmu_reset_context(vcpu);
-	}
+	kvm_mmu_reset_context(vcpu);
 
 	/*
 	 * Intel's SDM states that all TLB entries are flushed on INIT.  AMD's
-- 
2.53.0



