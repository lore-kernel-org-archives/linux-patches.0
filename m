Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210119;
	b=glGTdxLjb1Q98Sgy4+N8jRQax6rNBspKvDq0K6u/TpsELl/Hl2Kwh6mtep5q+v/F8JWV
	 TP7arBKBbIOAiiDWGvYt/MLwMkvGUjOcz+wBlad0lEcmOdfLMWwXrpxnFKXJKzAQX6BF/
	 r1FBysYNnMEjOTOoK4FQ3FTciSd75wNIcsg/cg1DWqUJ4L3CxiD6Inqj7Ie6E+uoulF7l
	 RgpzFqs/RO3ngT+n2EaeqKGk0rnjvpDp0Ay4JnLnYFTD43Eou8yXUEG67tA3aLG7eN/vr
	 4K4VKXAa1MbVhfCwZgmPCKS55s7InJFiXWsD7KS/8tIDYASk56YlKQu+MmwzO3TscTg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210119;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LYDOoEIk4ZeNbFmoUODWbmIUgAGgdF9Hf+DCtI/MVT0=;
	b=qxlv2ZWNZLKNFGbSU3pJfS3kXzapW8wJdgjzZqweLCHgDQybBzwmkZJ2L5UMy06llnd7
	 9SDKQ22dO0fFfDfLR+i/svPIiyTe4DlaXpSJ5FiddOPFdk6KmEaQr5q0556uUR+0nEkUR
	 mlZgSUK3EOUfNQoSmLqyF/kTg57/Sl2VAO7AqMqCxCn+r6pQylnvWKrMGwLLlrXAkN5qk
	 Y07dBhF4TQpJ37XfCg3aocCOoOLv0oMlZxO6QF0axrfG48G/98MnwBjpgI0mdfT5wnV0z
	 00eJORc4mwY885wlbx+TDgx8zt5Sg3A7oY9B72v0ABcWEgyfBpnFGlokEBUWjZ63tjg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LOBwIk5s;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6863E606A31C;
	Wed, 28 Oct 2026 17:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LOBwIk5s
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFDA71F01825;
	Wed, 28 Oct 2026 17:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210119;
	bh=LYDOoEIk4ZeNbFmoUODWbmIUgAGgdF9Hf+DCtI/MVT0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LOBwIk5s729PXlq9pikrA0pBC6wlBf1OUQNubfYFZIdQ0aHKFgYojqiSKWJ6KpxI7
	 hpRjOTCNH/COw+/uIySoY2Yinr3EbLP/8IQEF1+kZ9NSuTUJb5Ci8EYWoBbCqs2Td9
	 HP6D45Q/uR3QDvK5V0ndcrIIfRLEekjmScNDoLxg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 082/168] KVM: x86/mmu: Preserve nested TDP shadow page tables if they are used as roots
Date: Wed, 28 Oct 2026 18:00:18 +0100
Message-ID: <20261028165945.027893664@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165943.089486480@linuxfoundation.org>
References: <20261028165943.089486480@linuxfoundation.org>
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
[sean: resolve minor conflict due to lack of lockless aging in 6.12]
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/mmu/mmu.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index b243cb405808a..5bff73562cbd1 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2508,7 +2508,9 @@ static int mmu_page_zap_pte(struct kvm *kvm, struct kvm_mmu_page *sp,
 			 * avoids retaining a large number of stale nested SPs.
 			 */
 			if (tdp_enabled && invalid_list &&
-			    child->role.guest_mode && !child->parent_ptes.val)
+			    child->role.guest_mode &&
+			    !child->root_count &&
+			    !child->parent_ptes.val)
 				return kvm_mmu_prepare_zap_page(kvm, child,
 								invalid_list);
 		}
-- 
2.53.0



