Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3962124A07B;
	Tue, 29 Apr 2025 17:00:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946035; cv=none; b=uaASaiurPksMo4bZHh7DyYsXJ2Do2mUb/CrgrOhBXUwOqvdl5HbgdPqA3FudB5+p/Xx/mw8oljkbDFmVe5qyH2aFtldoINvbltSINOu7lrSV1MsOSPoWwRoj0VlCDLS4TVwLR3nYUIJMLrWYnK1a6nQH6hEkGbrhydvvMff3plU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946035; c=relaxed/simple;
	bh=jLWy7fSX+0GmsbJsMquAqHIaI5rrlVmd4vqRIRpKR/E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SntuwPGk9zw+QqU+yGLDr1Psw2t9Q5talJd660i0Ev10YFzDd5T+ZXV3Wt03SZ9pKAMyJbOBY9nvb2q+mut0HBj8mf5uzMDqh63ZK9k2IccxXSjtjS0GOKf00/n/J1y5S274QoO/tZzkb86mM7SyckbUoNnKotLtacL0qKXDOhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KmAnAWBp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KmAnAWBp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA468C4CEE3;
	Tue, 29 Apr 2025 17:00:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946035;
	bh=jLWy7fSX+0GmsbJsMquAqHIaI5rrlVmd4vqRIRpKR/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KmAnAWBpEA5wH4YBnUBd2Tx8w9EGGhaA6R3ANk/fviC9rKcgE2xb+Ho6C+YaIZLn5
	 3z+Mi86LvdgBjQj/D2F4QnOTBxAzIh7WopkdhmKoRuWAFbNVBi6iQeI37hQW+zGpfg
	 6+4cSlFX4a2THc6Tsn66hL1eN7+x9FSUzbt9xGy8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bibo Mao <maobibo@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.14 133/311] LoongArch: KVM: Fix PMU pass-through issue if VM exits to host finally
Date: Tue, 29 Apr 2025 18:39:30 +0200
Message-ID: <20250429161126.487975804@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
 arch/loongarch/kvm/vcpu.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/loongarch/kvm/vcpu.c
+++ b/arch/loongarch/kvm/vcpu.c
@@ -294,6 +294,7 @@ static int kvm_pre_enter_guest(struct kv
 		vcpu->arch.aux_inuse &= ~KVM_LARCH_SWCSR_LATEST;
 
 		if (kvm_request_pending(vcpu) || xfer_to_guest_mode_work_pending()) {
+			kvm_lose_pmu(vcpu);
 			/* make sure the vcpu mode has been written */
 			smp_store_mb(vcpu->mode, OUTSIDE_GUEST_MODE);
 			local_irq_enable();


