Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F4E52D5C95;
	Mon, 27 Oct 2025 19:25:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593133; cv=none; b=tO+yNd4hDZKAnVUAb0yTKRhyKLPKVDaBvF3IIKDSDEZiHKzKu3Glvs1p0afZ0tSimelet3DYkOpEElWPIdPLhUv30Z+GHzwYjWrOTj/56yyQ4mVYygNxr+lgp+zF+940tblEpm+vIuPl/DyMkYF1hdDsSTD6AXnNedFzY/T+OWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593133; c=relaxed/simple;
	bh=2PgAkErSLldYf5JOpWaIT0H1+3w/J0e5Hb8Fxse/Jb0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=haUjzYIF6Vph+IqAlFrCuW/CPycX0qySf46gZfXPtppjvZoMzTHXcG0slA2yMNil45v3mGFbis3fFlct1ax+8K4ykN0swxchUVKKtrajJ7UOp6gRmew8jx5U6w4FVBTnuztg380Yo6q+Tlm6UUhsS0RlR7YQlTiFIigqh+jdhDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WL10WBpB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WL10WBpB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2518C4CEF1;
	Mon, 27 Oct 2025 19:25:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593133;
	bh=2PgAkErSLldYf5JOpWaIT0H1+3w/J0e5Hb8Fxse/Jb0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WL10WBpBpGN+kpmP1frT9OUcz1uaTbvtt3BFRM9zU6SidLBL/f6JHX7uRsIuaJ4Z5
	 zafq6PRNBYgTchmACb4DXM3IOAKuvEEgQQMUN/rYBXN0aqaZx8+facbcGWiHyc01qh
	 nNrUoBGar7U/uYvYPtyow/M0UaLdfTuUbx8fs1H8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Paul Walmsley <pjw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 025/184] riscv: cpufeature: add validation for zfa, zfh and zfhmin
Date: Mon, 27 Oct 2025 19:35:07 +0100
Message-ID: <20251027183515.605036950@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183514.934710872@linuxfoundation.org>
References: <20251027183514.934710872@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Clément Léger <cleger@rivosinc.com>

[ Upstream commit 2e2cf5581fccc562f7faf174ffb9866fed5cafbd ]

These extensions depends on the F one. Add a validation callback
checking for the F extension to be present. Now that extensions are
correctly reported using the F/D presence, we can remove the
has_fpu() check in hwprobe_isa_ext0().

Signed-off-by: Clément Léger <cleger@rivosinc.com>
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
Link: https://lore.kernel.org/r/20250527100001.33284-1-cleger@rivosinc.com
Signed-off-by: Paul Walmsley <pjw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/cpufeature.c  |  6 +++---
 arch/riscv/kernel/sys_hwprobe.c | 14 ++++++--------
 2 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/arch/riscv/kernel/cpufeature.c b/arch/riscv/kernel/cpufeature.c
index 743d53415572e..67b59699357da 100644
--- a/arch/riscv/kernel/cpufeature.c
+++ b/arch/riscv/kernel/cpufeature.c
@@ -474,10 +474,10 @@ const struct riscv_isa_ext_data riscv_isa_ext[] = {
 	__RISCV_ISA_EXT_DATA(zacas, RISCV_ISA_EXT_ZACAS),
 	__RISCV_ISA_EXT_DATA(zalrsc, RISCV_ISA_EXT_ZALRSC),
 	__RISCV_ISA_EXT_DATA(zawrs, RISCV_ISA_EXT_ZAWRS),
-	__RISCV_ISA_EXT_DATA(zfa, RISCV_ISA_EXT_ZFA),
+	__RISCV_ISA_EXT_DATA_VALIDATE(zfa, RISCV_ISA_EXT_ZFA, riscv_ext_f_depends),
 	__RISCV_ISA_EXT_DATA_VALIDATE(zfbfmin, RISCV_ISA_EXT_ZFBFMIN, riscv_ext_f_depends),
-	__RISCV_ISA_EXT_DATA(zfh, RISCV_ISA_EXT_ZFH),
-	__RISCV_ISA_EXT_DATA(zfhmin, RISCV_ISA_EXT_ZFHMIN),
+	__RISCV_ISA_EXT_DATA_VALIDATE(zfh, RISCV_ISA_EXT_ZFH, riscv_ext_f_depends),
+	__RISCV_ISA_EXT_DATA_VALIDATE(zfhmin, RISCV_ISA_EXT_ZFHMIN, riscv_ext_f_depends),
 	__RISCV_ISA_EXT_DATA(zca, RISCV_ISA_EXT_ZCA),
 	__RISCV_ISA_EXT_DATA_VALIDATE(zcb, RISCV_ISA_EXT_ZCB, riscv_ext_zca_depends),
 	__RISCV_ISA_EXT_DATA_VALIDATE(zcd, RISCV_ISA_EXT_ZCD, riscv_ext_zcd_validate),
diff --git a/arch/riscv/kernel/sys_hwprobe.c b/arch/riscv/kernel/sys_hwprobe.c
index 0b170e18a2beb..3e9259790816e 100644
--- a/arch/riscv/kernel/sys_hwprobe.c
+++ b/arch/riscv/kernel/sys_hwprobe.c
@@ -153,14 +153,12 @@ static void hwprobe_isa_ext0(struct riscv_hwprobe *pair,
 			EXT_KEY(ZVKT);
 		}
 
-		if (has_fpu()) {
-			EXT_KEY(ZCD);
-			EXT_KEY(ZCF);
-			EXT_KEY(ZFA);
-			EXT_KEY(ZFBFMIN);
-			EXT_KEY(ZFH);
-			EXT_KEY(ZFHMIN);
-		}
+		EXT_KEY(ZCD);
+		EXT_KEY(ZCF);
+		EXT_KEY(ZFA);
+		EXT_KEY(ZFBFMIN);
+		EXT_KEY(ZFH);
+		EXT_KEY(ZFHMIN);
 
 		if (IS_ENABLED(CONFIG_RISCV_ISA_SUPM))
 			EXT_KEY(SUPM);
-- 
2.51.0



