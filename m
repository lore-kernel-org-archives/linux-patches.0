Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D767D2C3745;
	Mon, 27 Oct 2025 19:01:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591676; cv=none; b=XttD3SG5YQAeBFVKs6Ic47fqcuZDrSc4pgGoiYoEiV00RZ+iOxCL/LrT/U9ZWx+z6QsqEQLK4XFsLbCqtamrTYQTd8nPl2TURxrPXtdkqgvJrAJcIHZgM9GpKW/Fktx6/6oeFIlq/Ph+NV1jz4RSsNw59F9dySGL/TBIjNJxpHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591676; c=relaxed/simple;
	bh=uru+4rWf4vW3bCxUvPOXnnGrXOFnmg8555v+TfzqqBU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IEEyNbXmfNQKE8XhKQy63tsRy5VsGR2hZ++Dg2+zlvcdUPM+rVLOz/31xkwYqOrUDq64iulM3FvIT2FwgFjPrmtFLNJmxx/MV5J1ZHB6RSssC+t+uDbVO6+T+22XarO5wzAe/EOIYYwirNJ6zORkBl0gOrFhfpcnz7NI0FZA7W8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=glxakcG2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="glxakcG2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A357C4CEF1;
	Mon, 27 Oct 2025 19:01:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591676;
	bh=uru+4rWf4vW3bCxUvPOXnnGrXOFnmg8555v+TfzqqBU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=glxakcG2LEi8fXGl+g+a5o1OmLeTaWzH5DKTQS3CFxh5/xxekWGgMGWbWRdTieHdK
	 9nOterjYRF6L2wOe3fetdEceKXi5xcC5wijNo46KSZOqGdrm55i+EIsbb6rOuFqmBL
	 zbe5O6nbDY9+RK3/XAReplQFykdawRlmqVf27TVY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Atish Patra <atishp@rivosinc.com>,
	Tsukasa OI <research_trasio@irq.a4lg.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Anup Patel <anup@brainfault.org>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 288/332] RISC-V: Minimal parser for "riscv, isa" strings
Date: Mon, 27 Oct 2025 19:35:41 +0100
Message-ID: <20251027183532.463182630@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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

From: Tsukasa OI <research_trasio@irq.a4lg.com>

[ Upstream commit 2a31c54be097c74344b4fab20ea6104012d2cb8b ]

Current hart ISA ("riscv,isa") parser don't correctly parse:

1. Multi-letter extensions
2. Version numbers

All ISA extensions ratified recently has multi-letter extensions
(except 'H'). The current "riscv,isa" parser that is easily confused
by multi-letter extensions and "p" in version numbers can be a huge
problem for adding new extensions through the device tree.

Leaving it would create incompatible hacks and would make "riscv,isa"
value unreliable.

This commit implements minimal parser for "riscv,isa" strings.  With this,
we can safely ignore multi-letter extensions and version numbers.

[Improved commit text and fixed a bug around 's' in base extension]
Signed-off-by: Atish Patra <atishp@rivosinc.com>
[Fixed workaround for QEMU]
Signed-off-by: Tsukasa OI <research_trasio@irq.a4lg.com>
Tested-by: Heiko Stuebner <heiko@sntech.de>
Reviewed-by: Anup Patel <anup@brainfault.org>
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Stable-dep-of: d2721bb165b3 ("RISC-V: Don't print details of CPUs disabled in DT")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/cpufeature.c | 72 ++++++++++++++++++++++++++++------
 1 file changed, 61 insertions(+), 11 deletions(-)

diff --git a/arch/riscv/kernel/cpufeature.c b/arch/riscv/kernel/cpufeature.c
index ece126dad3547..54d230bdaf976 100644
--- a/arch/riscv/kernel/cpufeature.c
+++ b/arch/riscv/kernel/cpufeature.c
@@ -7,6 +7,7 @@
  */
 
 #include <linux/bitmap.h>
+#include <linux/ctype.h>
 #include <linux/of.h>
 #include <asm/processor.h>
 #include <asm/hwcap.h>
@@ -66,7 +67,7 @@ void riscv_fill_hwcap(void)
 	struct device_node *node;
 	const char *isa;
 	char print_str[NUM_ALPHA_EXTS + 1];
-	size_t i, j, isa_len;
+	int i, j;
 	static unsigned long isa2hwcap[256] = {0};
 
 	isa2hwcap['i'] = isa2hwcap['I'] = COMPAT_HWCAP_ISA_I;
@@ -92,23 +93,72 @@ void riscv_fill_hwcap(void)
 			continue;
 		}
 
-		i = 0;
-		isa_len = strlen(isa);
 #if IS_ENABLED(CONFIG_32BIT)
 		if (!strncmp(isa, "rv32", 4))
-			i += 4;
+			isa += 4;
 #elif IS_ENABLED(CONFIG_64BIT)
 		if (!strncmp(isa, "rv64", 4))
-			i += 4;
+			isa += 4;
 #endif
-		for (; i < isa_len; ++i) {
-			this_hwcap |= isa2hwcap[(unsigned char)(isa[i])];
+		for (; *isa; ++isa) {
+			const char *ext = isa++;
+			const char *ext_end = isa;
+			bool ext_long = false, ext_err = false;
+
+			switch (*ext) {
+			case 's':
+				/**
+				 * Workaround for invalid single-letter 's' & 'u'(QEMU).
+				 * No need to set the bit in riscv_isa as 's' & 'u' are
+				 * not valid ISA extensions. It works until multi-letter
+				 * extension starting with "Su" appears.
+				 */
+				if (ext[-1] != '_' && ext[1] == 'u') {
+					++isa;
+					ext_err = true;
+					break;
+				}
+				fallthrough;
+			case 'x':
+			case 'z':
+				ext_long = true;
+				/* Multi-letter extension must be delimited */
+				for (; *isa && *isa != '_'; ++isa)
+					if (!islower(*isa) && !isdigit(*isa))
+						ext_err = true;
+				break;
+			default:
+				if (unlikely(!islower(*ext))) {
+					ext_err = true;
+					break;
+				}
+				/* Find next extension */
+				if (!isdigit(*isa))
+					break;
+				/* Skip the minor version */
+				while (isdigit(*++isa))
+					;
+				if (*isa != 'p')
+					break;
+				if (!isdigit(*++isa)) {
+					--isa;
+					break;
+				}
+				/* Skip the major version */
+				while (isdigit(*++isa))
+					;
+				break;
+			}
+			if (*isa != '_')
+				--isa;
 			/*
-			 * TODO: X, Y and Z extension parsing for Host ISA
-			 * bitmap will be added in-future.
+			 * TODO: Full version-aware handling including
+			 * multi-letter extensions will be added in-future.
 			 */
-			if ('a' <= isa[i] && isa[i] < 'x')
-				this_isa |= (1UL << (isa[i] - 'a'));
+			if (ext_err || ext_long)
+				continue;
+			this_hwcap |= isa2hwcap[(unsigned char)(*ext)];
+			this_isa |= (1UL << (*ext - 'a'));
 		}
 
 		/*
-- 
2.51.0



