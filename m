Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B530718991E;
	Thu, 13 Feb 2025 15:26:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460368; cv=none; b=H+1ho/RweRmdmOsfki5Sa2EpOfwmEcjfCuNJq3BOFe4zxdKBw5PzcmAXGM7JivTNIl2aqhz2t1mIiLatB0zVG6QOYoAiZCTgXyC/xhabbR+0wyCHsBPo6boaGXWf/x3yItv2uGbeb0/6tLpYY+HxEtmxChmaIHojpFchvaIU+GY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460368; c=relaxed/simple;
	bh=ymP0XE4JZH3PD1x4PGTlXHHFkVwfsmcRBGN5x6j2MT4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lG8Sx5RwDpb0JgXjs+yKfFplYPmVBxjhi7id0UV8oCDDnLOs7vaHUk5rd32pAmPOwjqGB35c6cO0x5GbIHdnV1aJ5rpWOhaKDelF583s5ukJ/kACBpzB00gd3pgGHfwrSgDCCqSIxQslM3b0WlvvU+7ad6AMasCw3XNoky1w/Qs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g4SQTrxX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g4SQTrxX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E57E8C4CEE7;
	Thu, 13 Feb 2025 15:26:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460368;
	bh=ymP0XE4JZH3PD1x4PGTlXHHFkVwfsmcRBGN5x6j2MT4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g4SQTrxXrr2oN7RSM5HYOQNdMors01znlRqCB19ql7S5M/3FV3Lq9X3y9uyXGQElv
	 h61tHXImmi5z9+dq2BbE70VUFFAi6T/19nC3Yx5vzKNa/I9GrRywQIu8+kAobOA5s0
	 GjJelhMzU4c6IHH+IU0rmGoplROdDTWcH27MnQ2s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmytro Terletskyi <dmytro_terletskyi@epam.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 6.6 091/273] KVM: arm64: timer: Always evaluate the need for a soft timer
Date: Thu, 13 Feb 2025 15:27:43 +0100
Message-ID: <20250213142410.938699041@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Marc Zyngier <maz@kernel.org>

commit b450dcce93bc2cf6d2bfaf5a0de88a94ebad8f89 upstream.

When updating the interrupt state for an emulated timer, we return
early and skip the setup of a soft timer that runs in parallel
with the guest.

While this is OK if we have set the interrupt pending, it is pretty
wrong if the guest moved CVAL into the future.  In that case,
no timer is armed and the guest can wait for a very long time
(it will take a full put/load cycle for the situation to resolve).

This is specially visible with EDK2 running at EL2, but still
using the EL1 virtual timer, which in that case is fully emulated.
Any key-press takes ages to be captured, as there is no UART
interrupt and EDK2 relies on polling from a timer...

The fix is simply to drop the early return. If the timer interrupt
is pending, we will still return early, and otherwise arm the soft
timer.

Fixes: 4d74ecfa6458b ("KVM: arm64: Don't arm a hrtimer for an already pending timer")
Cc: stable@vger.kernel.org
Tested-by: Dmytro Terletskyi <dmytro_terletskyi@epam.com>
Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
Link: https://lore.kernel.org/r/20250204110050.150560-2-maz@kernel.org
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/arch_timer.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -467,10 +467,8 @@ static void timer_emulate(struct arch_ti
 
 	trace_kvm_timer_emulate(ctx, should_fire);
 
-	if (should_fire != ctx->irq.level) {
+	if (should_fire != ctx->irq.level)
 		kvm_timer_update_irq(ctx->vcpu, should_fire, ctx);
-		return;
-	}
 
 	/*
 	 * If the timer can fire now, we don't need to have a soft timer


