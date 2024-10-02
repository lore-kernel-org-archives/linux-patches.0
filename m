Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60C301D0DDD;
	Wed,  2 Oct 2024 14:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877977; cv=none; b=WE0+PauMKM1+Adsul7O4Od+rnplHjHuBt/GLVCzxZjZ4NRs0bVQq27i7nq811X592ix9PLbwhXWvr0AR3VqPfuPAQQ+ESg81t8NqDZighX+X1ngUld3y1vDAWtZzn/rYyCbCD6fTMWa9YKRbRiWCAmtIT0u8YC0aN9n0rCBhDNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877977; c=relaxed/simple;
	bh=JXybtLkVl+5ofFQgCkavZwDi4Na2ugQXo2+hc8tqmes=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QxyOElhoZK8dBLbZ/vRGa8Lh++VWs0s5m49F5MY4pu4ViEfy+pD7JoR/XWw7u99Tq/7pQJN5isUE9sec3A/oeh8io2KvLoc2H3dd49QBhK/YwtHFTVhSOJPgwKFtb1648QfZvlTPH16Bbco7g3kxYLhKvSgm7J7nx2ZGAqty8Fk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mf2nXS3c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mf2nXS3c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF629C4CEC2;
	Wed,  2 Oct 2024 14:06:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877977;
	bh=JXybtLkVl+5ofFQgCkavZwDi4Na2ugQXo2+hc8tqmes=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mf2nXS3coa6KhcjERcvxxFzmUJtX2E3bmMssDlMf6O1QiGDe92W60WlXOWlCJIHNh
	 /5C0cYy89uRkY7akIBkF2KENYnipuTFgXnQ5NN+aOMcXiUucIVT6gIe80zlBOn+3SU
	 /bkMYBLFr9Jsskjsp3PAcIpGneMEXi2ShTD9Pbf0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Ambardar <tony.ambardar@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 259/634] selftests/bpf: Fix compile if backtrace support missing in libc
Date: Wed,  2 Oct 2024 14:55:59 +0200
Message-ID: <20241002125821.323725498@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index 60c5ec0f6abf6..d5d0cb4eb1975 100644
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



