Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209461;
	b=bvFJ9lSBH7BzxRDzocpUjQFDwMGphN5w7KIonLqNVRT7xksReZSJ684kXG+LEjGstlKA
	 cBRg8bxTE8rU+/+sXkiXABMEbgxwFfqHXp6TgrnbQFetJDRH5E3k6VHFICxBWK1O6zU68
	 9nXunJRrT7oXaiMdNrYMQK694MBLKvhPpAhxu875bDBAbVRTtOT+bRcCpv64bMTJs7/gT
	 Eyg41mvdcb1nSapf0R1r4xmPZ7IK/EllpCaNWhCcyu/k0U7X6juTALmGR2OMoyTOPkE+d
	 oM+UZb4osRMxhhzgqCpcd53NY4OosZ5It1/+YGJFfILq7SxNvC+xOGTi/VmeevYqi9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209461;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OzBEVghwASAWOlPjnKzq9Q+6cltqzyNoa1+4VkhPyZ8=;
	b=W3IjxVAyarVVw/OWhd2BK22HnTe3/MV1WOkBRYOJjDOm+QhS1KRG1euTRERXNY6konco
	 8miGuuXlKNN4PDjH4tj5UUsfMKh0PTYwMICSbx9RN77OV9aphgGE/DyB++aXxOLZSk9Qh
	 OZ5SC/90F+c5GBwLIFkkq7q+usfnCZ0kUuOuh9lQdMVAvVImm26RhykGbXeVRQZkswRBu
	 eyPCDK8mqg+6n+QbgZRAJ/wtMRxALQySeMIASEgbmGcQ7NJDsPbxxUAqHkInTA0c4QUbq
	 xZL96EhzV3o+Zay8Mj0dacJ9sio5C1fmm2v8kgrjUVeM/Jhe1paRiAYKPbjWxCfWqmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gOBGB1UL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D363B606A31C;
	Wed, 28 Oct 2026 17:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gOBGB1UL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F4EB1F01825;
	Wed, 28 Oct 2026 17:44:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209460;
	bh=OzBEVghwASAWOlPjnKzq9Q+6cltqzyNoa1+4VkhPyZ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gOBGB1UL+GfJHaPQTgsIYAHusoFYSkWgb0qOuhM7VRiJcE1C5FZuATZNvo4hNS6Sg
	 nnxbbXW62tBcZa2aFgL9pMeQBShiCx2DnlsG8nfa9wBVE53vRAH6bat4m6j5dNXMPe
	 wXnqSFzJcsQFTTqZ4A90oAJUd9qzruA10z975fxQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 480/516] KVM: x86/mmu: Preserve nested TDP shadow page tables if they are used as roots
Date: Wed, 28 Oct 2026 18:00:32 +0100
Message-ID: <20261028170014.850985458@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
[sean: resolve minor conflict due to lack of lockless aging in 5.10]
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/mmu/mmu.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 13cad4becfba0..d2428c76d940e 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2237,7 +2237,9 @@ static int mmu_page_zap_pte(struct kvm *kvm, struct kvm_mmu_page *sp,
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



