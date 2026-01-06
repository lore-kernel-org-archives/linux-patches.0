Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C42035505C;
	Tue,  6 Jan 2026 17:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720381; cv=none; b=miQgq5KyJNzXcNoIafjmowDeezdsobXPBw6CFh4iF+s2gJSfqqgx4e5CVtWhKj03B2BfQQCKKLjbMYT+x96KqlK/8QF6B4ZLUIgQ3n78e8lEpGN+x5aXi4eg9HPZNBlnQOgvp+CMlvxR6ZQL+wdYUmI7odVVCtwme1XsIDdSpT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720381; c=relaxed/simple;
	bh=tSPB+fpk/KbIObNozHCWXlCCCmO3wnpm3GDGSuHHpTY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sn4eb6VJxxsF8JaK8Ia2jf5JLNZvU2EGgZ5I6a78dP0KB/YR955UU128p8geZ56ZvoSqvk0l0J9UiJQ/4Bbe4hdD0Up1kVjVsXHDsIRRpoXDqxR6sjIte8U8MqVJ2M6dQPo1IfFEWD+fUrJOwJoCXth/XCuqtlYXAv24AXx+ICw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iiwbAPo0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iiwbAPo0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91432C116C6;
	Tue,  6 Jan 2026 17:26:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720381;
	bh=tSPB+fpk/KbIObNozHCWXlCCCmO3wnpm3GDGSuHHpTY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iiwbAPo0tCTaDTHu8vyeXOTc02U09w47hqWx0xAtlpSnoN9kZS1MZW/xYM7H/AliB
	 EH9/SNg/7ctfHYL1IyMD7wc5NWF4BBV+beLd24PIUaa5gQrnm6hXd9Nc88Siyn1yOR
	 UFoGGb5Mupgq9T2TnnPZ7S3b9xQl8eOVXtKvo+gQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.12 220/567] KVM: x86: WARN if hrtimer callback for periodic APIC timer fires with period=0
Date: Tue,  6 Jan 2026 18:00:02 +0100
Message-ID: <20260106170459.453328561@linuxfoundation.org>
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
@@ -2869,7 +2869,7 @@ static enum hrtimer_restart apic_timer_f
 
 	apic_timer_expired(apic, true);
 
-	if (lapic_is_periodic(apic)) {
+	if (lapic_is_periodic(apic) && !WARN_ON_ONCE(!apic->lapic_timer.period)) {
 		advance_periodic_target_expiration(apic);
 		hrtimer_add_expires_ns(&ktimer->timer, ktimer->period);
 		return HRTIMER_RESTART;


