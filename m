Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 955A716CD33;
	Wed,  5 Feb 2025 14:40:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766433; cv=none; b=qeXhhl1GzN9p0dLqrDqsBAqglmMO0/d4p04dluUEkPTZ6JSD2dj2/s3AoqNII7dBaaOcdqY/hXpA6HQy5XyyNVUvxfv0Y7KI86JsrwkSDH7ubTbKpQAs2m2T5yjxLwkGYfuGN1qzEI6JA9aM9upUcq2Ec1KFH4j0aYbrJQb9ksQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766433; c=relaxed/simple;
	bh=NwBTKNBOr/NTCQq1IWqn2kX6u7jXIdInmdpJH1rm73Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SzX623wvr1vj2QTQ0Zb35DyOdX4JFyFXuXSCe0FDVc4eNT+kQzvO1wBq+EN4+Dc1m+CWTjsN1r4ddg1C79frqK0RQf0dHop4YTDvKcA+Xq2ncy68D1bDQlGhBXsOTuQ2XTUWdH6yM2wYySJqfJr5TqzTRmE7a91Mt1QSTz1gzqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NZM5SEbP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NZM5SEbP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 199ADC4CED1;
	Wed,  5 Feb 2025 14:40:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766433;
	bh=NwBTKNBOr/NTCQq1IWqn2kX6u7jXIdInmdpJH1rm73Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NZM5SEbPhX48jePQasF0k2yM7YQmmUqURSFf5ZL8CwRLdN2PQzy3icks+VkYbzapT
	 sL3i4TrwRf/VprhyeyDQU1pHoUNMRqdQO27X2IzAyxOILMT01vBpCs7Sd7sXKF0W+g
	 5LDF2nrF3MKxWHgSSJPTozm0CaO5thZWsXjhB6hM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 362/393] kconfig: deduplicate code in conf_read_simple()
Date: Wed,  5 Feb 2025 14:44:41 +0100
Message-ID: <20250205134434.151787267@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



