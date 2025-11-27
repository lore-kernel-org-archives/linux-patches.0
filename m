Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D193D334684;
	Thu, 27 Nov 2025 15:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255604; cv=none; b=IyFL2+bn45AV3MpO8sh8Hr5ruCv6urHLmBIl+CB8cqD9yxx/H7UCMJy0ZueFJ8eo+LtlYPRHjeJ0zBZRDg2D6v1n8A7gVxdmt12RPJ/yolqmtrWJiNL66lOBDd+5NdyV6cutRAaRBWfElCPFmG5Ea8wlAYi9SE11Dvim+/bshVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255604; c=relaxed/simple;
	bh=3/jwRldgeiwyd4H5vnRdc1Nw+QIzBYaKWHyrQHjbce4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dVhqctLxwbTPxpolHmxxT0iglA5Y9wmm4tLYii3+zbxrrJ4Xo+0MmxWrofh8witTDgFYf+lXcblnJTI1TtNSQij9xyDDi9GecwYGVR7axkmwEXOb8CnvdxIxQhQ6+WEJOer7pakb6Gz84gVnoOedudbDZubr+cjdy3+FT+M3RE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0uhG8QH0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0uhG8QH0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06511C4CEF8;
	Thu, 27 Nov 2025 15:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255604;
	bh=3/jwRldgeiwyd4H5vnRdc1Nw+QIzBYaKWHyrQHjbce4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0uhG8QH0igJmCMrNIjt1vdiXz9E0eHacudO8PcPQ94ZvpUtAHykssL7hPkNz6w6Jp
	 AkQIN81CBcyJSx2jGIC3FmU7j1Z84zOdsQjGMiktYh12ntg5LI1il8cgx5oW31uAdO
	 1v2Klm23IS2YfA3nyJRcunmG2JaFqZnxS9z1LWGw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hengqi Chen <hengqi.chen@gmail.com>,
	Vincent Li <vincent.mc.li@gmail.com>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.17 050/175] LoongArch: BPF: Disable trampoline for kernel module function trace
Date: Thu, 27 Nov 2025 15:45:03 +0100
Message-ID: <20251127144044.793710655@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144042.945669935@linuxfoundation.org>
References: <20251127144042.945669935@linuxfoundation.org>
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

From: Vincent Li <vincent.mc.li@gmail.com>

commit 677e6123e3d24adaa252697dc89740f2ac07664e upstream.

The current LoongArch BPF trampoline implementation is incompatible
with tracing functions in kernel modules. This causes several severe
and user-visible problems:

* The `bpf_selftests/module_attach` test fails consistently.
* Kernel lockup when a BPF program is attached to a module function [1].
* Critical kernel modules like WireGuard experience traffic disruption
  when their functions are traced with fentry [2].

Given the severity and the potential for other unknown side-effects, it
is safest to disable the feature entirely for now. This patch prevents
the BPF subsystem from allowing trampoline attachments to kernel module
functions on LoongArch.

This is a temporary mitigation until the core issues in the trampoline
code for kernel module handling can be identified and fixed.

[root@fedora bpf]# ./test_progs -a module_attach -v
bpf_testmod.ko is already unloaded.
Loading bpf_testmod.ko...
Successfully loaded bpf_testmod.ko.
test_module_attach:PASS:skel_open 0 nsec
test_module_attach:PASS:set_attach_target 0 nsec
test_module_attach:PASS:set_attach_target_explicit 0 nsec
test_module_attach:PASS:skel_load 0 nsec
libbpf: prog 'handle_fentry': failed to attach: -ENOTSUPP
libbpf: prog 'handle_fentry': failed to auto-attach: -ENOTSUPP
test_module_attach:FAIL:skel_attach skeleton attach failed: -524
Summary: 0/0 PASSED, 0 SKIPPED, 1 FAILED
Successfully unloaded bpf_testmod.ko.

[1]: https://lore.kernel.org/loongarch/CAK3+h2wDmpC-hP4u4pJY8T-yfKyk4yRzpu2LMO+C13FMT58oqQ@mail.gmail.com/
[2]: https://lore.kernel.org/loongarch/CAK3+h2wYcpc+OwdLDUBvg2rF9rvvyc5amfHT-KcFaK93uoELPg@mail.gmail.com/

Cc: stable@vger.kernel.org
Fixes: f9b6b41f0cf3 ("LoongArch: BPF: Add basic bpf trampoline support")
Acked-by: Hengqi Chen <hengqi.chen@gmail.com>
Signed-off-by: Vincent Li <vincent.mc.li@gmail.com>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/net/bpf_jit.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/loongarch/net/bpf_jit.c
+++ b/arch/loongarch/net/bpf_jit.c
@@ -1626,6 +1626,9 @@ static int __arch_prepare_bpf_trampoline
 	/* Direct jump skips 5 NOP instructions */
 	else if (is_bpf_text_address((unsigned long)orig_call))
 		orig_call += LOONGARCH_BPF_FENTRY_NBYTES;
+	/* Module tracing not supported - cause kernel lockups */
+	else if (is_module_text_address((unsigned long)orig_call))
+		return -ENOTSUPP;
 
 	if (flags & BPF_TRAMP_F_CALL_ORIG) {
 		move_addr(ctx, LOONGARCH_GPR_A0, (const u64)im);


