Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D4B9330B01;
	Fri, 17 Oct 2025 15:34:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715290; cv=none; b=kug62AErjaMtfn+sySealLKmTswjFadAyazOM209PLbZKM/DS1IklPCg0r6ffGNcQJsYZICkGKueLPD+8XjaZ4Bd/ThQ9iNcsUdqb/4Himg5iPkrDTetDA6NXXB7PKK2qaiZhYmAA5ltA13OgCrcltnVhfL87SuSpcex1Scs+wU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715290; c=relaxed/simple;
	bh=gjJ9GLFTY/q3i1HOH6nxLcYGM1jeHZEsVAZM4Mf1paM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vj3vvxDAMeZe6VnQerGDhq47tXM9q/7KKwqHcef9q1TcmXq6vLm3h3/U9G7pPWoUHqxVAURZCTXW4xHtgYBZPeFyJLCBMijS0LeNJ01lDZ3gisKqT38JEfe/irOkttMNPPg4zrFObK6+/miTglrJP3nLJXnluEH6MKSq41+qtGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZbwgjpcU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZbwgjpcU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A38AC4CEFE;
	Fri, 17 Oct 2025 15:34:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715289;
	bh=gjJ9GLFTY/q3i1HOH6nxLcYGM1jeHZEsVAZM4Mf1paM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZbwgjpcUCNFhY7QR3kiTY5hUajWzPTvHOUViH1XXScPlX09zQmzptH4UHV8+9HhOK
	 BFCZpPY2Mp9nfZiIIJYgg0mYNj/fzzTxz95IDGttRTrr9etCPufjAnkVYIDagxuy87
	 aZZMr8qw5eu13qzuKSUhaON7y/P7ilmBEU8qaQ/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Alexey Gladkov <legion@kernel.org>,
	Nicolas Schier <nsc@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 131/371] kbuild: keep .modinfo section in vmlinux.unstripped
Date: Fri, 17 Oct 2025 16:51:46 +0200
Message-ID: <20251017145206.670774308@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit 3e86e4d74c0490e5fc5a7f8de8f29e7579c9ffe5 ]

Keep the .modinfo section during linking, but strip it from the final
vmlinux.

Adjust scripts/mksysmap to exclude modinfo symbols from kallsyms.

This change will allow the next commit to extract the .modinfo section
from the vmlinux.unstripped intermediate.

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Alexey Gladkov <legion@kernel.org>
Reviewed-by: Nicolas Schier <nsc@kernel.org>
Link: https://patch.msgid.link/aaf67c07447215463300fccaa758904bac42f992.1758182101.git.legion@kernel.org
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Stable-dep-of: 8ec3af916fe3 ("kbuild: Add '.rel.*' strip pattern for vmlinux")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/asm-generic/vmlinux.lds.h | 2 +-
 scripts/Makefile.vmlinux          | 7 +++++--
 scripts/mksysmap                  | 3 +++
 3 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 8efbe8c4874ee..d61a02fce7274 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -832,6 +832,7 @@ defined(CONFIG_AUTOFDO_CLANG) || defined(CONFIG_PROPELLER_CLANG)
 
 /* Required sections not related to debugging. */
 #define ELF_DETAILS							\
+		.modinfo : { *(.modinfo) }				\
 		.comment 0 : { *(.comment) }				\
 		.symtab 0 : { *(.symtab) }				\
 		.strtab 0 : { *(.strtab) }				\
@@ -1045,7 +1046,6 @@ defined(CONFIG_AUTOFDO_CLANG) || defined(CONFIG_PROPELLER_CLANG)
 	*(.discard.*)							\
 	*(.export_symbol)						\
 	*(.no_trim_symbol)						\
-	*(.modinfo)							\
 	/* ld.bfd warns about .gnu.version* even when not emitted */	\
 	*(.gnu.version*)						\
 
diff --git a/scripts/Makefile.vmlinux b/scripts/Makefile.vmlinux
index 4f2d4c3fb7372..70856dab0f541 100644
--- a/scripts/Makefile.vmlinux
+++ b/scripts/Makefile.vmlinux
@@ -86,11 +86,14 @@ endif
 # vmlinux
 # ---------------------------------------------------------------------------
 
-remove-section-y                                   :=
+remove-section-y                                   := .modinfo
 remove-section-$(CONFIG_ARCH_VMLINUX_NEEDS_RELOCS) += '.rel*'
 
+# To avoid warnings: "empty loadable segment detected at ..." from GNU objcopy,
+# it is necessary to remove the PT_LOAD flag from the segment.
 quiet_cmd_strip_relocs = OBJCOPY $@
-      cmd_strip_relocs = $(OBJCOPY) $(addprefix --remove-section=,$(remove-section-y)) $< $@
+      cmd_strip_relocs = $(OBJCOPY) $(patsubst %,--set-section-flags %=noload,$(remove-section-y)) $< $@; \
+                         $(OBJCOPY) $(addprefix --remove-section=,$(remove-section-y)) $@
 
 targets += vmlinux
 vmlinux: vmlinux.unstripped FORCE
diff --git a/scripts/mksysmap b/scripts/mksysmap
index 3accbdb269ac7..a607a0059d119 100755
--- a/scripts/mksysmap
+++ b/scripts/mksysmap
@@ -79,6 +79,9 @@
 / _SDA_BASE_$/d
 / _SDA2_BASE_$/d
 
+# MODULE_INFO()
+/ __UNIQUE_ID_modinfo[0-9]*$/d
+
 # ---------------------------------------------------------------------------
 # Ignored patterns
 #  (symbols that contain the pattern are ignored)
-- 
2.51.0



