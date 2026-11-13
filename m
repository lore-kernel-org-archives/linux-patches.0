Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585574;
	b=o1ffLKA6rIdRGB3aOe/rF4ihtf2ttsv3Di0+Nw1dlbIrtBLwiPt87mbtZ2Q6I8czy2uq
	 7W7S6oYQ89x/UVSE32lzyNuTqssYYUbnNEjHnciGStyoQSNVZejf+M24FnvgfXJR5J+fh
	 ouPWbmdp8dTUiKKpO7AovAY/ABTNBHJkl5+N8/5rTw9HObaAw7Qej5M0cZK3kp0d9ln+c
	 HlO8LDK/EO9I+W3u5xJsAao0OcdaOwt8mSv0fo+XSSLpOzl7icPtd7NBuE1c3Q5XibUAZ
	 jUqvpTIjPccz//v3qls6OubenHYmyQqcOrw0dLXlSqXkS1pruv65E2UqYOnpVbPundw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585574;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=k3FJ40ICWtlVGd69ce5QwytL8HnYapQf1F6Tru+QP08=;
	b=K3U0z0U0YyktMv5r/Nq380R3BGiL/88GvvtQssIZd3L8yq4AWw/Cjn8JdNflibqor8cJ
	 WdXM0GdfkbmWo3kUJ/F6ObRn13W9vmEt7xk4Vd1Y4wLgWXRatku7tGlAT1fCI92slLP4N
	 aW08oN5MgNlqp0FJjacMgpDP5fxOutj7IUXvnpHs2+f5d1Bd3/A3KTu74Esne3fQm1O5c
	 i+5NqzlEq/w8M6nHFD6vosjDdxxIfUjXRmX3kmH4ROa9+BHAWp9480qFAmQ2jdbeLAcdr
	 vnDDkt1s0KYXCyFvP8vzRbieM5+2xIyo8VCMXpv4hz472lnMKyAomcqwyofwrut/zpw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nscQYyjY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CCFE606D2DD;
	Fri, 13 Nov 2026 15:59:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nscQYyjY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 084921F000C9;
	Fri, 13 Nov 2026 15:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585574;
	bh=k3FJ40ICWtlVGd69ce5QwytL8HnYapQf1F6Tru+QP08=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nscQYyjY9rPEbxOx2fdGaCVCgkFWpxAbPKS5mXfXMfUgDxAFjDgfRvEX96hpK4W0z
	 xUQ7RJRiTuaB3YmnZuwUPFPIqhOEChDgoU31A+MYSX4iBtuF2tv0Z+Smbf7h2OBGYl
	 7kLbbZ8h0wFD7ZnwoBV9gQulc5EbWgnDrG9zqMI8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Woodhouse <dwmw2@infradead.org>,
	Stefan Teodorescu <fane@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 207/507] KVM: x86: Conditionally resched when restarting REP string emulation
Date: Fri, 13 Nov 2026 10:48:31 -0500
Message-ID: <20261113153801.495212562@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

[ Upstream commit ae85ac25eb671d174811cc3101549448671fd505 ]

When restarting emulation, e.g. of a REP-prefixed string instruction,
conditionally reschedule as emulating guest writes can be deceptively slow
and expensive, e.g. when shadow paging is in use and each write can trigger
write tracking.

In a perfect world, restarting emulation (or not) would be less arbitrary,
e.g. would honor not only host events (NEED_RESCHED, signals, etc.) but
also guest events (e.g. by checking kvm_vcpu_has_events()).  Unfortunately,
as pointed out by Sashiko, pio_in_emulated()'s read-ahead logic is baked
into the restart logic, as KVM relies on restarting emulation to drain the
cache and avoid duplicate reads from the I/O port.  I.e. re-entering the
guest on kvm_vcpu_has_events() or __xfer_to_guest_mode_work_pending() would
introduce architecturally-incorrect, guest-visible changes.

Fixes: 5cd21917da24 ("KVM: x86 emulator: restart string instruction without going back to a guest.")
Cc: stable@vger.kernel.org
Cc: David Woodhouse <dwmw2@infradead.org>
Reported-by: Stefan Teodorescu <fane@google.com>
Suggested-by: Stefan Teodorescu <fane@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-ID: <20261028173638.1765329-1-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/x86.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c76498d1a162e..00e2e4587543b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6515,10 +6515,12 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 	} else if (vcpu->arch.complete_userspace_io) {
 		writeback = false;
 		r = 0;
-	} else if (r == EMULATION_RESTART)
+	} else if (r == EMULATION_RESTART) {
+		cond_resched();
 		goto restart;
-	else
+	} else {
 		r = 1;
+	}
 
 writeback:
 	if (writeback) {
-- 
2.53.0



