Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44FEFDF40
	for <patches@lists.linux.dev>; Mon, 15 May 2023 16:37:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A6A3C433EF;
	Mon, 15 May 2023 16:37:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684168633;
	bh=GlLKchtGOYLvwPcxXBP/qDaJ5S5fsUO1cK/Slfo2m6Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lf433/7lq3vFyTxnmMYdOetD1vqaeEbXlCCF5hc6OJE4BcrrCHXrdzjCOta7qBhO9
	 pT6hvff/r8GrOIVG24OyHUB9xFi+vLOEuG4XOcnUfow+R/24jA6CTqxgvB8BH8ivVD
	 DyG6lhV4ufIgnyXc3n0WKKL/FOzmNgcGDlcBlVJw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Jiri Olsa <jolsa@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	=?UTF-8?q?Daniel=20D=C3=ADaz?= <daniel.diaz@linaro.org>
Subject: [PATCH 4.14 111/116] perf bench: Share some global variables to fix build with gcc 10
Date: Mon, 15 May 2023 18:26:48 +0200
Message-Id: <20230515161701.922956299@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161658.228491273@linuxfoundation.org>
References: <20230515161658.228491273@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit e4d9b04b973b2dbce7b42af95ea70d07da1c936d ]

Noticed with gcc 10 (fedora rawhide) that those variables were not being
declared as static, so end up with:

  ld: /tmp/build/perf/bench/epoll-wait.o:/git/perf/tools/perf/bench/epoll-wait.c:93: multiple definition of `end'; /tmp/build/perf/bench/futex-hash.o:/git/perf/tools/perf/bench/futex-hash.c:40: first defined here
  ld: /tmp/build/perf/bench/epoll-wait.o:/git/perf/tools/perf/bench/epoll-wait.c:93: multiple definition of `start'; /tmp/build/perf/bench/futex-hash.o:/git/perf/tools/perf/bench/futex-hash.c:40: first defined here
  ld: /tmp/build/perf/bench/epoll-wait.o:/git/perf/tools/perf/bench/epoll-wait.c:93: multiple definition of `runtime'; /tmp/build/perf/bench/futex-hash.o:/git/perf/tools/perf/bench/futex-hash.c:40: first defined here
  ld: /tmp/build/perf/bench/epoll-ctl.o:/git/perf/tools/perf/bench/epoll-ctl.c:38: multiple definition of `end'; /tmp/build/perf/bench/futex-hash.o:/git/perf/tools/perf/bench/futex-hash.c:40: first defined here
  ld: /tmp/build/perf/bench/epoll-ctl.o:/git/perf/tools/perf/bench/epoll-ctl.c:38: multiple definition of `start'; /tmp/build/perf/bench/futex-hash.o:/git/perf/tools/perf/bench/futex-hash.c:40: first defined here
  ld: /tmp/build/perf/bench/epoll-ctl.o:/git/perf/tools/perf/bench/epoll-ctl.c:38: multiple definition of `runtime'; /tmp/build/perf/bench/futex-hash.o:/git/perf/tools/perf/bench/futex-hash.c:40: first defined here
  make[4]: *** [/git/perf/tools/build/Makefile.build:145: /tmp/build/perf/bench/perf-in.o] Error 1

Prefix those with bench__ and add them to bench/bench.h, so that we can
share those on the tools needing to access those variables from signal
handlers.

Acked-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: http://lore.kernel.org/lkml/20200303155811.GD13702@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Daniel Díaz <daniel.diaz@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/bench/bench.h         |    4 ++++
 tools/perf/bench/futex-hash.c    |   12 ++++++------
 tools/perf/bench/futex-lock-pi.c |   11 +++++------
 3 files changed, 15 insertions(+), 12 deletions(-)

--- a/tools/perf/bench/bench.h
+++ b/tools/perf/bench/bench.h
@@ -2,6 +2,10 @@
 #ifndef BENCH_H
 #define BENCH_H
 
+#include <sys/time.h>
+
+extern struct timeval bench__start, bench__end, bench__runtime;
+
 /*
  * The madvise transparent hugepage constants were added in glibc
  * 2.13. For compatibility with older versions of glibc, define these
--- a/tools/perf/bench/futex-hash.c
+++ b/tools/perf/bench/futex-hash.c
@@ -35,7 +35,7 @@ static unsigned int nfutexes = 1024;
 static bool fshared = false, done = false, silent = false;
 static int futex_flag = 0;
 
-struct timeval start, end, runtime;
+struct timeval bench__start, bench__end, bench__runtime;
 static pthread_mutex_t thread_lock;
 static unsigned int threads_starting;
 static struct stats throughput_stats;
@@ -101,8 +101,8 @@ static void toggle_done(int sig __maybe_
 {
 	/* inform all threads that we're done for the day */
 	done = true;
-	gettimeofday(&end, NULL);
-	timersub(&end, &start, &runtime);
+	gettimeofday(&bench__end, NULL);
+	timersub(&bench__end, &bench__start, &bench__runtime);
 }
 
 static void print_summary(void)
@@ -112,7 +112,7 @@ static void print_summary(void)
 
 	printf("%sAveraged %ld operations/sec (+- %.2f%%), total secs = %d\n",
 	       !silent ? "\n" : "", avg, rel_stddev_stats(stddev, avg),
-	       (int) runtime.tv_sec);
+	       (int)bench__runtime.tv_sec);
 }
 
 int bench_futex_hash(int argc, const char **argv)
@@ -156,7 +156,7 @@ int bench_futex_hash(int argc, const cha
 
 	threads_starting = nthreads;
 	pthread_attr_init(&thread_attr);
-	gettimeofday(&start, NULL);
+	gettimeofday(&bench__start, NULL);
 	for (i = 0; i < nthreads; i++) {
 		worker[i].tid = i;
 		worker[i].futex = calloc(nfutexes, sizeof(*worker[i].futex));
@@ -199,7 +199,7 @@ int bench_futex_hash(int argc, const cha
 	pthread_mutex_destroy(&thread_lock);
 
 	for (i = 0; i < nthreads; i++) {
-		unsigned long t = worker[i].ops/runtime.tv_sec;
+		unsigned long t = worker[i].ops / bench__runtime.tv_sec;
 		update_stats(&throughput_stats, t);
 		if (!silent) {
 			if (nfutexes == 1)
--- a/tools/perf/bench/futex-lock-pi.c
+++ b/tools/perf/bench/futex-lock-pi.c
@@ -34,7 +34,6 @@ static bool silent = false, multi = fals
 static bool done = false, fshared = false;
 static unsigned int ncpus, nthreads = 0;
 static int futex_flag = 0;
-struct timeval start, end, runtime;
 static pthread_mutex_t thread_lock;
 static unsigned int threads_starting;
 static struct stats throughput_stats;
@@ -61,7 +60,7 @@ static void print_summary(void)
 
 	printf("%sAveraged %ld operations/sec (+- %.2f%%), total secs = %d\n",
 	       !silent ? "\n" : "", avg, rel_stddev_stats(stddev, avg),
-	       (int) runtime.tv_sec);
+	       (int)bench__runtime.tv_sec);
 }
 
 static void toggle_done(int sig __maybe_unused,
@@ -70,8 +69,8 @@ static void toggle_done(int sig __maybe_
 {
 	/* inform all threads that we're done for the day */
 	done = true;
-	gettimeofday(&end, NULL);
-	timersub(&end, &start, &runtime);
+	gettimeofday(&bench__end, NULL);
+	timersub(&bench__end, &bench__start, &bench__runtime);
 }
 
 static void *workerfn(void *arg)
@@ -178,7 +177,7 @@ int bench_futex_lock_pi(int argc, const
 
 	threads_starting = nthreads;
 	pthread_attr_init(&thread_attr);
-	gettimeofday(&start, NULL);
+	gettimeofday(&bench__start, NULL);
 
 	create_threads(worker, thread_attr);
 	pthread_attr_destroy(&thread_attr);
@@ -204,7 +203,7 @@ int bench_futex_lock_pi(int argc, const
 	pthread_mutex_destroy(&thread_lock);
 
 	for (i = 0; i < nthreads; i++) {
-		unsigned long t = worker[i].ops/runtime.tv_sec;
+		unsigned long t = worker[i].ops / bench__runtime.tv_sec;
 
 		update_stats(&throughput_stats, t);
 		if (!silent)


