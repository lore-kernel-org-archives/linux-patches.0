Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFD6132F748;
	Fri,  9 Jan 2026 12:11:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960706; cv=none; b=jIVCJH9C7gMuu7UNYSgk5obYZj2JmaAGax2AnKbSrhrf+sJpM5VPydbC6KqO7u2ZBEjxsWwSJMpZ0JoR9aQmLY0H9YoRMMs4I3nzwAfNSCreWQMTqL0FeuMOgrE2v6ZbReUZo/uzU/vYWdTeCug7Nm6pOE3xQxDtcgUchydETiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960706; c=relaxed/simple;
	bh=MhhhkozYOPeLnok7kr6NliB3VqhJqjfQQqQCZR9DVKo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OK+JiIam67WqPzYwXKCw8WhfqNSR01G80+GUyys6nJ8YYLrSwmDSBMYNS0AJO+WyNwv8rL5XjlrEsb23AOlc4pZW1tUcC0qnHsx1Pabp+2kU/XFc6/JXZGGR63hCPCUhu1Fbmj7OtsU1ZmB312qlaaLCP256WEu9hWT5R4xLzLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q012h1p4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q012h1p4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B4E8C4CEF1;
	Fri,  9 Jan 2026 12:11:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960705;
	bh=MhhhkozYOPeLnok7kr6NliB3VqhJqjfQQqQCZR9DVKo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q012h1p4ICDIFGv3hVOzxh6tGK4txy+VWiG7AC7iPuokm1OqHGf1dMCKgcCeZ4klo
	 wxE8of9AlYQeolOZMINJT4EyoNkudH0AUgUxpdH5i0PI7wQjGKm4+3fxSfhoSlwy/V
	 7vQVZfWA/061gqT4lf6KqA1lm9tY5D2WPG8nIrGw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	fuqiang wang <fuqiang.wng@gmail.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.6 463/737] KVM: x86: Explicitly set new periodic hrtimer expiration in apic_timer_fn()
Date: Fri,  9 Jan 2026 12:40:02 +0100
Message-ID: <20260109112151.407679933@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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
@@ -2857,7 +2857,7 @@ static enum hrtimer_restart apic_timer_f
 
 	if (lapic_is_periodic(apic) && !WARN_ON_ONCE(!apic->lapic_timer.period)) {
 		advance_periodic_target_expiration(apic);
-		hrtimer_add_expires_ns(&ktimer->timer, ktimer->period);
+		hrtimer_set_expires(&ktimer->timer, ktimer->target_expiration);
 		return HRTIMER_RESTART;
 	} else
 		return HRTIMER_NORESTART;


