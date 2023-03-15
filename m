Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56C2F4431
	for <patches@lists.linux.dev>; Wed, 15 Mar 2023 12:31:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFB04C433EF;
	Wed, 15 Mar 2023 12:31:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678883486;
	bh=DG4gGiF9iw4Azd2VaHJiZVHwxM706SN54ONQ5b+x+X4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pNgRsnMTvpz3Bh/qA82YvMFUsyuEXpsKz3lxQrdhYb7up9CNJX7KlIH9Rx0z20NrT
	 P1vkRD6tUbrGPKyVlRtJVePJiWWDV4C+cSAGWvwelLSjFzuNfLnoJX0sHnlxUQXmko
	 aFl9RB5B3ONMQIIhhRAx1aHLrfKM+q41i73KSfvI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Conor Dooley <conor.dooley@microchip.com>,
	Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 6.1 008/143] RISC-V: Stop emitting attributes
Date: Wed, 15 Mar 2023 13:11:34 +0100
Message-Id: <20230315115740.710341569@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115740.429574234@linuxfoundation.org>
References: <20230315115740.429574234@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Palmer Dabbelt <palmer@rivosinc.com>

commit e18048da9bc3f87acef4eb67a11b4fc55fe15424 upstream.

The RISC-V ELF attributes don't contain any useful information.  New
toolchains ignore them, but they frequently trip up various older/mixed
toolchains.  So just turn them off.

Tested-by: Conor Dooley <conor.dooley@microchip.com>
Link: https://lore.kernel.org/r/20230223224605.6995-1-palmer@rivosinc.com
Cc: stable@vger.kernel.org
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/Makefile                    |    7 +++++++
 arch/riscv/kernel/compat_vdso/Makefile |    4 ++++
 2 files changed, 11 insertions(+)

--- a/arch/riscv/Makefile
+++ b/arch/riscv/Makefile
@@ -87,6 +87,13 @@ endif
 # Avoid generating .eh_frame sections.
 KBUILD_CFLAGS += -fno-asynchronous-unwind-tables -fno-unwind-tables
 
+# The RISC-V attributes frequently cause compatibility issues and provide no
+# information, so just turn them off.
+KBUILD_CFLAGS += $(call cc-option,-mno-riscv-attribute)
+KBUILD_AFLAGS += $(call cc-option,-mno-riscv-attribute)
+KBUILD_CFLAGS += $(call as-option,-Wa$(comma)-mno-arch-attr)
+KBUILD_AFLAGS += $(call as-option,-Wa$(comma)-mno-arch-attr)
+
 KBUILD_CFLAGS_MODULE += $(call cc-option,-mno-relax)
 KBUILD_AFLAGS_MODULE += $(call as-option,-Wa$(comma)-mno-relax)
 
--- a/arch/riscv/kernel/compat_vdso/Makefile
+++ b/arch/riscv/kernel/compat_vdso/Makefile
@@ -14,6 +14,10 @@ COMPAT_LD := $(LD)
 COMPAT_CC_FLAGS := -march=rv32g -mabi=ilp32
 COMPAT_LD_FLAGS := -melf32lriscv
 
+# Disable attributes, as they're useless and break the build.
+COMPAT_CC_FLAGS += $(call cc-option,-mno-riscv-attribute)
+COMPAT_CC_FLAGS += $(call as-option,-Wa$(comma)-mno-arch-attr)
+
 # Files to link into the compat_vdso
 obj-compat_vdso = $(patsubst %, %.o, $(compat_vdso-syms)) note.o
 


