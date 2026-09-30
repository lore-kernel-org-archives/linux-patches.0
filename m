Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA2274FDA77;
	Wed, 30 Sep 2026 15:37:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782675; cv=none; b=ODn/4qSIAPEk0CdDFNdXRkeynb7FFs0acREUOIG6EEW4mB+XTfb/QrHGCldAaUrMZq2p9vNrT0MBBdAaJZwCofBW4Yta/pX7GGGIM4I/ttf8m5+96JizmPQ/1XlKBosSUaLLFK211CeJNIl/O9AbdV8dZrt0xqWQkyWP+vqY4IY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782675; c=relaxed/simple;
	bh=AcJDtc5bDQ81L5ZiuUM2u4h84nTsQFfTqMMRa1NZlhc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N4YAJCfj2PhPorSr3Rk2mLlNWic3o8z7K5x/5lTQlSqVq1tejntcyN99xbnQ2LDagMmbzy42cQAEb6+9fdyVOQsRIeTl+KGDfLVgPVl6bqc8+d5P1ChceKyPTiVbDUMI9rDvkCqWQThqNCfeMpkIAUFYvqvKu3UU7a+dswXHJj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XMzRjh/K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XMzRjh/K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE5951F0089A;
	Wed, 30 Sep 2026 15:37:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790782669;
	bh=XsgqgkEL33Fk6OpG+K6Lh2pbMVurR5QwPyGeIkkxVwo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XMzRjh/K/OSBj9k2J8oPW9eFT9Ol/EsTmmJ8ggPWQ5X3CFxBPkc3BFtiVjK17Tl1p
	 q3teevbSu4mRb0uRYZ9hes9C84bRWBfJS/FtdKEEr3yH2z9kHOyqA84RuI/OS2m+qE
	 KRth3I2qGngaF/7BOYcDMH8K5fCSfaH11zpkGBZA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Andreas Larsson <andreas@gaisler.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 129/595] sparc: Disable compat support with LLD
Date: Wed, 30 Sep 2026 17:20:22 +0200
Message-ID: <20260930152350.513277306@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit 852fed2e8bfe195351fb0078ba7245d41154e7a5 ]

An LLVM=1 sparc64 allmodconfig enables COMPAT and then tries to
build the 32-bit vDSO. That path cannot be linked with ld.lld:

  ld.lld: error: unknown emulation: elf32_sparc

ld.lld does not support the 32-bit SPARC ELF emulation used for
the compat vDSO, so keep COMPAT disabled when LLD is the linker.
This avoids selecting an unsupported build path while leaving the
existing GNU ld configuration unchanged.

Assisted-by: Codex:GPT-5.5
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Acked-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Andreas Larsson <andreas@gaisler.com>
Link: https://lore.kernel.org/r/20260508000834.834824-1-rosenp@gmail.com
Signed-off-by: Andreas Larsson <andreas@gaisler.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/sparc/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index 7e2ce4c8d6571..7d0d1726a0898 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -496,6 +496,7 @@ endmenu
 config COMPAT
 	bool
 	depends on SPARC64
+	depends on !LD_IS_LLD
 	default y
 	select COMPAT_BINFMT_ELF if BINFMT_ELF
 	select HAVE_UID16
-- 
2.53.0



