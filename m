Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7D6E2E54D6;
	Tue,  8 Jul 2025 16:45:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993117; cv=none; b=MFWd+vN1kynbbffwzmmQFpEE4fki5Ls3G62PFwie6FPWpASvY2D7S9WHVeZhYAy3FWNVk8oQrRcDKQB9T1Vk2b9qi3Q45SqJwM2yHNAzUUkpdgvIOOgAEE7CPsKA+CGO4Bgi/syG3ey3vyzxAMHAYSERslX5qcYSZf7h3lZGXy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993117; c=relaxed/simple;
	bh=DMuVjw41DmsEZi5sazZ/OfkkOfdPeDFjlDqslS/F0FU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U8JOovCU0t3zRkSshtmqKcEQyIAcr9uVIG5dTRMkj72i02edZZW7rO3uuDd7dA4tw/ejvSMYjrF2NIdPysh4IzIbNNsIlYjzYSdL6EnaN+yOWYJm6nS7bLcSfusVnkJz/Wv5dqZdJ8BuN2Ddv7JnfWUyjvqLdidUfmO0q3rDCEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=igW6rXX9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="igW6rXX9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C70DC4CEED;
	Tue,  8 Jul 2025 16:45:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993117;
	bh=DMuVjw41DmsEZi5sazZ/OfkkOfdPeDFjlDqslS/F0FU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=igW6rXX90Nqv1KM7ud6MYvpGrjGXImO1riy2EZWaIulqXHqaJmovOwYrAqZboYuwE
	 v9GxnoV9ByhTBBCaaVReutS5uZa9u6V2g0+yrKf7kkddw3Ye0c+C3A09mzLYcsuF0+
	 Jv4zcYdhfZyqJpUF9o5THEfoIMCzNfxD+RZtPWG4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Petr Pavlu <petr.pavlu@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 192/232] module: Provide EXPORT_SYMBOL_GPL_FOR_MODULES() helper
Date: Tue,  8 Jul 2025 18:23:08 +0200
Message-ID: <20250708162246.459462704@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162241.426806072@linuxfoundation.org>
References: <20250708162241.426806072@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index d1154eb438101..cca94469fa414 100644
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
 
@@ -84,6 +87,22 @@ unit as preprocessor statement. The above example would then read::
 within the corresponding compilation unit before any EXPORT_SYMBOL macro is
 used.
 
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
 
@@ -155,3 +174,6 @@ in-tree modules::
 You can also run nsdeps for external module builds. A typical usage is::
 
 	$ make -C <path_to_kernel_src> M=$PWD nsdeps
+
+Note: it will happily generate an import statement for the module namespace;
+which will not work and generates build and runtime failures.
diff --git a/include/linux/export.h b/include/linux/export.h
index 1e04dbc675c2f..b40ae79b767da 100644
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
 
@@ -70,4 +76,6 @@
 #define EXPORT_SYMBOL_NS(sym, ns)	__EXPORT_SYMBOL(sym, "", __stringify(ns))
 #define EXPORT_SYMBOL_NS_GPL(sym, ns)	__EXPORT_SYMBOL(sym, "GPL", __stringify(ns))
 
+#define EXPORT_SYMBOL_GPL_FOR_MODULES(sym, mods) __EXPORT_SYMBOL(sym, "GPL", "module:" mods)
+
 #endif /* _LINUX_EXPORT_H */
-- 
2.39.5



