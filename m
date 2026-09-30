Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D5335158A8;
	Wed, 30 Sep 2026 16:47:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786828; cv=none; b=OM/D6RU05jbuCdOl/HHkivEU/I/sqc/c/6Hi+vcoRYO7v+Gq1+ZVj47egJPbanEMCtAh03+Zc3IsxEbijSjXq4hCn+nCxLITZaEI7pJYMEKNc7XoV1ORNQX0O+c6CTFKJpiJhGrjugy9+nxguGOO8gpWOFGR+rk9D5kLWutJ26g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786828; c=relaxed/simple;
	bh=hcDZgwJkEzn9oXBmT5c4ErJO6lff/kORNz26B1g13cg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ioJ2VLqMEoFvh93FEEJUAugBUjLUZ0kCZou2Itv5yCimRieoRcNtxfjwQhLe7LtaHDFYEgouDjzmlXpra+Zv0N+VuLOSmIM0iSPs9HL3FcVT+q4R64xc2pjCbE2/diotDoOfJsHlb6l1dqF0TMSjYHVB8/eBlueFMxVxMYYVbCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WCg9XIUD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WCg9XIUD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F0321F000FF;
	Wed, 30 Sep 2026 16:47:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786827;
	bh=8peV02LJt6jHz1n5Pum0+AETDG9dlcC8QRh4S7GOQKQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WCg9XIUD96369HFdp4mWtICAmNGWrlIVz5nPf1l/w7a/X1dlCqe9/VOEreHE6b9BY
	 kh1ZmHqm0tBINdM3KmUYWIguKCeG8QW+wjviYYCjJ59ahXl82WgnMvRL8U8n9+46i7
	 tG2C8YDT7xZScbWhs9YBHly1GwFhprtOJUBddzvE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 009/457] KVM: s390: Add missing srcu in kvm_s390_set_irq_state()
Date: Wed, 30 Sep 2026 17:21:54 +0200
Message-ID: <20260930152346.232607849@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Claudio Imbrenda <imbrenda@linux.ibm.com>

[ Upstream commit f3a557067d57ce6ae98d485c8009b223e16f5f36 ]

Like kvm_s390_inject_vcpu(), kvm_s390_set_irq_state() also needs the
kvm->srcu or the slots lock when performing the Store status operation.

Fix by taking kvm->srcu in kvm_s390_set_irq_state().

Fixes: ba5c1e9b6cee ("KVM: s390: interrupt subsystem, cpu timer, waitpsw")
Fixes: 062e44a9319f ("KVM: s390: Use srcu in kvm_arch_vcpu_unlocked_ioctl()")
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Message-ID: <20260828115439.145885-7-imbrenda@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kvm/interrupt.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
index 6397b53e33f52..80f4802934df9 100644
--- a/arch/s390/kvm/interrupt.c
+++ b/arch/s390/kvm/interrupt.c
@@ -3224,9 +3224,9 @@ int kvm_s390_set_irq_state(struct kvm_vcpu *vcpu, void __user *irqstate, int len
 				break;
 		}
 	}
-
 	if (storestatus) {
-		n = kvm_s390_store_status_unloaded(vcpu, KVM_S390_STORE_STATUS_NOADDR);
+		scoped_guard(srcu, &vcpu->kvm->srcu)
+			n = kvm_s390_store_status_unloaded(vcpu, KVM_S390_STORE_STATUS_NOADDR);
 		return r ? r : n;
 	}
 
-- 
2.53.0



