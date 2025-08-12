Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D2261DB92A;
	Tue, 12 Aug 2025 18:37:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023833; cv=none; b=HOoiWTPQhVFc7J3nIF2+I/DaeXH25sQa1Y+RPwp++3Nyq0GGDSdNcmJDxYl0o+7D4kJoJkPcA+FueAMCsRENIhQDpidSceRDlmkhhjQF4fQw2EGHH3PuP+sdiYXbGYNCvmfFyTrKWnrLXk8GrfrbUQGYGgNYq0UBFSPyR/nfA6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023833; c=relaxed/simple;
	bh=7rRsp/MaK7pxdV1GmqlvLt6KZusJGJgUV1JVsYgaDG8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IaAzVchNCE8ff33wxYU3WeUaP/54xdHE3EN+DsQ4MvDwxBh3sw54yamiDdlMxwoswDWkQZ3FCufHCaFQ1oxVl1feBQrnxpMcoi95smJxIKeHrLZkNOXHMv+rQcpr0Fro/pGrNaf2Bebtm3JV0bxu/np0IRMBFc24zaJQEVWHj4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IvJbX1nh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IvJbX1nh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88DA6C4CEF0;
	Tue, 12 Aug 2025 18:37:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023832;
	bh=7rRsp/MaK7pxdV1GmqlvLt6KZusJGJgUV1JVsYgaDG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IvJbX1nhI0m+kSFqwYQ8zJBYnElDPu4XxqQ8h83/ZmooiCiOD9jNPejo7unjq0LT5
	 gHAjn/Hj+Y+jaJ/LK8qitf4zSoXx0MoZJPnINSsF5XoYZtBZ9uJzHkt8MTM4dkWSyo
	 mgCpiGw4jxlNSOC0B6N0t8i9c9gz7/l+suu7jALo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 195/627] arm64: fix unnecessary rebuilding when CONFIG_DEBUG_EFI=y
Date: Tue, 12 Aug 2025 19:28:10 +0200
Message-ID: <20250812173426.684536217@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit 344b6580472451390d070c65c27f59716a1deecb ]

When CONFIG_DEBUG_EFI is enabled, some objects are needlessly rebuilt.

[Steps to reproduce]

  Enable CONFIG_DEBUG_EFI and run 'make' twice in a clean source tree.
  On the second run, arch/arm64/kernel/head.o is rebuilt even though
  no files have changed.

  $ make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- clean
  $ make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu-
     [ snip ]
  $ make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu-
    CALL    scripts/checksyscalls.sh
    AS      arch/arm64/kernel/head.o
    AR      arch/arm64/kernel/built-in.a
    AR      arch/arm64/built-in.a
    AR      built-in.a
     [ snip ]

The issue is caused by the use of the $(realpath ...) function.

At the time arch/arm64/kernel/Makefile is parsed on the first run,
$(objtree)/vmlinux does not exist. As a result,
$(realpath $(objtree)/vmlinux) expands to an empty string.

On the second run of Make, $(objtree)/vmlinux already exists, so
$(realpath $(objtree)/vmlinux) expands to the absolute path of vmlinux.
However, this change in the command line causes arch/arm64/kernel/head.o
to be rebuilt.

To address this issue, use $(abspath ...) instead, which does not require
the file to exist. While $(abspath ...) does not resolve symlinks, this
should be fine from a debugging perspective.

The GNU Make manual [1] clearly explains the difference between the two:

  $(realpath names...)
    For each file name in names return the canonical absolute name.
    A canonical name does not contain any . or .. components, nor any
    repeated path separators (/) or symlinks. In case of a failure the
    empty string is returned. Consult the realpath(3) documentation for
    a list of possible failure causes.

  $(abspath namees...)
    For each file name in names return an absolute name that does not
    contain any . or .. components, nor any repeated path separators (/).
    Note that, in contrast to realpath function, abspath does not resolve
    symlinks and does not require the file names to refer to an existing
    file or directory. Use the wildcard function to test for existence.

The same problem exists in drivers/firmware/efi/libstub/Makefile.zboot.
On the first run of Make, $(obj)/vmlinuz.efi.elf does not exist when the
Makefile is parsed, so -DZBOOT_EFI_PATH is set to an empty string.
Replace $(realpath ...) with $(abspath ...) there as well.

[1]: https://www.gnu.org/software/make/manual/make.html#File-Name-Functions

Fixes: 757b435aaabe ("efi: arm64: Add vmlinux debug link to the Image binary")
Fixes: a050910972bb ("efi/libstub: implement generic EFI zboot")
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Link: https://lore.kernel.org/r/20250625125555.2504734-1-masahiroy@kernel.org
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/Makefile                  | 2 +-
 drivers/firmware/efi/libstub/Makefile.zboot | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
index a2faf0049dab..76f32e424065 100644
--- a/arch/arm64/kernel/Makefile
+++ b/arch/arm64/kernel/Makefile
@@ -80,7 +80,7 @@ obj-y					+= head.o
 always-$(KBUILD_BUILTIN)		+= vmlinux.lds
 
 ifeq ($(CONFIG_DEBUG_EFI),y)
-AFLAGS_head.o += -DVMLINUX_PATH="\"$(realpath $(objtree)/vmlinux)\""
+AFLAGS_head.o += -DVMLINUX_PATH="\"$(abspath vmlinux)\""
 endif
 
 # for cleaning
diff --git a/drivers/firmware/efi/libstub/Makefile.zboot b/drivers/firmware/efi/libstub/Makefile.zboot
index 92e3c73502ba..832deee36e48 100644
--- a/drivers/firmware/efi/libstub/Makefile.zboot
+++ b/drivers/firmware/efi/libstub/Makefile.zboot
@@ -36,7 +36,7 @@ aflags-zboot-header-$(EFI_ZBOOT_FORWARD_CFI) := \
 		-DPE_DLL_CHAR_EX=IMAGE_DLLCHARACTERISTICS_EX_FORWARD_CFI_COMPAT
 
 AFLAGS_zboot-header.o += -DMACHINE_TYPE=IMAGE_FILE_MACHINE_$(EFI_ZBOOT_MACH_TYPE) \
-			 -DZBOOT_EFI_PATH="\"$(realpath $(obj)/vmlinuz.efi.elf)\"" \
+			 -DZBOOT_EFI_PATH="\"$(abspath $(obj)/vmlinuz.efi.elf)\"" \
 			 -DZBOOT_SIZE_LEN=$(zboot-size-len-y) \
 			 -DCOMP_TYPE="\"$(comp-type-y)\"" \
 			 $(aflags-zboot-header-y)
-- 
2.39.5



