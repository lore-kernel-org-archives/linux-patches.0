Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623102;
	b=muqI5hErFwNXb0h+6PDnKQWGGvWOUl+R7IqH3yOTSgJ36NrTCh3nY6ciCDsZXiybLonz
	 5kByITQdZoVmQLEDdM6o167M6bC916NhXa9cSEsHU/E4S3mvd97FuTx3WfuYWhdvoJ+xS
	 8jWf7AEUNLJvdA3/GOFU13burIHQg0KpgSbBoKgdbkXZOKNIUh7RjPgqB4F0cNgf32Huo
	 ASlgDpGuJt6Ts2OlUFsWZChlKSpctvEnxMp33nOl3DICvuUhVNPCen/gnYqhRbkIvjQ9A
	 lotkKtm4pDsB/OHYfRAmK8W0hvtgO65nKxcg/10zBfG3YaROhCi1+/L2BgZBblzBhnA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623102;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UF1kQEeXRZI6ZTa1Ov+stLbNwThWe2GR7ETkxQMmYT4=;
	b=A6CMAmi6HLCSGV32RY6Yk6Y8k7bgCh34UVxXhUVrRp5RybR4zJOKgLzRY9PLMaYO4SWe
	 0jhRzErza3lXzyv8MHZ/eNCOIXBL4Ig+uS8CGPxI3cPH0PkP6n2ZA2agaAYCpL12LUJ0l
	 wLrucSeMJzU5jQ6Ixs6SsuNZe4tKbSUitHlXkRkNBBnPzfzJhO8wPvCSicpqtpRhw/LF2
	 r+3ZlHGtxLhYMpORS4qAkaHccpyVlxRgOkvbHdRdH7zP0ya6kZzLmGNaUymPSIv0MTae7
	 zVm3LWRFeXG1G8IXiFw8FKkeiNJcHwgm0zLV9bqz0SssozFb6jFbtxIuFHHqCSJPMRg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CBZ7QRqc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F07B606A326;
	Wed, 25 Nov 2026 16:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CBZ7QRqc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9E591F000CF;
	Wed, 25 Nov 2026 16:11:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623102;
	bh=UF1kQEeXRZI6ZTa1Ov+stLbNwThWe2GR7ETkxQMmYT4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CBZ7QRqc2J6ajutInNXP4uGC4pEYuHvJjMG8GLL9TSs6uGGu3BJs09xqrcrbDtpIn
	 C4gmSDKRlWy1y2wTKFnXfI9Fh5TNzV6b3lRPrnozUek1F6beqDnQQf00ows9aRCbup
	 I5A8gC1p4jzSLS7AJu2+5+kne8M2jOk3UblJu7IM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Brown <broonie@kernel.org>,
	Vladimir Murzin <vladimir.murzin@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 6.18 752/990] arm64: suspend: Save POR_EL0 over suspend
Date: Wed, 25 Nov 2026 15:35:19 +0100
Message-ID: <20261125143839.674388903@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Brown <broonie@kernel.org>

commit 2386c3dcf13e39d7576eae821af66537332c02de upstream.

POR_EL0 is a live EL0 register on systems with S1POE but it is not saved
and restored by cpu_do_suspend()/cpu_do_resume(). This means that the task
that initiated suspend can return to userspace with an UNKNOWN value. Fix
this by saving and restoring the value over suspend.

This increases the size of struct cpu_suspend_ctx.

Fixes: bf83dae90fbc ("arm64: enable the Permission Overlay Extension for EL0")
Signed-off-by: Mark Brown <broonie@kernel.org>
Cc: stable@vger.kernel.org
Reviewed-by: Vladimir Murzin <vladimir.murzin@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/suspend.h |    2 +-
 arch/arm64/mm/proc.S             |    8 ++++++++
 2 files changed, 9 insertions(+), 1 deletion(-)

--- a/arch/arm64/include/asm/suspend.h
+++ b/arch/arm64/include/asm/suspend.h
@@ -2,7 +2,7 @@
 #ifndef __ASM_SUSPEND_H
 #define __ASM_SUSPEND_H
 
-#define NR_CTX_REGS 15
+#define NR_CTX_REGS 16
 #define NR_CALLEE_SAVED_REGS 12
 
 /*
--- a/arch/arm64/mm/proc.S
+++ b/arch/arm64/mm/proc.S
@@ -108,6 +108,10 @@ alternative_if ARM64_SME
 	mrs_s	x2, SYS_TPIDR2_EL0
 	str	x2, [x0, #112]
 alternative_else_nop_endif
+alternative_if ARM64_HAS_S1POE
+	mrs	x2, REG_POR_EL0
+	str	x2, [x0, #120]
+alternative_else_nop_endif
 	ret
 SYM_FUNC_END(cpu_do_suspend)
 
@@ -150,6 +154,10 @@ alternative_if ARM64_SME
 	ldr	x2, [x0, #112]
 	msr_s	SYS_TPIDR2_EL0, x2
 alternative_else_nop_endif
+alternative_if ARM64_HAS_S1POE
+	ldr	x2, [x0, #120]
+	msr	REG_POR_EL0, x2
+alternative_else_nop_endif
 
 	msr	sctlr_el1, x12
 	set_this_cpu_offset x13


