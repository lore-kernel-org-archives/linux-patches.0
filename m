Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D74E27D766;
	Tue, 27 May 2025 16:53:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748364836; cv=none; b=n4MJVB5azZLH3oEjq6ExJTmpsBOE7sPNwCVAzYuPizULnfiDUE0aflIRfPUHzn+H9hCE+ir0c1kqPawW0kAcVXE+gjbleEpf1RCAtcEu/YxttdjSRcjRkVaAd5/YqraM8dMkPgSzQpAI6NyGzCapi1X3IJiXJjgo+eoTNtAIUck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748364836; c=relaxed/simple;
	bh=QjS6iHdN/toan1wIJWA+WMo8xb/mOids/EOOzB+ldJI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q3cKjImn5XbkgzzCQVscfoaXmuqZniw2ZKKeKXbhYxKPQeEywGOjqsFDiHohtXAhv3xSkynEUx5hRTVu/VVMNDQIi+96yXAHPrzrM5ZWhtgG1hBBqvELnXKgS7sBGhfb5fGHAaoWGekzALYGsHybV1xqcWlpLfb1hT5LBzozz54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CmVFYmP1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CmVFYmP1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94881C4CEE9;
	Tue, 27 May 2025 16:53:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748364836;
	bh=QjS6iHdN/toan1wIJWA+WMo8xb/mOids/EOOzB+ldJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CmVFYmP1BLBoPfGpllTRZzhiiddDdq7wtuWmTlB9on2vEl7gESZoajwzyqPaUAdWK
	 16fYSmm49Re0NnHOjr/C5NYnJfqxV5r12vdbMVNNr0BEY/K3+g8aYdy22+dfRvoK/m
	 z8xgo+bepvaMAJQujQM0DLK7MBk1kzSiWVy8hcAE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 151/626] kconfig: do not clear SYMBOL_VALID when reading include/config/auto.conf
Date: Tue, 27 May 2025 18:20:44 +0200
Message-ID: <20250527162451.162196639@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit 226ac19c217f24f0927d0a73cf9ee613971a188d ]

When conf_read_simple() is called with S_DEF_AUTO, it is meant to read
previous symbol values from include/config/auto.conf to determine which
include/config/* files should be touched.

This process should not modify the current symbol status in any way.
However, conf_touch_deps() currently invalidates all symbol values and
recalculates them, which is totally unneeded.

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/kconfig/confdata.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
index 3b55e7a4131d9..ac95661a1c9dd 100644
--- a/scripts/kconfig/confdata.c
+++ b/scripts/kconfig/confdata.c
@@ -385,7 +385,7 @@ int conf_read_simple(const char *name, int def)
 
 	def_flags = SYMBOL_DEF << def;
 	for_all_symbols(sym) {
-		sym->flags &= ~(def_flags|SYMBOL_VALID);
+		sym->flags &= ~def_flags;
 		switch (sym->type) {
 		case S_INT:
 		case S_HEX:
@@ -398,7 +398,11 @@ int conf_read_simple(const char *name, int def)
 		}
 	}
 
-	expr_invalidate_all();
+	if (def == S_DEF_USER) {
+		for_all_symbols(sym)
+			sym->flags &= ~SYMBOL_VALID;
+		expr_invalidate_all();
+	}
 
 	while (getline_stripped(&line, &line_asize, in) != -1) {
 		struct menu *choice;
@@ -464,6 +468,9 @@ int conf_read_simple(const char *name, int def)
 		if (conf_set_sym_val(sym, def, def_flags, val))
 			continue;
 
+		if (def != S_DEF_USER)
+			continue;
+
 		/*
 		 * If this is a choice member, give it the highest priority.
 		 * If conflicting CONFIG options are given from an input file,
@@ -967,10 +974,8 @@ static int conf_touch_deps(void)
 	depfile_path[depfile_prefix_len] = 0;
 
 	conf_read_simple(name, S_DEF_AUTO);
-	sym_calc_value(modules_sym);
 
 	for_all_symbols(sym) {
-		sym_calc_value(sym);
 		if (sym_is_choice(sym))
 			continue;
 		if (sym->flags & SYMBOL_WRITE) {
@@ -1084,12 +1089,12 @@ int conf_write_autoconf(int overwrite)
 	if (ret)
 		return -1;
 
-	if (conf_touch_deps())
-		return 1;
-
 	for_all_symbols(sym)
 		sym_calc_value(sym);
 
+	if (conf_touch_deps())
+		return 1;
+
 	ret = __conf_write_autoconf(conf_get_autoheader_name(),
 				    print_symbol_for_c,
 				    &comment_style_c);
-- 
2.39.5



