Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34C0922301;
	Thu, 16 Jul 2026 13:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210139; cv=none; b=t9Cg2hu+KicOdFkgbCWDGR8p8Qsl3WO4Ndqc3KeX/1f8tw60j/vGpFU+vyxbX5l6v96e5Nu7CvMuwM/7IjSpPIWDE6rxm0/VpfdlE9TazmVeXWUfTnaSPqJRi34zswaPW8ti+EkpKvSyFzeW1UqPI2lrs3uI8Fr5IxEIJfGV7mU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210139; c=relaxed/simple;
	bh=cZua+gPLe5irHl+J0w53AoiqWCWH8DpSDFiJfDXIouI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QbfkJm1RqKZM6lr8OHX3GAXCYqKjYrFpf2rifUpRyvIpRen6nIe5iQvJzVvvKqEPu1h4rKcZ0k90ShwprLuvsGhxKajj+q2nWnkoHtpPj/dNWmH74D4tf9pF4FaeuhJI/cvpsJdIbc5z66t+Pc7ILc+YQzH1zztH5/BjV4dI0eY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ilpeixqd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ilpeixqd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 506831F000E9;
	Thu, 16 Jul 2026 13:55:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210137;
	bh=kYBTvLXysFBogvkFxXoWanWIxx0Mc54nSvI4Nr4OOm8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IlpeixqdY+wgwKKelEPgCfzlmUFsa4VmDbK9ngts5eTAjwjU1Z/Iwnihj0a7z+cjd
	 WmVmRC+U4JKQZkTlS6cJfXbEAKt2C9kmvg3K1NCqaigDWKbAOFuV1Cc4JyFtRqy1wt
	 m5CuaPkHRW52PoqEfL4utTXaOU2ElMYReIkwtyTc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Fuad Tabba <tabba@google.com>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 7.1 453/518] KVM: arm64: Clear __hyp_running_vcpu when flushing the pKVM hyp vCPU
Date: Thu, 16 Jul 2026 15:32:01 +0200
Message-ID: <20260716133057.757022206@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hyunwoo Kim <imv4bel@gmail.com>

commit e8042f6e1d7befb2fb6b10a75918642bcd0acf9a upstream.

flush_hyp_vcpu() copies the host vCPU context into the hyp's private
vCPU on every run. ctxt_to_vcpu() expects a guest context to have a
NULL __hyp_running_vcpu, which is only ever set on the host context, so
that it resolves the vCPU via container_of(). While this is generally
the case, flush_hyp_vcpu() copies the context verbatim and does not
enforce this, so a value provided by the host is dereferenced at EL2
(host -> EL2).

Fix by clearing __hyp_running_vcpu after the copy.

Cc: stable@vger.kernel.org
Fixes: be66e67f1750 ("KVM: arm64: Use the pKVM hyp vCPU structure in handle___kvm_vcpu_run()")
Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
Tested-by: Fuad Tabba <tabba@google.com>
Link: https://patch.msgid.link/20260606175614.83273-2-imv4bel@gmail.com
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/hyp/nvhe/hyp-main.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -131,6 +131,9 @@ static void flush_hyp_vcpu(struct pkvm_h
 
 	hyp_vcpu->vcpu.arch.ctxt	= host_vcpu->arch.ctxt;
 
+	/* __hyp_running_vcpu must be NULL in a guest context. */
+	hyp_vcpu->vcpu.arch.ctxt.__hyp_running_vcpu = NULL;
+
 	hyp_vcpu->vcpu.arch.mdcr_el2	= host_vcpu->arch.mdcr_el2;
 	hyp_vcpu->vcpu.arch.hcr_el2 &= ~(HCR_TWI | HCR_TWE);
 	hyp_vcpu->vcpu.arch.hcr_el2 |= READ_ONCE(host_vcpu->arch.hcr_el2) &


