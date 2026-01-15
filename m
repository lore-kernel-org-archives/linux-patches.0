Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B97C3D3D15;
	Thu, 15 Jan 2026 17:51:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499516; cv=none; b=UejnoyEjtxJckjDy7CwphBTmK7CWp7y0jrv1tPchgPoAksft1J/fgX3POkdaNnnGEkRLfDErvIbeRox1XP04mR1oumcZJIc6euiOnG2TezFy6c8Y7GalQADlnuz/E1LmhOBQqT87C1WCVB4/VBG3UaR1gq6lZL08oQTgdnfUvrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499516; c=relaxed/simple;
	bh=3kjzfLuR9A94iIcoUN89D1S7j2uxBM6YfVDqF116deQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kdgq6vj+JXsoh8gz5XMAqY2skN/J+0trM8TPaHB7gSJMyStRGDuIuEIuzcfXbteW2NZs/IG/PKorw3tVRhaaW57XhkP7aJnLJNCI8Kz+lq7Jmbbs8RbDMqhWLaHbj8qWY6XkTQ/uOC/oz89BSWnZOs2I6DTMnKORq9F1D3JcQm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yokj8OgS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yokj8OgS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D6A7C116D0;
	Thu, 15 Jan 2026 17:51:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499516;
	bh=3kjzfLuR9A94iIcoUN89D1S7j2uxBM6YfVDqF116deQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yokj8OgS4+mp8iL1062wBvpgfjsTuY3FHWn2g0THMV2rkANNTQGbs5s9Hzzfk+1Qn
	 tD/mVllS3nvMa9Gx8lDhXBE5r0Ca7gLv6i482V05FTXjw5IeGkqQDYO6ytQtoAJYJU
	 mQAZv2ICATW5hB3A/kQj9stLAlkGSaHhs7Kd3l30=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	fuqiang wang <fuqiang.wng@gmail.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 5.10 254/451] KVM: x86: Explicitly set new periodic hrtimer expiration in apic_timer_fn()
Date: Thu, 15 Jan 2026 17:47:35 +0100
Message-ID: <20260115164240.078268500@linuxfoundation.org>
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
@@ -2436,7 +2436,7 @@ static enum hrtimer_restart apic_timer_f
 
 	if (lapic_is_periodic(apic) && !WARN_ON_ONCE(!apic->lapic_timer.period)) {
 		advance_periodic_target_expiration(apic);
-		hrtimer_add_expires_ns(&ktimer->timer, ktimer->period);
+		hrtimer_set_expires(&ktimer->timer, ktimer->target_expiration);
 		return HRTIMER_RESTART;
 	} else
 		return HRTIMER_NORESTART;


