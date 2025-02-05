Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C9221607B7;
	Wed,  5 Feb 2025 15:15:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738768532; cv=none; b=s+i+pRdWVb4yqb+0ioZicjBjEyyY3TV+z5rZTW1c/4AoQ3kBuBWSzZrpTFwgGJTdQI3O3QZt7askMFCuRhxu3t/ra9ZTZRnLChXybPIeRhTh9Kooke+oqpQ6FSNeaC4snd9ERk+OSNl1KyrjSdqUyWzd1MLs4QHtTFE2Zt47MI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738768532; c=relaxed/simple;
	bh=Z51OKPMxOzqenoLx4/iq4Z56uab8jsnfUyNFsUXG9hk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u9f+IAroso+4VML1/POgD3+Myv04zjfUdMT9f60AstJ8TcWDygMrScSw0ChkAKzmumOSnnBKUIwI+YzRDL2YahRxTNSALcdecgQ+CoXTAJu/uNLp3V1KDSBp9KSbscQAC6vpSq+rGa6HvfeJbLdxQJtXRAXR5BaHRr70gn0IZpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mI1DxOfa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mI1DxOfa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95087C4CEDD;
	Wed,  5 Feb 2025 15:15:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738768532;
	bh=Z51OKPMxOzqenoLx4/iq4Z56uab8jsnfUyNFsUXG9hk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mI1DxOfaBqGdyM4WrGUshJn1+V1M6Ln746Lzhn3LvAniyk8zJmT3bLcC8qmyqA94j
	 OBg7rbfLQK3f4T7Gb5vvR+EpHMLr7nQirE1i2Y5WdSuCA4KuB+os2ea10aMTxdafUP
	 1+mckLGdKBFqgsaMvkssI/YhjW/W13kzD3cGERyQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 553/623] genksyms: fix memory leak when the same symbol is read from *.symref file
Date: Wed,  5 Feb 2025 14:44:55 +0100
Message-ID: <20250205134517.374956465@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index 8ca46f807b57a..c5e8e0e0f9490 100644
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



