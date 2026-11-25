Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623105;
	b=HDKBwP3t9VwSeTwCDyPNgzeL37aQYHGEGoPBeWqTkwx4s563vZpFh5GGsVNLXBNUNHuD
	 2IgFw+a4087q8jwhhqbMc/p2xiDBSK8xWAmKf+/nDrIzeDyrWZsqZg8qTvM7+oBJ/TW+H
	 fU5XW1557SOJMf9z9iUgm1mLGei+FVGxTZmvEkXeQmXElN5zSSpoSae65lrVxqgo/tEQf
	 BnjDThfH5cTFX6qG9/rCbIxPcN9Os0MZGOqokrq996YPOzGMavW7haurUoYoa/KxytIaw
	 0k2DQdl3GzwV6lTLJ/IcZ2QdCZFXsTl0TnHJBLbzoypQGQD9G0e/0+jxaDKXGRHCGvw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623105;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZKePko7CSUXV5sBEbBslkUav0uZ1eFgUHy69A5Gi/W4=;
	b=Dys+Wm/nNgryHtWoVj8f2EYMsK5V0pdoI+VEhLzNt/of/DNKk2OGaMtHxP6dpytLWXkW
	 1Sxpo5OyMVLiXUZobk2sYmaLXOF1T7enyA7ufHXU6qdwna6hJfx7QSnCOKql/WXZgBst4
	 pqIt6kaPsUw0DoprkWxD+vK+xTHQmotmjvUkycHTSpeQ2ClpQVsBdRc+ID7xrZkhPPb9y
	 /DiFFYo/i9cegTzMjm8D38UqIB2i81Klv7RCII5Ew2cmBZqP5koD4bm+vP9Me1kNC3qWQ
	 kuewQ4C0Eio70z6Ci68VfyaPkKVo6AmAoE6PtWC9eTujjRwEbHF6Q4sjthT/dLVmU5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qxaaioGz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33BAA606A31E;
	Wed, 25 Nov 2026 16:11:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qxaaioGz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 833CE1F000C0;
	Wed, 25 Nov 2026 16:11:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623105;
	bh=ZKePko7CSUXV5sBEbBslkUav0uZ1eFgUHy69A5Gi/W4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qxaaioGzyZ93XDvrmg7mxki7aOiSuUmdbPD4+Pd85oCL+5gP2KXMksp99+S140yGM
	 7+u67TXkb99SlEwMhBc2F27iVtZ7+7GYer04QjwYX1vvtzwrLjcT3Hg6cEDw3XruqL
	 qxk8tIiDBOk3r3KihwOC5FQ83GGybi2EeHZtXg24=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Brown <broonie@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 6.18 753/990] arm64: suspend: Save GCS state over suspend
Date: Wed, 25 Nov 2026 15:35:20 +0100
Message-ID: <20261125143839.696856443@linuxfoundation.org>
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

commit 7ca488055c69eed71219546deb805811854aca35 upstream.

GCSCRE0_EL1 and GCSPR_EL0 are live registers for EL0 on systems with GCS
but are not saved and restored by cpu_do_suspend()/cpu_do_resume(). This
means that the task that initiated suspend can return to userspace with
UNKNOWN or incorrect values for GCSPR_EL0 and GCSCRE0_EL1 (many fields
in GCSCRE0_EL1 reset to 0).  This will in turn lead to ongoing
corruption, including not restoring mode until a task with a different
GCS mode is run.  Fix this by saving and restoring the values over
suspend.

This increases the size of struct cpu_suspend_ctx by 16 bytes.

Fixes: 5d8b172e7005 ("arm64: Add Kconfig for Guarded Control Stack (GCS)")
Signed-off-by: Mark Brown <broonie@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/suspend.h |    2 +-
 arch/arm64/mm/proc.S             |   12 ++++++++++++
 2 files changed, 13 insertions(+), 1 deletion(-)

--- a/arch/arm64/include/asm/suspend.h
+++ b/arch/arm64/include/asm/suspend.h
@@ -2,7 +2,7 @@
 #ifndef __ASM_SUSPEND_H
 #define __ASM_SUSPEND_H
 
-#define NR_CTX_REGS 16
+#define NR_CTX_REGS 18
 #define NR_CALLEE_SAVED_REGS 12
 
 /*
--- a/arch/arm64/mm/proc.S
+++ b/arch/arm64/mm/proc.S
@@ -112,6 +112,12 @@ alternative_if ARM64_HAS_S1POE
 	mrs	x2, REG_POR_EL0
 	str	x2, [x0, #120]
 alternative_else_nop_endif
+alternative_if ARM64_HAS_GCS
+	mrs	x2, REG_GCSPR_EL0
+	str	x2, [x0, #128]
+	mrs	x2, REG_GCSCRE0_EL1
+	str	x2, [x0, #136]
+alternative_else_nop_endif
 	ret
 SYM_FUNC_END(cpu_do_suspend)
 
@@ -158,6 +164,12 @@ alternative_if ARM64_HAS_S1POE
 	ldr	x2, [x0, #120]
 	msr	REG_POR_EL0, x2
 alternative_else_nop_endif
+alternative_if ARM64_HAS_GCS
+	ldr	x2, [x0, #128]
+	msr	REG_GCSPR_EL0, x2
+	ldr	x2, [x0, #136]
+	msr	REG_GCSCRE0_EL1, x2
+alternative_else_nop_endif
 
 	msr	sctlr_el1, x12
 	set_this_cpu_offset x13


