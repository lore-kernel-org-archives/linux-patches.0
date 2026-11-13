Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591376;
	b=QMhb21e+udbj15hW2kuU58TrGWSSEZRtFfPm5o9l7SvA4NFdQP4M4+JqIxtrlkitYD1F
	 g2TgHmNsAc8dv3HtgYsJJaPJYoghef9FI8VjqnVRZglJtrCAYPg3nvAhiz2R2iHfMFIWi
	 RZQuPKvXvh5QtdPB4uk5kfUp6yFJc4/biaLI0jIqSLD410n2Ym6YW9TpPpYaAI6nHMirC
	 5bOrrG56kV1JjBLyxxJKaSHv0DiWyQio1v0WUedmG5CatB4G2O0ayAts0nJMs72Q4WlCZ
	 DtDdSdRLKtUUOtvVRrCphXb7H1OdcE8I7v4sAd60P43uZersxZZjttQBg3qXUgF9GSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591376;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0TKILPu8XbD4w/Nmo2aqYW28xGV1ch39TEuscvKIKcE=;
	b=gpA3oeye4qQurqIRrEaQ5STCeEULpE6YvrRzK1XV3XHoZAiO5/o1nHTCWxmnjzogXM0u
	 XfhJK1fQf8xRnXrcq8egftubeozQDSo5Z56IoPwDJFK9CODt8829qeQVEldl4kKHpNCH7
	 fz3ALCNAWPoZ28NnCptApmabIb+d3FMqy3p2NmEVM+iS632DGiy358xCwMUdlkguFMTjw
	 mLqMjaVgoKJA7jhmBWKJozWZvkW0C3Iwsiss588KEmR03p6XU3aQ5zyCA6JQcopAXTeF2
	 eblxxpSfzoEqIy54USiwihosNAWCNEwqPx3C+GUXUtLgUjAwjXPk02Ax0oibN5xWBPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RyvtPWmv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AF92606EDBD;
	Fri, 13 Nov 2026 17:36:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RyvtPWmv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA2A51F000C4;
	Fri, 13 Nov 2026 17:36:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591376;
	bh=0TKILPu8XbD4w/Nmo2aqYW28xGV1ch39TEuscvKIKcE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RyvtPWmvuC+v+vHQtYd5FXyVpIv+gEeHWiMNlbTzADNRXCzAQIFEyL4JSRQYZLa8i
	 kIsBECmkMVzrGpv6RS/lMUDzkhHB32t5TR39q3Gk6W3lSP9KEGjr0i6H7lXFQftLG3
	 jNzHmvuhmlsdsGw/Krw7Wv9AKoPIa7tKLS7wQBpw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko Bot <sashiko-bot@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 471/670] KVM: guest_memfd: Establish memslot<=>guest_memfd bindings *after* memslot is ready
Date: Fri, 13 Nov 2026 10:50:35 -0500
Message-ID: <20261113153827.923600792@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Replaced the CONFIG_KVM_GUEST_MEMFD guard on the relocated fput() with the older CONFIG_KVM_PRIVATE_MEM symbol, since the older tree still uses that name. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 virt/kvm/kvm_main.c | 34 ++++++++++++++++++----------------
 1 file changed, 18 insertions(+), 16 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 699198ae1594c..3fac4fe389ce3 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1932,6 +1932,15 @@ static int kvm_set_memslot(struct kvm *kvm,
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
@@ -2107,32 +2116,25 @@ int __kvm_set_memory_region(struct kvm *kvm,
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
 #ifdef CONFIG_KVM_PRIVATE_MEM
+	if (change == KVM_MR_CREATE && (mem->flags & KVM_MEM_GUEST_MEMFD))
 		fput(new->gmem.file);
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



