Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 779C84FE2CB;
	Tue, 13 Oct 2026 12:07:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893274; cv=none; b=fj4hPGQ9symhgI016A8vJmB5LBPjCUL7fmcNG1Y1Bq2/MsZK2PcmxZYg7bHu6RO4CcgliHbUGRwDOSUlRJp0u0FcVeWPLF+h7UsFq/pRV1FE2cDSzgd1OAx8Om7ApgCbYKuhGDDLoItD5p9wWKHRB1Wp+Bo3DPNnzsUCow1Koms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893274; c=relaxed/simple;
	bh=xcqYOl0/y1/icYBohiYYD9U1BAWqgFcVZBvnapvJFKk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AGIialhjHvs6iZxZN9XLFPhtE1RC6od+r79Q0HNNyTlgITwhrApnOU0D+GKzuu5t9DH04dDvfX/VWLvtm1Gz+5XxdatC+c8RTjsCLt6JQvIQiBGUNrQF+/R+dfPPHs/gtDzIwauQe99xsZDrg8+E1z6TnQvrRjEfQgUqbAR9gXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F8KVn4D8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F8KVn4D8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF1741F00893;
	Tue, 13 Oct 2026 12:07:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893273;
	bh=yp27TsEygeA3pJRpsuQ9RDiateDk8kpSkq1NlN0Ahv4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F8KVn4D84oZbVwn5gPPz3nnIGuQW5F5dFGZgGnb9Q2qPKVSPSYnoDsTVno661D00G
	 9bz1+zZxowX72+AVq6H+Axul90VnwTBqZCxebs+t/RLTpRc28j1hRX4nM/vW1RZDQW
	 fXN/Mndzo+A9HGn+yWoENuSPMfXKSP7dQR0imUHk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Naman Jain <namjain@linux.microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 172/621] static_call: allow using STATIC_CALL_TRAMP_STR() from assembly
Date: Tue, 13 Oct 2026 13:32:47 +0200
Message-ID: <20261013112924.945713485@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Naman Jain <namjain@linux.microsoft.com>

[ Upstream commit 796ef5a7fe86a8605f2844471ed7baa8e80bace8 ]

STATIC_CALL_TRAMP_STR() could not be used from .S files because
static_call_types.h was not safe to include in assembly as it pulled in C
types/constructs that are unavailable under __ASSEMBLY__.
Make the header assembly-friendly by adding __ASSEMBLY__ checks and
providing only the minimal definitions needed for assembly, so that it
can be safely included by .S code. This enables emitting the static call
trampoline symbol name via STATIC_CALL_TRAMP_STR() directly in assembly
sources, to be used with 'call' instruction. Also, move a certain
definitions out of __ASSEMBLY__ checks in compiler_types.h to meet
the dependencies.

No functional change for C compilation.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Naman Jain <namjain@linux.microsoft.com>
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Stable-dep-of: c0e296f25767 ("mshv: Fix error handling in mshv_region_pin")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/compiler_types.h          | 8 ++++----
 include/linux/static_call_types.h       | 4 ++++
 tools/include/linux/static_call_types.h | 4 ++++
 3 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/include/linux/compiler_types.h b/include/linux/compiler_types.h
index ba49413f704be..cb007601d8c3d 100644
--- a/include/linux/compiler_types.h
+++ b/include/linux/compiler_types.h
@@ -11,6 +11,10 @@
 #define __has_builtin(x) (0)
 #endif
 
+/* Indirect macros required for expanded argument pasting, eg. __LINE__. */
+#define ___PASTE(a, b) a##b
+#define __PASTE(a, b) ___PASTE(a, b)
+
 #ifndef __ASSEMBLY__
 
 /*
@@ -78,10 +82,6 @@ static inline void __chk_io_ptr(const volatile void __iomem *ptr) { }
 # define __builtin_warning(x, y...) (1)
 #endif /* __CHECKER__ */
 
-/* Indirect macros required for expanded argument pasting, eg. __LINE__. */
-#define ___PASTE(a,b) a##b
-#define __PASTE(a,b) ___PASTE(a,b)
-
 #ifdef __KERNEL__
 
 /* Attributes */
diff --git a/include/linux/static_call_types.h b/include/linux/static_call_types.h
index 5a00b8b2cf9fc..cfb6ddeb292b6 100644
--- a/include/linux/static_call_types.h
+++ b/include/linux/static_call_types.h
@@ -25,6 +25,8 @@
 #define STATIC_CALL_SITE_INIT 2UL	/* init section */
 #define STATIC_CALL_SITE_FLAGS 3UL
 
+#ifndef __ASSEMBLY__
+
 /*
  * The static call site table needs to be created by external tooling (objtool
  * or a compiler plugin).
@@ -100,4 +102,6 @@ struct static_call_key {
 
 #endif /* CONFIG_HAVE_STATIC_CALL */
 
+#endif /* __ASSEMBLY__ */
+
 #endif /* _STATIC_CALL_TYPES_H */
diff --git a/tools/include/linux/static_call_types.h b/tools/include/linux/static_call_types.h
index 5a00b8b2cf9fc..cfb6ddeb292b6 100644
--- a/tools/include/linux/static_call_types.h
+++ b/tools/include/linux/static_call_types.h
@@ -25,6 +25,8 @@
 #define STATIC_CALL_SITE_INIT 2UL	/* init section */
 #define STATIC_CALL_SITE_FLAGS 3UL
 
+#ifndef __ASSEMBLY__
+
 /*
  * The static call site table needs to be created by external tooling (objtool
  * or a compiler plugin).
@@ -100,4 +102,6 @@ struct static_call_key {
 
 #endif /* CONFIG_HAVE_STATIC_CALL */
 
+#endif /* __ASSEMBLY__ */
+
 #endif /* _STATIC_CALL_TYPES_H */
-- 
2.53.0



