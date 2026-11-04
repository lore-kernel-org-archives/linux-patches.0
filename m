Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831813;
	b=3C/oEkNEfg8Sr1stvLgrbbcy2f7G31UsfFDYnEA2vFRdMDM87HJaTeTBddfeApHQZv8k
	 D4ipfsQhXSaxtx0P0RfGArdiCJ9DeU974cBBpoSvJMHZXmCr5O9xQryrFSCDGG2uAbaF6
	 fJ6cflBKDrLcoWYx16f2WHrMHXcTQwm2SUEcyOOxiWYLh8WCy3uZEcdKSkbzTVo6sXp7l
	 FJCL+wwpaLc2mTTOSFuTJGEGxLBsCaahj9H/UioomAWqQgLUv+dVay8n5+WkrwYofGMEq
	 ydJ3+5Lk96HoBAM5SB4DeJm0PG991xaYsUJDQ6aXPUV+A412KgF+g2IV5Qbce19cFZg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831813;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dCdrziLKap1h4t7ITgkIZuxWDubJ7l18dGM+slDpggM=;
	b=K7fAlRATAS5FFZ7tRv+OIkSmU0sEsIG+K1ucS6oi2b0ACUxD8pmDpGHxhi/E+cK6nWIe
	 az4N7Juo1x2ru+LfwtYptitop6umxYxa/yVT5vU9wZ2//X2tOXzSpOGguS9zvG4pEkPiD
	 wGPJDM+u8GJlC/Rx91WgWqy5QSkFjljbi7lIO2ny1vDEIXM8b9FYClw3xaPNJTsRHLv05
	 5OPNQbEJp1VDh9lZL/DvUfaQ1hMJlcUpUnkup5K9SXF0DePfY23wXuv/Du/RkMwU5pCei
	 Qatz/i1w9+zlCXKWWPPWjGIlYvdmKxRxDOrKY9ONXQF7/PZItd/kHjNx7gjJGTMHkdw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MmDbyuml;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9501A606A86B;
	Wed,  4 Nov 2026 22:36:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MmDbyuml
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D59C91F000C1;
	Wed,  4 Nov 2026 22:36:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831813;
	bh=dCdrziLKap1h4t7ITgkIZuxWDubJ7l18dGM+slDpggM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MmDbyumlhQicCyjFgvYU24++LeBJ6OqrRB5hP4FVd3YIHo0exlNzW+FhtjmZxJ1pR
	 BfNZkbUv7uN0n/hla09SS3qLOxeoYUERvc35E9lBC+xhi02qHGF8eoKNeLXpLalw7w
	 dPuCZkvCUFP5uDzvyKwu85zJwdyxC6K4v3JXaW1w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Ackerley Tng <ackerleytng@google.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.18 0927/1005] KVM: Use goto to handle errors during memslot preparation
Date: Wed,  4 Nov 2026 16:11:00 -0500
Message-ID: <20261104211109.103861261@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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
@@ -1937,21 +1937,8 @@ static int kvm_set_memslot(struct kvm *k
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
@@ -1983,6 +1970,20 @@ static int kvm_set_memslot(struct kvm *k
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


