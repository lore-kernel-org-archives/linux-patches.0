Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FFE612C534;
	Tue, 30 Apr 2024 10:57:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474632; cv=none; b=olIh5nz3SAHHpkjFWVhRH2eYTcwxFARqs8zCxEKA00RyZYxzjXRG27bSDVYOrsECmKLexY2P88e/YwFL2fejmAMgLWjBXeLw0Yn6xS2Jww4k21EOvPvqVjFAiD2VSBkE0znIuDx+Ti5/lfLx/i/Kymr1wpj4tWGdXf9WfHcqdH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474632; c=relaxed/simple;
	bh=4d4v2lb4jSXvlHK0koSGlIXQJGBgUoZCttNTYB6EUV0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Oym516SuJncxogkC4wEceb4JIrjdH7C8H29Smf3TXwkC9MDxquq1JAK6cmnvytvL4MN6pA46UlXCb+I68dFVVLa60iEZn5rm+iJA72rnDuvoL/mNIiCooTmw4CSwc87xD2X0E7yiVBQzQE5Gso9+tb4MQ6QkBmsQYd1qQScwQas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ykc0yHsJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ykc0yHsJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD695C2BBFC;
	Tue, 30 Apr 2024 10:57:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474632;
	bh=4d4v2lb4jSXvlHK0koSGlIXQJGBgUoZCttNTYB6EUV0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ykc0yHsJXf8NcjwIOsizEgb8YGRzSEEQaB1XhVk4FD8k9wQjPWGOm8LPcR5KhoUxi
	 MUqhsIeP2TqrpvtpB0cwe1af+v+5c23gzjqW+ePRdb1SHk5znU2u2lQiWPWwbiiyrV
	 rQURVy2y5cNALtlTNOmHhbacjNY4QaC+xEIS8P8Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Holland <samuel.holland@sifive.com>,
	Jisheng Zhang <jszhang@kernel.org>,
	Bo Gan <ganboing@gmail.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 214/228] riscv: Fix TASK_SIZE on 64-bit NOMMU
Date: Tue, 30 Apr 2024 12:39:52 +0200
Message-ID: <20240430103109.981056692@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103103.806426847@linuxfoundation.org>
References: <20240430103103.806426847@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index 3422ced8a07fd..39c6bb8254683 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -888,7 +888,7 @@ static inline pte_t pte_swp_clear_exclusive(pte_t pte)
 #define PAGE_SHARED		__pgprot(0)
 #define PAGE_KERNEL		__pgprot(0)
 #define swapper_pg_dir		NULL
-#define TASK_SIZE		0xffffffffUL
+#define TASK_SIZE		_AC(-1, UL)
 #define VMALLOC_START		_AC(0, UL)
 #define VMALLOC_END		TASK_SIZE
 
-- 
2.43.0



