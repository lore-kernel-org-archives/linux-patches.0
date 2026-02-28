Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 601A4372228;
	Sat, 28 Feb 2026 17:58:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301494; cv=none; b=fEo9qjKW61uqb9Fp7+cdeZ0NwhES+ZWqEXoCn+XKHzAU6njDU4v38lbg02Od80C6KFqzO9pmKjec4fSWJSNFSUeNYSpLAk0/sPaKHgWGqsneL99HODCd4pb24pJPBPPGyv/szCVFyv6FWtEgHRbF1DbEpDg5Yh2uCRYbG9AXk54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301494; c=relaxed/simple;
	bh=m/dcfBsu94i559Z1SwwSI3r5gEPB4hYFt7qLmuUQkos=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I1L47gd7nqp+tenWTDLqxDrzfa6ZuVjmF2fKbP86tq6b/msruN4J41so2y4qPmPXSslm9IRb/r8x6nKstGJrPq5PPaHa6N5higw56eYrgMB22wV2vWImoQIeMuyVpiYcs8F6f+949obSEI8Tjct6lm47ecZMj2juqCStZuHWBkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Zzzjb/26; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Zzzjb/26"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98945C19423;
	Sat, 28 Feb 2026 17:58:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301494;
	bh=m/dcfBsu94i559Z1SwwSI3r5gEPB4hYFt7qLmuUQkos=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zzzjb/26HDa4xbimhUROgmOAx46iAlLbcrxE/AI640OO084v+vylrt9LptrUuocdC
	 n7wvXB+0bZR9n+/VEPHte+8pakroYAvnw+HjSwNWP9vwTvQ0sG7GnYsXRqpx87y1/L
	 6TgJQLoPPlGCuPKmmKDG2my3CZT+k6OBdDufOqEZHGwRhPAQl8Kp6+L8pMxUvz8/cx
	 8nfe9X+rL0t2dN5AwiflfAOjdIdTY+4wB2iBb12/2ZTEIl0Suo+Rvq/jXNwUpX0wLZ
	 NECzyOugtDG9ZsNyMhYr3jpYCFBZZSdkoSPmehV7U/8tfhtRQF/+s9x+urHGNhzK3M
	 JXbe0qV2s811Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Alan Maguire <alan.maguire@oracle.com>,
	Nilay Shroff <nilay@linux.ibm.com>,
	Marco Elver <elver@google.com>,
	Yonghong Song <yonghong.song@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Andrii Nakryiko <andrii.nakryiko@gmail.com>,
	Bart van Assche <bvanassche@acm.org>,
	Daniel Borkman <daniel@iogearbox.net>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Hao Luo <haoluo@google.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"Jason A. Donenfeld" <jason@zx2c4.com>,
	Jiri Olsa <jolsa@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>,
	Kees Cook <kees@kernel.org>,
	KP Singh <kpsingh@kernel.org>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Miguel Ojeda <ojeda@kernel.org>,
	Naman Jain <namjain@linux.microsoft.com>,
	Nathan Chancellor <nathan@kernel.org>,
	"Paul E . McKenney" <paulmck@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Uros Bizjak <ubizjak@gmail.com>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 678/752] kcsan, compiler_types: avoid duplicate type issues in BPF Type Format
Date: Sat, 28 Feb 2026 12:46:29 -0500
Message-ID: <20260228174750.1542406-678-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Alan Maguire <alan.maguire@oracle.com>

[ Upstream commit 9dc052234da736f7749f19ab6936342ec7dbe3ac ]

Enabling KCSAN is causing a large number of duplicate types in BTF for
core kernel structs like task_struct [1].  This is due to the definition
in include/linux/compiler_types.h

`#ifdef __SANITIZE_THREAD__
...
`#define __data_racy volatile
..
`#else
...
`#define __data_racy
...
`#endif

Because some objects in the kernel are compiled without KCSAN flags
(KCSAN_SANITIZE) we sometimes get the empty __data_racy annotation for
objects; as a result we get multiple conflicting representations of the
associated structs in DWARF, and these lead to multiple instances of core
kernel types in BTF since they cannot be deduplicated due to the
additional modifier in some instances.

Moving the __data_racy definition under CONFIG_KCSAN avoids this problem,
since the volatile modifier will be present for both KCSAN and
KCSAN_SANITIZE objects in a CONFIG_KCSAN=y kernel.

Link: https://lkml.kernel.org/r/20260116091730.324322-1-alan.maguire@oracle.com
Fixes: 31f605a308e6 ("kcsan, compiler_types: Introduce __data_racy type qualifier")
Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
Reported-by: Nilay Shroff <nilay@linux.ibm.com>
Tested-by: Nilay Shroff <nilay@linux.ibm.com>
Suggested-by: Marco Elver <elver@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Acked-by: Yonghong Song <yonghong.song@linux.dev>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc: Bart van Assche <bvanassche@acm.org>
Cc: Daniel Borkman <daniel@iogearbox.net>
Cc: Eduard Zingerman <eddyz87@gmail.com>
Cc: Hao Luo <haoluo@google.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jason A. Donenfeld <jason@zx2c4.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Kees Cook <kees@kernel.org>
Cc: KP Singh <kpsingh@kernel.org>
Cc: Martin KaFai Lau <martin.lau@linux.dev>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Naman Jain <namjain@linux.microsoft.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: "Paul E . McKenney" <paulmck@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stanislav Fomichev <sdf@fomichev.me>
Cc: Uros Bizjak <ubizjak@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/compiler_types.h | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/include/linux/compiler_types.h b/include/linux/compiler_types.h
index 8128a445f0480..2998af80cbef3 100644
--- a/include/linux/compiler_types.h
+++ b/include/linux/compiler_types.h
@@ -303,6 +303,22 @@ struct ftrace_likely_data {
 # define __no_kasan_or_inline __always_inline
 #endif
 
+#ifdef CONFIG_KCSAN
+/*
+ * Type qualifier to mark variables where all data-racy accesses should be
+ * ignored by KCSAN. Note, the implementation simply marks these variables as
+ * volatile, since KCSAN will treat such accesses as "marked".
+ *
+ * Defined here because defining __data_racy as volatile for KCSAN objects only
+ * causes problems in BPF Type Format (BTF) generation since struct members
+ * of core kernel data structs will be volatile in some objects and not in
+ * others.  Instead define it globally for KCSAN kernels.
+ */
+# define __data_racy volatile
+#else
+# define __data_racy
+#endif
+
 #ifdef __SANITIZE_THREAD__
 /*
  * Clang still emits instrumentation for __tsan_func_{entry,exit}() and builtin
@@ -314,16 +330,9 @@ struct ftrace_likely_data {
  * disable all instrumentation. See Kconfig.kcsan where this is mandatory.
  */
 # define __no_kcsan __no_sanitize_thread __disable_sanitizer_instrumentation
-/*
- * Type qualifier to mark variables where all data-racy accesses should be
- * ignored by KCSAN. Note, the implementation simply marks these variables as
- * volatile, since KCSAN will treat such accesses as "marked".
- */
-# define __data_racy volatile
 # define __no_sanitize_or_inline __no_kcsan notrace __maybe_unused
 #else
 # define __no_kcsan
-# define __data_racy
 #endif
 
 #ifdef __SANITIZE_MEMORY__
-- 
2.51.0

