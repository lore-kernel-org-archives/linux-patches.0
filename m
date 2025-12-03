Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5709125BEE5;
	Wed,  3 Dec 2025 15:40:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776414; cv=none; b=cHwhKVLoSefYxFEdlCR5ovgyBg0alEBKo92kbqDG/+LNONKaVB6tL/zWikPDEmhR+KPzgGWvl7NokhoNOXEMSxtfIw9vmTISnV/lvXbPlT/pnJOxMB8zz60H4Hvvspr0BowMNI7oKlN5SlRLb3n8r5s5cP7heHh5rYtyE7JIF2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776414; c=relaxed/simple;
	bh=WmFfMNreW0z4OYBaKNONoQdeJY2pBroxz6AP8w9j/20=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ry/1NUwinNd0pWZq3j67a/IEoMI60/tw4xcTfCkbC55BV8KW7+jpkdvnMly/COUjeXSA/dhfEv5A19KChco+2SKCEPg+Y76zdWgSQ8ZCgMcfGqPqCQNJ9ZgZ/rbqvw8yTn94WRuT7aK4bczXM5Lu1nEvfA263w30NiaoFBnZkYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tXP208th; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tXP208th"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B593C4CEF5;
	Wed,  3 Dec 2025 15:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776414;
	bh=WmFfMNreW0z4OYBaKNONoQdeJY2pBroxz6AP8w9j/20=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tXP208th9+ZlyphzM7NTZ5xpuDPcie3+RU29SnOexMojeL42MVXfrN1Q1bo67E9AG
	 7F+W7q1u1+fCAXFR29u/ggSwOptcP2XwFPOIpk2eUNVcDr7sf4l4xdVdGGsbdwkdUn
	 OTkLGxEgCAeNUY+Da9cO92OOx+fDF2Ln71yXYvTY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Koakuma <koachan@protonmail.com>,
	Andreas Larsson <andreas@gaisler.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 132/300] sparc/module: Add R_SPARC_UA64 relocation handling
Date: Wed,  3 Dec 2025 16:25:36 +0100
Message-ID: <20251203152405.503619080@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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
index 7e078bc73ef56..d3dda47d0bc5a 100644
--- a/arch/sparc/include/asm/elf_64.h
+++ b/arch/sparc/include/asm/elf_64.h
@@ -59,6 +59,7 @@
 #define R_SPARC_7		43
 #define R_SPARC_5		44
 #define R_SPARC_6		45
+#define R_SPARC_UA64		54
 
 /* Bits present in AT_HWCAP, primarily for Sparc32.  */
 #define HWCAP_SPARC_FLUSH       0x00000001
diff --git a/arch/sparc/kernel/module.c b/arch/sparc/kernel/module.c
index df39580f398d3..737f7a5c28359 100644
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



