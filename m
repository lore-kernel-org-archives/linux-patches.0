Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EE162F0C74;
	Fri,  7 Aug 2026 15:31:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116675; cv=none; b=kaKQmCzzax6czhSCUYf8rQILmgrcRqA22l8Oqx1bgUPqncZAHjzfMpX/IF7kWvHJ9ATBUw584xZrqW2pjb51yuwLate8mI/YcZe0OqvYNIKQjNgFD4oDsg9A6g76rU4NC3TIfLkoGXGYLW/vN8V8SDQCkCvuKY9B9uYnTmJtkTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116675; c=relaxed/simple;
	bh=uzpIJAS2l2L0Fzg4mFCcDK4l7aCTEdGcvFGBLYJXURE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KQV7k0Srj5BjC+UQlanghlc7iCtZVzCctc9nfElwYQdoo8FwP9YjMww7D6yCeT7e9V7feseKsezHA+OUC8Qp90PAn1v+4ciNCe+lm3eC/XEf58qXYWadLODHHTCLqSx6Yo2i41wMBDySBQJI5Hd8jy2VrOoa0ic5mHDtpu9ch+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PD98+p7A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PD98+p7A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B34D1F000E9;
	Fri,  7 Aug 2026 15:31:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116674;
	bh=FYrwOYCyLQ30xq8TLb8vwoVkRdEpkkftArL7bI2LE5g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PD98+p7AljhKLUKMwjkJjFcR6m+kZpFhPs9Ddpshlc59AylwdjjwheSoyQXsUGKTB
	 LyjCPw3GRP4McNebinY9v1Vhuh+SzCwVDg60RgVyRMtNAbJqRgEzdm8OCqyiPT/t+R
	 OmwlrjkRyWnmeuUozXoIY5CGK5ODrerHFtUir0wY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Donnefort <vdonnefort@google.com>,
	Fuad Tabba <tabba@google.com>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 050/438] KVM: arm64: Add missing hyp_enter when trapping sysreg
Date: Fri,  7 Aug 2026 16:34:06 +0200
Message-ID: <20260807143429.061635138@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

From: Vincent Donnefort <vdonnefort@google.com>

[ Upstream commit e7821048e8d72a94b1fb7422f8b45aa374ff076f ]

Add a missing hypervisor event call for hyp_enter on sysreg trapping,
causing an unbalanced hyp_enter/hyp_exit.

The enum hyp_enter_exit_reason is not ABI, so we can keep the ERET
reasons at the end for clarity.

Fixes: 696dfec22b8e ("KVM: arm64: Add hyp_enter/hyp_exit events to nVHE/pKVM hyp")
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
Tested-by: Fuad Tabba <tabba@google.com>
Link: https://patch.msgid.link/20260617095238.1530121-1-vdonnefort@google.com
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/kvm_hypevents.h | 1 +
 arch/arm64/kvm/hyp/nvhe/hyp-main.c     | 1 +
 arch/arm64/kvm/hyp_trace.c             | 1 +
 3 files changed, 3 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_hypevents.h b/arch/arm64/include/asm/kvm_hypevents.h
index 743c49bd878f7..5f6e6789d1211 100644
--- a/arch/arm64/include/asm/kvm_hypevents.h
+++ b/arch/arm64/include/asm/kvm_hypevents.h
@@ -12,6 +12,7 @@
 enum hyp_enter_exit_reason {
 	HYP_REASON_SMC,
 	HYP_REASON_HVC,
+	HYP_REASON_SYS,
 	HYP_REASON_PSCI,
 	HYP_REASON_HOST_ABORT,
 	HYP_REASON_GUEST_EXIT,
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index a0da08caa6c27..4cd321c27d042 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -925,6 +925,7 @@ void handle_trap(struct kvm_cpu_context *host_ctxt)
 		handle_host_mem_abort(host_ctxt);
 		break;
 	case ESR_ELx_EC_SYS64:
+		trace_hyp_enter(host_ctxt, HYP_REASON_SYS);
 		if (handle_host_mte(esr))
 			break;
 		fallthrough;
diff --git a/arch/arm64/kvm/hyp_trace.c b/arch/arm64/kvm/hyp_trace.c
index 3f4ba2034a155..210807edacf7f 100644
--- a/arch/arm64/kvm/hyp_trace.c
+++ b/arch/arm64/kvm/hyp_trace.c
@@ -409,6 +409,7 @@ static const char *__hyp_enter_exit_reason_str(u8 reason)
 	static const char strs[][12] = {
 		"smc",
 		"hvc",
+		"sys",
 		"psci",
 		"host_abort",
 		"guest_exit",
-- 
2.53.0



