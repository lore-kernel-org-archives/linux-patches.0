Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A07602FC4E;
	Fri, 24 Nov 2023 18:37:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PiCmBAtu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D173C433C8;
	Fri, 24 Nov 2023 18:37:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700851033;
	bh=cS7pLic9ctEjMcfYYUxiBSJBr3YJAobo4/nRV6wif+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PiCmBAtuYKbBc25UHLZdjTLwztUpBJpxLK7GnWrybEXHI+bHG336P5XOJ7f2gho/7
	 hM/w1SkrDGFzqafB1wV/loFPO341j/RO2/VLunqihXqc65sMVeIVBkC1DELLES2bC8
	 7iyNOAX4uhQSXTKQXeWWaWjOkASasmCZEXGvRtVM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maria Yu <quic_aiquny@quicinc.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 6.5 287/491] arm64: module: Fix PLT counting when CONFIG_RANDOMIZE_BASE=n
Date: Fri, 24 Nov 2023 17:48:43 +0000
Message-ID: <20231124172033.197098827@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172024.664207345@linuxfoundation.org>
References: <20231124172024.664207345@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maria Yu <quic_aiquny@quicinc.com>

commit d35686444fc80950c731e33a2f6ad4a55822be9b upstream.

The counting of module PLTs has been broken when CONFIG_RANDOMIZE_BASE=n
since commit:

  3e35d303ab7d22c4 ("arm64: module: rework module VA range selection")

Prior to that commit, when CONFIG_RANDOMIZE_BASE=n, the kernel image and
all modules were placed within a 128M region, and no PLTs were necessary
for B or BL. Hence count_plts() and partition_branch_plt_relas() skipped
handling B and BL when CONFIG_RANDOMIZE_BASE=n.

After that commit, modules can be placed anywhere within a 2G window
regardless of CONFIG_RANDOMIZE_BASE, and hence PLTs may be necessary for
B and BL even when CONFIG_RANDOMIZE_BASE=n. Unfortunately that commit
failed to update count_plts() and partition_branch_plt_relas()
accordingly.

Due to this, module_emit_plt_entry() may fail if an insufficient number
of PLT entries have been reserved, resulting in modules failing to load
with -ENOEXEC.

Fix this by counting PLTs regardless of CONFIG_RANDOMIZE_BASE in
count_plts() and partition_branch_plt_relas().

Fixes: 3e35d303ab7d ("arm64: module: rework module VA range selection")
Signed-off-by: Maria Yu <quic_aiquny@quicinc.com>
Cc: <stable@vger.kernel.org> # 6.5.x
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Fixes: 3e35d303ab7d ("arm64: module: rework module VA range selection")
Reviewed-by: Mark Rutland <mark.rutland@arm.com>
Link: https://lore.kernel.org/r/20231024010954.6768-1-quic_aiquny@quicinc.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/module-plts.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/arch/arm64/kernel/module-plts.c b/arch/arm64/kernel/module-plts.c
index bd69a4e7cd60..79200f21e123 100644
--- a/arch/arm64/kernel/module-plts.c
+++ b/arch/arm64/kernel/module-plts.c
@@ -167,9 +167,6 @@ static unsigned int count_plts(Elf64_Sym *syms, Elf64_Rela *rela, int num,
 		switch (ELF64_R_TYPE(rela[i].r_info)) {
 		case R_AARCH64_JUMP26:
 		case R_AARCH64_CALL26:
-			if (!IS_ENABLED(CONFIG_RANDOMIZE_BASE))
-				break;
-
 			/*
 			 * We only have to consider branch targets that resolve
 			 * to symbols that are defined in a different section.
@@ -269,9 +266,6 @@ static int partition_branch_plt_relas(Elf64_Sym *syms, Elf64_Rela *rela,
 {
 	int i = 0, j = numrels - 1;
 
-	if (!IS_ENABLED(CONFIG_RANDOMIZE_BASE))
-		return 0;
-
 	while (i < j) {
 		if (branch_rela_needs_plt(syms, &rela[i], dstidx))
 			i++;
-- 
2.43.0



