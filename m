Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7567F1C6BE;
	Wed,  5 Feb 2025 15:04:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767877; cv=none; b=qdfV3H38b+aDcaTaTv1F9eDwIkdGTl1rmQJlqnks9oVJhryTnKVSuYgwKdksqhzSq3XUuV1ZxXzyachqKFw3cFYr6nbJ3jgfPHVRkwiL/WOyt9gCE1NN2DrUL81VzDwI6015/4WOpONjd3K1LZlJTnMaPIQipppvTMqTlbCzaqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767877; c=relaxed/simple;
	bh=9HTPRf3ODFdAHaC0KI1DStTtG1KHqwgfls3nATEiuSo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qu60TR7/xiAO3pGTskPns8I/RDlwmSa0Wsz5AZ/Xa8OzOyRk2S/tftLe/YYUsFAB7cRmUGsv8XsGMbMSBN3/LQ8+/cA56oIlfymkM4hYixEfFk/LcwWwDRo3Ekc2XLr+b6oQpjDAqoBB0gNuwn9guOwliVe2TgeRLrCAziHek0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uyeYR9kA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uyeYR9kA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFC5AC4CED1;
	Wed,  5 Feb 2025 15:04:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767877;
	bh=9HTPRf3ODFdAHaC0KI1DStTtG1KHqwgfls3nATEiuSo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uyeYR9kAYGe1gfAHYvsujn4O6h2PHpVn5hyuovgYrAuu6OYbPOtloYJ54vlGk1pTm
	 gzxdH5lRHGHkxxwWsfQjCi5AbgzeHI3jCbUw7zNZJ+wKLayEOMXmMggt8fZ93npJmM
	 GaI3gxDYSVVCjijAUxxkCXKuXagAty2+saM2XuuA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 521/590] genksyms: fix memory leak when the same symbol is read from *.symref file
Date: Wed,  5 Feb 2025 14:44:36 +0100
Message-ID: <20250205134515.196239172@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

[ Upstream commit be2fa44b5180a1f021efb40c55fdf63c249c3209 ]

When a symbol that is already registered is read again from *.symref
file, __add_symbol() removes the previous one from the hash table without
freeing it.

[Test Case]

  $ cat foo.c
  #include <linux/export.h>
  void foo(void);
  void foo(void) {}
  EXPORT_SYMBOL(foo);

  $ cat foo.symref
  foo void foo ( void )
  foo void foo ( void )

When a symbol is removed from the hash table, it must be freed along
with its ->name and ->defn members. However, sym->name cannot be freed
because it is sometimes shared with node->string, but not always. If
sym->name and node->string share the same memory, free(sym->name) could
lead to a double-free bug.

To resolve this issue, always assign a strdup'ed string to sym->name.

Fixes: 64e6c1e12372 ("genksyms: track symbol checksum changes")
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/genksyms/genksyms.c | 8 ++++++--
 scripts/genksyms/genksyms.h | 2 +-
 scripts/genksyms/parse.y    | 4 ++--
 3 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/scripts/genksyms/genksyms.c b/scripts/genksyms/genksyms.c
index 0077c96e526f0..bbc6b7d3088c1 100644
--- a/scripts/genksyms/genksyms.c
+++ b/scripts/genksyms/genksyms.c
@@ -272,11 +272,15 @@ static struct symbol *__add_symbol(const char *name, enum symbol_type type,
 				break;
 			}
 		}
+
+		free_list(sym->defn, NULL);
+		free(sym->name);
+		free(sym);
 		--nsyms;
 	}
 
 	sym = xmalloc(sizeof(*sym));
-	sym->name = name;
+	sym->name = xstrdup(name);
 	sym->type = type;
 	sym->defn = defn;
 	sym->expansion_trail = NULL;
@@ -483,7 +487,7 @@ static void read_reference(FILE *f)
 			defn = def;
 			def = read_node(f);
 		}
-		subsym = add_reference_symbol(xstrdup(sym->string), sym->tag,
+		subsym = add_reference_symbol(sym->string, sym->tag,
 					      defn, is_extern);
 		subsym->is_override = is_override;
 		free_node(sym);
diff --git a/scripts/genksyms/genksyms.h b/scripts/genksyms/genksyms.h
index 21ed2ec2d98ca..5621533dcb8e4 100644
--- a/scripts/genksyms/genksyms.h
+++ b/scripts/genksyms/genksyms.h
@@ -32,7 +32,7 @@ struct string_list {
 
 struct symbol {
 	struct symbol *hash_next;
-	const char *name;
+	char *name;
 	enum symbol_type type;
 	struct string_list *defn;
 	struct symbol *expansion_trail;
diff --git a/scripts/genksyms/parse.y b/scripts/genksyms/parse.y
index 840371d01bf48..689cb6bb40b65 100644
--- a/scripts/genksyms/parse.y
+++ b/scripts/genksyms/parse.y
@@ -482,12 +482,12 @@ enumerator_list:
 enumerator:
 	IDENT
 		{
-			const char *name = strdup((*$1)->string);
+			const char *name = (*$1)->string;
 			add_symbol(name, SYM_ENUM_CONST, NULL, 0);
 		}
 	| IDENT '=' EXPRESSION_PHRASE
 		{
-			const char *name = strdup((*$1)->string);
+			const char *name = (*$1)->string;
 			struct string_list *expr = copy_list_range(*$3, *$2);
 			add_symbol(name, SYM_ENUM_CONST, expr, 0);
 		}
-- 
2.39.5



