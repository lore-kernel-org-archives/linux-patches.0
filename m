Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ECCD14F61
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:14:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dwu1Wy+t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE524C433C8;
	Mon, 23 Oct 2023 11:14:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698059657;
	bh=bGLXfwNdfdCRRUwgn2QIwfLMGi7A5ud9NsRD9eFfwxM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dwu1Wy+tNzcw5BFmn9E8V9nvzMpu2ZYkplq7z9a1ImpCHa9wzEyzXIKHWnTt/BixA
	 IOo5NJZx5rPdACd5KfTSe+75JsSYTPDUX79jt1MEjzkDyHzfeujAMgVqJD4MiPYhE2
	 3ogHn7frCie2j0VCjAi70jN1UybHJDLq2SCZiLyk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 01/98] indirect call wrappers: helpers to speed-up indirect calls of builtin
Date: Mon, 23 Oct 2023 12:55:50 +0200
Message-ID: <20231023104813.632511787@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104813.580375891@linuxfoundation.org>
References: <20231023104813.580375891@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit 283c16a2dfd332bf5610c874f7b9f9c8b601ce53 ]

This header define a bunch of helpers that allow avoiding the
retpoline overhead when calling builtin functions via function pointers.
It boils down to explicitly comparing the function pointers to
known builtin functions and eventually invoke directly the latter.

The macros defined here implement the boilerplate for the above schema
and will be used by the next patches.

rfc -> v1:
 - use branch prediction hint, as suggested by Eric
v1  -> v2:
 - list explicitly the builtin function names in INDIRECT_CALL_*(),
   as suggested by Ed Cree

Suggested-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 86a7e0b69bd5 ("net: prevent rewrite of msg_name in sock_sendmsg()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/indirect_call_wrapper.h | 51 +++++++++++++++++++++++++++
 1 file changed, 51 insertions(+)
 create mode 100644 include/linux/indirect_call_wrapper.h

diff --git a/include/linux/indirect_call_wrapper.h b/include/linux/indirect_call_wrapper.h
new file mode 100644
index 0000000000000..7c8b7f4948af5
--- /dev/null
+++ b/include/linux/indirect_call_wrapper.h
@@ -0,0 +1,51 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_INDIRECT_CALL_WRAPPER_H
+#define _LINUX_INDIRECT_CALL_WRAPPER_H
+
+#ifdef CONFIG_RETPOLINE
+
+/*
+ * INDIRECT_CALL_$NR - wrapper for indirect calls with $NR known builtin
+ *  @f: function pointer
+ *  @f$NR: builtin functions names, up to $NR of them
+ *  @__VA_ARGS__: arguments for @f
+ *
+ * Avoid retpoline overhead for known builtin, checking @f vs each of them and
+ * eventually invoking directly the builtin function. The functions are check
+ * in the given order. Fallback to the indirect call.
+ */
+#define INDIRECT_CALL_1(f, f1, ...)					\
+	({								\
+		likely(f == f1) ? f1(__VA_ARGS__) : f(__VA_ARGS__);	\
+	})
+#define INDIRECT_CALL_2(f, f2, f1, ...)					\
+	({								\
+		likely(f == f2) ? f2(__VA_ARGS__) :			\
+				  INDIRECT_CALL_1(f, f1, __VA_ARGS__);	\
+	})
+
+#define INDIRECT_CALLABLE_DECLARE(f)	f
+#define INDIRECT_CALLABLE_SCOPE
+
+#else
+#define INDIRECT_CALL_1(f, name, ...) f(__VA_ARGS__)
+#define INDIRECT_CALL_2(f, name, ...) f(__VA_ARGS__)
+#define INDIRECT_CALLABLE_DECLARE(f)
+#define INDIRECT_CALLABLE_SCOPE		static
+#endif
+
+/*
+ * We can use INDIRECT_CALL_$NR for ipv6 related functions only if ipv6 is
+ * builtin, this macro simplify dealing with indirect calls with only ipv4/ipv6
+ * alternatives
+ */
+#if IS_BUILTIN(CONFIG_IPV6)
+#define INDIRECT_CALL_INET(f, f2, f1, ...) \
+	INDIRECT_CALL_2(f, f2, f1, __VA_ARGS__)
+#elif IS_ENABLED(CONFIG_INET)
+#define INDIRECT_CALL_INET(f, f2, f1, ...) INDIRECT_CALL_1(f, f1, __VA_ARGS__)
+#else
+#define INDIRECT_CALL_INET(f, f2, f1, ...) f(__VA_ARGS__)
+#endif
+
+#endif
-- 
2.40.1



