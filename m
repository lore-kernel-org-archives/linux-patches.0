Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C8BD3C1FCC;
	Thu, 15 Jan 2026 17:29:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498181; cv=none; b=K5SsRKUsZP63BEVvh8MTqz9NKnd7xqkaFbsHkvPzpfnOe0KS1yCApiagommEVYp4vOq2BWawJtVCvDw361f+oRYjO6xdBndI4apXDZ19GIqfD+HUxsEhqy2/y7/xrPUSIqESR5FUvoUHVzB/fD4WwM4i06gykxK9bg0nUWHgnzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498181; c=relaxed/simple;
	bh=OgAOY96ShFeDkFEKHDwGKmI+bKym4tgMkNz5RmTcuE8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=knulpyAen/jowTl5cmz1SkEH+ZcJ/4+MtprVq4j8T97jxYqrcnFUn4owzX+3sTyLUeK4n4lhH7aoY+BejYh3AQ91YQLrbmlENJMbM9Aiybh3reMJA9R+YLpypbcJt3bE7whQRaUOeGBo1hkoWvejCgREYrRIkpChkbuittTGD/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rj1fUexT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rj1fUexT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE551C116D0;
	Thu, 15 Jan 2026 17:29:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498181;
	bh=OgAOY96ShFeDkFEKHDwGKmI+bKym4tgMkNz5RmTcuE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rj1fUexT2B6upFtqtjpNpJYYl9Oygqf2vwFQHc8ZCaojNoJtrfBMnvA41WwGmdcQx
	 joKsan8lWU0bMoXl2sO8YN+JPPzMTEFKGjDKNnew+h3tQKCTUEebdSFZGcAJCRP2bi
	 ismZYtUaniuM57RROrGtJ/3JqXzJuBJ/Ulu559AE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 5.15 314/554] KVM: x86: WARN if hrtimer callback for periodic APIC timer fires with period=0
Date: Thu, 15 Jan 2026 17:46:20 +0100
Message-ID: <20260115164257.597724347@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2449,7 +2449,7 @@ static enum hrtimer_restart apic_timer_f
 
 	apic_timer_expired(apic, true);
 
-	if (lapic_is_periodic(apic)) {
+	if (lapic_is_periodic(apic) && !WARN_ON_ONCE(!apic->lapic_timer.period)) {
 		advance_periodic_target_expiration(apic);
 		hrtimer_add_expires_ns(&ktimer->timer, ktimer->period);
 		return HRTIMER_RESTART;


