Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 162F02BB17;
	Tue, 11 Nov 2025 01:36:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824964; cv=none; b=qZWgtxzCqahb02+T4gRcoaxxgilpXv+55xeihvZBa3WD9Xgw6zzcdS3OqZjIjx22xB4uRvlh5ST6FIc3ErWlFMhhQRgk6r4wngTg0O8YYH1xeLfBLzZeVAXQOR7WL7k49jXkHMhHl0bB+F2tzY8EryHE66hhvlSkTRYRPsil3RI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824964; c=relaxed/simple;
	bh=UKnQjszi38AztQsb8m4Fy7BPkz8MDvnsULDopIkVmi8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d5ZCBGaVA+NOzvr8Ki97P460pVnUf26rSO3JPXa2jSZVgsl3nHAHjsnNmXM8tvN3jtr/ALp6/1P8+KBbstfyv00hs4mEq6Tk0enLNQuNzHs4z42KvMmCMG+Kyx8VW7zF8/Zfny6053HIdDeL3JJzOzEycXOgeCjp/4zMiz90Quc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IBuZn3Na; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IBuZn3Na"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6DCCC116B1;
	Tue, 11 Nov 2025 01:36:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824964;
	bh=UKnQjszi38AztQsb8m4Fy7BPkz8MDvnsULDopIkVmi8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IBuZn3NaL2eTq+/wxZKvIxp1rePYQFQjTT/v4H8EPh4lpViw++7/zHFl++zSSux5F
	 ETy1Qdew+yZq/qeeG5dPVLtKEh3psnvT2rk2lIsYu/wI6ztGlMs7hFVP1tKpKB2WMm
	 XLLDWQa9ZixlZ0i58lJwdFbKiujOxY9ohjbEM1Ng=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Koakuma <koachan@protonmail.com>,
	Andreas Larsson <andreas@gaisler.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 606/849] sparc/module: Add R_SPARC_UA64 relocation handling
Date: Tue, 11 Nov 2025 09:42:56 +0900
Message-ID: <20251111004551.071861617@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Koakuma <koachan@protonmail.com>

[ Upstream commit 05457d96175d25c976ab6241c332ae2eb5e07833 ]

This is needed so that the kernel can handle R_SPARC_UA64 relocations,
which is emitted by LLVM's IAS.

Signed-off-by: Koakuma <koachan@protonmail.com>
Reviewed-by: Andreas Larsson <andreas@gaisler.com>
Signed-off-by: Andreas Larsson <andreas@gaisler.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/sparc/include/asm/elf_64.h | 1 +
 arch/sparc/kernel/module.c      | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/sparc/include/asm/elf_64.h b/arch/sparc/include/asm/elf_64.h
index 8fb09eec8c3e7..694ed081cf8d9 100644
--- a/arch/sparc/include/asm/elf_64.h
+++ b/arch/sparc/include/asm/elf_64.h
@@ -58,6 +58,7 @@
 #define R_SPARC_7		43
 #define R_SPARC_5		44
 #define R_SPARC_6		45
+#define R_SPARC_UA64		54
 
 /* Bits present in AT_HWCAP, primarily for Sparc32.  */
 #define HWCAP_SPARC_FLUSH       0x00000001
diff --git a/arch/sparc/kernel/module.c b/arch/sparc/kernel/module.c
index b8c51cc23d969..6e3d4dde4f9ab 100644
--- a/arch/sparc/kernel/module.c
+++ b/arch/sparc/kernel/module.c
@@ -87,6 +87,7 @@ int apply_relocate_add(Elf_Shdr *sechdrs,
 			break;
 #ifdef CONFIG_SPARC64
 		case R_SPARC_64:
+		case R_SPARC_UA64:
 			location[0] = v >> 56;
 			location[1] = v >> 48;
 			location[2] = v >> 40;
-- 
2.51.0



