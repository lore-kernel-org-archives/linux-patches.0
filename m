Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 030C428EB
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 14:08:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D142C4339B;
	Mon, 30 Jan 2023 14:08:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675087700;
	bh=Hr2W4gaAjdGlVp+cggVmW4is9db3JoUMLLwy8ldIHpU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=juBqk1CRZBf7rl8HpDM5BUKOLVBScqRi6sVsxYKtyUMkY5/Q/NCM7+xptfWqcenWB
	 0lW7h167e8WW9O9j6J7a0Vzwdq/QmrUmv4nLP5nxOMN0rR8c1G/b4YEXFO8OXaBeYh
	 S0y+F9HiSG6TGjiKA1Q+FpaFWpRek+1j8OY+TDlM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Conor Dooley <conor.dooley@microchip.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Ley Foon Tan <leyfoon.tan@starfivetech.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 294/313] riscv: Move call to init_cpu_topology() to later initialization stage
Date: Mon, 30 Jan 2023 14:52:09 +0100
Message-Id: <20230130134350.439174898@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ley Foon Tan <leyfoon.tan@starfivetech.com>

[ Upstream commit c1d6105869464635d8a2bcf87a43c05f4c0cfca4 ]

If "capacity-dmips-mhz" is present in a CPU DT node,
topology_parse_cpu_capacity() will fail to allocate memory.  arm64, with
which this code path is shared, does not call
topology_parse_cpu_capacity() until later in boot where memory
allocation is available.  While "capacity-dmips-mhz" is not yet a valid
property on RISC-V, invalid properties should be ignored rather than
cause issues.  Move init_cpu_topology(), which calls
topology_parse_cpu_capacity(), to a later initialization stage, to match
arm64.

As a side effect of this change, RISC-V is "protected" from changes to
core topology code that would work on arm64 where memory allocation is
safe but on RISC-V isn't.

Fixes: 03f11f03dbfe ("RISC-V: Parse cpu topology during boot.")
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
Signed-off-by: Ley Foon Tan <leyfoon.tan@starfivetech.com>
Link: https://lore.kernel.org/r/20230105033705.3946130-1-leyfoon.tan@starfivetech.com
[Palmer: use Conor's commit text]
Link: https://lore.kernel.org/linux-riscv/20230104183033.755668-1-pierre.gondois@arm.com/T/#me592d4c8b9508642954839f0077288a353b0b9b2
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/smpboot.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/kernel/smpboot.c b/arch/riscv/kernel/smpboot.c
index 3373df413c88..ddb2afba6d25 100644
--- a/arch/riscv/kernel/smpboot.c
+++ b/arch/riscv/kernel/smpboot.c
@@ -39,7 +39,6 @@ static DECLARE_COMPLETION(cpu_running);
 
 void __init smp_prepare_boot_cpu(void)
 {
-	init_cpu_topology();
 }
 
 void __init smp_prepare_cpus(unsigned int max_cpus)
@@ -48,6 +47,8 @@ void __init smp_prepare_cpus(unsigned int max_cpus)
 	int ret;
 	unsigned int curr_cpuid;
 
+	init_cpu_topology();
+
 	curr_cpuid = smp_processor_id();
 	store_cpu_topology(curr_cpuid);
 	numa_store_cpu_info(curr_cpuid);
-- 
2.39.0



