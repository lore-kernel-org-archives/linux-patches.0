Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6C5D2517B3;
	Wed,  5 Mar 2025 18:08:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198135; cv=none; b=jgtibzm783m9jZsQt2kO22GwDtE1ugW/06aRVKWrBS+wUIvJ8+fGwF9WkIbtJuuQkfdTq5J0rZobmuQyyCHqACL7hDKumQS6iQ0RZ1LUV3eXP07c34lwd1gqFU94/lfL1Gsl7xt8MkydtlRYr8MjCvUb/jehqlK1PjlyiWJzE6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198135; c=relaxed/simple;
	bh=GwtEeqpUi2irUva6wLpwamIhBWP/tlEyuetO2twtv5M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MqR/geCPw2JHINUrdiBZgeixU4odfuaZhL+mM17O/3BBCRQ8oRJrsGI0eupiySiLOvBPzhmYGyfUHdsPOZsgaEFPdxpjD92RnDhtQACUXnDL2d3UBMfQtpc6sqI2RwXmcCX/vCgKqCi/XdebyDLhiLgJzT2SozJ/ete8cYbEcTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NJaulTTM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NJaulTTM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E195C4CEEC;
	Wed,  5 Mar 2025 18:08:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198135;
	bh=GwtEeqpUi2irUva6wLpwamIhBWP/tlEyuetO2twtv5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NJaulTTMDn15+mBqiGJDJGY8Pvq+1BPY/H8rjoc28pZfS590At4re9CTn7esUExUL
	 nRXX+BgJveCN7QomaekARUTC8gIqIqLuFLXphB8pIaf8DEAF48IDo5clEXvtVhOTCL
	 o3IvylkTAgTrIhbblhrSq9uyTa2g/6G3I6cAI4pc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 075/150] unreachable: Unify
Date: Wed,  5 Mar 2025 18:48:24 +0100
Message-ID: <20250305174506.828977737@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174503.801402104@linuxfoundation.org>
References: <20250305174503.801402104@linuxfoundation.org>
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

[ Upstream commit c837de3810982cd41cd70e5170da1931439f025c ]

Since barrier_before_unreachable() is empty for !GCC it is trivial to
unify the two definitions. Less is more.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Josh Poimboeuf <jpoimboe@kernel.org>
Link: https://lore.kernel.org/r/20241128094311.924381359@infradead.org
Stable-dep-of: 73cfc53cc3b6 ("objtool: Fix C jump table annotations for Clang")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/compiler-gcc.h | 12 ------------
 include/linux/compiler.h     | 10 +++++++---
 2 files changed, 7 insertions(+), 15 deletions(-)

diff --git a/include/linux/compiler-gcc.h b/include/linux/compiler-gcc.h
index cd6f9aae311fc..070b3b680209c 100644
--- a/include/linux/compiler-gcc.h
+++ b/include/linux/compiler-gcc.h
@@ -52,18 +52,6 @@
  */
 #define barrier_before_unreachable() asm volatile("")
 
-/*
- * Mark a position in code as unreachable.  This can be used to
- * suppress control flow warnings after asm blocks that transfer
- * control elsewhere.
- */
-#define unreachable() \
-	do {					\
-		annotate_unreachable();		\
-		barrier_before_unreachable();	\
-		__builtin_unreachable();	\
-	} while (0)
-
 #if defined(CONFIG_ARCH_USE_BUILTIN_BSWAP)
 #define __HAVE_BUILTIN_BSWAP32__
 #define __HAVE_BUILTIN_BSWAP64__
diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index 2d962dade9fae..0d10d75218f51 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -141,12 +141,16 @@ void ftrace_likely_update(struct ftrace_likely_data *f, int val,
 #define __annotate_jump_table
 #endif /* CONFIG_OBJTOOL */
 
-#ifndef unreachable
-# define unreachable() do {		\
+/*
+ * Mark a position in code as unreachable.  This can be used to
+ * suppress control flow warnings after asm blocks that transfer
+ * control elsewhere.
+ */
+#define unreachable() do {		\
 	annotate_unreachable();		\
+	barrier_before_unreachable();	\
 	__builtin_unreachable();	\
 } while (0)
-#endif
 
 /*
  * KENTRY - kernel entry point
-- 
2.39.5



