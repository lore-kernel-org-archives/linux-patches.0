Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207742;
	b=sEJAA7J7UJ3bgylKUNd3Zmgw7Yt/dP9c1LP3LAQsLzKcE3A6LzGqhqDsQtYpSd0fTq/6
	 qakSYQOrqUOSqwqi9k2ngUmPR6d4ECI7lUp/ZVbOJhsKR9Da9kZcG+Lu06ZS2KWCiyyZJ
	 9OvdptfH3TNriVq0nAPoCy1Ap4DUkAddNOn5i5VvdOdpyOMnT3ZR0qxXgDWCuvMHut+sF
	 +NeJyLTKs+1MTfXtUyfay3PHSpTY9a39KEN02k/U4oSsmkjHr6Rd9AxYosNhuphcZwmN3
	 JDc0JNyOkUHQihpRoyhnWw9Id6GzHYxg+NEY7YpK79k9Z+jo2OvnS6pJ9PmBi9kKY0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207742;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5flJNnvvza0HZO5E7uGvgdimqIxUunusiEOZuOPkND4=;
	b=fEiSVwFgwWlPPj9VNzeB84Xqp8viHgAqbp5MQ69iq645NhfGzpZmhbztLMGU0DqQAtKE
	 xQcBssy+Byfclw1mh4wFw/MP7nupmAeXKNHrQ3egFagWL0ddr1XKw2g8Vh/9dWYYRB1/M
	 yX+/C6tQhngh47jL3SbZykpo0nAGLOQvOH4qJXb+6R+s0Qc1XsyqlwgrodfYctw5OBZ8M
	 u4HQJ9wZB4WQzr/bBd7jdsphmXQRVGHcIKyH8bBjg0IuaMh3WH8fJzj5jQlSDIpp/siHg
	 2rToT2mkF2UpXAdJDTT2FXAE/j2mww7y7qxTxRYvQ9EOgNXA8LDr4mm6zQTdyOiT1oQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Jt2p6KEH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0BC5606A332;
	Wed, 28 Oct 2026 17:15:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Jt2p6KEH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDEA71F01828;
	Wed, 28 Oct 2026 17:15:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207741;
	bh=5flJNnvvza0HZO5E7uGvgdimqIxUunusiEOZuOPkND4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Jt2p6KEHtjv7oTVSmuckmwRdMw4radom/7p458x4CjMn7nOydmj6I2VMtajkeMpEL
	 wJyOM07DgEn2+mBVHmKYGRKFPORITXd3UMwe5IcCGHrHPppovm5u5dw3oeh0XM/YgT
	 CHe39EiyrY+yH6BCOzd+ttv9blCBsuGnci40T5Gk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 121/247] KVM: x86/mmu: Preserve nested TDP shadow page tables if they are used as roots
Date: Wed, 28 Oct 2026 17:58:44 +0100
Message-ID: <20261028165950.267900718@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
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
index ab6d3f565b0a1..1dfc568631e29 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2500,7 +2500,9 @@ static int mmu_page_zap_pte(struct kvm *kvm, struct kvm_mmu_page *sp,
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



