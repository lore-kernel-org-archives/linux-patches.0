Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829214;
	b=qhDhfTp0z3ouOyHl4igIjgLSl31ZTFzKe+MVUXefCBmpFUCTXPG8i9ULsgw/CTdy9YnI
	 hklFiX78uI5ZClSQ5qb/uR0/YbmZHGSkKCSK1drOkz1eWTUk7HP9yNFCjdUBmvjzng8tU
	 avWlKcyD4zlsNElxqrrC2Ted/N0TyHjhOdDn8K20k9tQdUINBKsI5cxE7tCQlQgE3VUgi
	 FxGNhqqCn9N7j4/6+PgZRNB8v1ijbDrYabNkIIUPh8QmteCxzZpwDAcDgA9HLgP6OUH5N
	 JhAVS+mIJMD7LBjMh0E4OuEThayZMO5fkvaQlQo15XGYadZkSaj3zrvE80H6gYw7RNA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829214;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fMHP57uxtatI1umv13DIkF+Px5SSXYltwk0g4PCKVEc=;
	b=OhjM8lHdZ/Li3OXijwPWp1NkSQVA4iS+orr3BoLs6q/1OdeyKpCPUbVEX5peCktG28fG
	 l3ypcwkv5vgCDp21FBEJMOuDSSbWAFyFarGFi+fgi41VWgH3+JbNGBcpEd42VnHyisEYo
	 3C6oSSs0JztLUPaMq860xyHcI3D+phgohMLEkfZJEeG5q+f979Y0/JesjPF4fJIL/8hih
	 oEMpC+0TMNSyFOXIEGjjiXYDPPLdKSWcwSnd7ZB65zLjFaVgS4qXUznBgtLNc4/HnEOpo
	 0FvXYo/Tgyy/uBqMiO83a16PAWs8Ni3CjziE1SqK0XVHeFmNpALKbZllt1hSqklpbKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AuZ4b64k;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 724E96070323;
	Wed,  4 Nov 2026 21:53:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AuZ4b64k
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9878A1F000C1;
	Wed,  4 Nov 2026 21:53:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829213;
	bh=fMHP57uxtatI1umv13DIkF+Px5SSXYltwk0g4PCKVEc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AuZ4b64ky8iMS15mKRiN39iHyd3UXvQectieDFdH9WE7zJ3TRn8FZTwRgr5xQ933j
	 LcuK3XfdEWtyoVD5Iq0DLni6STOntKS8RykZUbIOpx/Rt9Td2aYvqz6EyJLl/ua2/P
	 7n9blI1gjJCTPFCXlwm4a0yD2A9ZP9ISku4mhpo0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko Bot <sashiko-bot@kernel.org>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 7.3 480/547] KVM: guest_memfd: Establish memslot<=>guest_memfd bindings *after* memslot is ready
Date: Wed,  4 Nov 2026 16:11:04 -0500
Message-ID: <20261104211052.009940008@linuxfoundation.org>
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

commit 3fe5d2944e5ac3fc5073344b0982c73703332e18 upstream.

Wait to bind a memslot to a guest_memfd instance until *after* the memslot
is fully prepared, as creating the binding in guest_memfd will effectively
expose the memslot to readers.  As pointed out by Sashiko, binding the
memslot before it's ready to be exposed to the rest of the world can break
various memslot assumption and rules.  E.g. x86 could observe a NULL rmap
pointer if a PUNCH_HOLE hit the guest_memfd after the binding was created,
but before KVM made it through kvm_prepare_memory_region().

Fixes: a7800aa80ea4 ("KVM: Add KVM_CREATE_GUEST_MEMFD ioctl() for guest-specific backing memory")
Cc: stable@vger.kernel.org
Reported-by: Sashiko Bot <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/all/20260826170551.BEF801F000E9@smtp.kernel.org
Link: https://patch.msgid.link/20260922001332.1121266-6-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 virt/kvm/kvm_main.c |   36 +++++++++++++++++++-----------------
 1 file changed, 19 insertions(+), 17 deletions(-)

--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1950,6 +1950,15 @@ static int kvm_set_memslot(struct kvm *k
 	if (r)
 		goto err;
 
+	if (change == KVM_MR_CREATE && (new->flags & KVM_MEM_GUEST_MEMFD)) {
+		r = kvm_gmem_commit_memory_region(kvm, new);
+		if (r) {
+			kvm_arch_free_memslot(kvm, new);
+			kvm_destroy_dirty_bitmap(new);
+			goto err;
+		}
+	}
+
 	/*
 	 * For DELETE and MOVE, the working slot is now active as the INVALID
 	 * version of the old slot.  MOVE is particularly special as it reuses
@@ -2127,32 +2136,25 @@ static int kvm_set_memory_region(struct
 						   mem->guest_memfd_offset);
 		if (r)
 			goto out;
+	}
 
-		r = kvm_gmem_commit_memory_region(kvm, new);
+	r = kvm_set_memslot(kvm, old, new, change);
 
-		/*
-		 * Drop the reference to the file, even on success.  The file
-		 * pins KVM, not the other way 'round.  Active bindings are
-		 * invalidated if the file is closed before memslots are
-		 * destroyed.
-		 */
+	/*
+	 * Drop the reference to the gmem file, even on success.  The file pins
+	 * KVM, not the other way 'round.  Active bindings are invalidated if
+	 * the file is closed before memslots are destroyed.
+	 */
 #ifdef CONFIG_KVM_GUEST_MEMFD
-		 fput(new->gmem.file);
+	if (change == KVM_MR_CREATE && (mem->flags & KVM_MEM_GUEST_MEMFD))
+		fput(new->gmem.file);
 #endif
 
-		if (r)
-			goto out;
-	}
-
-	r = kvm_set_memslot(kvm, old, new, change);
 	if (r)
-		goto out_unbind;
+		goto out;
 
 	return 0;
 
-out_unbind:
-	if (change == KVM_MR_CREATE && (mem->flags & KVM_MEM_GUEST_MEMFD))
-		kvm_gmem_unbind(new);
 out:
 	kfree(new);
 	return r;


