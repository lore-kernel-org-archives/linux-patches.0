Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 521C12FA658;
	Tue, 17 Jun 2025 16:52:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750179130; cv=none; b=rQGhRe77LKaZ+RzkzFu3DvRtpCOyKKQo7tpEEP1QHbuVWdTC7uufLZRC7VloE1+Fr/sxFG+WI6PRUYrF2cC2w0SRSOuZ2ZIexqQFf6G1c1naR6UnMtbbWgFvZSlz91T3H/GArHPP4FQAyuIcX+Rl1cIcRzbDacEBqOUDJGj9KlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750179130; c=relaxed/simple;
	bh=U5vbkOBhhdDYE0bW/k16lw0xm7qKW/9jB0J3J/KYeBo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tu4T3knvElFe7SAHrU6H7+0KWiG3rSTyk7qbZ+zOyZSPE/3HPwZE/0ClSe/qr9zP3Qctmc0vTM3EV70ClMpznKFrndesMvaxKak0jD+HdvGf7lfhS4ZCWFaot6zjuSBOs/uhngr/AKukKEKF3y4XB9lakUdNPU2C8NeBXN29uXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AjMWB4NE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AjMWB4NE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3D13C4CEE3;
	Tue, 17 Jun 2025 16:52:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750179130;
	bh=U5vbkOBhhdDYE0bW/k16lw0xm7qKW/9jB0J3J/KYeBo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AjMWB4NEfNJFoW2LwpTdrf+BOux38UheDs4WSvYAx2kvYbqA0ohxIAUjH7KQYQT1o
	 x5W9SRp3MX3/Y2bu8QJ0tCQvGOmFF0WWahcZlWovDgapW+NFmUiIidos2J3PUxvWxr
	 nbY0Lz92BU4YB3gX7uv5dJRTpUCLQq2OtTMQFZwE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Pavlu <petr.pavlu@suse.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 657/780] genksyms: Fix enum consts from a reference affecting new values
Date: Tue, 17 Jun 2025 17:26:05 +0200
Message-ID: <20250617152518.223994989@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

From: Petr Pavlu <petr.pavlu@suse.com>

[ Upstream commit c50a04f8f45c7f13972f9097622d1d929033ea8c ]

Enumeration constants read from a symbol reference file can incorrectly
affect new enumeration constants parsed from an actual input file.

Example:

 $ cat test.c
 enum { E_A, E_B, E_MAX };
 struct bar { int mem[E_MAX]; };
 int foo(struct bar *a) {}
 __GENKSYMS_EXPORT_SYMBOL(foo);

 $ cat test.c | ./scripts/genksyms/genksyms -T test.0.symtypes
 #SYMVER foo 0x070d854d

 $ cat test.0.symtypes
 E#E_MAX 2
 s#bar struct bar { int mem [ E#E_MAX ] ; }
 foo int foo ( s#bar * )

 $ cat test.c | ./scripts/genksyms/genksyms -T test.1.symtypes -r test.0.symtypes
 <stdin>:4: warning: foo: modversion changed because of changes in enum constant E_MAX
 #SYMVER foo 0x9c9dfd81

 $ cat test.1.symtypes
 E#E_MAX ( 2 ) + 3
 s#bar struct bar { int mem [ E#E_MAX ] ; }
 foo int foo ( s#bar * )

The __add_symbol() function includes logic to handle the incrementation of
enumeration values, but this code is also invoked when reading a reference
file. As a result, the variables last_enum_expr and enum_counter might be
incorrectly set after reading the reference file, which later affects
parsing of the actual input.

Fix the problem by splitting the logic for the incrementation of
enumeration values into a separate function process_enum() and call it from
__add_symbol() only when processing non-reference data.

Fixes: e37ddb825003 ("genksyms: Track changes to enum constants")
Signed-off-by: Petr Pavlu <petr.pavlu@suse.com>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/genksyms/genksyms.c | 27 ++++++++++++++++++++-------
 1 file changed, 20 insertions(+), 7 deletions(-)

diff --git a/scripts/genksyms/genksyms.c b/scripts/genksyms/genksyms.c
index 8b0d7ac73dbb0..83e48670c2fcf 100644
--- a/scripts/genksyms/genksyms.c
+++ b/scripts/genksyms/genksyms.c
@@ -181,13 +181,9 @@ static int is_unknown_symbol(struct symbol *sym)
 			strcmp(defn->string, "{") == 0);
 }
 
-static struct symbol *__add_symbol(const char *name, enum symbol_type type,
-			    struct string_list *defn, int is_extern,
-			    int is_reference)
+static struct string_list *process_enum(const char *name, enum symbol_type type,
+					struct string_list *defn)
 {
-	unsigned long h;
-	struct symbol *sym;
-	enum symbol_status status = STATUS_UNCHANGED;
 	/* The parser adds symbols in the order their declaration completes,
 	 * so it is safe to store the value of the previous enum constant in
 	 * a static variable.
@@ -216,7 +212,7 @@ static struct symbol *__add_symbol(const char *name, enum symbol_type type,
 				defn = mk_node(buf);
 			}
 		}
-	} else if (type == SYM_ENUM) {
+	} else {
 		free_list(last_enum_expr, NULL);
 		last_enum_expr = NULL;
 		enum_counter = 0;
@@ -225,6 +221,23 @@ static struct symbol *__add_symbol(const char *name, enum symbol_type type,
 			return NULL;
 	}
 
+	return defn;
+}
+
+static struct symbol *__add_symbol(const char *name, enum symbol_type type,
+			    struct string_list *defn, int is_extern,
+			    int is_reference)
+{
+	unsigned long h;
+	struct symbol *sym;
+	enum symbol_status status = STATUS_UNCHANGED;
+
+	if ((type == SYM_ENUM_CONST || type == SYM_ENUM) && !is_reference) {
+		defn = process_enum(name, type, defn);
+		if (defn == NULL)
+			return NULL;
+	}
+
 	h = crc32(name);
 	hash_for_each_possible(symbol_hashtable, sym, hnode, h) {
 		if (map_to_ns(sym->type) != map_to_ns(type) ||
-- 
2.39.5



