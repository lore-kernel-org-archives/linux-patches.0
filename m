Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 889DF1EA65;
	Tue,  8 Apr 2025 12:50:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116658; cv=none; b=qFANAdSk6u/+GWv7FibkCDgqPgcfbwsL3/R+oqFxW7G7tk7qMUbtH+aPAHcXkJE5k9Whl89pkkCJaE/mXBKy8fK9B6SqzTJY45LGl7MBqpXeZNB+LF8+DP1nl7EBBdTukTWlHIR3/4yNNp9/b4/gw5JUFykEw+A4jsZTLg9urG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116658; c=relaxed/simple;
	bh=BqEgGPU7jjssAbs7VZ7sfIyGH/quxtJvk6cX5usvwK4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LVLqWqAyBNN3b5B6nFIx6GZC+eDRGEDCYYE2h5ZUEA5WUXbBvPiXkJaFalK0UlPuM0eawzS6jU/e+V+9lZcKc7X9KIgOptg7Kn0WkPOWRSlRe7lzD30n/j0mYWQyQNJV5NagFNOpHDyG2FiQ7RLZUsT7kceY9PLJ/p7anNW/Dcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZH1unNSx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZH1unNSx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10113C4CEE5;
	Tue,  8 Apr 2025 12:50:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116658;
	bh=BqEgGPU7jjssAbs7VZ7sfIyGH/quxtJvk6cX5usvwK4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZH1unNSxQxoNaznyl0Y7TAfxzuWcCgO8lOiVWCMKvzJMQ6+/MCPxw/M85OpMkCfWO
	 hx9KZDob+RNeLXULTz/q2ftX4npMCmCgzvyvJvKMlEL/j7hJ/++v9VYiYgiUkicj4o
	 Hz+ZMA/D3vaORDE54g7olvjtLiErzY1rkw1n2/LA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Richter <tmricht@linux.ibm.com>,
	Sumanth Korikkar <sumanthk@linux.ibm.com>,
	Athira Rajeev <atrajeev@linux.ibm.com>,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 182/423] perf bench: Fix perf bench syscall loop count
Date: Tue,  8 Apr 2025 12:48:28 +0200
Message-ID: <20250408104849.980916114@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Richter <tmricht@linux.ibm.com>

[ Upstream commit 957d194163bf983da98bf7ec7e4f86caff8cd0eb ]

Command 'perf bench syscall fork -l 100000' offers option -l to run for
a specified number of iterations. However this option is not always
observed. The number is silently limited to 10000 iterations as can be
seen:

Output before:
 # perf bench syscall fork -l 100000
 # Running 'syscall/fork' benchmark:
 # Executed 10,000 fork() calls
     Total time: 23.388 [sec]

    2338.809800 usecs/op
            427 ops/sec
 #

When explicitly specified with option -l or --loops, also observe
higher number of iterations:

Output after:
 # perf bench syscall fork -l 100000
 # Running 'syscall/fork' benchmark:
 # Executed 100,000 fork() calls
     Total time: 716.982 [sec]

    7169.829510 usecs/op
            139 ops/sec
 #

This patch fixes the issue for basic execve fork and getpgid.

Fixes: ece7f7c0507c ("perf bench syscall: Add fork syscall benchmark")
Signed-off-by: Thomas Richter <tmricht@linux.ibm.com>
Acked-by: Sumanth Korikkar <sumanthk@linux.ibm.com>
Tested-by: Athira Rajeev <atrajeev@linux.ibm.com>
Cc: Tiezhu Yang <yangtiezhu@loongson.cn>
Link: https://lore.kernel.org/r/20250304092349.2618082-1-tmricht@linux.ibm.com
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/bench/syscall.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/tools/perf/bench/syscall.c b/tools/perf/bench/syscall.c
index ea4dfc07cbd6b..e7dc216f717f5 100644
--- a/tools/perf/bench/syscall.c
+++ b/tools/perf/bench/syscall.c
@@ -22,8 +22,7 @@
 #define __NR_fork -1
 #endif
 
-#define LOOPS_DEFAULT 10000000
-static	int loops = LOOPS_DEFAULT;
+static	int loops;
 
 static const struct option options[] = {
 	OPT_INTEGER('l', "loop",	&loops,		"Specify number of loops"),
@@ -80,6 +79,18 @@ static int bench_syscall_common(int argc, const char **argv, int syscall)
 	const char *name = NULL;
 	int i;
 
+	switch (syscall) {
+	case __NR_fork:
+	case __NR_execve:
+		/* Limit default loop to 10000 times to save time */
+		loops = 10000;
+		break;
+	default:
+		loops = 10000000;
+		break;
+	}
+
+	/* Options -l and --loops override default above */
 	argc = parse_options(argc, argv, options, bench_syscall_usage, 0);
 
 	gettimeofday(&start, NULL);
@@ -94,16 +105,9 @@ static int bench_syscall_common(int argc, const char **argv, int syscall)
 			break;
 		case __NR_fork:
 			test_fork();
-			/* Only loop 10000 times to save time */
-			if (i == 10000)
-				loops = 10000;
 			break;
 		case __NR_execve:
 			test_execve();
-			/* Only loop 10000 times to save time */
-			if (i == 10000)
-				loops = 10000;
-			break;
 		default:
 			break;
 		}
-- 
2.39.5



