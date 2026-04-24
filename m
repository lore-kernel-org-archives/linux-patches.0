Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1256F23E356;
	Fri, 24 Apr 2026 13:36:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777037775; cv=none; b=SQmqSIObUN8uhJY+REUcCvcNEM9mw7tiPE48RvXNInp+gs4v2v8Co+Ay/mYbI4tvIgUfVVzaj80w4j6Jzhl+uWUprImUuEuIo7m5bsOfc6FdEhnLY0jm/vtCiqkV6z3U/La66yYD74+zGkFJCsIihwUp/g44hr5X7c8KUaA72rI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777037775; c=relaxed/simple;
	bh=WwBj3svLU4tmQpdCQ9u2i/J6TZG7gpRXI0kCx/lfj+g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YTxd5CIncF0UvqATlwa6zT2RLsmyPtN92HH8dKIwsNmsQWo8csAft/niyiedqCLSj7I7Tfh36zU86Q0gqAjFaCA00RXYBddzdc+7J2uR1+QVl/5qsoFlZJqQfwtnjr4SgiASfkQ0vtoHSLqbI22QfS+VOPo87+QbPIlmZbceB8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SkE9AahG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SkE9AahG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A898C2BCB2;
	Fri, 24 Apr 2026 13:36:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777037775;
	bh=WwBj3svLU4tmQpdCQ9u2i/J6TZG7gpRXI0kCx/lfj+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SkE9AahGS8MrV+9206uadOFCdfHaepR7XsHx3E10X0CJWChxBZjiAkC4lFSmynnr/
	 7iWRZG5j1nf1JJpl5ClZCG8Fnxqg9UJNRQS0oYmAi7D7SKxfIP8J1eeF9o9/rzlVFv
	 YvL9ybmjS+6ZiQj/1qqV7PmfEqM0Xs4KbM7CXF4Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaron Plattner <aplattner@nvidia.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 065/166] objtool: Remove max symbol name length limitation
Date: Fri, 24 Apr 2026 15:29:39 +0200
Message-ID: <20260424132546.373642736@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424132532.812258529@linuxfoundation.org>
References: <20260424132532.812258529@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aaron Plattner <aplattner@nvidia.com>

[ Upstream commit f404a58dcf0c862b05602f641ce5fdd8b98fbc3a ]

If one of the symbols processed by read_symbols() happens to have a
.cold variant with a name longer than objtool's MAX_NAME_LEN limit, the
build fails.

Avoid this problem by just using strndup() to copy the parent function's
name, rather than strncpy()ing it onto the stack.

Signed-off-by: Aaron Plattner <aplattner@nvidia.com>
Link: https://lore.kernel.org/r/41e94cfea1d9131b758dd637fecdeacd459d4584.1696355111.git.aplattner@nvidia.com
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/objtool/elf.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/tools/objtool/elf.c b/tools/objtool/elf.c
index 797507a90251b..19021f9755ac7 100644
--- a/tools/objtool/elf.c
+++ b/tools/objtool/elf.c
@@ -22,8 +22,6 @@
 #include <objtool/elf.h>
 #include <objtool/warn.h>
 
-#define MAX_NAME_LEN 128
-
 static inline u32 str_hash(const char *str)
 {
 	return jhash(str, strlen(str), 0);
@@ -515,7 +513,7 @@ static int read_symbols(struct elf *elf)
 	/* Create parent/child links for any cold subfunctions */
 	list_for_each_entry(sec, &elf->sections, list) {
 		sec_for_each_sym(sec, sym) {
-			char pname[MAX_NAME_LEN + 1];
+			char *pname;
 			size_t pnamelen;
 			if (sym->type != STT_FUNC)
 				continue;
@@ -531,15 +529,15 @@ static int read_symbols(struct elf *elf)
 				continue;
 
 			pnamelen = coldstr - sym->name;
-			if (pnamelen > MAX_NAME_LEN) {
-				WARN("%s(): parent function name exceeds maximum length of %d characters",
-				     sym->name, MAX_NAME_LEN);
+			pname = strndup(sym->name, pnamelen);
+			if (!pname) {
+				WARN("%s(): failed to allocate memory",
+				     sym->name);
 				return -1;
 			}
 
-			strncpy(pname, sym->name, pnamelen);
-			pname[pnamelen] = '\0';
 			pfunc = find_symbol_by_name(elf, pname);
+			free(pname);
 
 			if (!pfunc) {
 				WARN("%s(): can't find parent function",
-- 
2.53.0



