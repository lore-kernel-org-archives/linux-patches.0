Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 116A41D0488;
	Wed,  2 Oct 2024 14:35:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879729; cv=none; b=Ql2Wcqy+WwUV4zOXK9YN5pgcA78tmplsmGmRTij7MlZ6eBS6Bhe1wWm3CnZgoM0ARhktbxnPJU5puemKdPDv6p6pU9nMrEOI0Oie3znpMWu4YxAruZBcy+9UESn52+YbJRae5/bJ2MJGzO6Eyh/hSQZtcjDxHothNXUhJ1nBCqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879729; c=relaxed/simple;
	bh=MtlgAsmFkylkNhwd/79Axxk1cJZYtiIF/3OVqAU99qE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jDKTFSjSrQMz1eMVutKgsVo5QB0vvN5A8NxiD86fj76ElzTs3OA1vuVnxohPxLrzkppBgn7xGvGeDMpTQegCucM98i7FL7LT9a0Uw00/tcFnkp3Yjoslz8S7Pe/Ii1N0Hoz4T0U5iskdzh3AX38i+CnWstwbsaGK3paNS5Yf58o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zodtBl0i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zodtBl0i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A1F0C4CEC2;
	Wed,  2 Oct 2024 14:35:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879729;
	bh=MtlgAsmFkylkNhwd/79Axxk1cJZYtiIF/3OVqAU99qE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zodtBl0iI+sr9NLMhXuAvvJAAQEztmwrTbjfQ3Z94Fs4OMd7pG1vH+UuyETOl/6uM
	 OJNtaCX61UR+r8Mhr671t8OxUq1IG72MD7DVsIo4MdKtfUddXwBPDhUI9UagbuMTBc
	 sLt0jSwhcso6s5SmuR/jrxcmojeFtDqCD/+Pr/Y8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Ambardar <tony.ambardar@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 218/538] selftests/bpf: Fix compile if backtrace support missing in libc
Date: Wed,  2 Oct 2024 14:57:37 +0200
Message-ID: <20241002125800.861700988@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tony Ambardar <tony.ambardar@gmail.com>

[ Upstream commit c9a83e76b5a96801a2c7ea0a79ca77c356d8b38d ]

Include GNU <execinfo.h> header only with glibc and provide weak, stubbed
backtrace functions as a fallback in test_progs.c. This allows for non-GNU
replacements while avoiding compile errors (e.g. with musl libc) like:

  test_progs.c:13:10: fatal error: execinfo.h: No such file or directory
     13 | #include <execinfo.h> /* backtrace */
        |          ^~~~~~~~~~~~
  test_progs.c: In function 'crash_handler':
  test_progs.c:1034:14: error: implicit declaration of function 'backtrace' [-Werror=implicit-function-declaration]
   1034 |         sz = backtrace(bt, ARRAY_SIZE(bt));
        |              ^~~~~~~~~
  test_progs.c:1045:9: error: implicit declaration of function 'backtrace_symbols_fd' [-Werror=implicit-function-declaration]
   1045 |         backtrace_symbols_fd(bt, sz, STDERR_FILENO);
        |         ^~~~~~~~~~~~~~~~~~~~

Fixes: 9fb156bb82a3 ("selftests/bpf: Print backtrace on SIGSEGV in test_progs")
Signed-off-by: Tony Ambardar <tony.ambardar@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/aa6dc8e23710cb457b278039d0081de7e7b4847d.1722244708.git.tony.ambardar@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/test_progs.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/test_progs.c b/tools/testing/selftests/bpf/test_progs.c
index eed0e4fcf42ef..74620ed3a166e 100644
--- a/tools/testing/selftests/bpf/test_progs.c
+++ b/tools/testing/selftests/bpf/test_progs.c
@@ -10,7 +10,6 @@
 #include <sched.h>
 #include <signal.h>
 #include <string.h>
-#include <execinfo.h> /* backtrace */
 #include <sys/sysinfo.h> /* get_nprocs */
 #include <netinet/in.h>
 #include <sys/select.h>
@@ -19,6 +18,21 @@
 #include <bpf/btf.h>
 #include "json_writer.h"
 
+#ifdef __GLIBC__
+#include <execinfo.h> /* backtrace */
+#endif
+
+/* Default backtrace funcs if missing at link */
+__weak int backtrace(void **buffer, int size)
+{
+	return 0;
+}
+
+__weak void backtrace_symbols_fd(void *const *buffer, int size, int fd)
+{
+	dprintf(fd, "<backtrace not supported>\n");
+}
+
 static bool verbose(void)
 {
 	return env.verbosity > VERBOSE_NONE;
-- 
2.43.0



