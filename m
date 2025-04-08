Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33442268FCB;
	Tue,  8 Apr 2025 11:26:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111580; cv=none; b=bVwIx+EQp2wp/WSrLI6LP54fgfrILcDHw0DtOLU5RtBqvEK5F2qZKBub62Ck5RL7s62m1v7AsqWpYaX7fGnW/3f3g15bwEbPE0d/JtQk79toghntVmYOZ6lYCsSEceBj7E3mZKvrKJEYXqJVanqgW4whJ582dOGtbKoe5qX2qlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111580; c=relaxed/simple;
	bh=moQ0S3YMKWO8WthcBzdqOQFo8zfBsFI5kmiokhEf+8Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=apbMaq/e1224Z1NwMxbPr+uTpoWqE5nkAXxWZAn/mBzAM5uVVj5oIVuJ0RX+HmbYgyyBjlKweZRm50RW0n6GioGvLewTQNQNQr/dqerVWkFqRyNczsOYuB42Xd03mDE/JOuBA3i2reg+rNBxKLqhEyv8BGZjurkifOnSvhcF5XA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vQe2TlkY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vQe2TlkY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5163C4CEE5;
	Tue,  8 Apr 2025 11:26:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111580;
	bh=moQ0S3YMKWO8WthcBzdqOQFo8zfBsFI5kmiokhEf+8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vQe2TlkYdM3VZ11pyf2X8It+6xKQsmYwlKuyi+MS1wFymZA/PlxAVTzLcYKb74bt3
	 712ItSTB6pnwRaIa3mx+6rBrS4IeLD3D9XaSg9LQaS2FAbODyJQEaUjv6fw60M276M
	 UomxgzaAdaMarRndh4JXtxLnTWPhkhr44gC5+GPg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Yan <leo.yan@arm.com>,
	Thomas Richter <tmricht@linux.ibm.com>,
	Thomas Falcon <thomas.falcon@intel.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 483/731] perf test: Add timeout to datasym workload
Date: Tue,  8 Apr 2025 12:46:20 +0200
Message-ID: <20250408104925.511605835@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namhyung Kim <namhyung@kernel.org>

[ Upstream commit f04c7ef35256beea57a598a7ea06dd2242ae9ae6 ]

Unlike others it has an infinite loop that make it annoying to call.
Make it finish after 1 second and handle command-line argument to change
the setting.

Reviewed-by: Leo Yan <leo.yan@arm.com>
Tested-by: Thomas Richter <tmricht@linux.ibm.com>
Tested-by: Thomas Falcon <thomas.falcon@intel.com>
Cc: Thomas Richter <tmricht@linux.ibm.com>
Cc: Leo Yan <leo.yan@arm.com>
Link: https://lore.kernel.org/r/20250304022837.1877845-6-namhyung@kernel.org
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Stable-dep-of: 36e7748d33bf ("perf tests: Fix data symbol test with LTO builds")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/workloads/datasym.c | 23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/tools/perf/tests/workloads/datasym.c b/tools/perf/tests/workloads/datasym.c
index 8e08fc75a973e..8ddb2aa6a049e 100644
--- a/tools/perf/tests/workloads/datasym.c
+++ b/tools/perf/tests/workloads/datasym.c
@@ -1,3 +1,6 @@
+#include <stdlib.h>
+#include <signal.h>
+#include <unistd.h>
 #include <linux/compiler.h>
 #include "../tests.h"
 
@@ -12,9 +15,25 @@ static buf buf1 = {
 	.reserved[0] = 1,
 };
 
-static int datasym(int argc __maybe_unused, const char **argv __maybe_unused)
+static volatile sig_atomic_t done;
+
+static void sighandler(int sig __maybe_unused)
+{
+	done = 1;
+}
+
+static int datasym(int argc, const char **argv)
 {
-	for (;;) {
+	int sec = 1;
+
+	if (argc > 0)
+		sec = atoi(argv[0]);
+
+	signal(SIGINT, sighandler);
+	signal(SIGALRM, sighandler);
+	alarm(sec);
+
+	while (!done) {
 		buf1.data1++;
 		if (buf1.data1 == 123) {
 			/*
-- 
2.39.5



