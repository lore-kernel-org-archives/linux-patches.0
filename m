Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77CADC8EB;
	Wed, 23 Apr 2025 14:51:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745419908; cv=none; b=oi6WReQhjXbIaVeYJBHZyODon2H8V238sb6YqmvFCxbZu1ZCMa5w9kpgp0BxWMk25ovGM6yWs3vbZY6RoG/sRrrySxRoczGqi/f+ST8Y9HIdwiGPquglbH0XpzTIoApHqpYfJfg+UqHs+6iI8U6weNWhtcndeqWLp25tDr20ahg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745419908; c=relaxed/simple;
	bh=XZ+p7uIPWIIhZp6lK4iRbcSoEX+WE0DJlxi4mUh99E0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bw8MSbyGGOyGLTHJNQrlWBm5NtxzVtlqsKPwhleV3E2GSrSSb/3yNOzTWlvJhrw4K+kaLPrETSSVUrtcZJC0dX8wTXOWdYJ2OjHnyPQBkkBrVv2V+1VoGiiMeKudo4CoQW6WV2nZsvMuAzwps8uc6Rq4YT5DRxK/xdMXq0/kStI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nnE9kCov; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nnE9kCov"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08730C4CEE8;
	Wed, 23 Apr 2025 14:51:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745419908;
	bh=XZ+p7uIPWIIhZp6lK4iRbcSoEX+WE0DJlxi4mUh99E0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nnE9kCov+ihLFTCRgFFXu68FZRVIptpt8WWvI+l151sPOX6zGRAshEn8pCLOWfYUR
	 sV+ZSDTChY8AB4YOEyXoWQCtQ99nyRi4JQPveEiBWTvEy0o4T3lHlSgdbljY573McX
	 +7f+5AtLHt6EtM+2Yi3/KsnpVLxWz4LLPf8qIzf0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Holland <samuel.holland@sifive.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 078/223] riscv: module: Allocate PLT entries for R_RISCV_PLT32
Date: Wed, 23 Apr 2025 16:42:30 +0200
Message-ID: <20250423142620.300623913@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142617.120834124@linuxfoundation.org>
References: <20250423142617.120834124@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Samuel Holland <samuel.holland@sifive.com>

[ Upstream commit 1ee1313f4722e6d67c6e9447ee81d24d6e3ff4ad ]

apply_r_riscv_plt32_rela() may need to emit a PLT entry for the
referenced symbol, so there must be space allocated in the PLT.

Fixes: 8fd6c5142395 ("riscv: Add remaining module relocations")
Signed-off-by: Samuel Holland <samuel.holland@sifive.com>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
Link: https://lore.kernel.org/r/20250409171526.862481-2-samuel.holland@sifive.com
Signed-off-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/module-sections.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/riscv/kernel/module-sections.c b/arch/riscv/kernel/module-sections.c
index e264e59e596e8..91d0b355ceeff 100644
--- a/arch/riscv/kernel/module-sections.c
+++ b/arch/riscv/kernel/module-sections.c
@@ -73,16 +73,17 @@ static bool duplicate_rela(const Elf_Rela *rela, int idx)
 static void count_max_entries(Elf_Rela *relas, int num,
 			      unsigned int *plts, unsigned int *gots)
 {
-	unsigned int type, i;
-
-	for (i = 0; i < num; i++) {
-		type = ELF_RISCV_R_TYPE(relas[i].r_info);
-		if (type == R_RISCV_CALL_PLT) {
+	for (int i = 0; i < num; i++) {
+		switch (ELF_R_TYPE(relas[i].r_info)) {
+		case R_RISCV_CALL_PLT:
+		case R_RISCV_PLT32:
 			if (!duplicate_rela(relas, i))
 				(*plts)++;
-		} else if (type == R_RISCV_GOT_HI20) {
+			break;
+		case R_RISCV_GOT_HI20:
 			if (!duplicate_rela(relas, i))
 				(*gots)++;
+			break;
 		}
 	}
 }
-- 
2.39.5



