Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CA6E330B0E;
	Mon, 29 Dec 2025 16:29:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025797; cv=none; b=BkyiJ/pCOVWLNCRw2oPsET8KoPzPiudt7YYEhtOnQn0yqkW7SWCWblzlCCrJwj1pp0atdvAqomu1gVD/GMRvlKLivMEy/dtAEJmr4EofYvwyEgPz4j57mjFpveDWtIy7X2n54kEkvQyXrEyOiOLRnU6C5OKhaPPjTCpdLJrmFMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025797; c=relaxed/simple;
	bh=o6skrSEIPjpRCCybOdkkIB4Lnpi9gE7Lo3cbCtukhUM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C6Crt4DwjbSzo16LxjjLbyoQV5iEGAovod+hXWBo+VGZx+xpc41IP41KHp2fDUPd+piXwElHyA3rKAOUqobQrg5lO6LLwP9rk5WMtJ1fOBhlSkRBpixla7zm+VX2ottENKqGSb71usjJTgkwpXrlLtQ1Uhs8Dag3Yc+r4Fy7q+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W4oSbfqd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W4oSbfqd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01741C4CEF7;
	Mon, 29 Dec 2025 16:29:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025797;
	bh=o6skrSEIPjpRCCybOdkkIB4Lnpi9gE7Lo3cbCtukhUM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W4oSbfqdDJFc0Tp29yGx+vk6C+bI2VYXWP86EU+8rim04LqhlfkCLD97VlnChyfgl
	 2/TXEfUgEuv/1EwOY0TYvfFN/IFp/LnKeIZ5IjFBBdtQUIqQZVtN9MaiDpSK/8qFJD
	 JukdNAvgrnkbcsKCpKdoDnWXNTpS/kkDOvV3fZeY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.18 339/430] KVM: x86: WARN if hrtimer callback for periodic APIC timer fires with period=0
Date: Mon, 29 Dec 2025 17:12:21 +0100
Message-ID: <20251229160736.802534839@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2970,7 +2970,7 @@ static enum hrtimer_restart apic_timer_f
 
 	apic_timer_expired(apic, true);
 
-	if (lapic_is_periodic(apic)) {
+	if (lapic_is_periodic(apic) && !WARN_ON_ONCE(!apic->lapic_timer.period)) {
 		advance_periodic_target_expiration(apic);
 		hrtimer_add_expires_ns(&ktimer->timer, ktimer->period);
 		return HRTIMER_RESTART;


