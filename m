Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06EC41F03D7;
	Fri, 21 Nov 2025 13:31:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731864; cv=none; b=cd+ZVvw+t7Orn5b5YjmSkHXcjNA8t4z3mTL+fQL/Mz2JKsNOoV0BsGw/mT83KRdZEdBw/V2rtFJO18yN0gVftgXQqYYLcFGMhdLYELE4wP4XGwYtqBDRMxFB+qvJ7d0yjCQoW5MaY2rGAhUubSX3fhX2Vn9QygVWYCyhnynWpPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731864; c=relaxed/simple;
	bh=FXdGs4qyhrAvZgDrNq+0fbEN+p1GfYNVxoZUcctprsw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aTAU7XD2uGzoFNz1Ytq1YSCkMXHI3fFhAzcDG0SkaH6wqAUr/uL7WClY+cB+LP8qlEe3xaJ3RNTVjTNj7yH9PsGqTVJ9Nw+iZF95qgi4tpvBIutqvZ4JV5tRkvaiL2DvoP+Zx8XJyiFvkTr/zA6TPQdUMb/EpyPE3L6uYVSALms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1bJWsp2i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1bJWsp2i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82D2BC4CEF1;
	Fri, 21 Nov 2025 13:31:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731863;
	bh=FXdGs4qyhrAvZgDrNq+0fbEN+p1GfYNVxoZUcctprsw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1bJWsp2iVpHWmK7eZvgPY91kUVpooSrSMiaEUctlzjMTkI/qOveakXTVuINUB355K
	 OocS0C5DZtksX0ZAx4venbYSJAizE9BEui/RxUbBQpw0bTfNPWj0kwaxyN9k6ysl4+
	 //M7Tt3HDnmmibqDrOnoPyRznPgS7OT2FLPTku5o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bibo Mao <maobibo@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.12 107/185] LoongArch: KVM: Restore guest PMU if it is enabled
Date: Fri, 21 Nov 2025 14:12:14 +0100
Message-ID: <20251121130147.735208000@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130143.857798067@linuxfoundation.org>
References: <20251121130143.857798067@linuxfoundation.org>
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

From: Bibo Mao <maobibo@loongson.cn>

commit 5001bcf86edf2de02f025a0f789bcac37fa040e6 upstream.

On LoongArch system, guest PMU hardware is shared by guest and host but
PMU interrupt is separated. PMU is pass-through to VM, and there is PMU
context switch when exit to host and return to guest.

There is optimiation to check whether PMU is enabled by guest. If not,
it is not necessary to return to guest. However, if it is enabled, PMU
context for guest need switch on. Now KVM_REQ_PMU notification is set
on vCPU context switch, but it is missing if there is no vCPU context
switch while PMU is used by guest VM, so fix it.

Cc: <stable@vger.kernel.org>
Fixes: f4e40ea9f78f ("LoongArch: KVM: Add PMU support for guest")
Signed-off-by: Bibo Mao <maobibo@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/kvm/vcpu.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/arch/loongarch/kvm/vcpu.c
+++ b/arch/loongarch/kvm/vcpu.c
@@ -127,6 +127,9 @@ static void kvm_lose_pmu(struct kvm_vcpu
 	 * Clear KVM_LARCH_PMU if the guest is not using PMU CSRs when
 	 * exiting the guest, so that the next time trap into the guest.
 	 * We don't need to deal with PMU CSRs contexts.
+	 *
+	 * Otherwise set the request bit KVM_REQ_PMU to restore guest PMU
+	 * before entering guest VM
 	 */
 	val = kvm_read_sw_gcsr(csr, LOONGARCH_CSR_PERFCTRL0);
 	val |= kvm_read_sw_gcsr(csr, LOONGARCH_CSR_PERFCTRL1);
@@ -134,6 +137,8 @@ static void kvm_lose_pmu(struct kvm_vcpu
 	val |= kvm_read_sw_gcsr(csr, LOONGARCH_CSR_PERFCTRL3);
 	if (!(val & KVM_PMU_EVENT_ENABLED))
 		vcpu->arch.aux_inuse &= ~KVM_LARCH_PMU;
+	else
+		kvm_make_request(KVM_REQ_PMU, vcpu);
 
 	kvm_restore_host_pmu(vcpu);
 }


