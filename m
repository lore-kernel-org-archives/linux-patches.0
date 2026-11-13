Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590062;
	b=PgFV3rIn/gpYvnAYHQLOWsJFFONsfrRu2CcM+iNX8i30VATfK4JQhtZw2MLsTO0Cns9j
	 rGsv/JtFlm8b4v4/TqKR8EF7M99Yz1yDPrYuAOYMn886X8625QTUWb2Gr39Wg6ZroKVnJ
	 eArTflYfl6/WX7vT/aC9NHIuW094U9BDprklMpAmUUqzNsDhdFuW3DsOSRhHJ45h9jN+O
	 lskpjnblqWbLX9UaNMPG5NS8NxyOSQOwLNq989Xpw5MV3kazdHEUsvGmMyvhQKsRPHaqj
	 pBlHNYX6QSw+oAs4ccaXy97WCTUldpfXgFqEeZw24VQF/hQEwsYhBcAEWhjCBLRIYzg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590062;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jFGDJTEpTxyLEPSTFXGq1F8I0UccUx1yam7oMcFjv5k=;
	b=C7O8J2dRn2EpK1NzWZW8uCpp0KdffHbgpJ2ynSxY+G5ImWiKmj/0KqFkLIWd8MXDRj2D
	 FfNvTz8Vjj6aRDA76YcHnKRJFKknKEyMOHPHsHdq42C5IWw6OfOGwcN68xwjiqcXxfjhJ
	 psNDgR/7iRb4v3pnnSF1WYrNoAQ8MpP8YoJfRnLbsCScosezivJuXfOAMQFQaxlBi1l37
	 hzo4G7u3Bxq2R8BzHigzgUEvaQnhBDArp6CDmt7BDD0wL+8m1Bom7XsMapFeTtxTm6nhn
	 B52mypkhjxXTZ+8uOHvCKF1YrZKVusSrKxEhiMsMeRxySSfzBEwV1MszBBlAV5OvP/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kWFcrLct;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1088B606A894;
	Fri, 13 Nov 2026 17:14:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kWFcrLct
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0AB91F000C5;
	Fri, 13 Nov 2026 17:14:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590061;
	bh=jFGDJTEpTxyLEPSTFXGq1F8I0UccUx1yam7oMcFjv5k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kWFcrLctfA21eKxc7b+9TPtFI436OlqubDqk3F7JAxRy/Fneb8OBwANmTXHkbF7/g
	 yQdRIwhqbMUR+oP0EfRfG8k01gDVPPSUU5vCIbhvyAOJY3hO2Df+ThqDQPQHgSJ3jq
	 6Yc8UdWqYke5PlCAnIER+bQox7igrRNwIx7mxiPU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 052/686] KVM: Only bind memslot to guest_memfd instance for CREATE operations
Date: Fri, 13 Nov 2026 10:43:05 -0500
Message-ID: <20261113153822.724856671@linuxfoundation.org>
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

[ Upstream commit 513333a5546017da2a4a6173bfb70372f83733b3 ]

For additional defense-in-depth, and to avoid having to handle impossible
unwind scenarios when binding to a memslot fails, bind a memslot to a gmem
instance only for CREATE operations, i.e. don't attempt to establish a
binding for MOVE and FLAGS_ONLY operations.  And when FLAGS_ONLY operations
are eventually supported (this is currently all dead code), creating a new
binding would be incorrect; KVM instead needs to do a 1:1 replacement of
the existing binding, i.e. FLAGS_ONLY will need its own dedicated handling.

Update the relevant TODO to make a better guess as to what needs to be done
to support toggling dirty logging for guest_memfd memslots.

Because it's dead code, no functional change intended.

Cc: stable@vger.kernel.org
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Link: https://patch.msgid.link/20260922001332.1121266-4-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 virt/kvm/kvm_main.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 297fd43b1da6c..5521743d6e8cb 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1763,10 +1763,10 @@ static void kvm_commit_memory_region(struct kvm *kvm,
 			kvm_destroy_dirty_bitmap(old);
 
 		/*
-		 * Unbind the guest_memfd instance as needed; the @new slot has
-		 * already created its own binding.  TODO: Drop the WARN when
-		 * dirty logging guest_memfd memslots is supported.  Until then,
-		 * flags-only changes on guest_memfd slots should be impossible.
+		 * TODO: Drop the WARN and do the unbind() call only for MOVE
+		 * when dirty logging guest_memfd memslots is supported.  Until
+		 * then, flags-only changes on guest_memfd slots should also be
+		 * impossible; unbind the old memslot for defense-in-depth.
 		 */
 		if (WARN_ON_ONCE(old->flags & KVM_MEM_GUEST_MEMFD))
 			kvm_gmem_unbind(old);
@@ -2127,7 +2127,7 @@ static int kvm_set_memory_region(struct kvm *kvm,
 	new->npages = npages;
 	new->flags = mem->flags;
 	new->userspace_addr = mem->userspace_addr;
-	if (mem->flags & KVM_MEM_GUEST_MEMFD) {
+	if (change == KVM_MR_CREATE && (mem->flags & KVM_MEM_GUEST_MEMFD)) {
 		r = kvm_gmem_bind(kvm, new, mem->guest_memfd, mem->guest_memfd_offset);
 		if (r)
 			goto out;
@@ -2140,7 +2140,7 @@ static int kvm_set_memory_region(struct kvm *kvm,
 	return 0;
 
 out_unbind:
-	if (mem->flags & KVM_MEM_GUEST_MEMFD)
+	if (change == KVM_MR_CREATE && (mem->flags & KVM_MEM_GUEST_MEMFD))
 		kvm_gmem_unbind(new);
 out:
 	kfree(new);
-- 
2.53.0



