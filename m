Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7375339FEA;
	Fri, 24 Nov 2023 18:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aO5bMV3W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6F4FC433C8;
	Fri, 24 Nov 2023 18:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700849411;
	bh=cg8t3Mqbkf2r5o5dtEZHw8epDus23hMG460KfBCpMoo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aO5bMV3WKaDjtwJ/A5W1S51ZUoCfF5ao+RLIKU8hNaZn/ZyzKmXGOaPvtKzOKx1NR
	 biUWY/rBP1F2EHKCeQ/fpNoP03C4/9jUvaWFEexBnPasZc8X09/U63mn1rUqK2GDjE
	 0/7L79MqwAbh8m8XTUGt8MzsWhaEDFBlSKkna27M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Jones <ajones@ventanamicro.com>,
	Evan Green <evan@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 171/530] RISC-V: hwprobe: Fix vDSO SIGSEGV
Date: Fri, 24 Nov 2023 17:45:37 +0000
Message-ID: <20231124172033.286876619@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>
References: <20231124172028.107505484@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Jones <ajones@ventanamicro.com>

[ Upstream commit e1c05b3bf80f829ced464bdca90f1dfa96e8d251 ]

A hwprobe pair key is signed, but the hwprobe vDSO function was
only checking that the upper bound was valid. In order to help
avoid this type of problem in the future, and in anticipation of
this check becoming more complicated with sparse keys, introduce
and use a "key is valid" predicate function for the check.

Fixes: aa5af0aa90ba ("RISC-V: Add hwprobe vDSO function and data")
Signed-off-by: Andrew Jones <ajones@ventanamicro.com>
Reviewed-by: Evan Green <evan@rivosinc.com>
Link: https://lore.kernel.org/r/20231010165101.14942-2-ajones@ventanamicro.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/include/asm/hwprobe.h | 5 +++++
 arch/riscv/kernel/vdso/hwprobe.c | 2 +-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/include/asm/hwprobe.h b/arch/riscv/include/asm/hwprobe.h
index 78936f4ff5133..7cad513538d8d 100644
--- a/arch/riscv/include/asm/hwprobe.h
+++ b/arch/riscv/include/asm/hwprobe.h
@@ -10,4 +10,9 @@
 
 #define RISCV_HWPROBE_MAX_KEY 5
 
+static inline bool riscv_hwprobe_key_is_valid(__s64 key)
+{
+	return key >= 0 && key <= RISCV_HWPROBE_MAX_KEY;
+}
+
 #endif
diff --git a/arch/riscv/kernel/vdso/hwprobe.c b/arch/riscv/kernel/vdso/hwprobe.c
index d40bec6ac0786..cadf725ef7983 100644
--- a/arch/riscv/kernel/vdso/hwprobe.c
+++ b/arch/riscv/kernel/vdso/hwprobe.c
@@ -37,7 +37,7 @@ int __vdso_riscv_hwprobe(struct riscv_hwprobe *pairs, size_t pair_count,
 
 	/* This is something we can handle, fill out the pairs. */
 	while (p < end) {
-		if (p->key <= RISCV_HWPROBE_MAX_KEY) {
+		if (riscv_hwprobe_key_is_valid(p->key)) {
 			p->value = avd->all_cpu_hwprobe_values[p->key];
 
 		} else {
-- 
2.42.0



