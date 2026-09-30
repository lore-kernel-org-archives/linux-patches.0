Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8766250EBFC;
	Wed, 30 Sep 2026 15:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782650; cv=none; b=cOz/CIbOWrup4oucDJt+x31fxiHtUvN3dglTn1VtnHk+MZp+sGr5w0bpyvpWW+vBo88YhoCiSIM46+jSgEArN6inYr1lWe/LLlesf2zpGhaZk5kZ63kRyAlf6gCuoe3Mgzdb6QIffOnHVPWjDeXMAZBmnCrw3GXyPJPyoLNe3VI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782650; c=relaxed/simple;
	bh=SPJJ2BeHUQSkhJAbIGRHkjQe4qi+ZhU4Y7EWDwlDGjg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K2pZ9OJJB1J1be5Ji98zLznhUzKcfRwKfvXPMDWbwE1eLa1Crwgx0nE3pmUv9Qd5l+41CCJjYmf0e54Pn5Kg7nGV0+aQ45NnjVfgJVIYq/6YnZmjx/P/egGxv9KVYre4r3sdGljFFXOuIC11rEeVJ26yRpOyr4K8uDsx/ZaWnkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RXfvzoj5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RXfvzoj5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 988CA1F000FF;
	Wed, 30 Sep 2026 15:37:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790782641;
	bh=wkIA9M9jsgCn5YDau5F/AnFepzICFmcUXTYn25S81Po=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RXfvzoj54uConPnmISrkF1r5knZ4uqZ3Dy0MfvrHb71Mav0MMGqgCG61VKOyJaqqQ
	 xtVahJKXgkzgu24eo5dcCNrZ3I7TJggxRCqXqArfHAhBH8HC1YF2V4xEXIDeHWxBy0
	 vkYr84Skqay514g7hlg2kQdRnf6pmiCQLg8trJX8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	"Maciej W. Rozycki" <macro@orcam.me.uk>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 063/595] mips: cps: Assemble jr.hb with an R2 ISA level
Date: Wed, 30 Sep 2026 17:19:16 +0200
Message-ID: <20260930152349.092884212@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit e5d64f868e484da06f5c141c18c32c01c269625e ]

A MIPS allmodconfig built with LLVM can select CPU_MIPS32_R1 together
with MIPS_MT_SMP. In that configuration clang invokes the integrated
assembler with -march=mips32, and the MIPS MT path in cps-vec.S fails
to assemble two jr.hb instructions:

  arch/mips/kernel/cps-vec.S:376:2: error: instruction requires
  a CPU feature not currently enabled

  arch/mips/kernel/cps-vec.S:490:4: error: instruction requires
  a CPU feature not currently enabled

The earlier jr.hb in the same file is already assembled inside a .set
MIPS_ISA_LEVEL_RAW scope. The two failing sites are reached after
popping back to the file's base ISA level, so LLVM correctly rejects
them for an R1 target.

Wrap those jr.hb instructions in the same ISA-level push/pop used by
the working site. This keeps the MT code unchanged while making the
required R2 hazard-branch encoding explicit to the assembler.

Assisted-by: Codex:GPT-5.5
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Reviewed-by: Maciej W. Rozycki <macro@orcam.me.uk>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/kernel/cps-vec.S | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/mips/kernel/cps-vec.S b/arch/mips/kernel/cps-vec.S
index 4db7ff055c9f7..1673c66e50c24 100644
--- a/arch/mips/kernel/cps-vec.S
+++ b/arch/mips/kernel/cps-vec.S
@@ -395,8 +395,11 @@ LEAF(mips_cps_boot_vpes)
 	.set	pop
 
 	PTR_LA	t1, 1f
+	.set	push
+	.set	MIPS_ISA_LEVEL_RAW
 	jr.hb	t1
 	 nop
+	.set	pop
 1:	mfc0	t1, CP0_MVPCONTROL
 	ori	t1, t1, MVPCONTROL_VPC
 	mtc0	t1, CP0_MVPCONTROL
@@ -509,8 +512,11 @@ LEAF(mips_cps_boot_vpes)
 	li	t0, TCHALT_H
 	mtc0	t0, CP0_TCHALT
 	PTR_LA	t0, 1f
+	.set	push
+	.set	MIPS_ISA_LEVEL_RAW
 1:	jr.hb	t0
 	 nop
+	.set	pop
 
 2:
 
-- 
2.53.0



