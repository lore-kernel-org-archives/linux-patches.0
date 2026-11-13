Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585794;
	b=A3XxLpLorQ3J1JDXLyFZGQJmGMCkXlZwL+IQTqB0j37l9606VweAsMGC1GHf9Hn3C5DH
	 sVz37ffuxjLk5H+c9k8Okt6noz+2L4/DD4RTRN2jPMbz8lnO4f5dW0r87DyTePvAxeesQ
	 HI0NHQxX5cAY3Pt6T9gJNVNBTMZ7G7CXeyQC1J5pd5/p5vv/vm7MsNqLVKzlAD+yixTL6
	 DB7z9IHoQux8eLlCBNxekW3Qx7EJEyUn51SDXbJUUCmQU63tDnsPzgQ+qUIaShSeXDFD3
	 6YH0glk6G6NF92CjuGmaz0+qMJgQv/Gt0Wo0BsRTR2+ynCvHA5NIBgKouR0a8HjBkxg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585794;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=++B4xZfsuqORT8bf4hFTKHaTKEHz9GAyXlmegnuV8L0=;
	b=OT5Biiukmj2k76vK1yFItmKSRMfqHAD8XwnaWNgR2n0P7smKZBwlkgU2/N7Ti9nIgJ4Z
	 P3gEiZykADO5v37tWEiM9t+wG6QKdFexHfEvgRT/Ro/2IwcwQDSHvwlhVD2kWQ7k1Lnu/
	 xwWwMARrnvTp49BLm1oQwfUhV2bdGppF1hWhs3Md99dVqBf5+td1ojVTWJH7KieGjqI3l
	 Z+QKyxhA8OtoXpGI5LG7Yix6AdIIkS9HLaCESJ3Uy6XQ5hLPPaSQJdKhVLjeiMKneE5Zk
	 zeryLgYG7JSFZu5IruZXyKKv21Qz+5OzOh4Cimoii3qzMWv3bQEAMe7dR90oYxtYg3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0sw6hzsY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D51F606BA96;
	Fri, 13 Nov 2026 16:03:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0sw6hzsY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDF311F000C8;
	Fri, 13 Nov 2026 16:03:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585794;
	bh=++B4xZfsuqORT8bf4hFTKHaTKEHz9GAyXlmegnuV8L0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0sw6hzsYuAMmxYuPPSRqGnmjnP2snYzx7goi7mtIMWx4wWLzOxRv3MbuzdvEKpXex
	 ay6GachitURe/eg8k8rWM6ksr2QTPNVZMMt+QQpXTM6poMUsOt8FMhSDUw7qvhy0Tp
	 NToEkvF5Ho79FNA7W5+iuTCSoG2tkZULu2Kp6k4Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Will Deacon <will@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Wei Wang <wvw@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 382/507] arm64: suspend: Save and restore TPIDR2_EL0 across CPU suspend
Date: Fri, 13 Nov 2026 10:51:26 -0500
Message-ID: <20261113153809.328432684@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Wang <wvw@google.com>

[ Upstream commit beeec04046227eba42b7cc5ab32498aa43da9632 ]

TPIDR2_EL0 is a live EL0 register on systems with SME, but
cpu_do_suspend()/cpu_do_resume() don't preserve it. Its value is
UNKNOWN after a warm reset, so the task that initiates suspend can
return to userspace with a corrupted TPIDR2_EL0.

Save and restore it alongside TPIDR_EL0 and TPIDRRO_EL0. The new slot
fits in existing padding, so sizeof(struct cpu_suspend_ctx) is
unchanged.

Fixes: a9d691585950 ("arm64/sme: Implement support for TPIDR2")
Cc: stable@vger.kernel.org
Acked-by: Will Deacon <will@kernel.org>
Reviewed-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Wei Wang <wvw@google.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/suspend.h | 2 +-
 arch/arm64/mm/proc.S             | 8 ++++++++
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/suspend.h b/arch/arm64/include/asm/suspend.h
index e9ce68d50ba45..a5abf0615594d 100644
--- a/arch/arm64/include/asm/suspend.h
+++ b/arch/arm64/include/asm/suspend.h
@@ -2,7 +2,7 @@
 #ifndef __ASM_SUSPEND_H
 #define __ASM_SUSPEND_H
 
-#define NR_CTX_REGS 14
+#define NR_CTX_REGS 15
 #define NR_CALLEE_SAVED_REGS 12
 
 /*
diff --git a/arch/arm64/mm/proc.S b/arch/arm64/mm/proc.S
index 12aacc74f7647..b1516630904d7 100644
--- a/arch/arm64/mm/proc.S
+++ b/arch/arm64/mm/proc.S
@@ -113,6 +113,10 @@ SYM_FUNC_START(cpu_do_suspend)
 alternative_if ARM64_HAS_TCR2
 	mrs	x2, REG_TCR2_EL1
 	str	x2, [x0, #104]
+alternative_else_nop_endif
+alternative_if ARM64_SME
+	mrs_s	x2, SYS_TPIDR2_EL0
+	str	x2, [x0, #112]
 alternative_else_nop_endif
 	ret
 SYM_FUNC_END(cpu_do_suspend)
@@ -152,6 +156,10 @@ alternative_if ARM64_HAS_TCR2
 	ldr	x2, [x0, #104]
 	msr	REG_TCR2_EL1, x2
 alternative_else_nop_endif
+alternative_if ARM64_SME
+	ldr	x2, [x0, #112]
+	msr_s	SYS_TPIDR2_EL0, x2
+alternative_else_nop_endif
 
 	msr	sctlr_el1, x12
 	set_this_cpu_offset x13
-- 
2.53.0



