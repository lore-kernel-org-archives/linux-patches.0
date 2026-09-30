Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A1EE47A0DD;
	Wed, 30 Sep 2026 17:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790783; cv=none; b=b7SCzFornkNd++Gxa9ZaNaeZR1+gVHJwjII69vXbxDSuHvBqz1cM6f48nZtMngh418kQ/Xk7q6kYhr1iWwUBTGexq5WXTamkyd/EH94pjLPwKHC7X3Kd2DPt1r3hUTd7EmOCANAS2kt0IsZQTxzGo7Wa+P75sC1anN0n6cGY8eE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790783; c=relaxed/simple;
	bh=seNHZsx+2ofDP2CLVj3VdW0l76C3L8E3xOUH7DYhxpA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E7pUHcuMzGqEoAmPGZLH5YO3L/KfYJIk/6kNjkQ/C+1JyA0FTQwxhGmmNCfzVs07ROgCnAbMe/8RbOP8hX5uNiQS+y9oUD9Va+94wJOGdAlMuyidOf686cWo697ih8gh+IqXLN+BFvJAniFVcmAqvPOKHh6HaEnBa5xl5Ewj22c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ez/JF0GI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ez/JF0GI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50C691F000FF;
	Wed, 30 Sep 2026 17:53:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790781;
	bh=Tz+I1N7AA3IRSq5x0cKdQ2Z0hkTSotD3oRjuS9z5y6c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ez/JF0GIiR3+sg5reLgjx+wgT47nkNKYQZ+m/n4USE+9Zff1P/6YSADV+y6r6B5+Q
	 RKW2R7l00o7uY8Xb5L0gdHlWO47+boctgDc/jEgzruXbfLZtg92sUS2oO6aCPQa9A4
	 iuO/0XriQDh4rZ6Zl2xoKsxBUxWtxFZuSCAWBYGE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	"Maciej W. Rozycki" <macro@orcam.me.uk>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 070/752] mips: cps: Assemble jr.hb with an R2 ISA level
Date: Wed, 30 Sep 2026 17:19:00 +0200
Message-ID: <20260930152359.680124092@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 9753432401487..156abad9c3249 100644
--- a/arch/mips/kernel/cps-vec.S
+++ b/arch/mips/kernel/cps-vec.S
@@ -394,8 +394,11 @@ LEAF(mips_cps_boot_vpes)
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
@@ -508,8 +511,11 @@ LEAF(mips_cps_boot_vpes)
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



