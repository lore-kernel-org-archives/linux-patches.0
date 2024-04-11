Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B23EE13C9A5;
	Thu, 11 Apr 2024 10:39:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831977; cv=none; b=EQEH3fdOqHzhBp41f7do/hZTfSEf2Jw7p7lMeqVRlCAa76DkAJpE/t3bzLtC+lQperxR/nSE5Ajymz0rV+AxDxgIvIvAJh56Tu2+1CcAIXEp1k3ICoAn4pRuW6i5ln9i6oztbzY1RlJ6y2PU75TBV+eUubhmtZsoHyp6O/dYQgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831977; c=relaxed/simple;
	bh=PjfAb4dPOyG91O9oOFjaDHW4cPtBZWJ6t1MRjzseOb0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rbvuTfuY0We4Qh8WLT3w2zWeDs1jEk8fNnE+bGZw+UJ4ZCQYxYuEbOSs6ldp0Eg32gwL6UmabAZgSjbvOyrBDNNJFyDFiByYxSyoJWujkdLnEYVVn3+hZk/FSBrtnIybwzD3FO7LGVgs+tqMdDDzPgdD1zc6k1kgqh/CExVGIeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y+6PTsy9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y+6PTsy9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A9F5C43390;
	Thu, 11 Apr 2024 10:39:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831977;
	bh=PjfAb4dPOyG91O9oOFjaDHW4cPtBZWJ6t1MRjzseOb0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y+6PTsy9KoQD/EtnHHQmOS2vZX3OVIs0XZ2Dd8rpm/A6Qb/ijkG6rl0AO6GQDhq8w
	 TH7pwJTkm6d/LhfIYTCFk9+N9Vt9lRwGnEfwYMOwVvSCsPKpP4NkzNqmnC5v9MdH6h
	 lNPpTrMfbxhtDpplx5x71VFqynEyCoCVv8MuM24E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.10 151/294] powerpc: xor_vmx: Add -mhard-float to CFLAGS
Date: Thu, 11 Apr 2024 11:55:14 +0200
Message-ID: <20240411095440.197504497@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>
References: <20240411095435.633465671@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


