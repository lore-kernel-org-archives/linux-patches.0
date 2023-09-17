Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A08CF6FCC
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 19:53:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E100C433C7;
	Sun, 17 Sep 2023 19:53:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694980381;
	bh=P7KSkxiJEieAuKXF7YOnaZf+BLfzSCX5pcwJ9vEOWNs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=niznFh0h4jbO5/MTjBfNyg1VVwa7xY7ExGW6/Vs0GoCOFEh2TQMQSiiEFsqHtSPcT
	 FqNJRe2kps7+FT14Xw1CM1bMrtAeh1sq/LDujwxfZn6iO4Ym6YLlOelrPVfYGsfd8Z
	 an+qpBOemXvKYqM6Ut5OmqzxILfrgxK3pxmiZir8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John David Anglin <dave.anglin@bell.net>,
	Helge Deller <deller@gmx.de>,
	Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH 6.5 176/285] linux/export: fix reference to exported functions for parisc64
Date: Sun, 17 Sep 2023 21:12:56 +0200
Message-ID: <20230917191057.723296348@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191051.639202302@linuxfoundation.org>
References: <20230917191051.639202302@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masahiro Yamada <masahiroy@kernel.org>

commit 08700ec705043eb0cee01b35cf5b9d63f0230d12 upstream.

John David Anglin reported parisc has been broken since commit
ddb5cdbafaaa ("kbuild: generate KSYMTAB entries by modpost").

Like ia64, parisc64 uses a function descriptor. The function
references must be prefixed with P%.

Also, symbols prefixed $$ from the library have the symbol type
STT_LOPROC instead of STT_FUNC. They should be handled as functions
too.

Fixes: ddb5cdbafaaa ("kbuild: generate KSYMTAB entries by modpost")
Reported-by: John David Anglin <dave.anglin@bell.net>
Tested-by: John David Anglin <dave.anglin@bell.net>
Tested-by: Helge Deller <deller@gmx.de>
Closes: https://lore.kernel.org/linux-parisc/1901598a-e11d-f7dd-a5d9-9a69d06e6b6e@bell.net/T/#u
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/export-internal.h |    2 ++
 scripts/mod/modpost.c           |    9 +++++++++
 2 files changed, 11 insertions(+)

--- a/include/linux/export-internal.h
+++ b/include/linux/export-internal.h
@@ -52,6 +52,8 @@
 
 #ifdef CONFIG_IA64
 #define KSYM_FUNC(name)		@fptr(name)
+#elif defined(CONFIG_PARISC) && defined(CONFIG_64BIT)
+#define KSYM_FUNC(name)		P%name
 #else
 #define KSYM_FUNC(name)		name
 #endif
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -1226,6 +1226,15 @@ static void check_export_symbol(struct m
 	 */
 	s->is_func = (ELF_ST_TYPE(sym->st_info) == STT_FUNC);
 
+	/*
+	 * For parisc64, symbols prefixed $$ from the library have the symbol type
+	 * STT_LOPROC. They should be handled as functions too.
+	 */
+	if (elf->hdr->e_ident[EI_CLASS] == ELFCLASS64 &&
+	    elf->hdr->e_machine == EM_PARISC &&
+	    ELF_ST_TYPE(sym->st_info) == STT_LOPROC)
+		s->is_func = true;
+
 	if (match(secname, PATTERNS(INIT_SECTIONS)))
 		warn("%s: %s: EXPORT_SYMBOL used for init symbol. Remove __init or EXPORT_SYMBOL.\n",
 		     mod->name, name);


