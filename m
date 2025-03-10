Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8757517CA12;
	Mon, 10 Mar 2025 17:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629224; cv=none; b=Qt90mjDobU5AZbvH4inWhYqHWsw+a01xXXpy9kE7cCe49SM/3H04bPoioglZv6WvKG0UFOmcXyuUvAF4d/Zm2vfqqOuitloUpWtcv3qK4V/xR7zQu91RHhI3bBAY55ZhBeG74ahgMv4XdgZ71/+v9MTIbvi9ZylMEizQbEcuit0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629224; c=relaxed/simple;
	bh=FrnwbTMpN3QeLIwZRXDZ9EEyspJv8vo5DNP6Lvo1Wgo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RSLscxjZff9wb8aXu1U4dIb3h/O/FOTNlspJ+W4eSzmZcgyz5BG8K4iYAqV/QuQ1mcQpiJ/YhyXMF3n1AU5rFkXGZKXvCCbzkgC2XmIUmPMNuWXmumhhzx8eKL0TKbQmDCUXxFOSkDuOstA61Sz1j9uHdpN4W8QP1nVGRftwClM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1CeU/yEa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1CeU/yEa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 124D3C4CEE5;
	Mon, 10 Mar 2025 17:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629224;
	bh=FrnwbTMpN3QeLIwZRXDZ9EEyspJv8vo5DNP6Lvo1Wgo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1CeU/yEaf9usn6TgFbRicZMBRXom4RI6fhVu3YGWnrAqgnGLO22j3du7Zbh5Ys5lr
	 YPuQcP0eeItaUhmbJXFQJOI9i9R/EXexDqcEBZKnWkGaXWgNvOycdQvvKSCGY9W8pX
	 SOwZYBeSLmzcrxUe4GJ7/EKjvvYox/MEJ2H4arHU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 178/620] kconfig: add warn-unknown-symbols sanity check
Date: Mon, 10 Mar 2025 18:00:24 +0100
Message-ID: <20250310170552.648717703@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 469450b0a5176..033f2882436d3 100644
--- a/scripts/kconfig/confdata.c
+++ b/scripts/kconfig/confdata.c
@@ -351,7 +351,11 @@ int conf_read_simple(const char *name, int def)
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
@@ -441,6 +445,10 @@ int conf_read_simple(const char *name, int def)
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
@@ -475,7 +483,7 @@ int conf_read_simple(const char *name, int def)
 
 			sym = sym_find(line + strlen(CONFIG_));
 			if (!sym) {
-				if (def == S_DEF_AUTO)
+				if (def == S_DEF_AUTO) {
 					/*
 					 * Reading from include/config/auto.conf
 					 * If CONFIG_FOO previously existed in
@@ -483,8 +491,13 @@ int conf_read_simple(const char *name, int def)
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
 
@@ -523,6 +536,10 @@ int conf_read_simple(const char *name, int def)
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



