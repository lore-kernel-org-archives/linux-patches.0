Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 617BD36C0B5;
	Wed,  3 Dec 2025 16:31:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779517; cv=none; b=uI/sSzvAv5ihpDt6QF3lvj9o5Y6A3idAPRqpKmJ0DzvJTbzguDT+/yfWystmUJC2xeR5YrYNSxafr1Lm8PGFcf8aTKRPEw7dLQXtTqIID+aaadI+UTjvqvcE5ceIP8L1fet2sRO+3KJpgDVvk6FOsEFwg/mF/KKdPKC1u9ZKtbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779517; c=relaxed/simple;
	bh=ZTw6eiIwaS51Aah7S0py8q796ZPy9hY/C7pGHbQxDQ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oUuiR32d1L1PMXYx9/mTrgBtaz6XsA9GZHszD0HT8DyegTjIerPvSK2tdkVZ1R3JA8IcOONrEg8LcTzxG11fDcuu/qUt9YMt7OpMHJVnTxJqOfUz31rSpzGpBPhJq2T3A2HkM66gyhbKhxg3u60NCevGkALL3T+rj56IYGW+vYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uwnVC7VO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uwnVC7VO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0A8DC116C6;
	Wed,  3 Dec 2025 16:31:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779517;
	bh=ZTw6eiIwaS51Aah7S0py8q796ZPy9hY/C7pGHbQxDQ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uwnVC7VOFAaamCwUWHaWR32kYX7e/3a+XX3tmCHldHEKT9iiVpSG78hxkacK3Qoe5
	 2U7VeJAm6siajkEBzhPAQLHvwXwFgqA0xButsautsixfOMus2gZZbjCfppC8K6/shk
	 H/FRRSYocL6yhSxGByxblrZ7Hfglw+s2oyZF3VNM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Koakuma <koachan@protonmail.com>,
	Andreas Larsson <andreas@gaisler.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 248/568] sparc/module: Add R_SPARC_UA64 relocation handling
Date: Wed,  3 Dec 2025 16:24:10 +0100
Message-ID: <20251203152449.803243566@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 66c45a2764bc8..a7780907fc2f9 100644
--- a/arch/sparc/kernel/module.c
+++ b/arch/sparc/kernel/module.c
@@ -117,6 +117,7 @@ int apply_relocate_add(Elf_Shdr *sechdrs,
 			break;
 #ifdef CONFIG_SPARC64
 		case R_SPARC_64:
+		case R_SPARC_UA64:
 			location[0] = v >> 56;
 			location[1] = v >> 48;
 			location[2] = v >> 40;
-- 
2.51.0



