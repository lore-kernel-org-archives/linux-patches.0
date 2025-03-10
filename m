Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6409C21E087;
	Mon, 10 Mar 2025 17:19:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627185; cv=none; b=G0ChYDnGdOp/Qzw0u23r5opzpaUlMHG33IYHRsDxWNCcCDL79dlrsDmPzVBJLsMVq9Klhaz51VARBOGwZa1lhH+OGiu9Fj6qt3sK9xufXhyim+8Nrh1bl0eRRq1iRYQ1W1QRwD7JDi50tAxZ1XxPvz+SsppaW4PARyQwsJD/2BM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627185; c=relaxed/simple;
	bh=+dsgfyUl5bJX4Cie+gXLl5KRUwkBxnnpKHD+dGAvSac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=crnfl6UXKrLI28XhNc+Gu9M9PlZPJjtKlAm3VzXyd0jFwYY3+0cBFq3LAlmRMwaIF9+IVHFSijDWM/y6mctA90cgpdIAODbMFSMQI8mvDgbnWBdlQwSbocKhe8FJ1U42VUol9dtZvl4suREDAxbg5nAiHsoJdVUJwLSsPr8sGts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lq7343cB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lq7343cB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE69FC4CEE5;
	Mon, 10 Mar 2025 17:19:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627185;
	bh=+dsgfyUl5bJX4Cie+gXLl5KRUwkBxnnpKHD+dGAvSac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lq7343cBboddHVUShSVazycI0xYMTTcHs77mgbVeRjRCcHCRuUu+f1h4rQMVmHWsZ
	 YzlPQaKLv+5juLCqjNSoQ1IQZxR4AhCnCVOA49qzFROMI4Cxu++EwZgLYBzn8NTgnL
	 BB+thOEM7zxqEKrpeGCsckW0aJj2urUGRGrTCD9w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.12 011/269] loongarch: Use ASM_REACHABLE
Date: Mon, 10 Mar 2025 18:02:44 +0100
Message-ID: <20250310170458.155042546@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
References: <20250310170457.700086763@linuxfoundation.org>
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

From: Peter Zijlstra <peterz@infradead.org>

commit 624bde3465f660e54a7cd4c1efc3e536349fead5 upstream.

annotate_reachable() is unreliable since the compiler is free to place
random code inbetween two consecutive asm() statements.

This removes the last and only annotate_reachable() user.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Josh Poimboeuf <jpoimboe@kernel.org>
Link: https://lore.kernel.org/r/20241128094312.133437051@infradead.org
Closes: https://lore.kernel.org/loongarch/20250307214943.372210-1-ojeda@kernel.org/
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/include/asm/bug.h |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/arch/loongarch/include/asm/bug.h
+++ b/arch/loongarch/include/asm/bug.h
@@ -4,6 +4,7 @@
 
 #include <asm/break.h>
 #include <linux/stringify.h>
+#include <linux/objtool.h>
 
 #ifndef CONFIG_DEBUG_BUGVERBOSE
 #define _BUGVERBOSE_LOCATION(file, line)
@@ -33,25 +34,25 @@
 
 #define ASM_BUG_FLAGS(flags)					\
 	__BUG_ENTRY(flags)					\
-	break		BRK_BUG
+	break		BRK_BUG;
 
 #define ASM_BUG()	ASM_BUG_FLAGS(0)
 
-#define __BUG_FLAGS(flags)					\
-	asm_inline volatile (__stringify(ASM_BUG_FLAGS(flags)));
+#define __BUG_FLAGS(flags, extra)					\
+	asm_inline volatile (__stringify(ASM_BUG_FLAGS(flags))		\
+			     extra);
 
 #define __WARN_FLAGS(flags)					\
 do {								\
 	instrumentation_begin();				\
-	__BUG_FLAGS(BUGFLAG_WARNING|(flags));			\
-	annotate_reachable();					\
+	__BUG_FLAGS(BUGFLAG_WARNING|(flags), ASM_REACHABLE);	\
 	instrumentation_end();					\
 } while (0)
 
 #define BUG()							\
 do {								\
 	instrumentation_begin();				\
-	__BUG_FLAGS(0);						\
+	__BUG_FLAGS(0, "");					\
 	unreachable();						\
 } while (0)
 


