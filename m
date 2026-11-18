Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060130;
	b=CSXJQ+3Pb59Bme2yZ/1IILEoOw8WyHtk9obK1nQ+/P93XMkHu3xvrLfkownvJHyP+JE9
	 uxyak6Cr6VT8ZiBRsTE9wEjIArN7O6JTWII+u+Yg7vEEcTvY0VU1aMx2BxsDbvpg128nf
	 /L0zRYVbwYGrj61Y1CApvBT7Cji7J5yEfe70s7GIiT9NHh/j40w7zpfhABX2C+jYKb6LO
	 Cueo6c+S6Awt5WQ3SBlrQrhV/5aNoC8FEyfcQh+DIc5wjs6GuDlTNLsSg9ieqmGpI8uWK
	 v0nu50NpcKyrRovf6R2UdCXc5u7jIsAQTG/sfExkgxHdlRY2K88gDybHSFrOXrZuerQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060130;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OJqUrNv2R1IfJi1evchuev6PAebDOvBIEi1H58VyIA8=;
	b=I4zOsdHJDnyDdy5YFMcQPPeFSq4Iz0WpWU17be/s88u6ekhKPN18iJzOUiOOywKifnpO
	 TbgzO4wkQaqIB7vWxLXcWijzd2vBGCtttfxVPpwCc6cb2DOo9Zd/jOIEB8gZb4mj2/XEt
	 2V4S6gcczJpnddsMf2+orLI8nOTS9YanUrRx/+hsaZfqo4ir6f2jq+s3uJAbkrdkORv8n
	 1kyXxKLFotQH7bzBANUSSdZDiJAW8G6yrKaOOBzBLfTaBBmozzSu12nhX86N556AsQPmu
	 hv3AAhwEFq8M5EXAbMQgELjyPCnqDvlr8qULokIn3HQSt/9uiGu8NHwG2sWRRp/vGeQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F+HgQwVE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6E64606A325;
	Thu, 19 Nov 2026 03:48:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F+HgQwVE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38E031F000C4;
	Thu, 19 Nov 2026 03:48:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060130;
	bh=OJqUrNv2R1IfJi1evchuev6PAebDOvBIEi1H58VyIA8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F+HgQwVEjVjG0HESaNj/KRf/6jMauBTWKCIKEqW5ciXuDz+82t9zlVCFYthlA3l8d
	 M/b3atlZt2xwEBvut2FIZhjttylyyvPmLwItrIGiMTSwyN0/+vBcDRlylOM/VMxFs2
	 ENMR4W4I4ySYVXpGU2Jxpt7/3cpByujYmprS6US4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Woodhouse <dwmw2@infradead.org>,
	Stefan Teodorescu <fane@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1089/1848] KVM: x86: Conditionally resched when restarting REP string emulation
Date: Wed, 18 Nov 2026 15:52:07 +0100
Message-ID: <20261118150004.321389047@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index d7236e8467316..58660d5de1413 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7720,10 +7720,12 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
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
 
 	if (writeback) {
 		unsigned long rflags = kvm_x86_ops.get_rflags(vcpu);
-- 
2.53.0



