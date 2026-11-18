Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037693;
	b=xXioeVSYWPzFLj9iK1M1Sadjp7x730J05uYKgInOavK+CU7JcS9K5cfkjbMaromtsRaJ
	 aW4glbro5agkPxTgNvSsnkfk/bAq5Of5kid9UtES/RCQJhVfoSGhP1ctzs89AqZjRqcWi
	 WWfClnp5qOSDRdquOu8JPtruL1OsnT+LXM5jlVf+pmlJC071b34Nmmx054zGXg4K4nNFj
	 otfZxA2J+O59WHsWbthvYMjseEiOz8sujnIvQ2tANz1ZB1kM9o54EZV7pIZkR4oKlz9gw
	 wyvbDlZbYlz8wRLYXLHhJWDCrMQFIQTU+JE7rQGAvH9f9nFv0p0KbUjIGL/6B6oND6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037693;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=A80Bp4sRQq75YzGdWJ7wbfeWsVrXKyJYsxqa1NHMLyc=;
	b=5CV7peiH0jilj9I3+8F8Ey206+G4/OAPDzE+/bCEGgyD40dG/78gmhOlKGvyyEOLFkXD
	 M1hPiBMpUxR41WwKTW9C8jXbn/0caK4ERlQpOOx1rrTn19FThXfLoavIThVHGJjfj8W0D
	 p91gQODpwNXq0B3MqEa45xqiAdgvfs/oJLyo1BSMk8o6tUwlveeA2RAireRZ+mSv8ejri
	 kgmwksTjDNNNzD+R83HmtUrMTjm5AnrcPSQDanhW2jEjAnOtgf85P+f42SOQ37B6HzGkt
	 mW0+GGMBLTxIYJ+TeeZOibwazORz5jX0Ed4LMretmeIDfnlyyYvgK2MW2Flr4KjhH3g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nogLtBs4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D4EF606A31C;
	Wed, 18 Nov 2026 21:34:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nogLtBs4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88B341F000C6;
	Wed, 18 Nov 2026 21:34:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037693;
	bh=A80Bp4sRQq75YzGdWJ7wbfeWsVrXKyJYsxqa1NHMLyc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nogLtBs4GTJZCkJ37J5Tb6CduB2oPyd1S+HmvT8ZB2/Od3rdp8E6rpqag3ar3j1B5
	 OEEgzdt1TSb7SkD3jo9GD9V3AUplQCGA1wzM1nYUIKZkgv45gmrBOv2f0P9B47UFnx
	 XN/rmihIpg6nXwgZlZHEvrD2M5/ko7bRI2CRa/z0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Woodhouse <dwmw2@infradead.org>,
	Stefan Teodorescu <fane@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1469/3318] KVM: x86: Conditionally resched when restarting REP string emulation
Date: Wed, 18 Nov 2026 15:34:51 +0100
Message-ID: <20261118150404.965870155@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 1c785fc364b3f..a09ce0f97c22b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9130,10 +9130,12 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
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



