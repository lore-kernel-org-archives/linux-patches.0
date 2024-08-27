Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD31A1C2DB1;
	Tue, 27 Aug 2024 15:06:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771200; cv=none; b=SaH32mk4C9Pv7KT0lej8ORyCXpvw76r00uSjTmRWh+y+PYNhdiQQcFaTK4j1Pd+jHXioHaZ/VlZ4Kc3IaR43nDyXGUyrGQG9fpaTX/SxJc/QdIWZ4vxaGeLEL/Lt+Z79vzRLh0TOcNyqxUgJfePNqaIjMdzacj6sg1e41OUudiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771200; c=relaxed/simple;
	bh=h0/PHHKvj5wF08rH/AQKjzSBQwPKdknOhnwAOvtAPXM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ttcxXGG6F5iEnitN2G41nzLsJCqGZqSyolo3ifz7eRQ99gC6GWhqryaQ2UvLjG+RZr4kGLe61/Q2lcEToaJrhp1qF5ZkzkW5CKP+Vgiy6W44kE9Vyr54cbAKFzH7TRnt8jtkUtClquqUIju6h897ywxMqiLM00hRURg9v/ZkcZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gQOx6Zxt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gQOx6Zxt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D813C6107C;
	Tue, 27 Aug 2024 15:06:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771200;
	bh=h0/PHHKvj5wF08rH/AQKjzSBQwPKdknOhnwAOvtAPXM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gQOx6ZxtWTWIoG/r+pPfmp6PDfrZmW/nUiz2U5VJmXhFJeEkK9R4EzhQPgPoyT/vh
	 nwCmbJpZNHwM3fIFp6acou070EXT292Is67hl0f5fF9G3mjJRZd7zaRKysIFAZKFrL
	 FGH/QE4CCS9grGsSzJ7auUTHlGPv1TEhaLxJmSj0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Nicolas Schier <nicolas@fjasle.eu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 117/273] kbuild: remove PROVIDE() for kallsyms symbols
Date: Tue, 27 Aug 2024 16:37:21 +0200
Message-ID: <20240827143837.861072853@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit c442db3f49f27e5a60a641b2ac9a3c6320796ed6 ]

This reimplements commit 951bcae6c5a0 ("kallsyms: Avoid weak references
for kallsyms symbols") because I am not a big fan of PROVIDE().

As an alternative solution, this commit prepends one more kallsyms step.

    KSYMS   .tmp_vmlinux.kallsyms0.S          # added
    AS      .tmp_vmlinux.kallsyms0.o          # added
    LD      .tmp_vmlinux.btf
    BTF     .btf.vmlinux.bin.o
    LD      .tmp_vmlinux.kallsyms1
    NM      .tmp_vmlinux.kallsyms1.syms
    KSYMS   .tmp_vmlinux.kallsyms1.S
    AS      .tmp_vmlinux.kallsyms1.o
    LD      .tmp_vmlinux.kallsyms2
    NM      .tmp_vmlinux.kallsyms2.syms
    KSYMS   .tmp_vmlinux.kallsyms2.S
    AS      .tmp_vmlinux.kallsyms2.o
    LD      vmlinux

Step 0 takes /dev/null as input, and generates .tmp_vmlinux.kallsyms0.o,
which has a valid kallsyms format with the empty symbol list, and can be
linked to vmlinux. Since it is really small, the added compile-time cost
is negligible.

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Reviewed-by: Nicolas Schier <nicolas@fjasle.eu>
Stable-dep-of: 020925ce9299 ("kallsyms: Do not cleanup .llvm.<hash> suffix before sorting symbols")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/asm-generic/vmlinux.lds.h | 19 -------------------
 kernel/kallsyms_internal.h        |  5 -----
 scripts/kallsyms.c                |  6 ------
 scripts/link-vmlinux.sh           |  9 +++++++--
 4 files changed, 7 insertions(+), 32 deletions(-)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 70bf1004076b2..f00a8e18f389f 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -451,30 +451,11 @@
 #endif
 #endif
 
-/*
- * Some symbol definitions will not exist yet during the first pass of the
- * link, but are guaranteed to exist in the final link. Provide preliminary
- * definitions that will be superseded in the final link to avoid having to
- * rely on weak external linkage, which requires a GOT when used in position
- * independent code.
- */
-#define PRELIMINARY_SYMBOL_DEFINITIONS					\
-	PROVIDE(kallsyms_addresses = .);				\
-	PROVIDE(kallsyms_offsets = .);					\
-	PROVIDE(kallsyms_names = .);					\
-	PROVIDE(kallsyms_num_syms = .);					\
-	PROVIDE(kallsyms_relative_base = .);				\
-	PROVIDE(kallsyms_token_table = .);				\
-	PROVIDE(kallsyms_token_index = .);				\
-	PROVIDE(kallsyms_markers = .);					\
-	PROVIDE(kallsyms_seqs_of_names = .);
-
 /*
  * Read only Data
  */
 #define RO_DATA(align)							\
 	. = ALIGN((align));						\
-	PRELIMINARY_SYMBOL_DEFINITIONS					\
 	.rodata           : AT(ADDR(.rodata) - LOAD_OFFSET) {		\
 		__start_rodata = .;					\
 		*(.rodata) *(.rodata.*)					\
diff --git a/kernel/kallsyms_internal.h b/kernel/kallsyms_internal.h
index 85480274fc8fb..925f2ab22639a 100644
--- a/kernel/kallsyms_internal.h
+++ b/kernel/kallsyms_internal.h
@@ -4,11 +4,6 @@
 
 #include <linux/types.h>
 
-/*
- * These will be re-linked against their real values during the second link
- * stage. Preliminary values must be provided in the linker script using the
- * PROVIDE() directive so that the first link stage can complete successfully.
- */
 extern const unsigned long kallsyms_addresses[];
 extern const int kallsyms_offsets[];
 extern const u8 kallsyms_names[];
diff --git a/scripts/kallsyms.c b/scripts/kallsyms.c
index 47978efe4797c..fa53b5eef5530 100644
--- a/scripts/kallsyms.c
+++ b/scripts/kallsyms.c
@@ -259,12 +259,6 @@ static void shrink_table(void)
 		}
 	}
 	table_cnt = pos;
-
-	/* When valid symbol is not registered, exit to error */
-	if (!table_cnt) {
-		fprintf(stderr, "No valid symbol.\n");
-		exit(1);
-	}
 }
 
 static void read_map(const char *in)
diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
index 3d9d7257143a0..83d605ba7241a 100755
--- a/scripts/link-vmlinux.sh
+++ b/scripts/link-vmlinux.sh
@@ -227,6 +227,10 @@ btf_vmlinux_bin_o=
 kallsymso=
 strip_debug=
 
+if is_enabled CONFIG_KALLSYMS; then
+	kallsyms /dev/null .tmp_vmlinux.kallsyms0
+fi
+
 if is_enabled CONFIG_DEBUG_INFO_BTF; then
 	if ! gen_btf .tmp_vmlinux.btf .btf.vmlinux.bin.o ; then
 		echo >&2 "Failed to generate BTF for vmlinux"
@@ -239,9 +243,10 @@ if is_enabled CONFIG_KALLSYMS; then
 
 	# kallsyms support
 	# Generate section listing all symbols and add it into vmlinux
-	# It's a three step process:
+	# It's a four step process:
+	# 0)  Generate a dummy __kallsyms with empty symbol list.
 	# 1)  Link .tmp_vmlinux.kallsyms1 so it has all symbols and sections,
-	#     but __kallsyms is empty.
+	#     with a dummy __kallsyms.
 	#     Running kallsyms on that gives us .tmp_kallsyms1.o with
 	#     the right size
 	# 2)  Link .tmp_vmlinux.kallsyms2 so it now has a __kallsyms section of
-- 
2.43.0



