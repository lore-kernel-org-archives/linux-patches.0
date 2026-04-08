Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D2C32727F3;
	Wed,  8 Apr 2026 18:50:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674234; cv=none; b=P0/8fXQEWkCUDRQn+ucEL+BjvoJZOdGg6R4stiKAzSiFuaJcZiSmm2fw4Sdvju3DUshcf4YX3xVtA10iRJVWpoKa6e+MzYiNzAwFmaOEadX/Uy2MSgSTRO63CUbVYFMiYMzwSBPTHZbV+VOl0A1DO29EEgNoAFUjwiT/QlsBlWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674234; c=relaxed/simple;
	bh=ribLUs9Z+KE6n2XwV/9fAU9E3XzIvVYeSGHzGEn3DR8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NQzpWQpJaM+KuB7BGsdcjZpwxC/EOEmbgzV1DQ++GiA/PZY2EJ1x+NyE4KFGRPhUVKyQnEV1xRMoDqJj8O6/haxlW39WWVrh8XbT9ejWBKgE7iN22qBR5oDH4zArT5/1WqM48VXtemZmPbExPj7WVTh5RYqpjaeh+ttcLkeZnDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zX1mkkWM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zX1mkkWM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10F62C19421;
	Wed,  8 Apr 2026 18:50:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674234;
	bh=ribLUs9Z+KE6n2XwV/9fAU9E3XzIvVYeSGHzGEn3DR8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zX1mkkWM/feP7mOyn3v0iSXrX6nfAkowEBLLZF8p3L1VnWRluwFVOu31vprDFrAcl
	 jnqQuYv3xJtgNU7pZxzgco6zYN+yLr7efF9//iAaaUGuqGvjNb6jg+zmnp6qHTV1fz
	 umLHiSu02bhz7KPUPUMky9PHv2L+olUdY/AqYfk0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Song Liu <song@kernel.org>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 019/311] objtool/klp: fix mkstemp() failure with long paths
Date: Wed,  8 Apr 2026 20:00:19 +0200
Message-ID: <20260408175940.129469158@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joe Lawrence <joe.lawrence@redhat.com>

[ Upstream commit 28e367a969b0c54c87ca655ec180715fe469fd14 ]

The elf_create_file() function fails with EINVAL when the build directory
path is long enough to truncate the "XXXXXX" suffix in the 256-byte
tmp_name buffer.

Simplify the code to remove the unnecessary dirname()/basename() split
and concatenation.  Instead, allocate the exact number of bytes needed for
the path.

Acked-by: Song Liu <song@kernel.org>
Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>
Link: https://patch.msgid.link/20260310203751.1479229-3-joe.lawrence@redhat.com
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/objtool/elf.c | 23 +++--------------------
 1 file changed, 3 insertions(+), 20 deletions(-)

diff --git a/tools/objtool/elf.c b/tools/objtool/elf.c
index 3da90686350d7..2ffe3ebfbe37c 100644
--- a/tools/objtool/elf.c
+++ b/tools/objtool/elf.c
@@ -16,7 +16,6 @@
 #include <string.h>
 #include <unistd.h>
 #include <errno.h>
-#include <libgen.h>
 #include <ctype.h>
 #include <linux/align.h>
 #include <linux/kernel.h>
@@ -1189,7 +1188,7 @@ struct elf *elf_open_read(const char *name, int flags)
 struct elf *elf_create_file(GElf_Ehdr *ehdr, const char *name)
 {
 	struct section *null, *symtab, *strtab, *shstrtab;
-	char *dir, *base, *tmp_name;
+	char *tmp_name;
 	struct symbol *sym;
 	struct elf *elf;
 
@@ -1203,29 +1202,13 @@ struct elf *elf_create_file(GElf_Ehdr *ehdr, const char *name)
 
 	INIT_LIST_HEAD(&elf->sections);
 
-	dir = strdup(name);
-	if (!dir) {
-		ERROR_GLIBC("strdup");
-		return NULL;
-	}
-
-	dir = dirname(dir);
-
-	base = strdup(name);
-	if (!base) {
-		ERROR_GLIBC("strdup");
-		return NULL;
-	}
-
-	base = basename(base);
-
-	tmp_name = malloc(256);
+	tmp_name = malloc(strlen(name) + 8);
 	if (!tmp_name) {
 		ERROR_GLIBC("malloc");
 		return NULL;
 	}
 
-	snprintf(tmp_name, 256, "%s/%s.XXXXXX", dir, base);
+	sprintf(tmp_name, "%s.XXXXXX", name);
 
 	elf->fd = mkstemp(tmp_name);
 	if (elf->fd == -1) {
-- 
2.53.0



