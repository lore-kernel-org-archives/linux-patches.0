Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4D332F39DE;
	Mon, 22 Sep 2025 19:44:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758570269; cv=none; b=Rt/PrA98g9TLzgCHuK6NVAJrn8dtCqclNKEBY7sEX/TWh/YZI+oCnzDMc3WpSBBzUaLARkB2JHqWPlcJ8UEhyFS/wTV5nZvfmupsX3ZxDaMXPI/j+Eh3Y6AAZLrJi2FJ/wlezV+AzgeCSdtQVMEMnGugWHArEAH/gZJFkcP0hf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758570269; c=relaxed/simple;
	bh=UhlM5Abz9GzNQc4fPaIq8g3VSpEr2iRHdyjz4uxAd0E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g/OoSTCdfQlualUIrZ1KqdhxX/m6Dnwdkqo4KZDsoKduRkQpNFrjzyK477ygyyYlZa8zvB30OH+xpxs5kLYYe7TfcU/J2fsHF+BW2bzdHFRb0ZcM882lv8bTg8D3M04u1JGCd4dgQaucOi4LKSfUV0dx8uYDkKXEOcVslGYKuFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qJrcfost; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qJrcfost"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64CEEC4CEF0;
	Mon, 22 Sep 2025 19:44:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758570269;
	bh=UhlM5Abz9GzNQc4fPaIq8g3VSpEr2iRHdyjz4uxAd0E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qJrcfostV7y7kpf2z/4F1scUE+pObmYaYzpB7rpzwmvJgciY5GuuxsQKafbZpIgNA
	 Pkj/yPO+7fKrgrcqUF5s5gHxB4VQublsXYIPHyOyFqMwTm4C+sm7saMNLuZgbaNT2s
	 usUeMpSyufGZj+6/dk2IowPfdG59lOjJXXrIbFl8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	WANG Rui <wangrui@loongson.cn>,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.16 071/149] LoongArch: Make LTO case independent in Makefile
Date: Mon, 22 Sep 2025 21:29:31 +0200
Message-ID: <20250922192414.677497505@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192412.885919229@linuxfoundation.org>
References: <20250922192412.885919229@linuxfoundation.org>
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

commit b15212824a01cb0b62f7b522f4ee334622cf982a upstream.

LTO is not only used for Clang, but maybe also used for Rust, make LTO
case out of CONFIG_CC_HAS_ANNOTATE_TABLEJUMP in Makefile.

This is preparation for later patch, no function changes.

Cc: stable@vger.kernel.org
Suggested-by: WANG Rui <wangrui@loongson.cn>
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/Makefile |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/arch/loongarch/Makefile
+++ b/arch/loongarch/Makefile
@@ -102,16 +102,16 @@ KBUILD_CFLAGS			+= $(call cc-option,-mth
 
 ifdef CONFIG_OBJTOOL
 ifdef CONFIG_CC_HAS_ANNOTATE_TABLEJUMP
+KBUILD_CFLAGS			+= -mannotate-tablejump
+else
+KBUILD_CFLAGS			+= -fno-jump-tables # keep compatibility with older compilers
+endif
+ifdef CONFIG_LTO_CLANG
 # The annotate-tablejump option can not be passed to LLVM backend when LTO is enabled.
 # Ensure it is aware of linker with LTO, '--loongarch-annotate-tablejump' also needs to
 # be passed via '-mllvm' to ld.lld.
-KBUILD_CFLAGS			+= -mannotate-tablejump
-ifdef CONFIG_LTO_CLANG
 KBUILD_LDFLAGS			+= -mllvm --loongarch-annotate-tablejump
 endif
-else
-KBUILD_CFLAGS			+= -fno-jump-tables # keep compatibility with older compilers
-endif
 endif
 
 KBUILD_RUSTFLAGS		+= --target=loongarch64-unknown-none-softfloat -Ccode-model=small


