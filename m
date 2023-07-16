Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01E568F5B
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:29:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 789D7C433C8;
	Sun, 16 Jul 2023 20:29:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689539357;
	bh=hBD+EzXPiQw6PDfQtkXx+sOammQYpCaP1Ke3UMb+4RY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BLLcC8u+ljo/CmZbRyTPb5VEPBn9ErHDLs+9qU7asym6lONtLP/pJ0+BpxUjoPxfM
	 gS7H9pRFOAQ7cZjcjnRq7EJpFoXjhHY3MLB/aFQWr2q8sRSRN2v0HzE57KuL5A/Kwp
	 sB+jIVFaGyvYsw3clLJXAP/K4/HxsJylfduuc+Ao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH 6.4 779/800] powerpc/vdso: Include CLANG_FLAGS explicitly in ldflags-y
Date: Sun, 16 Jul 2023 21:50:32 +0200
Message-ID: <20230716195007.242114093@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Nathan Chancellor <nathan@kernel.org>

commit a7e5eb53bf9b800d086e2ebcfebd9a3bb16bd1b0 upstream.

A future change will move CLANG_FLAGS from KBUILD_{A,C}FLAGS to
KBUILD_CPPFLAGS so that '--target' is available while preprocessing.
When that occurs, the following error appears when building the compat
PowerPC vDSO:

  clang: error: unsupported option '-mbig-endian' for target 'x86_64-pc-linux-gnu'
  make[3]: *** [.../arch/powerpc/kernel/vdso/Makefile:76: arch/powerpc/kernel/vdso/vdso32.so.dbg] Error 1

Explicitly add CLANG_FLAGS to ldflags-y, so that '--target' will always
be present.

Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/kernel/vdso/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/kernel/vdso/Makefile
+++ b/arch/powerpc/kernel/vdso/Makefile
@@ -54,7 +54,7 @@ KASAN_SANITIZE := n
 KCSAN_SANITIZE := n
 
 ccflags-y := -fno-common -fno-builtin
-ldflags-y := -Wl,--hash-style=both -nostdlib -shared -z noexecstack
+ldflags-y := -Wl,--hash-style=both -nostdlib -shared -z noexecstack $(CLANG_FLAGS)
 ldflags-$(CONFIG_LD_IS_LLD) += $(call cc-option,--ld-path=$(LD),-fuse-ld=lld)
 # Filter flags that clang will warn are unused for linking
 ldflags-y += $(filter-out $(CC_AUTO_VAR_INIT_ZERO_ENABLER) $(CC_FLAGS_FTRACE) -Wa$(comma)%, $(KBUILD_CFLAGS))


