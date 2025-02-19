Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA8FA1E0E0F;
	Wed, 19 Feb 2025 09:16:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956612; cv=none; b=NEuFH4OqQ48DLFe2u5IC9oC2WKDUC9uM8XcS+Jl5tcteR4rx8+WG6m60aNClaDofhtW5v9ph6WrDg37RnJhkGvOEHGlpYfndKauDzKYOWSaYi3bEDI51Te1WN6eMLJSnAJY35wWhp4zdOzqoPbAnLDSmXD06+B+08mlnx33BLQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956612; c=relaxed/simple;
	bh=5EdXvWXfE860uqYukgjB8f2PWsh3PgEo8VlAZCqU7s4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sBCL3vF94kOxHcZ9gXdvUTvHFH52d104hkIt8ool8feMaLOXjVYiIkl58rCUzJEv14xUDcVS3U4SSD/ZOz1bDXBs5Oc5/3HJcvczSnd6HnCzHO2s4R3q2mzlLXUUc3TbTsimE3be3b5aAfWHY4ADb/p59CNPLknDo/KMcR0EQEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mVtvmerA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mVtvmerA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11294C4CED1;
	Wed, 19 Feb 2025 09:16:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956611;
	bh=5EdXvWXfE860uqYukgjB8f2PWsh3PgEo8VlAZCqU7s4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mVtvmerAIEzllJZL4QE6rSzkJVZjt8xpILr9bWr3vg47m6Z2B0A+vs4zEf2m7Nfv5
	 83ffjxgENMfIDJNlPeIbe8x+WqLBmz8HV0Vf657MKERAlc1v4DsC6wsbhXds9G8igR
	 fm4zkB3sZuKHzlcawaWU1/nX0ungzpnDwklpc8vk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 238/578] kconfig: deduplicate code in conf_read_simple()
Date: Wed, 19 Feb 2025 09:24:02 +0100
Message-ID: <20250219082702.403146607@linuxfoundation.org>
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

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit d854b4b21de684a16a7d6163c7b0e9c5ff8a09d3 ]

Kconfig accepts both "# CONFIG_FOO is not set" and "CONFIG_FOO=n" as
a valid input, but conf_read_simple() duplicates similar code to handle
them. Factor out the common code.

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Stable-dep-of: a409fc1463d6 ("kconfig: fix memory leak in sym_warn_unmet_dep()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/kconfig/confdata.c | 89 +++++++++++++++-----------------------
 1 file changed, 35 insertions(+), 54 deletions(-)

diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
index 21a65ffe7c3db..7e799060b6fe2 100644
--- a/scripts/kconfig/confdata.c
+++ b/scripts/kconfig/confdata.c
@@ -346,11 +346,10 @@ int conf_read_simple(const char *name, int def)
 	FILE *in = NULL;
 	char   *line = NULL;
 	size_t  line_asize = 0;
-	char *p, *p2;
+	char *p, *p2, *val;
 	struct symbol *sym;
 	int i, def_flags;
-	const char *warn_unknown;
-	const char *werror;
+	const char *warn_unknown, *werror, *sym_name;
 
 	warn_unknown = getenv("KCONFIG_WARN_UNKNOWN_SYMBOLS");
 	werror = getenv("KCONFIG_WERROR");
@@ -430,77 +429,34 @@ int conf_read_simple(const char *name, int def)
 
 	while (compat_getline(&line, &line_asize, in) != -1) {
 		conf_lineno++;
-		sym = NULL;
 		if (line[0] == '#') {
 			if (line[1] != ' ')
 				continue;
-			if (memcmp(line + 2, CONFIG_, strlen(CONFIG_)))
+			p = line + 2;
+			if (memcmp(p, CONFIG_, strlen(CONFIG_)))
 				continue;
-			p = strchr(line + 2 + strlen(CONFIG_), ' ');
+			sym_name = p + strlen(CONFIG_);
+			p = strchr(sym_name, ' ');
 			if (!p)
 				continue;
 			*p++ = 0;
 			if (strncmp(p, "is not set", 10))
 				continue;
 
-			sym = sym_find(line + 2 + strlen(CONFIG_));
-			if (!sym) {
-				if (warn_unknown)
-					conf_warning("unknown symbol: %s",
-						     line + 2 + strlen(CONFIG_));
-
-				conf_set_changed(true);
-				continue;
-			}
-			if (sym->flags & def_flags) {
-				conf_warning("override: reassigning to symbol %s", sym->name);
-			}
-			switch (sym->type) {
-			case S_BOOLEAN:
-			case S_TRISTATE:
-				sym->def[def].tri = no;
-				sym->flags |= def_flags;
-				break;
-			default:
-				;
-			}
+			val = "n";
 		} else if (memcmp(line, CONFIG_, strlen(CONFIG_)) == 0) {
-			p = strchr(line + strlen(CONFIG_), '=');
+			sym_name = line + strlen(CONFIG_);
+			p = strchr(sym_name, '=');
 			if (!p)
 				continue;
 			*p++ = 0;
+			val = p;
 			p2 = strchr(p, '\n');
 			if (p2) {
 				*p2-- = 0;
 				if (*p2 == '\r')
 					*p2 = 0;
 			}
-
-			sym = sym_find(line + strlen(CONFIG_));
-			if (!sym) {
-				if (def == S_DEF_AUTO) {
-					/*
-					 * Reading from include/config/auto.conf
-					 * If CONFIG_FOO previously existed in
-					 * auto.conf but it is missing now,
-					 * include/config/FOO must be touched.
-					 */
-					conf_touch_dep(line + strlen(CONFIG_));
-				} else {
-					if (warn_unknown)
-						conf_warning("unknown symbol: %s",
-							     line + strlen(CONFIG_));
-
-					conf_set_changed(true);
-				}
-				continue;
-			}
-
-			if (sym->flags & def_flags) {
-				conf_warning("override: reassigning to symbol %s", sym->name);
-			}
-			if (conf_set_sym_val(sym, def, def_flags, p))
-				continue;
 		} else {
 			if (line[0] != '\r' && line[0] != '\n')
 				conf_warning("unexpected data: %.*s",
@@ -509,6 +465,31 @@ int conf_read_simple(const char *name, int def)
 			continue;
 		}
 
+		sym = sym_find(sym_name);
+		if (!sym) {
+			if (def == S_DEF_AUTO) {
+				/*
+				 * Reading from include/config/auto.conf.
+				 * If CONFIG_FOO previously existed in auto.conf
+				 * but it is missing now, include/config/FOO
+				 * must be touched.
+				 */
+				conf_touch_dep(sym_name);
+			} else {
+				if (warn_unknown)
+					conf_warning("unknown symbol: %s", sym_name);
+
+				conf_set_changed(true);
+			}
+			continue;
+		}
+
+		if (sym->flags & def_flags)
+			conf_warning("override: reassigning to symbol %s", sym->name);
+
+		if (conf_set_sym_val(sym, def, def_flags, val))
+			continue;
+
 		if (sym && sym_is_choice_value(sym)) {
 			struct symbol *cs = prop_get_symbol(sym_get_choice_prop(sym));
 			switch (sym->def[def].tri) {
-- 
2.39.5



