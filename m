Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1F461AB517;
	Mon, 14 Oct 2024 14:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917991; cv=none; b=t8gfrVHRpxIMGZiajocWuvhzhEEgIFSeY8/aaiSjAtyXTEiyzqXZnXxSUcoBgfZKwytBhOlSW0GqfbZcNfo6qBGZpuuiscpB/Kd4fRsDggV7KRo2pJ+f9eZi9D0AewzAjyan3x39YVaNXlRhkrlfuueaC/hBUvybO7iOGeYTuXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917991; c=relaxed/simple;
	bh=4cRGyAbI3rAwaH7+J4GXM5nzRAa3SkKEkUGNHxdOj2E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W2b+PzEfSoj5mywhCQeYjhAIQXtCDoj+LOK+otfaVtJCKyFBw5Bc+REg4PVx1ywpxG/6DLWayIy8rJS1ll199K0inaQITwdNuVohgH6lqL5DIVEBwbCRVcXkAoHuKTRGCWNXtcY3oumeZ71vWPwxONvJQcbVGxCMTGEmt/CZClw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k+nEDaBy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k+nEDaBy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0BD4C4CEC3;
	Mon, 14 Oct 2024 14:59:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917991;
	bh=4cRGyAbI3rAwaH7+J4GXM5nzRAa3SkKEkUGNHxdOj2E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k+nEDaByt1SN1JfZ6cE0nFnaYBfvj2DOsnsj2L97WvkMkukVUDXXTcQ8e3c5wmX+s
	 nST+4GRHrfo2z5Dz/8/rB/XLpiIJTTd2noimL41FA+pu+pAZq14wTbCfAg1TCdoAb1
	 4egyhCU690xdszv9I+adWQhSRjvVSIypt31igm8U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Ambardar <tony.ambardar@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 160/798] selftests/bpf: Fix compile if backtrace support missing in libc
Date: Mon, 14 Oct 2024 16:11:54 +0200
Message-ID: <20241014141224.202773944@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index e78289b72739f..11d4c51c7d211 100644
--- a/tools/testing/selftests/bpf/test_progs.c
+++ b/tools/testing/selftests/bpf/test_progs.c
@@ -10,13 +10,27 @@
 #include <sched.h>
 #include <signal.h>
 #include <string.h>
-#include <execinfo.h> /* backtrace */
 #include <sys/sysinfo.h> /* get_nprocs */
 #include <netinet/in.h>
 #include <sys/select.h>
 #include <sys/socket.h>
 #include <sys/un.h>
 
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



