Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829119;
	b=VrwOxaAjGvcgblPbPJq3gXzFvcRzBUEf5546mFDqTRS3ScGFdCjNWLoj5Xb/NPoJVOwC
	 xWvcRjEN/3QXs1+icq4SpLjLcIGmvaGw82xyEsMNDYIMNjp3JxjxKkZARYu4ykkXmKCAj
	 dSEsYGXXhRMHXLMxNuUAO+jkKh48Hyo47OvTp46YtjJqnWwQJ7hBJwX3dxLjhA45FI4gt
	 cYZqwQMXH2ltaoTdPCppY2yO80q8uiXJi1GufEwyIeZFO4UBVz/tZcbVkWpkVM5IrOdhh
	 YU9xFW0ZTll6NABfMufRwIwcR0BZMsxGCkR0p8KPMzp8XhcHpTz8wtVBkpLy+kjMeCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829119;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ytcQ0JOhEeIQUzLpadfvJg+ri4oAW3prkUOyU+zQnE4=;
	b=EXtCDMhjIqke8B6721M2Jq23TD8VfyYEGHKHGFXEKY8STQZzZR7+da9vvlCg88eQCFuB
	 YdTIJXWwg/GTIOBt4+0mG5CgcB6hDejxSz0uW37zO8LmBjp41RDQ+GfiTOBrkqLOwrbc5
	 r8qC8Rg11fCD+uwavWrC1OEmCk8102Latz4eHa2+IAWhWnWRaI6dbFWh6wG5PoHWxyxaW
	 iQsdap1PpfLxSY6WdypnXcv/RLXJurX3IAYZQKkcwrWD+W0/+YiFxC0IDPEou6OQWOoxs
	 EIQvf9E3MJreTqzSSEyki3nJZl2Cw7uh8sXQkSP0n0Spr+nfoHTWkFzdbKFPLfHGBvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GshkXUrm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F9BD6083627;
	Wed,  4 Nov 2026 21:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GshkXUrm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 004931F000C1;
	Wed,  4 Nov 2026 21:51:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829119;
	bh=ytcQ0JOhEeIQUzLpadfvJg+ri4oAW3prkUOyU+zQnE4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GshkXUrmybrXWcERkkIP1JpauDkOm0ZKlEdKGKoZ/rrcNhY4J+STfPnsmVknZQK96
	 2uw+Grz67ny5c+ElQj0IrKpjh78goIGWuzrlGFasEvd/FZPZENarsMKgccN3bU6w4Y
	 irvc/L3w+uDjN9PvtirRo+VEmFjmOd2f7/YbDd1I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Ackerley Tng <ackerleytng@google.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 7.3 458/547] KVM: Use goto to handle errors during memslot preparation
Date: Wed,  4 Nov 2026 16:10:42 -0500
Message-ID: <20261104211051.361134424@linuxfoundation.org>
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

commit 23a205797cec86f391d0be886b9bc741e1262063 upstream.

Use a goto to unwind early memslot changes if preparing for a memslot
operation fails.  This will allow moving the creation of guest_memfd
bindings into kvm_set_memslot() without needing to copy+paste the unwind
logic.

No functional change intended.

Cc: stable@vger.kernel.org
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Ackerley Tng <ackerleytng@google.com>
Link: https://patch.msgid.link/20260922001332.1121266-3-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 virt/kvm/kvm_main.c |   31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1947,21 +1947,8 @@ static int kvm_set_memslot(struct kvm *k
 	}
 
 	r = kvm_prepare_memory_region(kvm, old, new, change);
-	if (r) {
-		/*
-		 * For DELETE/MOVE, revert the above INVALID change.  No
-		 * modifications required since the original slot was preserved
-		 * in the inactive slots.  Changing the active memslots also
-		 * release slots_arch_lock.
-		 */
-		if (change == KVM_MR_DELETE || change == KVM_MR_MOVE) {
-			kvm_activate_memslot(kvm, invalid_slot, old);
-			kfree(invalid_slot);
-		} else {
-			mutex_unlock(&kvm->slots_arch_lock);
-		}
-		return r;
-	}
+	if (r)
+		goto err;
 
 	/*
 	 * For DELETE and MOVE, the working slot is now active as the INVALID
@@ -1993,6 +1980,20 @@ static int kvm_set_memslot(struct kvm *k
 	kvm_commit_memory_region(kvm, old, new, change);
 
 	return 0;
+
+err:
+	/*
+	 * For DELETE/MOVE, revert the above INVALID change.  No modifications
+	 * required since the original slot was preserved in the inactive slots.
+	 * Changing the active memslots also release slots_arch_lock.
+	 */
+	if (change == KVM_MR_DELETE || change == KVM_MR_MOVE) {
+		kvm_activate_memslot(kvm, invalid_slot, old);
+		kfree(invalid_slot);
+	} else {
+		mutex_unlock(&kvm->slots_arch_lock);
+	}
+	return r;
 }
 
 static bool kvm_check_memslot_overlap(struct kvm_memslots *slots, int id,


