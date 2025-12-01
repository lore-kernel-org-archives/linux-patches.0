Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D9DB2522B6;
	Mon,  1 Dec 2025 11:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764588572; cv=none; b=ZD5zXAmVWFtDWaX6yrrpMtlOy3Yxvlrc0p4nEmdn0jkT21tubPzIRq3LlEkzc7GpLeOYLJi74a64XcMHZk3SIeJXU7MnKp5xlwG+NbvA+hRTdPUppy54iv/MFLxOrg4g+BdD4ux6qMCY96GTZtUCJisaMudNtZQ3CKNJRR0w2q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764588572; c=relaxed/simple;
	bh=hzEawvccUP3sKZeZs/BIIqoljmSmaiNgJs+oeX5k/Vg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DPl5kMy9OtWuQeY6yNubBB4hJiBArQr9sHZOYVd8tfNwDyFhNHTOksomxLiruuWcytVxR6LX0YInsrur6efZARWTvJJO6UUC2rrWhL/WXQKh+B+HEVl8Lu4o0O6LUP8fHyamo/jFkcywcLZvHDozmn0CaqFDJovPe01fCE296+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ass1c0hQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ass1c0hQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3DC4C4CEF1;
	Mon,  1 Dec 2025 11:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764588572;
	bh=hzEawvccUP3sKZeZs/BIIqoljmSmaiNgJs+oeX5k/Vg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ass1c0hQ/i5zzGaAIq1V6qbFAJkg8JoE34bZdJizWVv7FTMzzV3N+OfkW70LSYxhR
	 CsMJjjaYJ6hG5FFu+QRkYKk2Zh4pzd1yJ2iVn1a07M+K8U6ltkyUtVYEqSdoB1fMuA
	 mhvb0pgIZsBppbv2JXvnMoiYQNHL2YomiMNDZrqQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Koakuma <koachan@protonmail.com>,
	Andreas Larsson <andreas@gaisler.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 096/187] sparc/module: Add R_SPARC_UA64 relocation handling
Date: Mon,  1 Dec 2025 12:23:24 +0100
Message-ID: <20251201112244.709149627@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251201112241.242614045@linuxfoundation.org>
References: <20251201112241.242614045@linuxfoundation.org>
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



