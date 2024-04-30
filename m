Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 457FF12CD96;
	Tue, 30 Apr 2024 11:05:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475143; cv=none; b=ufE2ycVqQ5+dewKLt6Pbm3UwaCTgQBPiPwBJ+TdVqE3+CINQNOEGMbLUqewFMPAWBbpF4XZKsCnEcpgameBIKgv7aSOEVEaTQxw33wUKqMr3OTfbidS/qXdPOE70vvlhk7zN0trlaXFSH9SsHdvdv8TsGvryJhE8o4Mo7WU64ow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475143; c=relaxed/simple;
	bh=Op6qcBLJXvAEK+q8QPLjhZGv4t7PB4Gu9fFFpocc3Kw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sKa4+yr2hc2OZafWE6k6XFTiSxn2dt05JRTBMOcsMSUwXrBu2aziFVabGFndXQjjB9NoXO7AXssFQ9H3z4VaAqhQryEctytPI60yTapmWQNYAYump/zMNWXTGEbZD1ELWssHupJlu9oXW+FYMOZRQgUMxGuU2h+Gtfe59rudYSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WsIPgDTD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WsIPgDTD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6467EC4AF19;
	Tue, 30 Apr 2024 11:05:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475142;
	bh=Op6qcBLJXvAEK+q8QPLjhZGv4t7PB4Gu9fFFpocc3Kw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WsIPgDTDWkNX6m2llPb8l7woD1txpGLlZYBOtlo9AUuWIRMj047vQlt2lgIhmoE4I
	 tEXW84k/NtJUXYz70pmqAbWUzjfOiuOxdeOh0dJWThI/zPLrS9+iQX6I1CCJtqLf9H
	 9Oqw66QJNAwd44LyOoZGpDXX6YT+EwgfDiRJZOp0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Holland <samuel.holland@sifive.com>,
	Jisheng Zhang <jszhang@kernel.org>,
	Bo Gan <ganboing@gmail.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 132/138] riscv: Fix TASK_SIZE on 64-bit NOMMU
Date: Tue, 30 Apr 2024 12:40:17 +0200
Message-ID: <20240430103053.287991181@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103049.422035273@linuxfoundation.org>
References: <20240430103049.422035273@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Samuel Holland <samuel.holland@sifive.com>

[ Upstream commit 6065e736f82c817c9a597a31ee67f0ce4628e948 ]

On NOMMU, userspace memory can come from anywhere in physical RAM. The
current definition of TASK_SIZE is wrong if any RAM exists above 4G,
causing spurious failures in the userspace access routines.

Fixes: 6bd33e1ece52 ("riscv: add nommu support")
Fixes: c3f896dcf1e4 ("mm: switch the test_vmalloc module to use __vmalloc_node")
Signed-off-by: Samuel Holland <samuel.holland@sifive.com>
Reviewed-by: Jisheng Zhang <jszhang@kernel.org>
Reviewed-by: Bo Gan <ganboing@gmail.com>
Link: https://lore.kernel.org/r/20240227003630.3634533-2-samuel.holland@sifive.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/include/asm/pgtable.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
index d048fb5faa691..982745572945e 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -456,7 +456,7 @@ static inline int ptep_clear_flush_young(struct vm_area_struct *vma,
 #define PAGE_SHARED		__pgprot(0)
 #define PAGE_KERNEL		__pgprot(0)
 #define swapper_pg_dir		NULL
-#define TASK_SIZE		0xffffffffUL
+#define TASK_SIZE		_AC(-1, UL)
 #define VMALLOC_START		_AC(0, UL)
 #define VMALLOC_END		TASK_SIZE
 
-- 
2.43.0



