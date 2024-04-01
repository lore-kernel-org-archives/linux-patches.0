Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76D05481DD;
	Mon,  1 Apr 2024 15:54:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711986873; cv=none; b=MG2r9H4Nn+fKiI5996T/82XMtIpO0EUd0sAYyx2fgs/HhwbLgEeWznuUb67xoVzlKmy0YERqZgNfYIwpMB+snrihIo6zEB4KRpKpUbGrVL0GOOTez3lQEdvsQxoG9zo8l/Zjatn2XnNEx+mOjCgVuzmWZYtsKLQ5aqeV2k42Kjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711986873; c=relaxed/simple;
	bh=TKRL8lUzxq+FhZWpuZTIRQa7dYsr2mrZpRB1/0jcQJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IojMnlzxRDdOn0JdoflT5UvQw4rLVuNymKQIJbA29zy8wU459oV2WAiKFKDBZcxnKga6ag4gNWnYrPnT/D8TyKBFQkl5HUpugqu3yO8X6czTsHtc1UcK3BWeHZoOprS0+9Uowo3zrQ13ZRkzuJKBaSYOZOBLaVl29vkyOj9rYnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qfpw/EsX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qfpw/EsX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC306C433C7;
	Mon,  1 Apr 2024 15:54:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711986873;
	bh=TKRL8lUzxq+FhZWpuZTIRQa7dYsr2mrZpRB1/0jcQJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qfpw/EsXRgBuSzCQ53D3JIjHcQ3CoO2Dvq6EfPOlsN1p1Y1Z710iUDSlUvb0opd4t
	 a+5bfk5Hklq/X/9P80z0471/FR833Pmtq395eX/Qxa5fCJQ1sht+dHTu/az99ngQg/
	 dAI0kLledz6kCJoGVo/Pz+AAsgvfexB3umXVb6Gc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 113/399] powerpc: xor_vmx: Add -mhard-float to CFLAGS
Date: Mon,  1 Apr 2024 17:41:19 +0200
Message-ID: <20240401152552.564013502@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Chancellor <nathan@kernel.org>

[ Upstream commit 35f20786c481d5ced9283ff42de5c69b65e5ed13 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/lib/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/lib/Makefile b/arch/powerpc/lib/Makefile
index 6eac63e79a899..0ab65eeb93ee3 100644
--- a/arch/powerpc/lib/Makefile
+++ b/arch/powerpc/lib/Makefile
@@ -76,7 +76,7 @@ obj-$(CONFIG_PPC_LIB_RHEAP) += rheap.o
 obj-$(CONFIG_FTR_FIXUP_SELFTEST) += feature-fixups-test.o
 
 obj-$(CONFIG_ALTIVEC)	+= xor_vmx.o xor_vmx_glue.o
-CFLAGS_xor_vmx.o += -maltivec $(call cc-option,-mabi=altivec)
+CFLAGS_xor_vmx.o += -mhard-float -maltivec $(call cc-option,-mabi=altivec)
 # Enable <altivec.h>
 CFLAGS_xor_vmx.o += -isystem $(shell $(CC) -print-file-name=include)
 
-- 
2.43.0



