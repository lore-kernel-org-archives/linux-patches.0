Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B74803603D5;
	Sat, 12 Sep 2026 16:41:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789231289; cv=none; b=fiIgx2BulTUYfATElOrvLkv8NHssOzLhtuepkCgfcrCqEhJ8sPTX9GaRYWsWq0AGCD4NAaquiYWKqW0C9Pl8NXxjKwaz20vx5ZjjG+lrfNDLwa1R4oCyhfgO47lbwaFfGeVhpjk04+u4pH511ibVrHxfbn6bTQRz5OcT0cj1svE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789231289; c=relaxed/simple;
	bh=dgOh/wM8g5NWMRalD/ITG4Y+94+Fd2K345PXUJCizqU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C++GnBvWkAjrdbqivxgKkp7K8TpSIo0hcO1XCC2N845hnUVv8qNq9iizHTloYRKX8bgTk1Dvslpu0LjwCraCZFn0k8E1iSGhwk0NlaQxrOi1K67YqbF/RLKQT6WDafXzp6OVBkpBfGvSVZSS/gXX5mdDvd9YcaYV3ByzL+JVrB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fpPdLCnK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fpPdLCnK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 571C01F000FF;
	Sat, 12 Sep 2026 16:41:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789231288;
	bh=qJ+9JapMRa8luakTecpfufaRK8zJXFQ5/7T9NEGbIyc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fpPdLCnK9v4V2fCK/ZgsuJZqkq9TjsLgjMfS828ekH8S+CEgDiYz+/bzNCDMY932h
	 1LZc/QBfc8Rs/zc7vq/xhNxjfNc2ICtzvQAQ41WOdUNHsPytVZyGaNjcIid8v4TCNc
	 j41r5co8fe0hYxb63WPGe9oerTSZoDXdoS3AEL5E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tanushree Shah <tshah@linux.ibm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0925/1191] perf trace-event: Fix integer truncation in do_read() and skip()
Date: Sat, 12 Sep 2026 09:00:53 +0200
Message-ID: <20260912065609.007453677@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Tanushree Shah <tshah@linux.ibm.com>

[ Upstream commit c108c1391be0826920991d24532fbae8f6373ddc ]

The do_read() and skip() functions use 'int' for size parameters,
truncating 64-bit sizes from callers. This causes two issues:

1. Uninitialized memory dump: do_read() reads fewer bytes than
   allocated, leaving uninitialized heap memory that gets written
   to output files.

2. Out-of-bounds read: Parsing functions process the full 64-bit
   size while only partial data was read into the buffer.

Change do_read(), __do_read(), and skip() to use size_t for size
parameters and ssize_t for return values (where applicable), matching
read()/write() system calls.
Update callers to use ssize_t for storing return values.

Fixes: 4a31e56599d4 ("perf tools: Get rid of read_or_die() in trace-event-read.c")
Signed-off-by: Tanushree Shah <tshah@linux.ibm.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/trace-event-read.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/tools/perf/util/trace-event-read.c b/tools/perf/util/trace-event-read.c
index fd44de3cb873b..18ec18ec24ce0 100644
--- a/tools/perf/util/trace-event-read.c
+++ b/tools/perf/util/trace-event-read.c
@@ -23,18 +23,18 @@ static int input_fd;
 static ssize_t trace_data_size;
 static bool repipe;
 
-static int __do_read(int fd, void *buf, int size)
+static ssize_t __do_read(int fd, void *buf, size_t size)
 {
-	int rsize = size;
+	size_t rsize = size;
 
 	while (size) {
-		int ret = read(fd, buf, size);
+		ssize_t ret = read(fd, buf, size);
 
 		if (ret <= 0)
 			return -1;
 
 		if (repipe) {
-			int retw = write(STDOUT_FILENO, buf, ret);
+			ssize_t retw = write(STDOUT_FILENO, buf, ret);
 
 			if (retw <= 0 || retw != ret) {
 				pr_debug("repiping input file");
@@ -49,13 +49,13 @@ static int __do_read(int fd, void *buf, int size)
 	return rsize;
 }
 
-static int do_read(void *data, int size)
+static ssize_t do_read(void *data, size_t size)
 {
-	int r;
+	ssize_t r;
 
 	r = __do_read(input_fd, data, size);
 	if (r <= 0) {
-		pr_debug("reading input file (size expected=%d received=%d)",
+		pr_debug("reading input file (size expected=%zu received=%zd)",
 			 size, r);
 		return -1;
 	}
@@ -66,10 +66,10 @@ static int do_read(void *data, int size)
 }
 
 /* If it fails, the next read will report it */
-static void skip(int size)
+static void skip(size_t size)
 {
 	char buf[BUFSIZ];
-	int r;
+	size_t r;
 
 	while (size) {
 		r = size > BUFSIZ ? BUFSIZ : size;
@@ -200,7 +200,7 @@ static int read_header_files(struct tep_handle *pevent)
 	unsigned long long size;
 	char *header_page;
 	char buf[BUFSIZ];
-	int ret = 0;
+	ssize_t ret = 0;
 
 	if (do_read(buf, 12) < 0)
 		return -1;
@@ -248,7 +248,7 @@ static int read_header_files(struct tep_handle *pevent)
 
 static int read_ftrace_file(struct tep_handle *pevent, unsigned long long size)
 {
-	int ret;
+	ssize_t ret;
 	char *buf;
 
 	buf = malloc(size);
@@ -274,7 +274,7 @@ static int read_ftrace_file(struct tep_handle *pevent, unsigned long long size)
 static int read_event_file(struct tep_handle *pevent, char *sys,
 			   unsigned long long size)
 {
-	int ret;
+	ssize_t ret;
 	char *buf;
 
 	buf = malloc(size);
@@ -320,7 +320,7 @@ static int read_event_files(struct tep_handle *pevent)
 	int systems;
 	int count;
 	int i,x;
-	int ret;
+	ssize_t ret;
 
 	systems = read4(pevent);
 
@@ -348,7 +348,7 @@ static int read_saved_cmdline(struct tep_handle *pevent)
 {
 	unsigned long long size;
 	char *buf;
-	int ret;
+	ssize_t ret;
 
 	/* it can have 0 size */
 	size = read8(pevent);
-- 
2.53.0



