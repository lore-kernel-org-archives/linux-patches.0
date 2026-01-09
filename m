Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9411735CB76;
	Fri,  9 Jan 2026 12:40:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962419; cv=none; b=Nz80riDMqTB/47LSRXOonzlf1SFxtzJwiEwAuiY3C+Xsj6fghxldfA3cm0F95QehJ8k83PANVVuxPk3S630M2R2Hva9bMxTwgtIjEne3FN3nT/04cElgYMHIwDLkOleSmHOuUhyBK6Jn0QgTfx6mRlYBLKTKPR+a9I4RvS3dhLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962419; c=relaxed/simple;
	bh=/MIgzFWKNe5V3mP0U+WMMaWlUud02uOil9AVEzu3C80=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sCf4RN4muiBo+RfPSrGcya1Ph4LjeRF01JC3J/7RI8ZMJSgrDkzeOQKQgUuS2fz8H251guPlsKTXXCCGiwJq8tpACvprteZkv63UxfDT6Z9xUUFSJBXfaqP1ZMECRRExXfKkfrbcYzjAXaY8uYq0GzB0cwJxJyzHwHhlLcIEIso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r0q4sRKw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r0q4sRKw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21652C4CEF1;
	Fri,  9 Jan 2026 12:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962419;
	bh=/MIgzFWKNe5V3mP0U+WMMaWlUud02uOil9AVEzu3C80=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r0q4sRKwv+aPWBSuVPWRise48peDCzBEeksljdHti/lso//2yAKqV6BJrjvxVNhqz
	 IQ4YQVu55cxM4N1P1bzb0UKxAG2E8P7r4GtGn+HBX9cduBshgtl1eHUv46r5GvdyeL
	 KrpJ6lD1BRNph0tK2wEBitqIX60MJl/XjJyG9BIk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.1 359/634] KVM: x86: WARN if hrtimer callback for periodic APIC timer fires with period=0
Date: Fri,  9 Jan 2026 12:40:37 +0100
Message-ID: <20260109112131.032175444@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2637,7 +2637,7 @@ static enum hrtimer_restart apic_timer_f
 
 	apic_timer_expired(apic, true);
 
-	if (lapic_is_periodic(apic)) {
+	if (lapic_is_periodic(apic) && !WARN_ON_ONCE(!apic->lapic_timer.period)) {
 		advance_periodic_target_expiration(apic);
 		hrtimer_add_expires_ns(&ktimer->timer, ktimer->period);
 		return HRTIMER_RESTART;


