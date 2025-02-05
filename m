Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC45816F288;
	Wed,  5 Feb 2025 14:44:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766655; cv=none; b=X6N/xpDfiL7Imoah216mvhSaFgrliAOeZOTMAkP5z46oN7yBAOMJkXSM2w3d7tcF0+5wyZNbNR1ZCYzbPR26tACt3lUi/2x2kkkw0kjwiwilB9e1IgcZPPK9F/z2dONrg4kwvTfcX53ODoVYUZBiRdMoQ/x9g0sgmiMAEcpaGgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766655; c=relaxed/simple;
	bh=ioQMoR6T3DQkYg7r53c50jHZ6RLY7Ca2FZuq7yXKnhY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jCAeP2f7Lz+TAbrqY/jmEi3lkbnNk+pWL1mhqj3HphJzqEEcbq/T1U5hkKOi6Q4UBsLGqx2BYI70q4uJY8UGi3OmKruESzWl66BBU1UyBh49ADoiKMkDtqEkmGGcp+qEFOMrcJTgu5tVWJo1SrEX5p6JFLJmU4cCllJzEesQ1V8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wyaHgHfg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wyaHgHfg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 189ADC4CED1;
	Wed,  5 Feb 2025 14:44:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766655;
	bh=ioQMoR6T3DQkYg7r53c50jHZ6RLY7Ca2FZuq7yXKnhY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wyaHgHfgexIpa4pALTRuiEviNCWrBe5BgO8jyaR4/ywFhGlTG25Mob+QDNvbGD8mq
	 3OXOoLl5tifndeGcSaE2xw73xnVnYNSQs3IEfMCvENiUcHqMJ42mMPAgww0NSioFjj
	 ZAqZwBIUGYcVy0LK7NhuGFa5ra2QSD6boD9hFQn4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Reinauer <reinauer@google.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 363/393] kconfig: WERROR unmet symbol dependency
Date: Wed,  5 Feb 2025 14:44:42 +0100
Message-ID: <20250205134434.189946390@linuxfoundation.org>
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

From: Sergey Senozhatsky <senozhatsky@chromium.org>

[ Upstream commit 15d3f7664d2776c086f813f1efbfe2ae20a85e89 ]

When KCONFIG_WERROR env variable is set treat unmet direct
symbol dependency as a terminal condition (error).

Suggested-by: Stefan Reinauer <reinauer@google.com>
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Stable-dep-of: a409fc1463d6 ("kconfig: fix memory leak in sym_warn_unmet_dep()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/kconfig/conf.c      |  6 ++++++
 scripts/kconfig/confdata.c  | 13 ++++++++-----
 scripts/kconfig/lkc_proto.h |  2 ++
 scripts/kconfig/symbol.c    |  9 +++++++++
 4 files changed, 25 insertions(+), 5 deletions(-)

diff --git a/scripts/kconfig/conf.c b/scripts/kconfig/conf.c
index 33d19e419908b..662a5e7c37c28 100644
--- a/scripts/kconfig/conf.c
+++ b/scripts/kconfig/conf.c
@@ -827,6 +827,9 @@ int main(int ac, char **av)
 		break;
 	}
 
+	if (conf_errors())
+		exit(1);
+
 	if (sync_kconfig) {
 		name = getenv("KCONFIG_NOSILENTUPDATE");
 		if (name && *name) {
@@ -890,6 +893,9 @@ int main(int ac, char **av)
 		break;
 	}
 
+	if (sym_dep_errors())
+		exit(1);
+
 	if (input_mode == savedefconfig) {
 		if (conf_write_defconfig(defconfig_file)) {
 			fprintf(stderr, "n*** Error while saving defconfig to: %s\n\n",
diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
index 7e799060b6fe2..f214e8d3762e0 100644
--- a/scripts/kconfig/confdata.c
+++ b/scripts/kconfig/confdata.c
@@ -155,6 +155,13 @@ static void conf_message(const char *fmt, ...)
 static const char *conf_filename;
 static int conf_lineno, conf_warnings;
 
+bool conf_errors(void)
+{
+	if (conf_warnings)
+		return getenv("KCONFIG_WERROR");
+	return false;
+}
+
 static void conf_warning(const char *fmt, ...)
 {
 	va_list ap;
@@ -349,10 +356,9 @@ int conf_read_simple(const char *name, int def)
 	char *p, *p2, *val;
 	struct symbol *sym;
 	int i, def_flags;
-	const char *warn_unknown, *werror, *sym_name;
+	const char *warn_unknown, *sym_name;
 
 	warn_unknown = getenv("KCONFIG_WARN_UNKNOWN_SYMBOLS");
-	werror = getenv("KCONFIG_WERROR");
 	if (name) {
 		in = zconf_fopen(name);
 	} else {
@@ -513,9 +519,6 @@ int conf_read_simple(const char *name, int def)
 	free(line);
 	fclose(in);
 
-	if (conf_warnings && werror)
-		exit(1);
-
 	return 0;
 }
 
diff --git a/scripts/kconfig/lkc_proto.h b/scripts/kconfig/lkc_proto.h
index edd1e617b25c5..e4931bde7ca76 100644
--- a/scripts/kconfig/lkc_proto.h
+++ b/scripts/kconfig/lkc_proto.h
@@ -12,6 +12,7 @@ void conf_set_changed(bool val);
 bool conf_get_changed(void);
 void conf_set_changed_callback(void (*fn)(void));
 void conf_set_message_callback(void (*fn)(const char *s));
+bool conf_errors(void);
 
 /* symbol.c */
 extern struct symbol * symbol_hash[SYMBOL_HASHSIZE];
@@ -22,6 +23,7 @@ void print_symbol_for_listconfig(struct symbol *sym);
 struct symbol ** sym_re_search(const char *pattern);
 const char * sym_type_name(enum symbol_type type);
 void sym_calc_value(struct symbol *sym);
+bool sym_dep_errors(void);
 enum symbol_type sym_get_type(struct symbol *sym);
 bool sym_tristate_within_range(struct symbol *sym,tristate tri);
 bool sym_set_tristate_value(struct symbol *sym,tristate tri);
diff --git a/scripts/kconfig/symbol.c b/scripts/kconfig/symbol.c
index 7b1df55b01767..758c42621f7a1 100644
--- a/scripts/kconfig/symbol.c
+++ b/scripts/kconfig/symbol.c
@@ -40,6 +40,7 @@ static struct symbol symbol_empty = {
 
 struct symbol *modules_sym;
 static tristate modules_val;
+static int sym_warnings;
 
 enum symbol_type sym_get_type(struct symbol *sym)
 {
@@ -320,6 +321,14 @@ static void sym_warn_unmet_dep(struct symbol *sym)
 			       "  Selected by [m]:\n");
 
 	fputs(str_get(&gs), stderr);
+	sym_warnings++;
+}
+
+bool sym_dep_errors(void)
+{
+	if (sym_warnings)
+		return getenv("KCONFIG_WERROR");
+	return false;
 }
 
 void sym_calc_value(struct symbol *sym)
-- 
2.39.5



