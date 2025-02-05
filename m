Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B9148634E;
	Wed,  5 Feb 2025 14:38:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766291; cv=none; b=tbCZf+Im0W052exu5+v/9eOku26QIss5c3/AzbaShXXEBnYsiA1oW8LvPlruaUw/RxOrCKGOJfNG1rwdADe8xVHxTtYXbu54MFQE1KnvfN121uPhVhuHwRN4HGE8KXbrQZdsUwCVyIpjhEc+Xi8TsEi+uM7G3Fx0/VJn9Kfg5DQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766291; c=relaxed/simple;
	bh=G6Tujn7slVEgYQB5qENPJegSr/LXc5hOwl75T5j5bCs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O6p7bYPtrMpb3DfifY9zmf+ORHJBpSAMjSiozyJNAXl0QZptlRmonyMpBB6GWWDGD3ZPa4ilPmPWRtFypuagARkWZZ07rovYgeCUrtBkFQ4R0eyRA/3Cyr/LX4YPc+17T9FhK8G9yezEej79AdBxUK8uKrFthPsCXDG7TauJbek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cb8gMj5A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cb8gMj5A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CF4CC4CED1;
	Wed,  5 Feb 2025 14:38:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766289;
	bh=G6Tujn7slVEgYQB5qENPJegSr/LXc5hOwl75T5j5bCs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cb8gMj5AifW5gmIHV6m+IDSsLSh9ybfpsSr0u7o7IUEzpqJJUyqijl62j1+u0AZg9
	 GaFFuXLqIQuYKOkcgVTto1iqNvBhJoBNnBv9GGGKRQd8C+VB8nK3D1e3ueyU2LhAMX
	 kW/t9ZKuoEcAi/0Hl43bw/+eOKO96l3A5cEcIsMs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 349/393] genksyms: fix memory leak when the same symbol is read from *.symref file
Date: Wed,  5 Feb 2025 14:44:28 +0100
Message-ID: <20250205134433.659825608@linuxfoundation.org>
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
index 6ddc8f406c75f..6b0eb3898e4ec 100644
--- a/scripts/genksyms/genksyms.c
+++ b/scripts/genksyms/genksyms.c
@@ -274,11 +274,15 @@ static struct symbol *__add_symbol(const char *name, enum symbol_type type,
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
@@ -485,7 +489,7 @@ static void read_reference(FILE *f)
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



