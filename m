Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C558C5E1;
	Wed, 15 Feb 2023 18:41:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B679C4339B;
	Wed, 15 Feb 2023 18:41:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1676486486;
	bh=Bn4PnsdfMk3VpRZTuBATRwN4ucU9A9gaRgDX010A7pA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=K8DssxvWbdq3XXo1YlSzB5+4GoV8/dvTaDPuEvZyLvicAEOonCuS2M5DEFoCbrvhg
	 9mX1bx0KyAhhg/9xZjzUlCLfgkI4AtVp12CiaitfkmBdGayB6shkHIcfQYfCaILPFl
	 ZWwZx/cZ24fUFYqQNUm4vn0vD7tBojGDzilj0Ph30bbwU7lwBvDE/KMd10N660T9wb
	 y0CoDUJoN5/UGiiVBnXt3o0rPnzt9mJ5v0OQ/zG481K9slBRUjyMcnYQ/P8+4OaEUm
	 GhAGo6913DGwcPIbWcvHbaSpd/5Sd8TnWJ3pfordVGsGBdVCNuG6XT5/pW3IxuytL3
	 5jbCLGsXGIUPA==
From: Nathan Chancellor <nathan@kernel.org>
Date: Wed, 15 Feb 2023 11:41:15 -0700
Subject: [PATCH 1/3] powerpc/boot: Only use '-mabi=elfv2' with
 CONFIG_PPC64_BOOT_WRAPPER
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230118-ppc64-elfv2-llvm-v1-1-b9e2ec9da11d@kernel.org>
References: <20230118-ppc64-elfv2-llvm-v1-0-b9e2ec9da11d@kernel.org>
In-Reply-To: <20230118-ppc64-elfv2-llvm-v1-0-b9e2ec9da11d@kernel.org>
To: mpe@ellerman.id.au
Cc: npiggin@gmail.com, christophe.leroy@csgroup.eu, erhard_f@mailbox.org, 
 nathan@kernel.org, ndesaulniers@google.com, trix@redhat.com, 
 linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org, 
 llvm@lists.linux.dev, patches@lists.linux.dev
X-Mailer: b4 0.12.1
X-Developer-Signature: v=1; a=openpgp-sha256; l=1330; i=nathan@kernel.org;
 h=from:subject:message-id; bh=Bn4PnsdfMk3VpRZTuBATRwN4ucU9A9gaRgDX010A7pA=;
 b=owGbwMvMwCEmm602sfCA1DTG02pJDMlv1UNDVS+uVxZctb7mrC67yZbDwu3i3yIzTRpudAjIi
 LeJeV/tKGVhEONgkBVTZKl+rHrc0HDOWcYbpybBzGFlAhnCwMUpABP5spLhf+Bf/oNmFpFBUb6v
 WfMc5rDmiO8KlFiyN/ebnkn7A8F7Gxl+s/3U+PCZu/WaT3mP2GK3kIayadsSHt+fKtjALvwuec1
 TdgA=
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

When CONFIG_PPC64_ELF_ABI_V2 is enabled with clang through
CONFIG_PPC64_BIG_ENDIAN_ELF_ABI_V2, building the powerpc boot wrapper
in 32-bit mode (i.e. with CONFIG_PPC64_BOOT_WRAPPER=n) fails with:

    error: unknown target ABI 'elfv2'

The ABI cannot be changed with '-m32'; GCC silently accepts it but clang
errors out. Only provide '-mabi=elfv2' when CONFIG_PPC64_BOOT_WRAPPER is
enabled, which is the only way '-mabi=elfv2' will be useful.

Tested-by: "Erhard F." <erhard_f@mailbox.org>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 arch/powerpc/boot/Makefile | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/boot/Makefile b/arch/powerpc/boot/Makefile
index d32d95aea5d6..0d4a8e8bdcab 100644
--- a/arch/powerpc/boot/Makefile
+++ b/arch/powerpc/boot/Makefile
@@ -44,6 +44,9 @@ BOOTCFLAGS	+= -m64 -mcpu=powerpc64le
 else
 BOOTCFLAGS	+= -m64 -mcpu=powerpc64
 endif
+ifdef CONFIG_PPC64_ELF_ABI_V2
+BOOTCFLAGS	+= $(call cc-option,-mabi=elfv2)
+endif
 else
 BOOTCFLAGS	+= -m32 -mcpu=powerpc
 endif
@@ -55,9 +58,6 @@ BOOTCFLAGS	+= -mbig-endian
 else
 BOOTCFLAGS	+= -mlittle-endian
 endif
-ifdef CONFIG_PPC64_ELF_ABI_V2
-BOOTCFLAGS	+= $(call cc-option,-mabi=elfv2)
-endif
 
 BOOTAFLAGS	:= -D__ASSEMBLY__ $(BOOTCFLAGS) -nostdinc
 

-- 
2.39.2

