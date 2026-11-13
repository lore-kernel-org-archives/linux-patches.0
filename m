Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590060;
	b=0T6ZMWmcw5JS3dBv4Rn4Y4rb6BfKCVtAZmQHOdz9Nag6AZizGVSbuod8PEQUZNeLLCY6
	 TvBD3DgNbbWPDmgZysPGT2T3up65a1Y4mVys+l9+B88C+cgBYu0DX/b9t3uhDAqhTAc1v
	 KOgZwRy5CeG0JPpE49r6INo30roF4uTg2yePLBjGC6NLKv/vbOzH9YcrJYx6oTttRLMfG
	 mChK8uw9gK3x1QMiWUvGeRAQk3D5yBnY9j34oH5Nim3e2ez+laxBoYAue9ygt2/y6jgsl
	 eP4GHLFvG70jLmnYyHQEaXHdBVN7I4Kzfxo6KO1mXkOqBnJOECsQjVvw76ccSUK9gEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590060;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uFp1DdKaottaOERb+lMLOwuBVxPNVJ5xrfRDKEpL2fU=;
	b=Dhn8GMDJc2H0gHKSvkU130HmBUCjO0uF+LlDHTd+isecX/1Th0Gtg11gNBa33JGT0PsR
	 cyxWPTsyHaB4Yaj8b8E8YYKDWm6+Wfxh/plgkEHA9OEq9Ep/WeKUjtcYEBC2TC2MHABDb
	 NKiJWY0OtDTcQ5YsEW3yPUMpGYwquNm95x4zd0ybABLZYDRmFHdis28cc6NyaCdIpjk+p
	 f4nO0mId/qWlLje4JXRyRBiKwG30HFxZ/O8EtwjAsYxoaYAJxHxeoUfakCp9M4iP6WR9P
	 EilDUtBkF7dmZMywW4TS3Tlf6xPVL38ncD0EKxSLSc4IFmUovCqXppYgn+qGtICx7ng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="A/QMtRSa";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C93A2606A8B5;
	Fri, 13 Nov 2026 17:14:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A/QMtRSa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75FC41F000C9;
	Fri, 13 Nov 2026 17:14:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590060;
	bh=uFp1DdKaottaOERb+lMLOwuBVxPNVJ5xrfRDKEpL2fU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A/QMtRSaP6JNm7jD6+dV0Ioc+JFBobDWhW/n9lUmqYBhfkicxM6eCvglQbnywoRwQ
	 RVtthSwThpY43j9JhKv7s7V52MPDb9idIe0Wqu6rlor+BCq4XUJhFb+m7fRtOpxOlF
	 mVp477KwKQLz+EAErVzJSq51pTkW9UU/P3fB89s0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 051/686] KVM: Harden and prepare for modifying existing guest_memfd memslots
Date: Fri, 13 Nov 2026 10:43:04 -0500
Message-ID: <20261113153822.688861579@linuxfoundation.org>
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

[ Upstream commit af62fe2494da84eb01752282c8228c9bb3fe9f67 ]

Unbind guest_memfd memslots if KVM commits a MOVE or FLAGS_ONLY memslot
change to harden against use-after-free, and to prepare for eventually
supporting dirty logging on guest_memfd memslots, at which point
FLAGS_ONLY changes will be expected/supported.

Add two separate WARNs, once to yell if a guest_memfd memslot is moved
(which KVM is never expected to allow/support), and again if the unbind()
is triggered, to help detect uAPI goofs prior to deliberately allowing
FLAGS_ONLY changes.

Link: https://patch.msgid.link/20251202020334.1171351-3-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Stable-dep-of: 513333a55460 ("KVM: Only bind memslot to guest_memfd instance for CREATE operations")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 virt/kvm/kvm_main.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 23e7d1bb80b04..297fd43b1da6c 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1748,6 +1748,12 @@ static void kvm_commit_memory_region(struct kvm *kvm,
 		kvm_free_memslot(kvm, old);
 		break;
 	case KVM_MR_MOVE:
+		/*
+		 * Moving a guest_memfd memslot isn't supported, and will never
+		 * be supported.
+		 */
+		WARN_ON_ONCE(old->flags & KVM_MEM_GUEST_MEMFD);
+		fallthrough;
 	case KVM_MR_FLAGS_ONLY:
 		/*
 		 * Free the dirty bitmap as needed; the below check encompasses
@@ -1756,6 +1762,15 @@ static void kvm_commit_memory_region(struct kvm *kvm,
 		if (old->dirty_bitmap && !new->dirty_bitmap)
 			kvm_destroy_dirty_bitmap(old);
 
+		/*
+		 * Unbind the guest_memfd instance as needed; the @new slot has
+		 * already created its own binding.  TODO: Drop the WARN when
+		 * dirty logging guest_memfd memslots is supported.  Until then,
+		 * flags-only changes on guest_memfd slots should be impossible.
+		 */
+		if (WARN_ON_ONCE(old->flags & KVM_MEM_GUEST_MEMFD))
+			kvm_gmem_unbind(old);
+
 		/*
 		 * The final quirk.  Free the detached, old slot, but only its
 		 * memory, not any metadata.  Metadata, including arch specific
-- 
2.53.0



