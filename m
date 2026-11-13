Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590839;
	b=eCn99Nnabz0V2vN3ImTrxIw/572HVccbvFo5qBjNIOKHmgk6FEWi8yRJBWMQvFo6uN91
	 JhtpawcBJRMPGfxEp4dNJ5S3EHLYXAjqDMEXGjyTKea35kExUonkwjBdbWsaqTGRuOB2V
	 kB0a3bedY5ifezdxTYGl0T6JMcdqGbYNFhf8yVlvBHXCKBpxNQ0KwHOo1TtbxLrVXaiil
	 RAvgDEv+FIQeQ7qIywHkzV3xJLS5yUdQFTIJpCXBYSvc9HI6u+LQoONpT/RvTGMv7harV
	 Wf+mNTNiTEQP1w2nQb4yOvgkKYrw9CpJcuxrl1vNIIAQnbvqHscbDfydCToF+L0g2AQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590839;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Z3DWaM0sD2pWYkSxJU6sfSUl6X4Ll5i6vlywn/wOo3M=;
	b=WS4SGP/FfM8gq7CBejYFx0GTkeWv9Si1dJuSNuL7kSU87zjl5+NqBa/UFpus3uKejC54
	 9Fcu0VeoC5N0tAY+5rCbo1SpIYLjGSd8eKVGy1kVpUs7e85Q0KYmxOx0AJvyzH4z4Is41
	 LIXsH5HuoBDYy6d770T+ome6dUmeUkMfARakvk5MUdC5SChur9QebT+C9UHHv8i1fVrJe
	 bWzXZ4yd0umiMu8Un/2YnbqJ7CgTYyCc4q6t9UsLRYu6pKTCgihW1l3kXdsJTZU/R6bzU
	 JKPWwjo/CFjVEzlpynxYfrt9xOI+iG9/OtoeOmsIPZxy6VgILZ82zQgtwgUqa6TQbrA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SFMw4kT7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93797607E07B;
	Fri, 13 Nov 2026 17:27:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SFMw4kT7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FDF21F000C4;
	Fri, 13 Nov 2026 17:27:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590839;
	bh=Z3DWaM0sD2pWYkSxJU6sfSUl6X4Ll5i6vlywn/wOo3M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SFMw4kT7Cj3LI5dgytd7OUGw89EcW570b/xyPCkyFuHeSNJLD01RlcPdvCOrGanit
	 3PVZ1LvYsAF1OiQcCGd4zZBHQT199fKa0sbmpv77PTtBXtpPkys2t5S9mg1AX/N8hm
	 ofAZmhD6aYAWxI4mCVqDLo4LGEmnCK9CNZxxvcrA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 041/670] KVM: Harden and prepare for modifying existing guest_memfd memslots
Date: Fri, 13 Nov 2026 10:43:25 -0500
Message-ID: <20261113153812.551511340@linuxfoundation.org>
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
index 7debedc1ddaae..0d017f75c5a11 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1725,6 +1725,12 @@ static void kvm_commit_memory_region(struct kvm *kvm,
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
@@ -1733,6 +1739,15 @@ static void kvm_commit_memory_region(struct kvm *kvm,
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



