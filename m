Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10FD12EA161;
	Tue, 17 Jun 2025 16:36:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178168; cv=none; b=dwPr1SIStsLGRXACk6NvmxJJ9YXi0zDsd7wKzsyzwyoBEdamOZYv3TPqollhOF3SY9JNjlP+LIxEA/W9oYHYCzqy72vEb5qcZrvsZQuPSDBtGY3Fqts9AM5eBzcB7N1Z1mSw7gn10AurJODsJUDnVJv3bAWa5rPbgaI2LfUFNLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178168; c=relaxed/simple;
	bh=giHPThbUwfr7P6W4QJqRyqU9jL9k+D8HPm13HEXtYHs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KXKt9YUDGiBps6ikH/d4He/xbE34WlYSBKrd/WHwDtlCZYgSfYIIyKYMtzLMcPm53nAnbTZyoDl5hRAcE3YwL/k3Nzk+cNqEFKGED4XNA1/zVafp98gah4/JOuT4GQSb87s0yHWoiDxlLOZtzH35T/azsitJ8+M5+1WPaFFWjcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u1ykcV0p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u1ykcV0p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A685C4CEE3;
	Tue, 17 Jun 2025 16:36:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178167;
	bh=giHPThbUwfr7P6W4QJqRyqU9jL9k+D8HPm13HEXtYHs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u1ykcV0p9EgYQd6B/m4ajWG8Ob1IjbVz47t3n8Vx6r/+bsJ9mY9BxdQGomJk2+YjS
	 4qXhL/9aZHfHhf1qWFj79JYpLuDgiyZJ37Ip9yLWAGpWpdqhF2h6GZXoizGkhaAqjw
	 E5MMVzEK591Ro4JWXgmEDoRleiQZngRbjekKlnfI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thiago Jung Bauermann <thiago.bauermann@linaro.org>,
	Ingo Saitz <ingo@hannover.ccc.de>,
	Kees Cook <kees@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 419/780] randstruct: gcc-plugin: Fix attribute addition
Date: Tue, 17 Jun 2025 17:22:07 +0200
Message-ID: <20250617152508.535318127@linuxfoundation.org>
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

From: Kees Cook <kees@kernel.org>

[ Upstream commit f39f18f3c3531aa802b58a20d39d96e82eb96c14 ]

Based on changes in the 2021 public version of the randstruct
out-of-tree GCC plugin[1], more carefully update the attributes on
resulting decls, to avoid tripping checks in GCC 15's
comptypes_check_enum_int() when it has been configured with
"--enable-checking=misc":

arch/arm64/kernel/kexec_image.c:132:14: internal compiler error: in comptypes_check_enum_int, at c/c-typeck.cc:1519
  132 | const struct kexec_file_ops kexec_image_ops = {
      |              ^~~~~~~~~~~~~~
 internal_error(char const*, ...), at gcc/gcc/diagnostic-global-context.cc:517
 fancy_abort(char const*, int, char const*), at gcc/gcc/diagnostic.cc:1803
 comptypes_check_enum_int(tree_node*, tree_node*, bool*), at gcc/gcc/c/c-typeck.cc:1519
 ...

Link: https://archive.org/download/grsecurity/grsecurity-3.1-5.10.41-202105280954.patch.gz [1]
Reported-by: Thiago Jung Bauermann <thiago.bauermann@linaro.org>
Closes: https://github.com/KSPP/linux/issues/367
Closes: https://lore.kernel.org/lkml/20250530000646.104457-1-thiago.bauermann@linaro.org/
Reported-by: Ingo Saitz <ingo@hannover.ccc.de>
Closes: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1104745
Fixes: 313dd1b62921 ("gcc-plugins: Add the randstruct plugin")
Tested-by: Thiago Jung Bauermann <thiago.bauermann@linaro.org>
Link: https://lore.kernel.org/r/20250530221824.work.623-kees@kernel.org
Signed-off-by: Kees Cook <kees@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/gcc-plugins/gcc-common.h              | 32 +++++++++++++++++++
 scripts/gcc-plugins/randomize_layout_plugin.c | 22 ++++++-------
 2 files changed, 43 insertions(+), 11 deletions(-)

diff --git a/scripts/gcc-plugins/gcc-common.h b/scripts/gcc-plugins/gcc-common.h
index 3222c1070444f..ef12c8f929eda 100644
--- a/scripts/gcc-plugins/gcc-common.h
+++ b/scripts/gcc-plugins/gcc-common.h
@@ -123,6 +123,38 @@ static inline tree build_const_char_string(int len, const char *str)
 	return cstr;
 }
 
+static inline void __add_type_attr(tree type, const char *attr, tree args)
+{
+	tree oldattr;
+
+	if (type == NULL_TREE)
+		return;
+	oldattr = lookup_attribute(attr, TYPE_ATTRIBUTES(type));
+	if (oldattr != NULL_TREE) {
+		gcc_assert(TREE_VALUE(oldattr) == args || TREE_VALUE(TREE_VALUE(oldattr)) == TREE_VALUE(args));
+		return;
+	}
+
+	TYPE_ATTRIBUTES(type) = copy_list(TYPE_ATTRIBUTES(type));
+	TYPE_ATTRIBUTES(type) = tree_cons(get_identifier(attr), args, TYPE_ATTRIBUTES(type));
+}
+
+static inline void add_type_attr(tree type, const char *attr, tree args)
+{
+	tree main_variant = TYPE_MAIN_VARIANT(type);
+
+	__add_type_attr(TYPE_CANONICAL(type), attr, args);
+	__add_type_attr(TYPE_CANONICAL(main_variant), attr, args);
+	__add_type_attr(main_variant, attr, args);
+
+	for (type = TYPE_NEXT_VARIANT(main_variant); type; type = TYPE_NEXT_VARIANT(type)) {
+		if (!lookup_attribute(attr, TYPE_ATTRIBUTES(type)))
+			TYPE_ATTRIBUTES(type) = TYPE_ATTRIBUTES(main_variant);
+
+		__add_type_attr(TYPE_CANONICAL(type), attr, args);
+	}
+}
+
 #define PASS_INFO(NAME, REF, ID, POS)		\
 struct register_pass_info NAME##_pass_info = {	\
 	.pass = make_##NAME##_pass(),		\
diff --git a/scripts/gcc-plugins/randomize_layout_plugin.c b/scripts/gcc-plugins/randomize_layout_plugin.c
index 971a1908a8cc4..ff65a4f87f240 100644
--- a/scripts/gcc-plugins/randomize_layout_plugin.c
+++ b/scripts/gcc-plugins/randomize_layout_plugin.c
@@ -73,6 +73,9 @@ static tree handle_randomize_layout_attr(tree *node, tree name, tree args, int f
 
 	if (TYPE_P(*node)) {
 		type = *node;
+	} else if (TREE_CODE(*node) == FIELD_DECL) {
+		*no_add_attrs = false;
+		return NULL_TREE;
 	} else {
 		gcc_assert(TREE_CODE(*node) == TYPE_DECL);
 		type = TREE_TYPE(*node);
@@ -348,15 +351,14 @@ static int relayout_struct(tree type)
 		TREE_CHAIN(newtree[i]) = newtree[i+1];
 	TREE_CHAIN(newtree[num_fields - 1]) = NULL_TREE;
 
+	add_type_attr(type, "randomize_performed", NULL_TREE);
+	add_type_attr(type, "designated_init", NULL_TREE);
+	if (has_flexarray)
+		add_type_attr(type, "has_flexarray", NULL_TREE);
+
 	main_variant = TYPE_MAIN_VARIANT(type);
-	for (variant = main_variant; variant; variant = TYPE_NEXT_VARIANT(variant)) {
+	for (variant = main_variant; variant; variant = TYPE_NEXT_VARIANT(variant))
 		TYPE_FIELDS(variant) = newtree[0];
-		TYPE_ATTRIBUTES(variant) = copy_list(TYPE_ATTRIBUTES(variant));
-		TYPE_ATTRIBUTES(variant) = tree_cons(get_identifier("randomize_performed"), NULL_TREE, TYPE_ATTRIBUTES(variant));
-		TYPE_ATTRIBUTES(variant) = tree_cons(get_identifier("designated_init"), NULL_TREE, TYPE_ATTRIBUTES(variant));
-		if (has_flexarray)
-			TYPE_ATTRIBUTES(type) = tree_cons(get_identifier("has_flexarray"), NULL_TREE, TYPE_ATTRIBUTES(type));
-	}
 
 	/*
 	 * force a re-layout of the main variant
@@ -424,10 +426,8 @@ static void randomize_type(tree type)
 	if (lookup_attribute("randomize_layout", TYPE_ATTRIBUTES(TYPE_MAIN_VARIANT(type))) || is_pure_ops_struct(type))
 		relayout_struct(type);
 
-	for (variant = TYPE_MAIN_VARIANT(type); variant; variant = TYPE_NEXT_VARIANT(variant)) {
-		TYPE_ATTRIBUTES(type) = copy_list(TYPE_ATTRIBUTES(type));
-		TYPE_ATTRIBUTES(type) = tree_cons(get_identifier("randomize_considered"), NULL_TREE, TYPE_ATTRIBUTES(type));
-	}
+	add_type_attr(type, "randomize_considered", NULL_TREE);
+
 #ifdef __DEBUG_PLUGIN
 	fprintf(stderr, "Marking randomize_considered on struct %s\n", ORIG_TYPE_NAME(type));
 #ifdef __DEBUG_VERBOSE
-- 
2.39.5



