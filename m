Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FC821CAA82;
	Wed, 19 Feb 2025 09:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956603; cv=none; b=S9cp/5AKryuPuDB5eGtWzUZFbQ8+V9r6sTt+GHdDX2b2Ieg/68/QTsaknLmhYfC8byhcNay+eGG/Foj8YsJdV0pU2CMGjtiv3hB2vGpsq/HjPE+luWVFH4fYoQvYdHTxFvqToIrgXfa4AOCbHSnmRXtddXxeFLtO8K6jR4FPUIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956603; c=relaxed/simple;
	bh=kEuelo8tSP3bOmOiV3Ia0H1oICCB+KVcRiX8aS7RhY0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CxKXansWbL4c0gb3e+Oh9Bro96gMi8nuWtJfh5tPgNgT7tXpGTLzNYfn0rMHdbSk6X0Lf84ZdPSHu/XthZ6zuFlQBId+lzVEYiaR6OhefU7BRgdh0J+kjN9e/uk8+Bg7/889PTGPZJbtgxyr+D4Rk4wVjQOFxBbXNK0h8UP64/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c7wUqK1X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c7wUqK1X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD304C4CED1;
	Wed, 19 Feb 2025 09:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956603;
	bh=kEuelo8tSP3bOmOiV3Ia0H1oICCB+KVcRiX8aS7RhY0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c7wUqK1XWTUpwlyW7AJCXGx25TYRWyTCH4daCZG5+NzHE3d0FAkcH3luimA1Ct4IM
	 Fh7u9UQZiUwvjfl+L2FMKNI5doldMaBklipvnQAwnA+IzH94gl79yojEw0y5TEvT83
	 ldV5dm4IRbRGWyFI67JRrB9jQDeqS/MAvpY9Qi30=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 235/578] kconfig: add warn-unknown-symbols sanity check
Date: Wed, 19 Feb 2025 09:23:59 +0100
Message-ID: <20250219082702.287530770@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sergey Senozhatsky <senozhatsky@chromium.org>

[ Upstream commit 7cd343008b967423b06af8f6d3236749c67d12e8 ]

Introduce KCONFIG_WARN_UNKNOWN_SYMBOLS environment variable,
which makes Kconfig warn about unknown config symbols.

This is especially useful for continuous kernel uprevs when
some symbols can be either removed or renamed between kernel
releases (which can go unnoticed otherwise).

By default KCONFIG_WARN_UNKNOWN_SYMBOLS generates warnings,
which are non-terminal. There is an additional environment
variable KCONFIG_WERROR that overrides this behaviour and
turns warnings into errors.

Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Stable-dep-of: a409fc1463d6 ("kconfig: fix memory leak in sym_warn_unmet_dep()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/kbuild/kconfig.rst |  9 +++++++++
 scripts/kconfig/confdata.c       | 21 +++++++++++++++++++--
 2 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/Documentation/kbuild/kconfig.rst b/Documentation/kbuild/kconfig.rst
index 5967c79c3baa7..eee0d298774ab 100644
--- a/Documentation/kbuild/kconfig.rst
+++ b/Documentation/kbuild/kconfig.rst
@@ -54,6 +54,15 @@ KCONFIG_OVERWRITECONFIG
 If you set KCONFIG_OVERWRITECONFIG in the environment, Kconfig will not
 break symlinks when .config is a symlink to somewhere else.
 
+KCONFIG_WARN_UNKNOWN_SYMBOLS
+----------------------------
+This environment variable makes Kconfig warn about all unrecognized
+symbols in the config input.
+
+KCONFIG_WERROR
+--------------
+If set, Kconfig treats warnings as errors.
+
 `CONFIG_`
 ---------
 If you set `CONFIG_` in the environment, Kconfig will prefix all symbols
diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
index 886698a5afba1..02ac250b8fe9e 100644
--- a/scripts/kconfig/confdata.c
+++ b/scripts/kconfig/confdata.c
@@ -349,7 +349,11 @@ int conf_read_simple(const char *name, int def)
 	char *p, *p2;
 	struct symbol *sym;
 	int i, def_flags;
+	const char *warn_unknown;
+	const char *werror;
 
+	warn_unknown = getenv("KCONFIG_WARN_UNKNOWN_SYMBOLS");
+	werror = getenv("KCONFIG_WERROR");
 	if (name) {
 		in = zconf_fopen(name);
 	} else {
@@ -439,6 +443,10 @@ int conf_read_simple(const char *name, int def)
 			if (def == S_DEF_USER) {
 				sym = sym_find(line + 2 + strlen(CONFIG_));
 				if (!sym) {
+					if (warn_unknown)
+						conf_warning("unknown symbol: %s",
+							     line + 2 + strlen(CONFIG_));
+
 					conf_set_changed(true);
 					continue;
 				}
@@ -473,7 +481,7 @@ int conf_read_simple(const char *name, int def)
 
 			sym = sym_find(line + strlen(CONFIG_));
 			if (!sym) {
-				if (def == S_DEF_AUTO)
+				if (def == S_DEF_AUTO) {
 					/*
 					 * Reading from include/config/auto.conf
 					 * If CONFIG_FOO previously existed in
@@ -481,8 +489,13 @@ int conf_read_simple(const char *name, int def)
 					 * include/config/FOO must be touched.
 					 */
 					conf_touch_dep(line + strlen(CONFIG_));
-				else
+				} else {
+					if (warn_unknown)
+						conf_warning("unknown symbol: %s",
+							     line + strlen(CONFIG_));
+
 					conf_set_changed(true);
+				}
 				continue;
 			}
 
@@ -521,6 +534,10 @@ int conf_read_simple(const char *name, int def)
 	}
 	free(line);
 	fclose(in);
+
+	if (conf_warnings && werror)
+		exit(1);
+
 	return 0;
 }
 
-- 
2.39.5



