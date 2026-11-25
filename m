Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625746;
	b=ay9htFCp4oYBhDYEzFOUbbnMNqiTT0uRztjrXodZy7UXxv+Ak/RfUp/qabnHWsTmvvRn
	 ri9Qt9ePJ5mNlZrCHCLghy+4rrOhCrW09O4fPRVr66RuvcEzU35o77fAiitdDKfsNxvmH
	 s5dp4NArK/nQd4GLLwl9bifjfSye8wQQVXPvn4P75dsWTUyw5zdPXj7UCGUXaK85I/n62
	 NtjgcKQeq84IkMK8IJ/DLldwDL8n+yrs55J9b7qOqhTmJ5ERyi0RP7R27VEf8sXM/qSOj
	 rdgLHjGc7XSPv0reCf7C9LpW3V6jJnVHAiDPLbVllOl9kgpl69zQ7FBLk0fmLRDfC3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625746;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=T3ooOa+ovF5Xoc3z1jLwGRtGSvN2j9hkiuKXJ6redfA=;
	b=xUm3Ln3CrlvXoJRYIwx4iACJ8DOEtP6mMrc471rLpwWdiijO+H9dxHKDjiNoABMh9AhD
	 4GioPHvHrjpkHVKhRvf5uHmkIEKlCYkrmLpiz0Yc+/Sy25Euqi43wt4CVPj+N64osFkjO
	 5BiZfgSY+zbvxqqV/3rwy/QEdUO9CWxr2prGykCWgNSzJqvSua52d6L7cm7x+9tfW6X1z
	 nwV4NBsyFjhz6+E+9OQ76KfahpxscBbAUZPze97wUOCTJnridiDk+lRYkcS5oBqhpORRJ
	 eTJRzXgSoyuoaGGIYxYquokXRhUJbFJ5GqL1iTaKB6da0PBXw52fbTkysLAGBiEYGZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="HZUIE/TO";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9882606A686;
	Wed, 25 Nov 2026 16:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HZUIE/TO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BDCE1F000CA;
	Wed, 25 Nov 2026 16:55:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625746;
	bh=T3ooOa+ovF5Xoc3z1jLwGRtGSvN2j9hkiuKXJ6redfA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HZUIE/TO4FFYQXBut7ThVOxJTe0cUtQmVrzIMq6mewvYqEJaaDan+HvtCSmtp/57S
	 727Yx4Rynv3Oo20WG2VrFro3aGN0fZVuxYsU0q/JQOT/B7Z9oOEe3ueElj4bCrlahU
	 MOVJEhWntdy5cP76vZXvqFY5z0tHMsYGkcyKJvCM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Brown <broonie@kernel.org>,
	Vladimir Murzin <vladimir.murzin@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 6.12 620/816] arm64: suspend: Save POR_EL0 over suspend
Date: Wed, 25 Nov 2026 15:36:08 +0100
Message-ID: <20261125143903.533780952@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


