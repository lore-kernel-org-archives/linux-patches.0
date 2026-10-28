Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211858;
	b=g5Yg9xzsiBDwMsR9LxxZ0EWn8PYaSWx9hIH6/3QOFlcZmNEwt3NakSRCnZeapiwJpchl
	 7LCdAODnqsRdFr2ydeKNMlndxY3Xks/GVf7p6Za/K01jYZroAFHuHXxHMAIa2wcA4tQDK
	 59n2PxOFFW0PP7eLERQz3H95VH01X9qJu6wR0m3hU5Pd3QaPYzS4cqHOfU2dPUptt4py1
	 R6wH8RGWi+rkg8pIKzRYSdt6AtEwfdb8JruLLXs0pxSyLiVw9D61pW2yJWY2BfWUFmojN
	 gNSr+px9snvD/REG4zM8kNYGYxSeozO+2h2gvGZe/ThbO5VnJDldg8CtaSLBinIV38A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211858;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EZNoA8R6eHqXEcITk8Y3iinS6mZ7Q0AFdjzeYgooY+I=;
	b=Ij5kMPvk7x/9lRx7XLyyCd6/2rBs1eblbNOcmFTO7EOGvxbY78oca8RAMP600XsWPl2q
	 PR1gkWbZ/oIsbgcxYYi5EoZimbipU9lO1nSwSHpK+iYYWClMTdVv/CqnR3UBUEIJhf781
	 f7T0mPNNYK6Wv7lqO6qaN8XsQedxylSpH94lYEEzREmDFPuZEC6XQGN9ll5SvXJWOqkTz
	 ArUBMdUMftAB6cEWDydlm4q47PZig9RHStkRWQsiSzxITYjZqiteXxaJ0B6kNLRws3951
	 yZMGWXEH0EJUb7OadK28uoy07OeBlrZlROR1GTJmevXEcT4zxvbYwVggSaCS4CDZJKQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=enQkn5Gz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A77E606A324;
	Wed, 28 Oct 2026 18:24:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=enQkn5Gz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85B751F01825;
	Wed, 28 Oct 2026 18:24:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211858;
	bh=EZNoA8R6eHqXEcITk8Y3iinS6mZ7Q0AFdjzeYgooY+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=enQkn5GzhWg/PbnwGdxyqMgv6v8aowvnJpbmqk0dxQA2OrlIinlib4yciNigOlxOA
	 fZXexwuKV3oQQ1xVGug3lenHjbBMRAEAjW0/Px+L0RKgoAFgmJlcK2HD+xfCSneDTI
	 RSpVXEVKpJ8G1dX9Ajne/aJk8gbCYlxv333L8mA4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 526/571] KVM: x86/mmu: Preserve nested TDP shadow page tables if they are used as roots
Date: Wed, 28 Oct 2026 18:01:13 +0100
Message-ID: <20261028170020.512080794@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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
[sean: resolve minor conflict due to lack of lockless aging in 5.15]
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/mmu/mmu.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 081547246801b..a768cbe23808c 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2336,7 +2336,9 @@ static int mmu_page_zap_pte(struct kvm *kvm, struct kvm_mmu_page *sp,
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



