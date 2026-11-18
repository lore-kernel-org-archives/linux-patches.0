Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046480;
	b=gL2u/jROINWwptECIo/K1RUJFGVsjwywuHLJQmJzwvm8WeKX1zaUIH3F1kaO/JtlalUE
	 vztUAWnVEtIgLOgbNDl6bcqsBNjy2nb30Y+EQxhEklyUMSChLdEtHX+AAhhSIaEJiJ0s/
	 jPufjQ78lD2d1VyFMEoeRdNtlA8HUqrkAH8yc8qX+O+5/lemgptSKKGlHqKIPMuD/tgyM
	 IOgvdc05XtLEvLxngENxPe3uYXEjxbQY1mCZ/B8z4pDqwh7AXeKZBlGzVZ0OpE/29ZOmc
	 LEjunxqGF5Qw7evbUF1VZFfw8NRNTqXa940FChW/Wuzt4cw9jdGTyIhzehb+OFwx59Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046480;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7vroiwv7YKnUKX+Z6MhUvJYkJS1i3jqGkTBxIldNofQ=;
	b=R1ic5mI5VoKhp7+1Kv4HVWRAsGT2T36TRZUO5PqPuwqMiOdKQ5K18hiLaCNsA+YILaPi
	 /3GzY9ZoWUZfy7F8F+WakUFmgtcqMM5jChog67TuRPUGchyTl54PxP+O688UKhH6TTqZR
	 agoPsilK7Z3p76IZYYNCkmsEkcollsAK4DIPiFI4S6mtgMYeuCe2m2iULujDL55EQHxfU
	 Q1XS/bMDNIWIhXQPc1Ig5rlQbo8kPoQ0i64A4/leyRO64avBitOVJ4XWprUga/q/m8E3u
	 UE5eeQ4GvmMiY/rFNTS6FrbzqBJ9gI/lZl0BBxD41YFkaYBGPZV5rwiHHHafCuGrrEw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FsAiq4jZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B99C2606A31C;
	Thu, 19 Nov 2026 00:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FsAiq4jZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFB8B1F000C4;
	Thu, 19 Nov 2026 00:01:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046480;
	bh=7vroiwv7YKnUKX+Z6MhUvJYkJS1i3jqGkTBxIldNofQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FsAiq4jZ58hjoqRJWLeTnZwKTaQFfaVvVMW+kuKsItJI4Sm/em+sdsfB+rYhEWNkn
	 QxTOU15BSDJem/oFrlcSEamTOM2cMpuQcmDMjSIds5WVrNYBnVHkbRxy/iS+HWrPPY
	 49HfHMYxuwiwF89Knx3/OOXE+v+VTmtFPdxq00hs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Woodhouse <dwmw2@infradead.org>,
	Stefan Teodorescu <fane@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1246/2857] KVM: x86: Conditionally resched when restarting REP string emulation
Date: Wed, 18 Nov 2026 15:38:00 +0100
Message-ID: <20261118150246.409927172@linuxfoundation.org>
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
index 0fcac00259cba..d9f8f2ce4ed25 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9062,10 +9062,12 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
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



