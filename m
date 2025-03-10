Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53A901DE89C;
	Mon, 10 Mar 2025 17:09:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741626570; cv=none; b=UUrR4isWotxF4ob/M80CKBx7ULYYs/ex6vTDoOg2YTnBBDTQfW4+KsOfU3yjjLeUYroovAQb+tlZmLWbqTaZYb+NpEkIMWARMTwWQWUy/sWZ3+zGFzuMAfnlt5coDMx+2s+7bNF9RSyFQdUYyyXdF3hsOWEZ7wEMTUwXikk+XGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741626570; c=relaxed/simple;
	bh=78G1BrOxRggyL2uTdFHuxlNC0xIOpGcCS6o9U/5c2Bk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EciZRVjfrx9gHrMRAG48xoAmIy9z+KIBdUPSOaM4b78ZCcJONv6F2eiUDEFr7WAGq7DarMoHLpZg/whceY4HrVWjcyYc4pOrMSfxkhIIZth2okO8DkbBwPupR/xHYZDyJ/Qzw9BI3+kBKnc5S/mGq6JuqKgBCzlPbXrMNaVMAGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jhBn7Nv7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jhBn7Nv7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB05EC4CEE5;
	Mon, 10 Mar 2025 17:09:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741626570;
	bh=78G1BrOxRggyL2uTdFHuxlNC0xIOpGcCS6o9U/5c2Bk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jhBn7Nv7fuSwhCb9jJnJSVPGrKze4sJWXMJiDG5zH6cnC5mujtMstw77W9hqSjUO8
	 Sk7ccE6XUaziDcGlfiH3G8iYNzrUWh6Hom+k5+77UShTCEehyzo9NEinGSvaDp3pXQ
	 4E65wmBVbH2ogl3nBq1LbodijcVL9UG9BkajudUM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.13 006/207] loongarch: Use ASM_REACHABLE
Date: Mon, 10 Mar 2025 18:03:19 +0100
Message-ID: <20250310170448.006687736@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170447.729440535@linuxfoundation.org>
References: <20250310170447.729440535@linuxfoundation.org>
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
 


