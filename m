Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774173;
	b=lQnErD+gCFsUPLqW8Iu1KxoTkqvX0mlKSLE3Iq1UZPcD5R4B7GXO7WIyLDOepmP1BbDA
	 I1ge+Xy/b/BIAv5B8Z2Nc1/lutCwpKwd53xtnSo7YRZlCcIZKtbecxDYpmO8Q6jTXs6fW
	 N70PpY6oSVWoggSRugymSrfvi/QiGhI71AG/Fm/+4nWz3iMhbHooqs58TK69hGcvuwbbI
	 02KLrJbgcI9r7+VjUbiNMnUHoeKdDb+L5q3hxKnkdrtJoyNIsE3VfvyfGfI8RpIjXWXjg
	 oS5veFzcfGVqW/GqKHMhpVLY+pc+YbDnUH0xjqWsM9EVW98Nkcennk4LAQ4jjzUDSJQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774173;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4tYMeib50uGngD/fKnrDQF3E+2eda2J+N7fVBan9apA=;
	b=ZgLcvXwwwY6siiF13jiEPYYPFU0kTPqYcWL94a3Reni6QbA/jHIhHNHAmfh6NfwuXV9S
	 6tnMRSa9phy6lpEoI+JpKYoSmGK9XGp67PTSRxFIvfxrdsVdR6uN2gp1k2dGfeMlLczZW
	 03s178oz6VFHJyssTtiNOH2eefpXyNIyG3cAKMqCdn1sRdkQgv70MthFoHgHpdaRjtEVC
	 zcgRhKTUKlCkuX1xomD+d1mHVMpejlS+yet+hHH4h3FX+WGBTM7WqxNhP3v+PXNjBgEBb
	 7r7JA1QOKtPqBiex8hsV+9oqk1m1mVRSoU/TYfOm3TBgO9glhWUU59daxywY7mm/azA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="2RN88qN/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E93E606A31B;
	Fri, 23 Oct 2026 16:49:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2RN88qN/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 051C11F01825;
	Fri, 23 Oct 2026 16:49:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774172;
	bh=4tYMeib50uGngD/fKnrDQF3E+2eda2J+N7fVBan9apA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2RN88qN/rl9GCWqW+DhHh+1tVSdwVB589VfQT1RzmVRcDYLZWjnnQMDu+RMPf3vJO
	 T9Zg8A46EirHw5KiTc7fA2RV3csAsHFvWACHc0gb4lOeSckTQun40hIkWkTuYRalQP
	 Ad+M8fp1az17F40FIhqPqJkGuSUlkKlLywocAOww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 146/193] KVM: x86/mmu: Preserve nested TDP shadow page tables if they are used as roots
Date: Fri, 23 Oct 2026 18:37:03 +0200
Message-ID: <20261023163717.663703579@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
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

From: Hyunwoo Kim <imv4bel@gmail.com>

[ Upstream commit 7a2c70e777a00c32ebafd376a6fe31ebb91c5b20 ]

kvm_mmu_zap_oldest_mmu_pages() excludes a shadow page whose root_count
is non-zero from top-level reclaim, because such a page cannot be
freed. The path in mmu_page_zap_pte() that recursively zaps a parentless
nested TDP child has no such check. As a result, a shadow page can
be zapped even if the page itself can't be freed; as the comment in
kvm_mmu_zap_oldest_mmu_pages() notes, zapping it will just force vCPUs
to rebuild the page.

As in top-level reclaim, do not recursively prepare zapping of a
nested TDP child whose root_count is non-zero.

Fixes: 2de4085cccea ("KVM: x86/MMU: Recursively zap nested TDP SPs when zapping last/only parent")
Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/mmu/mmu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 205d314a7583c..1fa251ca4dccf 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2630,6 +2630,7 @@ static int mmu_page_zap_pte(struct kvm *kvm, struct kvm_mmu_page *sp,
 			 */
 			if (tdp_enabled && invalid_list &&
 			    child->role.guest_mode &&
+			    !child->root_count &&
 			    !atomic_long_read(&child->parent_ptes.val))
 				return kvm_mmu_prepare_zap_page(kvm, child,
 								invalid_list);
-- 
2.53.0



