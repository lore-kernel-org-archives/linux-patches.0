Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E585B27448;
	Wed,  7 Aug 2024 15:05:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043149; cv=none; b=EWVJtmYGQTj5ZA9dBLw9ooSobLpNQdXeNXviKx/rwFvkKm5Bh7x13VZ29q8jp8HR2y9LPDqiyx6XXISjLQHmwKxX7y13J74tNbCWU7FROhQqY1ak+n+sdPjwLCXfMeX+M97jdV0BZ+9+igMCTHLs+amjxwvNHOoCApUqyxWjYM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043149; c=relaxed/simple;
	bh=v48d8U20Gnvo+Ftx7tUwXDgkkEfJ4v5NPe/vdvJ3qGg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pj3uAgUcAILdk5f4pmAmBEAgaz9MCPcut17AmOeH8iQ1D6Y8Vpcpi7bfFnJHOAFU2dcY+smN0dAiFITxVOCA8gHKsP3NPTFjXv+G7d2LRvYva564iT18ituR4CrAFJC/Epa2BXmmOLiU8UBUMx3j67Nc8vJ3R//XS8afJPqfPmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B87V/E5l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B87V/E5l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77EB8C32781;
	Wed,  7 Aug 2024 15:05:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043148;
	bh=v48d8U20Gnvo+Ftx7tUwXDgkkEfJ4v5NPe/vdvJ3qGg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B87V/E5lYquCCZXOlPwBB5FfWs7DmKaKgwTzYKbS0y3BdJ/hVORUmLBaXjTsvp1Mt
	 GPn4Aa5GDqMtxpsZWd9SZVv6NfpViZfJAWKf+ahTgrrwe3AShoQkyrGO3TQ1ALzTC7
	 LzKHFxzAtMLfy2hjfXoYPab67bVNDbZ6YLBZNzEI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nick Hu <nick.hu@sifive.com>,
	Anup Patel <anup@brainfault.org>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 072/123] RISC-V: Enable the IPI before workqueue_online_cpu()
Date: Wed,  7 Aug 2024 16:59:51 +0200
Message-ID: <20240807150023.134133059@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150020.790615758@linuxfoundation.org>
References: <20240807150020.790615758@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nick Hu <nick.hu@sifive.com>

[ Upstream commit 3908ba2e0b2476e2ec13e15967bf6a37e449f2af ]

Sometimes the hotplug cpu stalls at the arch_cpu_idle() for a while after
workqueue_online_cpu(). When cpu stalls at the idle loop, the reschedule
IPI is pending. However the enable bit is not enabled yet so the cpu stalls
at WFI until watchdog timeout. Therefore enable the IPI before the
workqueue_online_cpu() to fix the issue.

Fixes: 63c5484e7495 ("workqueue: Add multiple affinity scopes and interface to select them")
Signed-off-by: Nick Hu <nick.hu@sifive.com>
Reviewed-by: Anup Patel <anup@brainfault.org>
Link: https://lore.kernel.org/r/20240717031714.1946036-1-nick.hu@sifive.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/sbi-ipi.c | 2 +-
 include/linux/cpuhotplug.h  | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/kernel/sbi-ipi.c b/arch/riscv/kernel/sbi-ipi.c
index 1026e22955ccc..0cc5559c08d8f 100644
--- a/arch/riscv/kernel/sbi-ipi.c
+++ b/arch/riscv/kernel/sbi-ipi.c
@@ -71,7 +71,7 @@ void __init sbi_ipi_init(void)
 	 * the masking/unmasking of virtual IPIs is done
 	 * via generic IPI-Mux
 	 */
-	cpuhp_setup_state(CPUHP_AP_ONLINE_DYN,
+	cpuhp_setup_state(CPUHP_AP_IRQ_RISCV_SBI_IPI_STARTING,
 			  "irqchip/sbi-ipi:starting",
 			  sbi_ipi_starting_cpu, NULL);
 
diff --git a/include/linux/cpuhotplug.h b/include/linux/cpuhotplug.h
index 7a5785f405b62..0a8fd4a3d04c9 100644
--- a/include/linux/cpuhotplug.h
+++ b/include/linux/cpuhotplug.h
@@ -147,6 +147,7 @@ enum cpuhp_state {
 	CPUHP_AP_IRQ_LOONGARCH_STARTING,
 	CPUHP_AP_IRQ_SIFIVE_PLIC_STARTING,
 	CPUHP_AP_IRQ_RISCV_IMSIC_STARTING,
+	CPUHP_AP_IRQ_RISCV_SBI_IPI_STARTING,
 	CPUHP_AP_ARM_MVEBU_COHERENCY,
 	CPUHP_AP_PERF_X86_AMD_UNCORE_STARTING,
 	CPUHP_AP_PERF_X86_STARTING,
-- 
2.43.0



