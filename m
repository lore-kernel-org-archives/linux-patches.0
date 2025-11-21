Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C36F625F7BF;
	Fri, 21 Nov 2025 13:47:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732842; cv=none; b=FrorTnVm7APCfJiPKgUjZiHEoLEsGRpjEaLufCUyydX8jizNUpKV8nJWv+R6P7chCoUqzpmONV7kEHh2UrNz15201lZgKqVMLVQphfDEfcnKbp+C34k6IR5QzWRbIH3uk5PIgJYxJaDkwYnb4xnGJT9fCuS90hUKsbuIOUeEUFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732842; c=relaxed/simple;
	bh=HiwdzYY6qpiS+9tQvJQNy6UKcESIzL0S44xQ+fvyXho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rC3Dtth6jP8Vy3fH7/FjyPwsHo6/Sm7bwJJC+q/yRdaaogRZn2QoO7mfh/MaerjHi/gHZ7Z1wVwo7u77BtU3y2JGTeZPLnRTL7bfjrsAEaKAjYS8JeKYhrv3WLVmfuj9r9LgJ0tDO3esPOmaOoluR+ETZpz5FTuxPrPyXO+bIag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n8JcF2dl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n8JcF2dl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42560C4CEF1;
	Fri, 21 Nov 2025 13:47:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732842;
	bh=HiwdzYY6qpiS+9tQvJQNy6UKcESIzL0S44xQ+fvyXho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n8JcF2dli49w2D6HhzRm+RwonIfrCazmLWgsd9gBQ0oJVJhQ5oGYiKlX3nYlPRRA4
	 6ayje3AoAAETftd9PaUWKMy0/p41PrV0kdbEYGmPDaFmLX2xkYbklW22lSawU08Uyb
	 MVPFT1vvT4jBMPyxG3r1MOhT9ayBtGI/PGn/KYJQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Koakuma <koachan@protonmail.com>,
	Andreas Larsson <andreas@gaisler.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 262/529] sparc/module: Add R_SPARC_UA64 relocation handling
Date: Fri, 21 Nov 2025 14:09:21 +0100
Message-ID: <20251121130240.345353546@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



