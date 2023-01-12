Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46BD879C9
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:26:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D68CC433D2;
	Thu, 12 Jan 2023 14:26:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673533595;
	bh=cy62qzUXmxJDIjtBNB+9WcseOi5CuKs9U+vaJzf7JtI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QuNttfOfWlPP4pkHt9RzXHHF5CiiqQjMQppveY2F46Moh0VsNy1yJZmACnu2adl9C
	 VodpGXmLFYPNlK16C4+sKcozupkfcbOsgxl7whgcYJWrgLvDD3rkUcfN+Um2wkQ0fz
	 obEF1t2eeunm16x509vp6jcZ7l8yei+iUgvdhacQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrii Nakryiko <andrii@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 529/783] libbpf: Avoid enum forward-declarations in public API in C++ mode
Date: Thu, 12 Jan 2023 14:54:05 +0100
Message-Id: <20230112135548.744839705@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Andrii Nakryiko <andrii@kernel.org>

[ Upstream commit b42693415b86f608049cf1b4870adc1dc65e58b0 ]

C++ enum forward declarations are fundamentally not compatible with pure
C enum definitions, and so libbpf's use of `enum bpf_stats_type;`
forward declaration in libbpf/bpf.h public API header is causing C++
compilation issues.

More details can be found in [0], but it comes down to C++ supporting
enum forward declaration only with explicitly specified backing type:

  enum bpf_stats_type: int;

In C (and I believe it's a GCC extension also), such forward declaration
is simply:

  enum bpf_stats_type;

Further, in Linux UAPI this enum is defined in pure C way:

enum bpf_stats_type { BPF_STATS_RUN_TIME = 0; }

And even though in both cases backing type is int, which can be
confirmed by looking at DWARF information, for C++ compiler actual enum
definition and forward declaration are incompatible.

To eliminate this problem, for C++ mode define input argument as int,
which makes enum unnecessary in libbpf public header. This solves the
issue and as demonstrated by next patch doesn't cause any unwanted
compiler warnings, at least with default warnings setting.

  [0] https://stackoverflow.com/questions/42766839/c11-enum-forward-causes-underlying-type-mismatch
  [1] Closes: https://github.com/libbpf/libbpf/issues/249

Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20221130200013.2997831-1-andrii@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/bpf.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/tools/lib/bpf/bpf.h b/tools/lib/bpf/bpf.h
index 875dde20d56e..92a3eaa154dd 100644
--- a/tools/lib/bpf/bpf.h
+++ b/tools/lib/bpf/bpf.h
@@ -241,8 +241,15 @@ LIBBPF_API int bpf_task_fd_query(int pid, int fd, __u32 flags, char *buf,
 				 __u32 *buf_len, __u32 *prog_id, __u32 *fd_type,
 				 __u64 *probe_offset, __u64 *probe_addr);
 
+#ifdef __cplusplus
+/* forward-declaring enums in C++ isn't compatible with pure C enums, so
+ * instead define bpf_enable_stats() as accepting int as an input
+ */
+LIBBPF_API int bpf_enable_stats(int type);
+#else
 enum bpf_stats_type; /* defined in up-to-date linux/bpf.h */
 LIBBPF_API int bpf_enable_stats(enum bpf_stats_type type);
+#endif
 
 struct bpf_prog_bind_opts {
 	size_t sz; /* size of this struct for forward/backward compatibility */
-- 
2.35.1



