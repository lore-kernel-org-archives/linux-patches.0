Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044615;
	b=JHYUqnS49pvqDbXU1CqwPmrCIqDZ+XaeCOmxgyjNfX/sF0i7REDvCS+WW5ta5bjDnjnA
	 tBJeagzp5tXUneFJQM3+8qR5815vZ14tEm0fdF8GoBOPLSCPS0OiMYD+H2raCMiwCC0Ph
	 F2Ht9/cMDrMYYRuEwIDTOO0VpYFJPCLgFuplSUAgZNLVfMxpJYEoaFnVYIZmbU2WCtVXZ
	 9yK5jMc6zDsCMWG0B8y3YFaDX4hRNELlkeirWnb/igh1tWAPhDoFJ7X2OYZojnfcGwUi8
	 SX31GdHEytu7lJwN33dmbD8cD44di48ixrehdsgdCLMkQQ9BcicUXL8dMlSgp6thO7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044615;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vfI/ItPpXWWlk7EGgNFxirnP5IMmiv6zy51lboEXpN0=;
	b=5UEGqCHG4z5VOHU1KjskRCwhBuV+s1h4g9415PP9pPftar6/P++7k9XTqm8ORH346GK7
	 QkmF98mxWGWHnyF/LAfQok3pA4K90iqOM0TlheyyQag1TPCqXefI1IWUpYoTCzTCVLsEo
	 4oK6KNmusX1gcyK854D99BZ0YJxXlk4s+bCkYKSINrQycWGTZW3nFCFvvYWsctUHw2Ea0
	 YktatvNEU7Vetncg2CVeHKhia4XzJAmgQf2o9IKWcgVoWo0rS6SZMwacF7XmHWZRmodaz
	 YYJcC5orJyeeBRM9XOxFX9uZ4yin0oTS6tXcHEOP8T0DRGHoYLUsz+du8vRB9s9Mn5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mpKtxUoF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02447606A325;
	Wed, 18 Nov 2026 23:30:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mpKtxUoF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 003291F000C4;
	Wed, 18 Nov 2026 23:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044614;
	bh=vfI/ItPpXWWlk7EGgNFxirnP5IMmiv6zy51lboEXpN0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mpKtxUoF2qyJg8DjdomovdL8fDOCNJYINR3Dh3H3h80uS2TBwRoc1OhSi7vIVa0f1
	 zrW3UaU6h+qBviR6LeDPJxlI0foQp1edgsrRb394QQ0fQrcY8cD9rGyomdHgjpTbcN
	 jv0eojoQ3sLDyEConcRbADDf0nQIRpK2EO4SOyVw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Ackerley Tng <ackerleytng@google.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.1 0623/2857] KVM: Use goto to handle errors during memslot preparation
Date: Wed, 18 Nov 2026 15:27:37 +0100
Message-ID: <20261118150223.921565375@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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
@@ -1866,21 +1866,8 @@ static int kvm_set_memslot(struct kvm *k
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
@@ -1912,6 +1899,20 @@ static int kvm_set_memslot(struct kvm *k
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


