Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DCF47F7CF;
	Mon,  8 Apr 2024 13:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584791; cv=none; b=hHiI7pvpYsY5db8mzhptMsgDzINQU5ykud8wX4rYpVx4E7OcNB1L8IGggA6ozIMJNCie1JV1bBjg9sEbFBMJSHJNTpXhiPcbijKwzCREOtjWpU6pAzGxB6R2zbmkIO9aQ4pAaiibxmuo53a1+Qigpo0H/GSGGzSWONOVZPQIzEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584791; c=relaxed/simple;
	bh=TJQROmOsmJJtepvnSMSUOewH9bFooKnbgBUf7je9l9M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EWbH2siCuDy3nkCsEVflDhHY6hdwFjdOyGcoAOi6hce81Q5/xliztlfCQtbLhIxVrFM+8ZvVGA+A2cXjAOGm64Ls9DtnjBxU36i8arkcsqrR7hYhiMVsSCTG0gcKKRpZOj3xY2XOhygSFT7tMTzenPq2k3QfYWM5TSqnM73qXvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZkvHUOyL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZkvHUOyL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCB8CC433F1;
	Mon,  8 Apr 2024 13:59:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584791;
	bh=TJQROmOsmJJtepvnSMSUOewH9bFooKnbgBUf7je9l9M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZkvHUOyLbwSjrIykhp2crq8H0nNY7sABux5pRnyFKBh+7K0KBJTh3FbI0/MIJBD10
	 YLu275IB5AtmtveLbhTs7SsLIY884VcOfLiUpcM7Y4d58TVHWFfuEuNA+X0cfrlg7B
	 8apwyV7TygJFl1HwxH1LJDUD/PilrWHgNx3All3Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.15 559/690] powerpc: xor_vmx: Add -mhard-float to CFLAGS
Date: Mon,  8 Apr 2024 14:57:05 +0200
Message-ID: <20240408125419.878064507@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Chancellor <nathan@kernel.org>

commit 35f20786c481d5ced9283ff42de5c69b65e5ed13 upstream.

arch/powerpc/lib/xor_vmx.o is built with '-msoft-float' (from the main
powerpc Makefile) and '-maltivec' (from its CFLAGS), which causes an
error when building with clang after a recent change in main:

  error: option '-msoft-float' cannot be specified with '-maltivec'
  make[6]: *** [scripts/Makefile.build:243: arch/powerpc/lib/xor_vmx.o] Error 1

Explicitly add '-mhard-float' before '-maltivec' in xor_vmx.o's CFLAGS
to override the previous inclusion of '-msoft-float' (as the last option
wins), which matches how other areas of the kernel use '-maltivec', such
as AMDGPU.

Cc: stable@vger.kernel.org
Closes: https://github.com/ClangBuiltLinux/linux/issues/1986
Link: https://github.com/llvm/llvm-project/commit/4792f912b232141ecba4cbae538873be3c28556c
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20240127-ppc-xor_vmx-drop-msoft-float-v1-1-f24140e81376@kernel.org
[nathan: Fixed conflicts due to lack of 04e85bbf71c9 in older trees]
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/lib/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/lib/Makefile
+++ b/arch/powerpc/lib/Makefile
@@ -67,6 +67,6 @@ obj-$(CONFIG_PPC_LIB_RHEAP) += rheap.o
 obj-$(CONFIG_FTR_FIXUP_SELFTEST) += feature-fixups-test.o
 
 obj-$(CONFIG_ALTIVEC)	+= xor_vmx.o xor_vmx_glue.o
-CFLAGS_xor_vmx.o += -maltivec $(call cc-option,-mabi=altivec)
+CFLAGS_xor_vmx.o += -mhard-float -maltivec $(call cc-option,-mabi=altivec)
 
 obj-$(CONFIG_PPC64) += $(obj64-y)


