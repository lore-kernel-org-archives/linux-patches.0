Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ED5638F91;
	Thu,  3 Jul 2025 15:01:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554899; cv=none; b=Wienh1IAiLsgLODCIGCoXLAj6HtW8s1dDMw0PPTKUtI+c+OlrE4LuE2jsrvH1cUqZCl/ugUYarERoq2GmPsOxgIyUIxqS1DCKpDq9L2r2MVZY7t/0924TN0e/ggJK+Bc5QixAFBh7Pd9Tjy3aXklUVyVO13hfTTlj3og0o4aZP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554899; c=relaxed/simple;
	bh=d0NoP+5oK/o5th1OuZqOS+g4J9EMehi2SZ/ZcMwZ7/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WzLHzQKcpkqA0TU03UGC8Hlq9DyvNXCh+PKDX5lgf0MBr4lG/34E+DWFDtbmd87UTPrL/kr+piSO79+ORpfrrgTsmR6nDgCAf5agO/yTPOQUpUcJg3dCqsEFgiIb7Sp8fX7yHauJ7z6+i3yBUtRAnXQc3Yg9s4IRjQWRcG1KTvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YzDHeXuI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YzDHeXuI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80BAEC4CEE3;
	Thu,  3 Jul 2025 15:01:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554899;
	bh=d0NoP+5oK/o5th1OuZqOS+g4J9EMehi2SZ/ZcMwZ7/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YzDHeXuI4RdT6HXU+jfMCe7XSqrmDA3ZhwTWokCVLfNtJQKmsYo6TLnVTOiyBrsfD
	 mxURPnYaojJq3DXzC0+NdeBDUK6RwzHSnuPDj8ZcH8x6Rv3sawMJsIRIBS6UU8ixaU
	 i1+eoAv6g2FTwc16dZcbUTeuFpTlC9au6zq1XurI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Han Gao <rabenda.cn@gmail.com>,
	Xiongchuan Tan <tanxiongchuan@isrc.iscas.ac.cn>,
	Charlie Jenkins <charlie@rivosinc.com>,
	Yanteng Si <si.yanteng@linux.dev>,
	Andy Chiu <andybnac@gmail.com>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Palmer Dabbelt <palmer@dabbelt.com>
Subject: [PATCH 6.15 113/263] riscv: vector: Fix context save/restore with xtheadvector
Date: Thu,  3 Jul 2025 16:40:33 +0200
Message-ID: <20250703144008.874049190@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Han Gao <rabenda.cn@gmail.com>

commit 4262bd0d9cc704ea1365ac00afc1272400c2cbef upstream.

Previously only v0-v7 were correctly saved/restored,
and the context of v8-v31 are damanged.
Correctly save/restore v8-v31 to avoid breaking userspace.

Fixes: d863910eabaf ("riscv: vector: Support xtheadvector save/restore")
Cc: stable@vger.kernel.org
Signed-off-by: Han Gao <rabenda.cn@gmail.com>
Tested-by: Xiongchuan Tan <tanxiongchuan@isrc.iscas.ac.cn>
Reviewed-by: Charlie Jenkins <charlie@rivosinc.com>
Reviewed-by: Yanteng Si <si.yanteng@linux.dev>
Reviewed-by: Andy Chiu <andybnac@gmail.com>
Link: https://lore.kernel.org/r/9b9eb2337f3d5336ce813721f8ebea51e0b2b553.1747994822.git.rabenda.cn@gmail.com
Signed-off-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Signed-off-by: Palmer Dabbelt <palmer@dabbelt.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/include/asm/vector.h |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/arch/riscv/include/asm/vector.h
+++ b/arch/riscv/include/asm/vector.h
@@ -200,11 +200,11 @@ static inline void __riscv_v_vstate_save
 			THEAD_VSETVLI_T4X0E8M8D1
 			THEAD_VSB_V_V0T0
 			"add		t0, t0, t4\n\t"
-			THEAD_VSB_V_V0T0
+			THEAD_VSB_V_V8T0
 			"add		t0, t0, t4\n\t"
-			THEAD_VSB_V_V0T0
+			THEAD_VSB_V_V16T0
 			"add		t0, t0, t4\n\t"
-			THEAD_VSB_V_V0T0
+			THEAD_VSB_V_V24T0
 			: : "r" (datap) : "memory", "t0", "t4");
 	} else {
 		asm volatile (
@@ -236,11 +236,11 @@ static inline void __riscv_v_vstate_rest
 			THEAD_VSETVLI_T4X0E8M8D1
 			THEAD_VLB_V_V0T0
 			"add		t0, t0, t4\n\t"
-			THEAD_VLB_V_V0T0
+			THEAD_VLB_V_V8T0
 			"add		t0, t0, t4\n\t"
-			THEAD_VLB_V_V0T0
+			THEAD_VLB_V_V16T0
 			"add		t0, t0, t4\n\t"
-			THEAD_VLB_V_V0T0
+			THEAD_VLB_V_V24T0
 			: : "r" (datap) : "memory", "t0", "t4");
 	} else {
 		asm volatile (


