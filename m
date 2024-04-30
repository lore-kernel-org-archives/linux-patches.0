Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E65D12D1F1;
	Tue, 30 Apr 2024 11:14:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475685; cv=none; b=iasF/LQlOunIfy2pHYkR1bqUFGdqWNjcCu/8yJFVcuCHMVBH+CGdha0d4W2SlIJu3jM7Ct5O7ujxt8i3IYZuuoYRBbY8zp6Y3mTKHPj05PI+grisWKIm7pIzP5te5y3LC8rYzLfpwBk3bAMYUyHJ+Cv+1j3/6b40aWW1HwcjC8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475685; c=relaxed/simple;
	bh=dNN717FtmjQqxZVzOzFbSfE+19qVdldgUge3cfDCCAs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PL1yoU9alkE0j/UvzmgsJlCJ24pmrK87rwfIDIS4b1pZeYfX8PAKkWxZyFHlNfieIeLYrHL5LmR1N1HeMWMFTCsuYUz0ZKkLa4BrQvdacqSBqVP/+CkTbI6pF/XRKnMgm7fWJA4gsRcxm5sVmdH2oViSuCtOvTfDE+cK9BLF45o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PiPsjgbH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PiPsjgbH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62395C2BBFC;
	Tue, 30 Apr 2024 11:14:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475685;
	bh=dNN717FtmjQqxZVzOzFbSfE+19qVdldgUge3cfDCCAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PiPsjgbHegMB97UWBTiYToR59vOLSvSSgvVKqXumzEjXRGjK1IZd74gaVaS96TNxX
	 te20p9fyo7n9KY4flg2PO6GdyVRcPPcJc3bSVTnB6DDZnRA9XHYhevQsWRhwXIQw8A
	 U7ggn/5fH9/pSjpWjTdhjQe+Ut22aM2hCA2W1mF8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Holland <samuel.holland@sifive.com>,
	Jisheng Zhang <jszhang@kernel.org>,
	Bo Gan <ganboing@gmail.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 173/186] riscv: Fix TASK_SIZE on 64-bit NOMMU
Date: Tue, 30 Apr 2024 12:40:25 +0200
Message-ID: <20240430103103.054262772@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103058.010791820@linuxfoundation.org>
References: <20240430103058.010791820@linuxfoundation.org>
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
index eaa54a3a16212..719c3041ae1c2 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -903,7 +903,7 @@ static inline pte_t pte_swp_clear_exclusive(pte_t pte)
 #define PAGE_SHARED		__pgprot(0)
 #define PAGE_KERNEL		__pgprot(0)
 #define swapper_pg_dir		NULL
-#define TASK_SIZE		0xffffffffUL
+#define TASK_SIZE		_AC(-1, UL)
 #define VMALLOC_START		_AC(0, UL)
 #define VMALLOC_END		TASK_SIZE
 
-- 
2.43.0



