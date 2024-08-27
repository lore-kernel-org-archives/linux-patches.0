Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8024F1A072D;
	Tue, 27 Aug 2024 15:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772721; cv=none; b=CjmcI1pe9m3bBj1240gyzXt9Rcv7Ujwm8fy1ESQu0BDVKYvXAtVbVhUiAKE+nBPmTx3NBfL+U9ZvaRo0SpQBeA/rOu+VOrTS8xIDYF2FgrGXS6cNNke8OWo5jEZkRVIKyzSCAzIQukytLgMOvotJ/npLQtJVmDQ/M6V1cP1EABM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772721; c=relaxed/simple;
	bh=Xi9x9nXVL+1a4B0cTPxd8q5HOLtxzpzI8tnmDTYjo8Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CnpGwIOxaU+8swHXrgrvh2hCorefszr1qB/Vk5YpNQ0g9oNpXhIqfxUGVDTuZVzvM0jpTCW9cMu02SmlcChG72NNCY7XPF45LoQiEGWO9SqBde0rszY08vZMV802hfYSuSLId+yqrkx0xAp5pvOKHrelayTYMKibdNFRYcJny8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hySuQs/1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hySuQs/1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC08FC4DDFC;
	Tue, 27 Aug 2024 15:32:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772721;
	bh=Xi9x9nXVL+1a4B0cTPxd8q5HOLtxzpzI8tnmDTYjo8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hySuQs/175G2PULfhHV5OlC37bokjW/2jxt1sOIfeQMjtVLw0I7yjDdOfGWUXWDf9
	 6aDujOmjpcxZ+68gq1vhmXG/VFMG+sRu/emzwQRT23lFYDXooMl4+fy5Dm+lRQy90N
	 rhGiso1TD5MWDFOT2Q0Z0I9F33QJ3TzrpjWzFDHk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Peter Shier <pshier@google.com>,
	Jim Mattson <jmattson@google.com>,
	Wanpeng Li <wanpengli@tencent.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Li RongQing <lirongqing@baidu.com>,
	David Hunter <david.hunter.linux@gmail.com>
Subject: [PATCH 6.1 298/321] KVM: x86: fire timer when it is migrated and expired, and in oneshot mode
Date: Tue, 27 Aug 2024 16:40:06 +0200
Message-ID: <20240827143849.600025269@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Li RongQing <lirongqing@baidu.com>

commit 8e6ed96cdd5001c55fccc80a17f651741c1ca7d2 upstream.

when the vCPU was migrated, if its timer is expired, KVM _should_ fire
the timer ASAP, zeroing the deadline here will cause the timer to
immediately fire on the destination

Cc: Sean Christopherson <seanjc@google.com>
Cc: Peter Shier <pshier@google.com>
Cc: Jim Mattson <jmattson@google.com>
Cc: Wanpeng Li <wanpengli@tencent.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Li RongQing <lirongqing@baidu.com>
Link: https://lore.kernel.org/r/20230106040625.8404-1-lirongqing@baidu.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: David Hunter <david.hunter.linux@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/lapic.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1843,8 +1843,12 @@ static bool set_target_expiration(struct
 		if (unlikely(count_reg != APIC_TMICT)) {
 			deadline = tmict_to_ns(apic,
 				     kvm_lapic_get_reg(apic, count_reg));
-			if (unlikely(deadline <= 0))
-				deadline = apic->lapic_timer.period;
+			if (unlikely(deadline <= 0)) {
+				if (apic_lvtt_period(apic))
+					deadline = apic->lapic_timer.period;
+				else
+					deadline = 0;
+			}
 			else if (unlikely(deadline > apic->lapic_timer.period)) {
 				pr_info_ratelimited(
 				    "kvm: vcpu %i: requested lapic timer restore with "


