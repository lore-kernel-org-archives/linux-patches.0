Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8D65134C7
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 18:15:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37F7EC433C8;
	Mon, 26 Jun 2023 18:15:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687803307;
	bh=2/ivfQYyBos8Cgvhzwf5Q7NdtoDaDVj+jY89iCauki0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o+rlaDSu7va1mX9EmmYV8cLlMkKMHwx7A2IVUC8FMvbfMjOK4W7TWGvegbE125IZ0
	 abBi8IZ4qtiLaOpeg53hoTZTsHdRhhPAWabdZjav4UnD54TGJQMHYsIXSOTViv4l7V
	 OFbhPXpEaRwbNHg44TVpvXfPN/Fe62v3gZlZgr+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"palmer@dabbelt.com, conor@kernel.org, ndesaulniers@google.com, nathan@kernel.org, linux-riscv@lists.infradead.org, stable@vger.kernel.org, llvm@lists.linux.dev, kernel test robot" <lkp@intel.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	kernel test robot <lkp@intel.com>
Subject: [PATCH 6.3 017/199] riscv: Link with -z norelro
Date: Mon, 26 Jun 2023 20:08:43 +0200
Message-ID: <20230626180806.427700545@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230626180805.643662628@linuxfoundation.org>
References: <20230626180805.643662628@linuxfoundation.org>
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

This patch fixes a stable only patch, so it has no direct upstream
equivalent.

After a stable only patch to explicitly handle the '.got' section to
handle an orphan section warning from the linker, certain configurations
error when linking with ld.lld, which enables relro by default:

  ld.lld: error: section: .got is not contiguous with other relro sections

This has come up with other architectures before, such as arm and arm64
in commit 0cda9bc15dfc ("ARM: 9038/1: Link with '-z norelro'") and
commit 3b92fa7485eb ("arm64: link with -z norelro regardless of
CONFIG_RELOCATABLE"). Additionally, '-z norelro' is used unconditionally
for RISC-V upstream after commit 26e7aacb83df ("riscv: Allow to
downgrade paging mode from the command line"), which alluded to this
issue for the same reason. Bring 6.3 in line with mainline and link with
'-z norelro', which resolves the above link failure.

Fixes: e6d1562dd4e9 ("riscv: vmlinux.lds.S: Explicitly handle '.got' section")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202306192231.DJmWr6BX-lkp@intel.com/
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Acked-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/riscv/Makefile
+++ b/arch/riscv/Makefile
@@ -7,7 +7,7 @@
 #
 
 OBJCOPYFLAGS    := -O binary
-LDFLAGS_vmlinux :=
+LDFLAGS_vmlinux := -z norelro
 ifeq ($(CONFIG_DYNAMIC_FTRACE),y)
 	LDFLAGS_vmlinux := --no-relax
 	KBUILD_CPPFLAGS += -DCC_USING_PATCHABLE_FUNCTION_ENTRY


