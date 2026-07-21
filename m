Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A51638839E;
	Tue, 21 Jul 2026 20:50:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667021; cv=none; b=PLgzUlIA9mZiwSvhPOTZJ7IfIlUURd5+pqV7/8EJoBdXvLE+uFoOmTC+HDtW6/tBLxFAuyWlKo4uhGwpAcLC0ruJiuezSG8Csm07LL7YOGn9k9ucaLP0lmkc6XnkX/b4jrHywuG4PU8LYk1QbpY9fHZt3LharBmbLPe1ZtZUia4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667021; c=relaxed/simple;
	bh=B+iIOgge19MynL4Xang937NMAySz/9gEqYAhBXfkQmM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fUO8VHkJ8h8L4GO18tOyW1mCqtZpzFVmvHZxfc3kprF+E0z8UTN+oCihhBMSY3f0b8CX8j8rxlGnOMpusfte21JzOKs3m+DB7EQaHTel435ZOgK3+GEavcAHrvrVHWzUoyTJlf4YuLp3Q+8CRfM1R/m+Qfz5E4Sy8acJmYPKw3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=afuiXdiC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="afuiXdiC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F47F1F00A3A;
	Tue, 21 Jul 2026 20:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667020;
	bh=hoJg+DchG7Uze9N/S+l2rXdw9YdUb8HftILlMYh18cU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=afuiXdiCeBA1/e/NhQTZGyeTmJ5/aDoJYDy2Y2RO0cw4zqJo/9i/LBPFHXh9+amEr
	 fI6RXeALWYFPMnMuIgIQ51HngDNoCaDJwaaMFkfa7mdXcGPSwT11hM5QJfh0jC6Twz
	 ZzrOnJYhsgarniFRosWaxCgUdOPQ7cK0lds1xhlg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 6.6 0902/1266] KVM: arm64: vgic: Check the interrupt is still ours before migrating it
Date: Tue, 21 Jul 2026 17:22:19 +0200
Message-ID: <20260721152502.029861951@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hyunwoo Kim <imv4bel@gmail.com>

commit 0074b82cdfcb5fd13710a0ac308ade68ac6f6fbe upstream.

vgic_prune_ap_list() drops both ap_list_lock and irq_lock while migrating
an interrupt to another vCPU. After reacquiring the locks it only checks
that the affinity is unchanged (target_vcpu == vgic_target_oracle(irq))
before moving the interrupt, which assumes that an interrupt whose affinity
is preserved is still queued on this vCPU's ap_list.

That assumption no longer holds if the interrupt is taken off the ap_list
while the locks are dropped. vgic_flush_pending_lpis() removes the
interrupt from the list and sets irq->vcpu to NULL, but leaves
enabled/pending/target_vcpu untouched. As the interrupt is still enabled
and pending, vgic_target_oracle() returns the same target_vcpu, so the
affinity check passes and list_del() is run a second time on an entry that
has already been removed.

Also check that the interrupt is still assigned to this vCPU
(irq->vcpu == vcpu) before moving it.

Fixes: 0919e84c0fc1 ("KVM: arm/arm64: vgic-new: Add IRQ sync/flush framework")
Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
Link: https://patch.msgid.link/aiHnI1mu6SGQrgnz@v4bel
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/vgic/vgic.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -701,15 +701,16 @@ retry:
 		raw_spin_lock(&irq->irq_lock);
 
 		/*
-		 * If the affinity has been preserved, move the
-		 * interrupt around. Otherwise, it means things have
-		 * changed while the interrupt was unlocked, and we
-		 * need to replay this.
+		 * If the interrupt is still ours and its affinity has
+		 * been preserved, move it around. Otherwise, it means
+		 * things have changed while the interrupt was unlocked
+		 * (it may even have been taken off the list with its
+		 * affinity left untouched), and we need to replay this.
 		 *
 		 * In all cases, we cannot trust the list not to have
 		 * changed, so we restart from the beginning.
 		 */
-		if (target_vcpu == vgic_target_oracle(irq)) {
+		if (irq->vcpu == vcpu && target_vcpu == vgic_target_oracle(irq)) {
 			struct vgic_cpu *new_cpu = &target_vcpu->arch.vgic_cpu;
 
 			list_del(&irq->ap_list);


