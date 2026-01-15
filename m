Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABD843BFE37;
	Thu, 15 Jan 2026 17:51:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499513; cv=none; b=cZsiY4Fd3Xg3d7pku7YXm+qCtnuq/6G1zC+gykNYmRraED8j2u9xgU6DPeJ+4xXDhdWqjMoY1/Wn4EbkIsolDrWcRg+5WdLWq6/0M9HHs8aYcEaby8s6r5eYyeph0hmIxEkchjDYiX4TBIKKsDg6wmpGXzrZxO9jUlQch93NnQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499513; c=relaxed/simple;
	bh=AfzBOSUV44X6Z9awrZ2GqTHWHYeMR8zg1D39qdJjipA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hXrXvPP0BjkVvmQ2RzXr0bUnGgRfw8BHVa5qDYhYve/B/S9VxzuRJBH5g1rMN2DM8tXGFLh0hZHZECsF96eb267aCiT4Ps+He6nuNHebmCSytve5XYZSGU7u0tMV+qmxbelafFyWeH55N2Q/xZ8DzGQgxDGxMP6W0QS9Ro+ST6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lm55/czz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lm55/czz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0AB7C19422;
	Thu, 15 Jan 2026 17:51:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499513;
	bh=AfzBOSUV44X6Z9awrZ2GqTHWHYeMR8zg1D39qdJjipA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lm55/czzFMPuHtEb9MIcLJPA9E42qsfS2ZIn1VEo2bRfNeCYOMaX58+8bLP1pmpmQ
	 /vp1f1Liw7N7L5gbQq2ZCVqLAue3iyjyEPFZ6gWJ1pX/czdDphGBz2DRouCp8zw+V/
	 4esrHdrnCb4MJnB4dov7XJyBm2XeaWDseA4SsbMc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 5.10 253/451] KVM: x86: WARN if hrtimer callback for periodic APIC timer fires with period=0
Date: Thu, 15 Jan 2026 17:47:34 +0100
Message-ID: <20260115164240.042652412@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

commit 0ea9494be9c931ddbc084ad5e11fda91b554cf47 upstream.

WARN and don't restart the hrtimer if KVM's callback runs with the guest's
APIC timer in periodic mode but with a period of '0', as not advancing the
hrtimer's deadline would put the CPU into an infinite loop of hrtimer
events.  Observing a period of '0' should be impossible, even when the
hrtimer is running on a different CPU than the vCPU, as KVM is supposed to
cancel the hrtimer before changing (or zeroing) the period, e.g. when
switching from periodic to one-shot.

Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20251113205114.1647493-2-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/lapic.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2434,7 +2434,7 @@ static enum hrtimer_restart apic_timer_f
 
 	apic_timer_expired(apic, true);
 
-	if (lapic_is_periodic(apic)) {
+	if (lapic_is_periodic(apic) && !WARN_ON_ONCE(!apic->lapic_timer.period)) {
 		advance_periodic_target_expiration(apic);
 		hrtimer_add_expires_ns(&ktimer->timer, ktimer->period);
 		return HRTIMER_RESTART;


