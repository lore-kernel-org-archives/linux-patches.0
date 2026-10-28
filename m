Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793217046;
	b=ta9OhRJ3v4uIug820w+K2KVF/iYIgqpgz+zngZWr4N6PRGS0Bl8vp0BW0GikAxB/e0PN
	 tTFMX7Cfwpvs47vvmUNUNuU4oK17LTVD7fZU9VZ+pXWzbQp05BzYjkj3zhiLyvWcARwsQ
	 APiH0dxN/xTJ5naT9x+MgXZ8kIDICk0FpC4BTqpe58KnEmhXLSYr1Qf2i8H9rxcyuURVd
	 N6UjlQE/KHzaUPDon05WKq6/tqzpyGF9s3gI5WTFG0VOI+GvRUVupQSEk/Em4kUHiMcD/
	 fnUHLwj01vwy7Ky0r7tv5ry8kaK1D8Xu+guXUJ0BOHz3Vit29EXACd1+X/75YlNkflQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793217046;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UP5wv3tMDyBUgUBsciViTdCPV5zRwhYqIz7ZDZK19Xs=;
	b=BrqP0K4hByc3EwfTIFw2/jlSivghLQx9KpnQ6No/BlmBXAlgzbwPqhz2mYwJOJfKG3F9
	 HpCtnjOgk3VGM6TEQdT7a/t63Q8if8+N0sfyAGkjFFw0BdlaCyBwoFlILTKKCaJ2/owYQ
	 38sp+c0ChcAgnwFHg4plNxJPOGyZNz/GHsHYwVv/PMXQ1b4vt6AokKd4ZkMb/tnGM4lSm
	 +Q4pkXYqX22KP0BIqTCxb3UmsMi5qthx8yiox6y5huvGdmp4Cfn8oAXBYfkdn8bv9txDf
	 ZExDGqCT7AcMkvteTyYhYBcUEmNtkmzWsXoIdDjb8Gk5z7Hbq/m9CLoALiFNNCOyd5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0CQixXqY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6BBE606A320;
	Wed, 28 Oct 2026 19:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0CQixXqY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44DDD1F031E1;
	Wed, 28 Oct 2026 19:50:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793217045;
	bh=UP5wv3tMDyBUgUBsciViTdCPV5zRwhYqIz7ZDZK19Xs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0CQixXqYs6V+VHrVsw1Q+X7uEjhPPtKzTaH8Tx0uXgfUKIhiNOxJPI+Ls4rimVr+M
	 XyAiFtoR1claxykIeDnOTbj6sr0ae3ZQ3Ynt6EJZNfVa6j/y6G4Yb4pGfpYYIwfQes
	 MC109f8L4Zbaz6Ge8rr0MsBAhfxg6w2CU4YdchdM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1768/1887] KVM: x86/mmu: Preserve nested TDP shadow page tables if they are used as roots
Date: Wed, 28 Oct 2026 18:04:24 +0100
Message-ID: <20261028170539.688703621@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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
[sean: resolve minor conflict due to lack of lockless aging in 6.1]
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/mmu/mmu.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index d7f1fbf8a83d0..33e89555bb091 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2395,7 +2395,9 @@ static int mmu_page_zap_pte(struct kvm *kvm, struct kvm_mmu_page *sp,
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



