Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AC2231B812;
	Mon, 27 Oct 2025 18:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761590479; cv=none; b=XVhd6ENGbL0VTCkXWHa3pfAM3Dka8SqgbspxQDKJhH3bzOdgFbTMdUqCtcPSyo7raUfD/wD6iM00lqzcKtFzy2bcOTTakHIJIpb/EGPV3nMOMu/MvbvjlRgvX+qhqBiTu+ReYh3w2ZJB9a7bDtc/jRBMFRYSuia6p/6E8+u3snQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761590479; c=relaxed/simple;
	bh=sZUdDl8nuEK2wVz2hb0Fnys8igMw/YZe6IZQpMzS96Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f5TyMb5lkumE9WJATmJGYtSCxD3Ex3Uv9mDNq+76UXeYqkuv2OiCbZxALbkHXO3lirFc6nnj/J1NiAO/Wp8OruE+FaSJn9QuKuPbVc+K6BJM0GcJngUrnwDy/yOrQCrMm4ZkOHDS/jfr0+k4apt3E+Y6cvsdXzA0u8eQNXHlsbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LvazilgZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LvazilgZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2960FC113D0;
	Mon, 27 Oct 2025 18:41:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761590479;
	bh=sZUdDl8nuEK2wVz2hb0Fnys8igMw/YZe6IZQpMzS96Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LvazilgZQD584RPTl2yG8MKQklOV8585wFyOi33R9qn5TQwzsG7lYyrklXhDcoB34
	 562E71pTWs18RBRTG2gWvug8slD0/4kFU/cCglW0/Y/q2YskklGFmzenqyUGPxNF+0
	 Le/99G1FdG6Ua/zIr7P1F4Wp+c70dy9OJd3C7VHo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>,
	Andreas Larsson <andreas@gaisler.com>,
	Sasha Levin <sashal@kernel.org>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Tony Rodriguez <unixpro1970@gmail.com>
Subject: [PATCH 5.4 060/224] sparc: fix accurate exception reporting in copy_{from,to}_user for M7
Date: Mon, 27 Oct 2025 19:33:26 +0100
Message-ID: <20251027183510.609139887@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183508.963233542@linuxfoundation.org>
References: <20251027183508.963233542@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>

[ Upstream commit 936fb512752af349fc30ccbe0afe14a2ae6d7159 ]

The referenced commit introduced exception handlers on user-space memory
references in copy_from_user and copy_to_user. These handlers return from
the respective function and calculate the remaining bytes left to copy
using the current register contents. This commit fixes a couple of bad
calculations. This will fix the return value of copy_from_user and
copy_to_user in the faulting case. The behaviour of memcpy stays unchanged.

Fixes: 34060b8fffa7 ("arch/sparc: Add accurate exception reporting in M7memcpy")
Tested-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de> # on Oracle SPARC S7
Tested-by: Tony Rodriguez <unixpro1970@gmail.com> # S7, see https://lore.kernel.org/r/98564e2e68df2dda0e00c67a75c7f7dfedb33c7e.camel@physik.fu-berlin.de
Signed-off-by: Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>
Reviewed-by: Andreas Larsson <andreas@gaisler.com>
Link: https://lore.kernel.org/r/20250905-memcpy_series-v4-5-1ca72dda195b@mkarcher.dialup.fu-berlin.de
Signed-off-by: Andreas Larsson <andreas@gaisler.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/sparc/lib/M7memcpy.S     | 20 ++++++++++----------
 arch/sparc/lib/Memcpy_utils.S |  9 +++++++++
 2 files changed, 19 insertions(+), 10 deletions(-)

diff --git a/arch/sparc/lib/M7memcpy.S b/arch/sparc/lib/M7memcpy.S
index cbd42ea7c3f7c..99357bfa8e82a 100644
--- a/arch/sparc/lib/M7memcpy.S
+++ b/arch/sparc/lib/M7memcpy.S
@@ -696,16 +696,16 @@ FUNC_NAME:
 	EX_LD_FP(LOAD(ldd, %o4+40, %f26), memcpy_retl_o2_plus_o5_plus_40)
 	faligndata %f24, %f26, %f10
 	EX_ST_FP(STORE(std, %f6, %o0+24), memcpy_retl_o2_plus_o5_plus_40)
-	EX_LD_FP(LOAD(ldd, %o4+48, %f28), memcpy_retl_o2_plus_o5_plus_40)
+	EX_LD_FP(LOAD(ldd, %o4+48, %f28), memcpy_retl_o2_plus_o5_plus_32)
 	faligndata %f26, %f28, %f12
-	EX_ST_FP(STORE(std, %f8, %o0+32), memcpy_retl_o2_plus_o5_plus_40)
+	EX_ST_FP(STORE(std, %f8, %o0+32), memcpy_retl_o2_plus_o5_plus_32)
 	add	%o4, 64, %o4
-	EX_LD_FP(LOAD(ldd, %o4-8, %f30), memcpy_retl_o2_plus_o5_plus_40)
+	EX_LD_FP(LOAD(ldd, %o4-8, %f30), memcpy_retl_o2_plus_o5_plus_24)
 	faligndata %f28, %f30, %f14
-	EX_ST_FP(STORE(std, %f10, %o0+40), memcpy_retl_o2_plus_o5_plus_40)
-	EX_ST_FP(STORE(std, %f12, %o0+48), memcpy_retl_o2_plus_o5_plus_40)
+	EX_ST_FP(STORE(std, %f10, %o0+40), memcpy_retl_o2_plus_o5_plus_24)
+	EX_ST_FP(STORE(std, %f12, %o0+48), memcpy_retl_o2_plus_o5_plus_16)
 	add	%o0, 64, %o0
-	EX_ST_FP(STORE(std, %f14, %o0-8), memcpy_retl_o2_plus_o5_plus_40)
+	EX_ST_FP(STORE(std, %f14, %o0-8), memcpy_retl_o2_plus_o5_plus_8)
 	fsrc2	%f30, %f14
 	bgu,pt	%xcc, .Lunalign_sloop
 	 prefetch [%o4 + (8 * BLOCK_SIZE)], 20
@@ -728,7 +728,7 @@ FUNC_NAME:
 	add	%o4, 8, %o4
 	faligndata %f0, %f2, %f16
 	subcc	%o5, 8, %o5
-	EX_ST_FP(STORE(std, %f16, %o0), memcpy_retl_o2_plus_o5)
+	EX_ST_FP(STORE(std, %f16, %o0), memcpy_retl_o2_plus_o5_plus_8)
 	fsrc2	%f2, %f0
 	bgu,pt	%xcc, .Lunalign_by8
 	 add	%o0, 8, %o0
@@ -772,7 +772,7 @@ FUNC_NAME:
 	subcc	%o5, 0x20, %o5
 	EX_ST(STORE(stx, %o3, %o0 + 0x00), memcpy_retl_o2_plus_o5_plus_32)
 	EX_ST(STORE(stx, %g2, %o0 + 0x08), memcpy_retl_o2_plus_o5_plus_24)
-	EX_ST(STORE(stx, %g7, %o0 + 0x10), memcpy_retl_o2_plus_o5_plus_24)
+	EX_ST(STORE(stx, %g7, %o0 + 0x10), memcpy_retl_o2_plus_o5_plus_16)
 	EX_ST(STORE(stx, %o4, %o0 + 0x18), memcpy_retl_o2_plus_o5_plus_8)
 	bne,pt	%xcc, 1b
 	 add	%o0, 0x20, %o0
@@ -804,12 +804,12 @@ FUNC_NAME:
 	brz,pt	%o3, 2f
 	 sub	%o2, %o3, %o2
 
-1:	EX_LD(LOAD(ldub, %o1 + 0x00, %g2), memcpy_retl_o2_plus_g1)
+1:	EX_LD(LOAD(ldub, %o1 + 0x00, %g2), memcpy_retl_o2_plus_o3)
 	add	%o1, 1, %o1
 	subcc	%o3, 1, %o3
 	add	%o0, 1, %o0
 	bne,pt	%xcc, 1b
-	 EX_ST(STORE(stb, %g2, %o0 - 0x01), memcpy_retl_o2_plus_g1_plus_1)
+	 EX_ST(STORE(stb, %g2, %o0 - 0x01), memcpy_retl_o2_plus_o3_plus_1)
 2:
 	and	%o1, 0x7, %o3
 	brz,pn	%o3, .Lmedium_noprefetch_cp
diff --git a/arch/sparc/lib/Memcpy_utils.S b/arch/sparc/lib/Memcpy_utils.S
index 64fbac28b3db1..207343367bb2d 100644
--- a/arch/sparc/lib/Memcpy_utils.S
+++ b/arch/sparc/lib/Memcpy_utils.S
@@ -137,6 +137,15 @@ ENTRY(memcpy_retl_o2_plus_63_8)
 	ba,pt	%xcc, __restore_asi
 	 add	%o2, 8, %o0
 ENDPROC(memcpy_retl_o2_plus_63_8)
+ENTRY(memcpy_retl_o2_plus_o3)
+	ba,pt	%xcc, __restore_asi
+	 add	%o2, %o3, %o0
+ENDPROC(memcpy_retl_o2_plus_o3)
+ENTRY(memcpy_retl_o2_plus_o3_plus_1)
+	add	%o3, 1, %o3
+	ba,pt	%xcc, __restore_asi
+	 add	%o2, %o3, %o0
+ENDPROC(memcpy_retl_o2_plus_o3_plus_1)
 ENTRY(memcpy_retl_o2_plus_o5)
 	ba,pt	%xcc, __restore_asi
 	 add	%o2, %o5, %o0
-- 
2.51.0



