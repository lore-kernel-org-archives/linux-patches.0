Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD2B51C29F;
	Wed,  3 Jan 2024 17:15:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XUT/Pwxe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19F3FC433C7;
	Wed,  3 Jan 2024 17:15:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704302125;
	bh=bCBxo89qCPrq8ZPeA5H1zzWiFrO4cC+ThSp0jBcwRxg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XUT/PwxeT9g8t9C1e7OQYzM7kz0SbE7wBemakWxvBPZOtWUcmu5SHIEnxDUly9Rov
	 TfxItM3TmmzriiT6b5/WKY5awduchzXOsptjYRiJE+oBUiqJo05q9g70nNSQSMKXM7
	 XpiwJ2lQ7ysffD8lHFR4gygm+xCC/i4XpD6P4i0Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Eric DeVolder <eric_devolder@yahoo.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Borislav Petkov <bp@alien8.de>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Conor Dooley <conor@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	Heiko Carstens <hca@linux.ibm.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Ingo Molnar <mingo@redhat.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Sven Schnelle <svens@linux.ibm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 24/49] kexec: fix KEXEC_FILE dependencies
Date: Wed,  3 Jan 2024 17:55:44 +0100
Message-ID: <20240103164838.696708028@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240103164834.970234661@linuxfoundation.org>
References: <20240103164834.970234661@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit c1ad12ee0efc07244be37f69311e6f7c4ac98e62 ]

The cleanup for the CONFIG_KEXEC Kconfig logic accidentally changed the
'depends on CRYPTO=y' dependency to a plain 'depends on CRYPTO', which
causes a link failure when all the crypto support is in a loadable module
and kexec_file support is built-in:

x86_64-linux-ld: vmlinux.o: in function `__x64_sys_kexec_file_load':
(.text+0x32e30a): undefined reference to `crypto_alloc_shash'
x86_64-linux-ld: (.text+0x32e58e): undefined reference to `crypto_shash_update'
x86_64-linux-ld: (.text+0x32e6ee): undefined reference to `crypto_shash_final'

Both s390 and x86 have this problem, while ppc64 and riscv have the
correct dependency already.  On riscv, the dependency is only used for the
purgatory, not for the kexec_file code itself, which may be a bit
surprising as it means that with CONFIG_CRYPTO=m, it is possible to enable
KEXEC_FILE but then the purgatory code is silently left out.

Move this into the common Kconfig.kexec file in a way that is correct
everywhere, using the dependency on CRYPTO_SHA256=y only when the
purgatory code is available.  This requires reversing the dependency
between ARCH_SUPPORTS_KEXEC_PURGATORY and KEXEC_FILE, but the effect
remains the same, other than making riscv behave like the other ones.

On s390, there is an additional dependency on CRYPTO_SHA256_S390, which
should technically not be required but gives better performance.  Remove
this dependency here, noting that it was not present in the initial
Kconfig code but was brought in without an explanation in commit
71406883fd357 ("s390/kexec_file: Add kexec_file_load system call").

[arnd@arndb.de: fix riscv build]
  Link: https://lkml.kernel.org/r/67ddd260-d424-4229-a815-e3fcfb864a77@app.fastmail.com
Link: https://lkml.kernel.org/r/20231023110308.1202042-1-arnd@kernel.org
Fixes: 6af5138083005 ("x86/kexec: refactor for kernel/Kconfig.kexec")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Eric DeVolder <eric_devolder@yahoo.com>
Tested-by: Eric DeVolder <eric_devolder@yahoo.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Conor Dooley <conor@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/Kconfig | 4 ++--
 arch/riscv/Kconfig   | 4 +---
 arch/s390/Kconfig    | 4 ++--
 arch/x86/Kconfig     | 4 ++--
 kernel/Kconfig.kexec | 1 +
 5 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index d5d5388973ac7..4640cee33f123 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -607,10 +607,10 @@ config ARCH_SUPPORTS_KEXEC
 	def_bool PPC_BOOK3S || PPC_E500 || (44x && !SMP)
 
 config ARCH_SUPPORTS_KEXEC_FILE
-	def_bool PPC64 && CRYPTO=y && CRYPTO_SHA256=y
+	def_bool PPC64
 
 config ARCH_SUPPORTS_KEXEC_PURGATORY
-	def_bool KEXEC_FILE
+	def_bool y
 
 config ARCH_SELECTS_KEXEC_FILE
 	def_bool y
diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
index 6688cbbed0b42..9e6d442773eea 100644
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -686,9 +686,7 @@ config ARCH_SELECTS_KEXEC_FILE
 	select KEXEC_ELF
 
 config ARCH_SUPPORTS_KEXEC_PURGATORY
-	def_bool KEXEC_FILE
-	depends on CRYPTO=y
-	depends on CRYPTO_SHA256=y
+	def_bool ARCH_SUPPORTS_KEXEC_FILE
 
 config ARCH_SUPPORTS_CRASH_DUMP
 	def_bool y
diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index ae29e4392664a..bd4782f23f66d 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -252,13 +252,13 @@ config ARCH_SUPPORTS_KEXEC
 	def_bool y
 
 config ARCH_SUPPORTS_KEXEC_FILE
-	def_bool CRYPTO && CRYPTO_SHA256 && CRYPTO_SHA256_S390
+	def_bool y
 
 config ARCH_SUPPORTS_KEXEC_SIG
 	def_bool MODULE_SIG_FORMAT
 
 config ARCH_SUPPORTS_KEXEC_PURGATORY
-	def_bool KEXEC_FILE
+	def_bool y
 
 config ARCH_SUPPORTS_CRASH_DUMP
 	def_bool y
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 66bfabae88149..fe3292e310d48 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2034,7 +2034,7 @@ config ARCH_SUPPORTS_KEXEC
 	def_bool y
 
 config ARCH_SUPPORTS_KEXEC_FILE
-	def_bool X86_64 && CRYPTO && CRYPTO_SHA256
+	def_bool X86_64
 
 config ARCH_SELECTS_KEXEC_FILE
 	def_bool y
@@ -2042,7 +2042,7 @@ config ARCH_SELECTS_KEXEC_FILE
 	select HAVE_IMA_KEXEC if IMA
 
 config ARCH_SUPPORTS_KEXEC_PURGATORY
-	def_bool KEXEC_FILE
+	def_bool y
 
 config ARCH_SUPPORTS_KEXEC_SIG
 	def_bool y
diff --git a/kernel/Kconfig.kexec b/kernel/Kconfig.kexec
index f9619ac6b71d9..d3b8a2b1b5732 100644
--- a/kernel/Kconfig.kexec
+++ b/kernel/Kconfig.kexec
@@ -36,6 +36,7 @@ config KEXEC
 config KEXEC_FILE
 	bool "Enable kexec file based system call"
 	depends on ARCH_SUPPORTS_KEXEC_FILE
+	depends on CRYPTO_SHA256=y || !ARCH_SUPPORTS_KEXEC_PURGATORY
 	select KEXEC_CORE
 	help
 	  This is new version of kexec system call. This system call is
-- 
2.43.0



