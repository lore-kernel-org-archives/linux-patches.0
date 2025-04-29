Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6752233713;
	Tue, 29 Apr 2025 17:31:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947907; cv=none; b=M1L/yiRoUEWqCR/Yq9OTkLlC9ORwkf8lPG1Gi5/caZQoAWuaPUT9HZRMXiwshDFNRw/q0ihFbvQ8tCUQANIJASiKXyCexPJQ8aO969udCSNFA4u74EwSYm8ZrJFhBACIyB7aWPWNeKE/jsAZ6/piehvMeYkxS92gNQhZM2WJYaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947907; c=relaxed/simple;
	bh=duBHKfTj/Oz5KjKo9pMJ8xS9Ykr3qlEjDAG6Ijs+x94=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AWp83dMuYVk2QRkKHO3yk+17DS4GvcKpGGvsjsi+baixzcQBY6DTCk/pvSAM1370uQxAUnoRqck0dv6nLHnEmE0w6sA7MK2LkAy5864++8PkhOijT1o5DhiZmlvgdqWGAWldLIbJqX6fsOU9B+yF8SSrspF6mxgPRY4khhpgArs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GNXs28QJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GNXs28QJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BEEBC4CEE3;
	Tue, 29 Apr 2025 17:31:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947907;
	bh=duBHKfTj/Oz5KjKo9pMJ8xS9Ykr3qlEjDAG6Ijs+x94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GNXs28QJ9EoMWvUd6fM66J48Zcreoj74AHhsMKMvSaRrRdk2g2wixhBivYiEp4xDU
	 lAHtQitQ8j6fudNdmruFOVXqwX32XVYqbaFUzTCyBMqQ/gsxawXtbo/1YrFrphaYbg
	 rWmw20E+v6JevvZVKXRiVwGjcynk4/KRLshSVxlM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bibo Mao <maobibo@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.12 111/280] LoongArch: KVM: Fix PMU pass-through issue if VM exits to host finally
Date: Tue, 29 Apr 2025 18:40:52 +0200
Message-ID: <20250429161119.656222959@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Bibo Mao <maobibo@loongson.cn>

commit 5add0dbbebd60628b55e5eb8426612dedab7311a upstream.

In function kvm_pre_enter_guest(), it prepares to enter guest and check
whether there are pending signals or events. And it will not enter guest
if there are, PMU pass-through preparation for guest should be cancelled
and host should own PMU hardware.

Cc: stable@vger.kernel.org
Fixes: f4e40ea9f78f ("LoongArch: KVM: Add PMU support for guest")
Signed-off-by: Bibo Mao <maobibo@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/kvm/vcpu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
index 2d3c2a2d1d1c..5af32ec62cb1 100644
--- a/arch/loongarch/kvm/vcpu.c
+++ b/arch/loongarch/kvm/vcpu.c
@@ -294,6 +294,7 @@ static int kvm_pre_enter_guest(struct kvm_vcpu *vcpu)
 		vcpu->arch.aux_inuse &= ~KVM_LARCH_SWCSR_LATEST;
 
 		if (kvm_request_pending(vcpu) || xfer_to_guest_mode_work_pending()) {
+			kvm_lose_pmu(vcpu);
 			/* make sure the vcpu mode has been written */
 			smp_store_mb(vcpu->mode, OUTSIDE_GUEST_MODE);
 			local_irq_enable();
-- 
2.49.0



