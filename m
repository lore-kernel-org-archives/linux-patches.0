Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2194220330;
	Tue, 26 Aug 2025 11:35:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208142; cv=none; b=ON3UdrRbpdFTFItFeb6k9JuiM4yg1WkkrDy+1dIYLmJXLVj0jv6tb9dBj94fB7ibrf9hVRhTxC6ayJi2s5Q4FfkjhYhNqSNwBmAdU8AHRk4OWKgZlwUk6x0Pwis9d+9039HS1mpJy+IG7guleLveZ80xpxodpFDrFFivFxxD4vQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208142; c=relaxed/simple;
	bh=qPfJc0VW5pS6mS6mBiHlWCxqnRiBlF5lm0+BznhuHII=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UNk5eQ/4KVkMbb1Q8X/KhxTIFJmB+jFaVxuA9XBiLtdj0tUFLdFwYe2OEOhl6sJONH9K0OpibutEZ5/vPra8Ph7+IFvnbIWEKAnfA8hn4FP/0UcpNgwMIci7GJl66+mY7JDNcUB8zs9uMF1djOkj4et/kW7oF2lVK0YBQCn6blA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f4nd+VRm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f4nd+VRm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4591C4CEF1;
	Tue, 26 Aug 2025 11:35:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208142;
	bh=qPfJc0VW5pS6mS6mBiHlWCxqnRiBlF5lm0+BznhuHII=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f4nd+VRmlUQAi4VgKk3qXmZKveM1B/pUA3Z+ilRj/LNxgS/vN3qDtm+B8yaSw3Lxb
	 bM/s7VNK40dIM0wodLJBUqXaQLwI7/ZbRHKGBbEeDn39I7qxXoiBmrN3XgyQOCEpzS
	 nikP4ZVgFQ87wSxcDBK7iqszbCWyDRef4Zz7essM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	WANG Rui <wangrui@loongson.cn>,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 423/457] LoongArch: Pass annotate-tablejump option if LTO is enabled
Date: Tue, 26 Aug 2025 13:11:47 +0200
Message-ID: <20250826110947.745812566@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tiezhu Yang <yangtiezhu@loongson.cn>

[ Upstream commit 5dfea6644d201bfeffaa7e0d79d62309856613b7 ]

When compiling with LLVM and CONFIG_LTO_CLANG is set, there exist many
objtool warnings "sibling call from callable instruction with modified
stack frame".

For this special case, the related object file shows that there is no
generated relocation section '.rela.discard.tablejump_annotate' for the
table jump instruction jirl, thus objtool can not know that what is the
actual destination address.

It needs to do something on the LLVM side to make sure that there is the
relocation section '.rela.discard.tablejump_annotate' if LTO is enabled,
but in order to maintain compatibility for the current LLVM compiler,
this can be done in the kernel Makefile for now. Ensure it is aware of
linker with LTO, '--loongarch-annotate-tablejump' needs to be passed via
'-mllvm' to ld.lld.

Note that it should also pass the compiler option -mannotate-tablejump
rather than only pass '-mllvm --loongarch-annotate-tablejump' to ld.lld
if LTO is enabled, otherwise there are no jump info for some table jump
instructions.

Fixes: e20ab7d454ee ("LoongArch: Enable jump table for objtool")
Closes: https://lore.kernel.org/loongarch/20250731175655.GA1455142@ax162/
Reported-by: Nathan Chancellor <nathan@kernel.org>
Tested-by: Nathan Chancellor <nathan@kernel.org>
Co-developed-by: WANG Rui <wangrui@loongson.cn>
Signed-off-by: WANG Rui <wangrui@loongson.cn>
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/Makefile | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/loongarch/Makefile b/arch/loongarch/Makefile
index b0703a4e02a2..a3a9759414f4 100644
--- a/arch/loongarch/Makefile
+++ b/arch/loongarch/Makefile
@@ -102,7 +102,13 @@ KBUILD_CFLAGS			+= $(call cc-option,-mthin-add-sub) $(call cc-option,-Wa$(comma)
 
 ifdef CONFIG_OBJTOOL
 ifdef CONFIG_CC_HAS_ANNOTATE_TABLEJUMP
+# The annotate-tablejump option can not be passed to LLVM backend when LTO is enabled.
+# Ensure it is aware of linker with LTO, '--loongarch-annotate-tablejump' also needs to
+# be passed via '-mllvm' to ld.lld.
 KBUILD_CFLAGS			+= -mannotate-tablejump
+ifdef CONFIG_LTO_CLANG
+KBUILD_LDFLAGS			+= -mllvm --loongarch-annotate-tablejump
+endif
 else
 KBUILD_CFLAGS			+= -fno-jump-tables # keep compatibility with older compilers
 endif
-- 
2.50.1



