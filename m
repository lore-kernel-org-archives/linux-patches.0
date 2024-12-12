Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 091C922371A;
	Thu, 12 Dec 2024 16:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019214; cv=none; b=C3/riTL4t6TzZoNhjJc5fwkQUHQjecCs8Tq1SwwKKi2DCwVjjutTAtAlseMxVoqv9VaWzs2j7zqHyQnNAcBaIBKtSrH5DzZaQpa5dSwaFNFpdBOkK4ztfOehyJ7hNa8hHMjpXEm5JGk9WDxo3magaFUwu+DXaLA+eNBQGoKkQxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019214; c=relaxed/simple;
	bh=kYagJ4ppruJgk7fRxdSCymeHQ60KtSf1QWRhZFs/jkk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fUVCZInUqvpO3fGYE+8pIt5T1EY7ZCwWv+ZoyuytKOUmLnE8IDdbpjdFg++nNv9Qz16mVgKxFg5jeSzXBytaQf67gDRhKVC6SArQNwGNksvPGmJe80qwT2dH7KscSMSdUcaBAnJ9TJcCYbbvj88K9eMLcL1x+a7+6iLdU9EjVgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zR08EhBf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zR08EhBf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E22CC4CECE;
	Thu, 12 Dec 2024 16:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019213;
	bh=kYagJ4ppruJgk7fRxdSCymeHQ60KtSf1QWRhZFs/jkk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zR08EhBfu6am6BpH7aMUdF895bT+fdjYSs98I8a2IOwTxbaoBmLIjZdhLrxpQxXBE
	 +uZU1Mv3i9FS8YXLn1pifN4vENUNiSOfLb0N90uavUlVY/nAk5IXQ2pku5MwgE/RIx
	 FqA2jm1ze2dCoO1kacB+oQyWTBtyrZ4GEzlOTWBo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eduard Zingerman <eddyz87@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Tony Ambardar <tony.ambardar@gmail.com>,
	Daniel Xu <dxu@dxuuu.xyz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 148/772] selftests/bpf: Fix backtrace printing for selftests crashes
Date: Thu, 12 Dec 2024 15:51:33 +0100
Message-ID: <20241212144356.055634072@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

From: Eduard Zingerman <eddyz87@gmail.com>

[ Upstream commit 5bf1557e3d6a69113649d831276ea2f97585fc33 ]

test_progs uses glibc specific functions backtrace() and
backtrace_symbols_fd() to print backtrace in case of SIGSEGV.

Recent commit (see fixes) updated test_progs.c to define stub versions
of the same functions with attriubte "weak" in order to allow linking
test_progs against musl libc. Unfortunately this broke the backtrace
handling for glibc builds.

As it turns out, glibc defines backtrace() and backtrace_symbols_fd()
as weak:

  $ llvm-readelf --symbols /lib64/libc.so.6 \
     | grep -P '( backtrace_symbols_fd| backtrace)$'
  4910: 0000000000126b40   161 FUNC    WEAK   DEFAULT    16 backtrace
  6843: 0000000000126f90   852 FUNC    WEAK   DEFAULT    16 backtrace_symbols_fd

So does test_progs:

 $ llvm-readelf --symbols test_progs \
    | grep -P '( backtrace_symbols_fd| backtrace)$'
  2891: 00000000006ad190    15 FUNC    WEAK   DEFAULT    13 backtrace
 11215: 00000000006ad1a0    41 FUNC    WEAK   DEFAULT    13 backtrace_symbols_fd

In such situation dynamic linker is not obliged to favour glibc
implementation over the one defined in test_progs.

Compiling with the following simple modification to test_progs.c
demonstrates the issue:

  $ git diff
  ...
  \--- a/tools/testing/selftests/bpf/test_progs.c
  \+++ b/tools/testing/selftests/bpf/test_progs.c
  \@@ -1817,6 +1817,7 @@ int main(int argc, char **argv)
          if (err)
                  return err;

  +       *(int *)0xdeadbeef  = 42;
          err = cd_flavor_subdir(argv[0]);
          if (err)
                  return err;

  $ ./test_progs
  [0]: Caught signal #11!
  Stack trace:
  <backtrace not supported>
  Segmentation fault (core dumped)

Resolve this by hiding stub definitions behind __GLIBC__ macro check
instead of using "weak" attribute.

Fixes: c9a83e76b5a9 ("selftests/bpf: Fix compile if backtrace support missing in libc")
Signed-off-by: Eduard Zingerman <eddyz87@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Tested-by: Tony Ambardar <tony.ambardar@gmail.com>
Reviewed-by: Tony Ambardar <tony.ambardar@gmail.com>
Acked-by: Daniel Xu <dxu@dxuuu.xyz>
Link: https://lore.kernel.org/bpf/20241003210307.3847907-1-eddyz87@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/test_progs.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_progs.c b/tools/testing/selftests/bpf/test_progs.c
index 11d4c51c7d211..6068f5bde8fd5 100644
--- a/tools/testing/selftests/bpf/test_progs.c
+++ b/tools/testing/selftests/bpf/test_progs.c
@@ -16,11 +16,13 @@
 #include <sys/socket.h>
 #include <sys/un.h>
 
+/* backtrace() and backtrace_symbols_fd() are glibc specific,
+ * use header file when glibc is available and provide stub
+ * implementations when another libc implementation is used.
+ */
 #ifdef __GLIBC__
 #include <execinfo.h> /* backtrace */
-#endif
-
-/* Default backtrace funcs if missing at link */
+#else
 __weak int backtrace(void **buffer, int size)
 {
 	return 0;
@@ -30,6 +32,7 @@ __weak void backtrace_symbols_fd(void *const *buffer, int size, int fd)
 {
 	dprintf(fd, "<backtrace not supported>\n");
 }
+#endif /*__GLIBC__ */
 
 static bool verbose(void)
 {
-- 
2.43.0



