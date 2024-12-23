Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C92B13BC0C;
	Mon, 23 Dec 2024 16:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970067; cv=none; b=YfliNkXtwWFLGU5I5Jt5huBq69Kt8/EY+k/AFq3CDw7x1u+zvVIuzEYQrKlV1As9F0DubQYi1WboGACuaoCnfOp/fgWwJju3ffIEs3MyUcl4eFTyXir7GeNokftNJ238874v89c2iC26Mm5WFM7murY13Tvwl/mnJcsUsU8fGDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970067; c=relaxed/simple;
	bh=NkXV+M9tdckD4BMSPIu3/WqMIpYWnsJ7TiHHWratY2Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HlBoWOq84Kvj7UMJBTvkVJ6QlMikBqFi8GyAXL8/JQj7iXSZw43IpPzX5T1yx90ku/oaG1E2pU6tlpw8L4o0sz9U0XEeriTRHRtCuwf9GNTU4HMo2UGdeQhXTaX1ljSqULeuDwplcYLlDXPFysK5eTtWH/CnebYrU22U5smUXL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o2seAzAT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o2seAzAT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83873C4CED3;
	Mon, 23 Dec 2024 16:07:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970066;
	bh=NkXV+M9tdckD4BMSPIu3/WqMIpYWnsJ7TiHHWratY2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o2seAzATq8/6ii2EFlr0jc1XaiE0DZa/ROrNUtx8/6bMjYI3DmLjzBp6LNr4WmzWa
	 aKrwR54Jidq7qCXLQzjKc6HSBAPOPZ2ar27vjedR94x6cf1h4bkvUCIn6F2trAaCTW
	 DAvdoMxvo0VLS0AkcLgJ0w+CiCjJET2BVEE4YPt8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Isaac J. Manjarres" <isaacmanjarres@google.com>,
	Jeff Xu <jeffxu@google.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Kalesh Singh <kaleshsingh@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 134/160] selftests/memfd: run sysctl tests when PID namespace support is enabled
Date: Mon, 23 Dec 2024 16:59:05 +0100
Message-ID: <20241223155413.963771777@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155408.598780301@linuxfoundation.org>
References: <20241223155408.598780301@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Isaac J. Manjarres <isaacmanjarres@google.com>

commit 6a75f19af16ff482cfd6085c77123aa0f464f8dd upstream.

The sysctl tests for vm.memfd_noexec rely on the kernel to support PID
namespaces (i.e.  the kernel is built with CONFIG_PID_NS=y).  If the
kernel the test runs on does not support PID namespaces, the first sysctl
test will fail when attempting to spawn a new thread in a new PID
namespace, abort the test, preventing the remaining tests from being run.

This is not desirable, as not all kernels need PID namespaces, but can
still use the other features provided by memfd.  Therefore, only run the
sysctl tests if the kernel supports PID namespaces.  Otherwise, skip those
tests and emit an informative message to let the user know why the sysctl
tests are not being run.

Link: https://lkml.kernel.org/r/20241205192943.3228757-1-isaacmanjarres@google.com
Fixes: 11f75a01448f ("selftests/memfd: add tests for MFD_NOEXEC_SEAL MFD_EXEC")
Signed-off-by: Isaac J. Manjarres <isaacmanjarres@google.com>
Reviewed-by: Jeff Xu <jeffxu@google.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: <stable@vger.kernel.org>	[6.6+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/memfd/memfd_test.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/memfd/memfd_test.c
+++ b/tools/testing/selftests/memfd/memfd_test.c
@@ -9,6 +9,7 @@
 #include <fcntl.h>
 #include <linux/memfd.h>
 #include <sched.h>
+#include <stdbool.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <signal.h>
@@ -1557,6 +1558,11 @@ static void test_share_fork(char *banner
 	close(fd);
 }
 
+static bool pid_ns_supported(void)
+{
+	return access("/proc/self/ns/pid", F_OK) == 0;
+}
+
 int main(int argc, char **argv)
 {
 	pid_t pid;
@@ -1591,8 +1597,12 @@ int main(int argc, char **argv)
 	test_seal_grow();
 	test_seal_resize();
 
-	test_sysctl_simple();
-	test_sysctl_nested();
+	if (pid_ns_supported()) {
+		test_sysctl_simple();
+		test_sysctl_nested();
+	} else {
+		printf("PID namespaces are not supported; skipping sysctl tests\n");
+	}
 
 	test_share_dup("SHARE-DUP", "");
 	test_share_mmap("SHARE-MMAP", "");


