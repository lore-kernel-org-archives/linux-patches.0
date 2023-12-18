Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 056EC1D127;
	Mon, 18 Dec 2023 13:58:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DXQVtctR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BE22C433C8;
	Mon, 18 Dec 2023 13:58:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702907916;
	bh=aXjIL5Snv57/dQi/nT58X83ZGvLoL0urGLC0JP2ZYHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DXQVtctRPWHIgo0iw1p5VE44NYPLfRj1QonilstXWouXlxsHHgfdO/qSPXgfMAbYE
	 HVyhbxttFywWfl8qMipOMSOaK6ZY8kiqGvqQFkZdB2J2utb60o/85ZRXSPbrZxyOFB
	 4mqk3FWrKaMiKoT6/gShkMIicgWoQXhwmnZzIIi0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 065/106] LoongArch: Add dependency between vmlinuz.efi and vmlinux.efi
Date: Mon, 18 Dec 2023 14:51:19 +0100
Message-ID: <20231218135057.826944339@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231218135055.005497074@linuxfoundation.org>
References: <20231218135055.005497074@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit d3ec75bc635cb0cb8185b63293d33a3d1b942d22 ]

A common issue in Makefile is a race in parallel building.

You need to be careful to prevent multiple threads from writing to the
same file simultaneously.

Commit 3939f3345050 ("ARM: 8418/1: add boot image dependencies to not
generate invalid images") addressed such a bad scenario.

A similar symptom occurs with the following command:

  $ make -j$(nproc) ARCH=loongarch vmlinux.efi vmlinuz.efi
    [ snip ]
    SORTTAB vmlinux
    OBJCOPY arch/loongarch/boot/vmlinux.efi
    OBJCOPY arch/loongarch/boot/vmlinux.efi
    PAD     arch/loongarch/boot/vmlinux.bin
    GZIP    arch/loongarch/boot/vmlinuz
    OBJCOPY arch/loongarch/boot/vmlinuz.o
    LD      arch/loongarch/boot/vmlinuz.efi.elf
    OBJCOPY arch/loongarch/boot/vmlinuz.efi

The log "OBJCOPY arch/loongarch/boot/vmlinux.efi" is displayed twice.

It indicates that two threads simultaneously enter arch/loongarch/boot/
and write to arch/loongarch/boot/vmlinux.efi.

It occasionally leads to a build failure:

  $ make -j$(nproc) ARCH=loongarch vmlinux.efi vmlinuz.efi
    [ snip ]
    SORTTAB vmlinux
    OBJCOPY arch/loongarch/boot/vmlinux.efi
    PAD     arch/loongarch/boot/vmlinux.bin
  truncate: Invalid number: ‘arch/loongarch/boot/vmlinux.bin’
  make[2]: *** [drivers/firmware/efi/libstub/Makefile.zboot:13:
  arch/loongarch/boot/vmlinux.bin] Error 1
  make[2]: *** Deleting file 'arch/loongarch/boot/vmlinux.bin'
  make[1]: *** [arch/loongarch/Makefile:146: vmlinuz.efi] Error 2
  make[1]: *** Waiting for unfinished jobs....
  make: *** [Makefile:234: __sub-make] Error 2

vmlinuz.efi depends on vmlinux.efi, but such a dependency is not
specified in arch/loongarch/Makefile.

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/Makefile | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/loongarch/Makefile b/arch/loongarch/Makefile
index 01b57b7263225..ed47a3a87768e 100644
--- a/arch/loongarch/Makefile
+++ b/arch/loongarch/Makefile
@@ -116,6 +116,8 @@ vdso_install:
 
 all:	$(notdir $(KBUILD_IMAGE))
 
+vmlinuz.efi: vmlinux.efi
+
 vmlinux.elf vmlinux.efi vmlinuz.efi: vmlinux
 	$(Q)$(MAKE) $(build)=$(boot) $(bootvars-y) $(boot)/$@
 
-- 
2.43.0



