Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80F658F5E;
	Tue,  8 Jul 2025 16:50:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993440; cv=none; b=Verz2bGtGovHYK6PV5WLX09qtwKPWqtk6h+WG6afwv5/qXgA2ZBi6gzDgrgTKmx6jvQaOtn6fk4ROMKyo6s8Xwc4GHUfX+bghH5P/SPdwqugyX8X+iRxBPd8V/hjcN+leAK26ERmnvpCiEhZLjjdPgAlizlHnk9MaoLi7GcugD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993440; c=relaxed/simple;
	bh=uhkaudExw0j/g8N1ZI/cqvnv5EucMvaTGIsItMIuH/w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AWCdF3S/jYU0/oF/a0dUzZcdavr46LnopHc5XlwctRz5IBOucx+0Dtx37Z9qVE957J848I7Ydj9Xr9Eu9cdCDTH2SxJGGJPHxAlozrfd/TiNj33B9jsrPGhEix8eVS+0glFa3Mtne7xkLcS8SP+Ppr4OrWcKwXw9ybj+q/Wjrlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yxx06poi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yxx06poi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAF98C4CEED;
	Tue,  8 Jul 2025 16:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993440;
	bh=uhkaudExw0j/g8N1ZI/cqvnv5EucMvaTGIsItMIuH/w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yxx06poiRsiIq+1UU68h56mFlIF/3Xr4VuV1/GO9y5w7WXDy90n9IsErGPVLO7XFH
	 WQwVVEWQMmsQqZ6DWha3KbegMR3IcOj8/+IA2ynFSlCVU0CVBzqudq0g96FyC6xHtM
	 LcKcIzePrGxdCULbr8HNuVZFfb8/90J3w/Z8Nlxg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Petr Pavlu <petr.pavlu@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 045/178] module: Provide EXPORT_SYMBOL_GPL_FOR_MODULES() helper
Date: Tue,  8 Jul 2025 18:21:22 +0200
Message-ID: <20250708162237.857850056@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162236.549307806@linuxfoundation.org>
References: <20250708162236.549307806@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 707f853d7fa3ce323a6875487890c213e34d81a0 ]

Helper macro to more easily limit the export of a symbol to a given
list of modules.

Eg:

  EXPORT_SYMBOL_GPL_FOR_MODULES(preempt_notifier_inc, "kvm");

will limit the use of said function to kvm.ko, any other module trying
to use this symbol will refure to load (and get modpost build
failures).

Requested-by: Masahiro Yamada <masahiroy@kernel.org>
Requested-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Reviewed-by: Petr Pavlu <petr.pavlu@suse.com>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Stable-dep-of: cbe4134ea4bc ("fs: export anon_inode_make_secure_inode() and fix secretmem LSM bypass")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/core-api/symbol-namespaces.rst | 22 ++++++++++++++++++++
 include/linux/export.h                       | 12 +++++++++--
 2 files changed, 32 insertions(+), 2 deletions(-)

diff --git a/Documentation/core-api/symbol-namespaces.rst b/Documentation/core-api/symbol-namespaces.rst
index 06f766a6aab24..c6f59c5e25648 100644
--- a/Documentation/core-api/symbol-namespaces.rst
+++ b/Documentation/core-api/symbol-namespaces.rst
@@ -28,6 +28,9 @@ kernel. As of today, modules that make use of symbols exported into namespaces,
 are required to import the namespace. Otherwise the kernel will, depending on
 its configuration, reject loading the module or warn about a missing import.
 
+Additionally, it is possible to put symbols into a module namespace, strictly
+limiting which modules are allowed to use these symbols.
+
 2. How to define Symbol Namespaces
 ==================================
 
@@ -83,6 +86,22 @@ unit as preprocessor statement. The above example would then read::
 within the corresponding compilation unit before the #include for
 <linux/export.h>. Typically it's placed before the first #include statement.
 
+2.3 Using the EXPORT_SYMBOL_GPL_FOR_MODULES() macro
+===================================================
+
+Symbols exported using this macro are put into a module namespace. This
+namespace cannot be imported.
+
+The macro takes a comma separated list of module names, allowing only those
+modules to access this symbol. Simple tail-globs are supported.
+
+For example:
+
+  EXPORT_SYMBOL_GPL_FOR_MODULES(preempt_notifier_inc, "kvm,kvm-*")
+
+will limit usage of this symbol to modules whoes name matches the given
+patterns.
+
 3. How to use Symbols exported in Namespaces
 ============================================
 
@@ -154,3 +173,6 @@ in-tree modules::
 You can also run nsdeps for external module builds. A typical usage is::
 
 	$ make -C <path_to_kernel_src> M=$PWD nsdeps
+
+Note: it will happily generate an import statement for the module namespace;
+which will not work and generates build and runtime failures.
diff --git a/include/linux/export.h b/include/linux/export.h
index a8c23d945634b..f35d03b4113b1 100644
--- a/include/linux/export.h
+++ b/include/linux/export.h
@@ -24,11 +24,17 @@
 	.long sym
 #endif
 
-#define ___EXPORT_SYMBOL(sym, license, ns)		\
+/*
+ * LLVM integrated assembler cam merge adjacent string literals (like
+ * C and GNU-as) passed to '.ascii', but not to '.asciz' and chokes on:
+ *
+ *   .asciz "MODULE_" "kvm" ;
+ */
+#define ___EXPORT_SYMBOL(sym, license, ns...)		\
 	.section ".export_symbol","a"		ASM_NL	\
 	__export_symbol_##sym:			ASM_NL	\
 		.asciz license			ASM_NL	\
-		.asciz ns			ASM_NL	\
+		.ascii ns "\0"			ASM_NL	\
 		__EXPORT_SYMBOL_REF(sym)	ASM_NL	\
 	.previous
 
@@ -85,4 +91,6 @@
 #define EXPORT_SYMBOL_NS(sym, ns)	__EXPORT_SYMBOL(sym, "", ns)
 #define EXPORT_SYMBOL_NS_GPL(sym, ns)	__EXPORT_SYMBOL(sym, "GPL", ns)
 
+#define EXPORT_SYMBOL_GPL_FOR_MODULES(sym, mods) __EXPORT_SYMBOL(sym, "GPL", "module:" mods)
+
 #endif /* _LINUX_EXPORT_H */
-- 
2.39.5



