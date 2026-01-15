Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89D623D3328;
	Thu, 15 Jan 2026 17:30:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498201; cv=none; b=sUX/Pw7N1UFhXQkO3ZBJTFDRly+E7L2/orPEVOjUkHB2g43irXRMH/MzHaLENkQ17p6GC4CusYa/dpBtAZbT+UpaOVpu086tU5s5Gn4lcKh5yxW5Rjlq3eyqKOZqMqLsVvEgNrShUVD77EkPeghPWiSEjParLRkzp15x45anH7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498201; c=relaxed/simple;
	bh=nUHIdbg01dKw7D3dCQvZOHjD7vU7/HwWeMnOIn0X/74=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SCeGYUGD+d4e+LCSUVL82HIqtc7GNqdlWri9SeVgHKs9YBdu5PhiADWE3hHme4hMuXwFvl0rKL7ht5thHuCkrEbGgGVf4//N9z/VWu2X6aQ3rjmB3KnFvyJ4pRJxtKtN4MDz/dmsLndhNd0EFe9IJk8aer7FL/tArVtnzpFR+HA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b3t9vrNa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b3t9vrNa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDFF7C16AAE;
	Thu, 15 Jan 2026 17:30:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498201;
	bh=nUHIdbg01dKw7D3dCQvZOHjD7vU7/HwWeMnOIn0X/74=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b3t9vrNaZnJUWWps1Jbb7aHepT3BiojVn+KR8/wQl0mOvQUhH4vcOPlRuIWosSTJJ
	 qjtrIQq3GLMM1XTcr5NiaxuVcSi4RTwH/cldXELix54YTBCPpM3HUt5RP9I/TnC0TO
	 BdGX+w5dagPd1kTQkWx+iURtgmNt5xMryerKWEKc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	fuqiang wang <fuqiang.wng@gmail.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 5.15 315/554] KVM: x86: Explicitly set new periodic hrtimer expiration in apic_timer_fn()
Date: Thu, 15 Jan 2026 17:46:21 +0100
Message-ID: <20260115164257.633551784@linuxfoundation.org>
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

From: fuqiang wang <fuqiang.wng@gmail.com>

commit 9633f180ce994ab293ce4924a9b7aaf4673aa114 upstream.

When restarting an hrtimer to emulate a the guest's APIC timer in periodic
mode, explicitly set the expiration using the target expiration computed
by advance_periodic_target_expiration() instead of adding the period to
the existing timer.  This will allow making adjustments to the expiration,
e.g. to deal with expirations far in the past, without having to implement
the same logic in both advance_periodic_target_expiration() and
apic_timer_fn().

Cc: stable@vger.kernel.org
Signed-off-by: fuqiang wang <fuqiang.wng@gmail.com>
[sean: split to separate patch, write changelog]
Link: https://patch.msgid.link/20251113205114.1647493-3-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/lapic.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2451,7 +2451,7 @@ static enum hrtimer_restart apic_timer_f
 
 	if (lapic_is_periodic(apic) && !WARN_ON_ONCE(!apic->lapic_timer.period)) {
 		advance_periodic_target_expiration(apic);
-		hrtimer_add_expires_ns(&ktimer->timer, ktimer->period);
+		hrtimer_set_expires(&ktimer->timer, ktimer->target_expiration);
 		return HRTIMER_RESTART;
 	} else
 		return HRTIMER_NORESTART;


