Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C38D355805;
	Tue,  6 Jan 2026 17:26:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720384; cv=none; b=mdxApY6cE7ajFnwD0M+KjV1VXvI+IR+K7f/iAJNwyZWUOMBrcS29xZydIvg7uqDf0RzjSsFVwpU7ejHE+OSN1ZiDnThf+75pwei8x0Tig0xVI5NtsRiWGRrSRdD3H+r6oZyNnMPGGjuurmTvdEvbpE5vD5G8WV8FESVAGEMaJXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720384; c=relaxed/simple;
	bh=7XC+vYCpJusipSd3hr+GbGSPvBy89672wytrxdQ/Eds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TZMGXEIt9CNM9cvlRRCcWxhS+hu7oL6k/44fo7hUJME8PIf4LaojX60XnKQoPfRZC+ciy/ianQ5pAltdkeF6ZtA1yT+anrFATuyyZxXc2Ocb+v3Bhi/duoURt5Xte/t0wnQ2f1V+IVoQZhsJcH5DYP0aFOO1VoIoPL/VKo5TcKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HYbnJk1n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HYbnJk1n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4222C116C6;
	Tue,  6 Jan 2026 17:26:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720384;
	bh=7XC+vYCpJusipSd3hr+GbGSPvBy89672wytrxdQ/Eds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HYbnJk1nVrW2apLznWT1usNadKHa2zblZcl09QsdmhyQ9WmJH16N0Gbj01wY8J53H
	 u9ks4pPdAT6IzW0rBbysYkCNgP0m6EXPlAkJrIjRlcabZ6uP1O7hS9Dqa8hYWbu7xW
	 MKr3vVnz19xhFF1Aw8WjwC/OztYLAJD52C0YrG44=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	fuqiang wang <fuqiang.wng@gmail.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.12 221/567] KVM: x86: Explicitly set new periodic hrtimer expiration in apic_timer_fn()
Date: Tue,  6 Jan 2026 18:00:03 +0100
Message-ID: <20260106170459.491015646@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2871,7 +2871,7 @@ static enum hrtimer_restart apic_timer_f
 
 	if (lapic_is_periodic(apic) && !WARN_ON_ONCE(!apic->lapic_timer.period)) {
 		advance_periodic_target_expiration(apic);
-		hrtimer_add_expires_ns(&ktimer->timer, ktimer->period);
+		hrtimer_set_expires(&ktimer->timer, ktimer->target_expiration);
 		return HRTIMER_RESTART;
 	} else
 		return HRTIMER_NORESTART;


