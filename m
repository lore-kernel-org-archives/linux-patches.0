Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 255F519ABA3;
	Wed,  5 Mar 2025 18:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198556; cv=none; b=GoE3bP+rYoNBTE3xNRajwwCIcE8MRRUL9S+2hbmidW11Q/8a8DkhtEAAXYCoKhK5gcL099j2YDIJZgtAbysiThyLOtw95MP+VX6W2eSpwt6QGXAhi6SQz+WTz63r57VYQmtPT+jVffo2/VEh92yoZhaFc7uE0pK6rejk8oieS84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198556; c=relaxed/simple;
	bh=d6sp7wgggqfC+WV/4d+4fTQkq8vz6cPFxEaMy40GKKk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bat13dzJjf/KS32l6ViOusiNKhX/g0mP2teuZafrHtUSEgE+FJ77ofh/tZfvxNoy0FR9HM6qTMUSJWYcNGsLepJn5gsGqk7eJeoIZom5LWC/iJH1dXrZL+0isUxpg2XIIEzfg37mn1Fp6+4Yp79Qiea1uTkEPOE0UL/goewO9mE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U9oXPWNu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U9oXPWNu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A202AC4CED1;
	Wed,  5 Mar 2025 18:15:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198556;
	bh=d6sp7wgggqfC+WV/4d+4fTQkq8vz6cPFxEaMy40GKKk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U9oXPWNuFBV5YvaaQxq24rUQbLTTbLTXts/rYp10+tyvBapBQOSUMO17nEQ9VJ5ls
	 gBi9NhPxDLDMRdM8p5d3drQVNghKmASwwH2rB7WT7xFVK6oDXJzyNWa0vF4kkN207m
	 6lDz5VDtrpSrUW9so2HhCTHmEALxkRhZCB0G4S+0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 069/157] unreachable: Unify
Date: Wed,  5 Mar 2025 18:48:25 +0100
Message-ID: <20250305174508.075710987@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.268725418@linuxfoundation.org>
References: <20250305174505.268725418@linuxfoundation.org>
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
index d0ed9583743fc..c9b58188ec61e 100644
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
index 7af999a131cb2..bd5d10c479c09 100644
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



