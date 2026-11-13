Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590590;
	b=df81vzEU6XUn09BiPnUYjv0wEtkkHbSLfaYp98WM/8Jn5m2Ayg/Gd5D+qODZ/I+CBqz6
	 K73hS52CCtPtvWsrX+zEVNzregwme6Ayn6ueDka3Jcr8TBHD+z+KO8IP+V/vlBV0sjy0p
	 O0BlENZdPFIJ1lWn/jP1Zzu/LPhPNZ40puyK3zZyDNxfFuI6fsDJACqWpFphgnEhxfwvL
	 9d70hh/F+kB/+1C77xPQrr4RzYlUXli9MWMwouZGpKARG3tDgKg70QRBZn4R6RR/29Som
	 PfTjt8/Ya3toglFFDsvdzMV4bk0uxR1UbnDoxVkd3jQmE8namBprXsyjDVjINN3KtXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590590;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iBdl1ot4dwyMs3O6mWcNZ4cbQ+NNuHrFSyHIkH3Kdyo=;
	b=PFtIVqNspjDaN4wrKWZRYsbcCg7zaiuxO0OnyptiZKdfp9E6IapQi9Es7mXNy0k2QeVY
	 HwncgwsgtwONUXj1JlrZ4naXLTkM+4gu3qmwYH4jVR8XCgYhFqG9TTLCnPreOGScV5PJE
	 XwgjuA9w1wyx3qGbi59DnkelKC3s/1kViXo5gPMpXv7vAY+1NXjoexMDrkRKIZTN2gPB2
	 YKJj+JkXymuazjtSeL4fWIZXGtoovW1GXIIFuGAQieVOBrfGXfpnipdIPtII6aHUCpAef
	 N3kBkEDrLRdADo8HxCGPcYRxpdOxhpv5WABPVRuOKMXd/KSWU24IOJUhNZd+uDj2yuw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oWPcvJAf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9201C606A32E;
	Fri, 13 Nov 2026 17:23:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oWPcvJAf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E3081F000C7;
	Fri, 13 Nov 2026 17:23:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590590;
	bh=iBdl1ot4dwyMs3O6mWcNZ4cbQ+NNuHrFSyHIkH3Kdyo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oWPcvJAfj1Z0Rat919cbi/dTD2pvL7p0ynataxprxrkVTa2cRuJQ/FBwr3gNuoQ7g
	 Q5vxv+Rh0SdHcSXRIAA2cZJYidBtUpNgoU/caP6p8ttP8Oi59lK0Xtomq+w2ZfebD9
	 tI8rfY+jquAcGbUp+16i3ytrLsK3A2c1baY85IvI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko Bot <sashiko-bot@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 522/686] KVM: guest_memfd: Establish memslot<=>guest_memfd bindings *after* memslot is ready
Date: Fri, 13 Nov 2026 10:50:55 -0500
Message-ID: <20261113153838.823600942@linuxfoundation.org>
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

[ Upstream commit 3fe5d2944e5ac3fc5073344b0982c73703332e18 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 virt/kvm/kvm_main.c | 36 +++++++++++++++++++-----------------
 1 file changed, 19 insertions(+), 17 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 2354a4097dec4..723463fe60380 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1955,6 +1955,15 @@ static int kvm_set_memslot(struct kvm *kvm,
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
@@ -2132,32 +2141,25 @@ static int kvm_set_memory_region(struct kvm *kvm,
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
-- 
2.53.0



