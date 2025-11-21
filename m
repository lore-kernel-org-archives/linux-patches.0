Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 146CC1F09AC;
	Fri, 21 Nov 2025 13:21:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731273; cv=none; b=okFIcrZqqXSFZSKI3HDsa5T8Qj2e2mI72XZY235FkNEQ/SHha+EcLmmcDJnjgs03TRxMpesDu4skTzEjdj7yC9pGskzovYHZdEm5zKVClaUnVZN33jEq1M+kXpjmDnMRXQZ6+seES/JtwUgtXg9ZHUGrNvIuui3fRHsnixoROlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731273; c=relaxed/simple;
	bh=wKn0WRwOGrWAgs7ruLkXPA+AXKIjWKh36wUJ93fxwqA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ru3l+px74qVyn696Ue2KFvCbNM8VFeSYIvjnGBUkdOUKct104ut+R5l00Vi5xAHXtPYbY8k0dRhfdMVXoOY4uW7HtGkFph6tZqh1gDnkRzidNwg4sDh4ve1J5svI/4oA1EBe8kqgDTpbMaYZCYBHqD7WDyj0UCVFXQa2WnlqPlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0xDxkMJk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0xDxkMJk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 942FBC4CEF1;
	Fri, 21 Nov 2025 13:21:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731273;
	bh=wKn0WRwOGrWAgs7ruLkXPA+AXKIjWKh36wUJ93fxwqA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0xDxkMJkjWGBOpY1Ty2PqmT1TxTOvMV7IG+wjaP6/A2do1FmbaWgiEvmsNtelkHQb
	 ra3D4bReK1609pbcXaMmQYyXLW9GN6TqYIXyN4JAPCYLSD1d9Imt03aSI8T6XbEQ0b
	 imeSVefg+KEUwc85OrALB8Ft1K4wt9IRor4/Y3sk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bibo Mao <maobibo@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.17 149/247] LoongArch: KVM: Restore guest PMU if it is enabled
Date: Fri, 21 Nov 2025 14:11:36 +0100
Message-ID: <20251121130200.074688584@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
@@ -133,6 +133,9 @@ static void kvm_lose_pmu(struct kvm_vcpu
 	 * Clear KVM_LARCH_PMU if the guest is not using PMU CSRs when
 	 * exiting the guest, so that the next time trap into the guest.
 	 * We don't need to deal with PMU CSRs contexts.
+	 *
+	 * Otherwise set the request bit KVM_REQ_PMU to restore guest PMU
+	 * before entering guest VM
 	 */
 	val = kvm_read_sw_gcsr(csr, LOONGARCH_CSR_PERFCTRL0);
 	val |= kvm_read_sw_gcsr(csr, LOONGARCH_CSR_PERFCTRL1);
@@ -140,6 +143,8 @@ static void kvm_lose_pmu(struct kvm_vcpu
 	val |= kvm_read_sw_gcsr(csr, LOONGARCH_CSR_PERFCTRL3);
 	if (!(val & KVM_PMU_EVENT_ENABLED))
 		vcpu->arch.aux_inuse &= ~KVM_LARCH_PMU;
+	else
+		kvm_make_request(KVM_REQ_PMU, vcpu);
 
 	kvm_restore_host_pmu(vcpu);
 }


