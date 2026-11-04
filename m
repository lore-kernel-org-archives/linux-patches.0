Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829113;
	b=lqyE5Q1ss/VUuwQ7OhGWaKJhdxpZptufwxWwMW5/bYR13CWKR3keCKrqL8ZU7W92xciF
	 pDbNN6/m44iIP/o10GkcITqOegOKDVgmPzvoX2N8jVEISvnJbiGCal6YyhWAc1uhqckai
	 pCsKgrKBp/e13DEXK6QVmEU6PFbbd8R6Yu2equhJ564Lu6/pWm4Hf1MhxLwEI8NjQqTEo
	 rtuZ8nBq85CFMjvorQIC5wdSnzV0/uzWwRk6eaMqScwKvP5Y6y6ouLM2yU0FWwDUuNayn
	 q872ynXDEqYoMiLRG1mvx1X5hCjRaLOFqdgqeZAYW7OaO+97fKJU5shEYiwIPTWf6Rg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829113;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HhPzwLiZBjZUs9EiBcAPHoU6d6305AgkUB12D3zu4zU=;
	b=VFWsOZmPH9iHGiCZwQlURn6bsWxjRwyVE/qy52ERN6As0rWcLz8i3KCjRXxguW4SiD5T
	 ICXGoBJQHhY8tmQEVk9co/5TbsFpv1+JLj1aTtPe2Edz/p91eXoU6rVwPh5zUrLYbmoQU
	 JDpGPt5gcxnDxwCd7OUzRDBKUIFEtxQ5z0P8U5ELj0oHLCfeZ4NBBZ6ylQ9cndJXp398u
	 wwHLoA/Iw25gTD5A8GeXJWyLxOfJD37kGLmC2Wx+f0jB0l/fBj1BAblfwJU8IHcqNSOoT
	 Aa0Iz3UPFwYXbk9xkjt36ELR6EhW5ex1OJzcyrOnxe4EoYhWeQErMN/jJar/Mcq4IHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jjXVIG79;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 805926073504;
	Wed,  4 Nov 2026 21:51:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jjXVIG79
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BE001F00919;
	Wed,  4 Nov 2026 21:51:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829113;
	bh=HhPzwLiZBjZUs9EiBcAPHoU6d6305AgkUB12D3zu4zU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jjXVIG7997k5LI4lWVm1CqmLqAkhk4bHptIEtKePVnizR1Dv1mpIVQAh5LtA0SfaK
	 pS8T4tqUK57uOiXz6e1ThuEBSw9ACv+amuUwl1NCNLRM21jlDF4yyZ5aI7OpV1P0KO
	 MXJLThqZj6roibvVKWaXcMiXo8VRqQwOWIxgJMyU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 7.3 454/547] KVM: Only bind memslot to guest_memfd instance for CREATE operations
Date: Wed,  4 Nov 2026 16:10:38 -0500
Message-ID: <20261104211051.252213766@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

commit 513333a5546017da2a4a6173bfb70372f83733b3 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 virt/kvm/kvm_main.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1758,10 +1758,10 @@ static void kvm_commit_memory_region(str
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
@@ -2121,7 +2121,7 @@ static int kvm_set_memory_region(struct
 	new->npages = npages;
 	new->flags = mem->flags;
 	new->userspace_addr = mem->userspace_addr;
-	if (mem->flags & KVM_MEM_GUEST_MEMFD) {
+	if (change == KVM_MR_CREATE && (mem->flags & KVM_MEM_GUEST_MEMFD)) {
 		r = kvm_gmem_bind(kvm, new, mem->guest_memfd, mem->guest_memfd_offset);
 		if (r)
 			goto out;
@@ -2134,7 +2134,7 @@ static int kvm_set_memory_region(struct
 	return 0;
 
 out_unbind:
-	if (mem->flags & KVM_MEM_GUEST_MEMFD)
+	if (change == KVM_MR_CREATE && (mem->flags & KVM_MEM_GUEST_MEMFD))
 		kvm_gmem_unbind(new);
 out:
 	kfree(new);


