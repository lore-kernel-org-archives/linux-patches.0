Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5C78223323;
	Fri, 13 Feb 2026 13:57:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770991033; cv=none; b=TyTeFUxH/XKfrRCQ7Y1mLwresINqZ2yEtiNcP15SgmY37b+UIdROcU6PvMv8vhUCpycs7zuGJj0TrF90sFdQMZoUC0FcPYmbFFbdIQqn9Lj0Pk1EBilnR7u+lQ2vJhXO5ssu9QEhBtVQUT8SfPhGNuN7LBplun9Ew0C/lBXdt5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770991033; c=relaxed/simple;
	bh=J5RbTe1Ci5fCeeeosLuUOumOaMX9xCYBhyfe2M1PYFc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rlrxwGRjtwRuHmdXIDPWQGithkj9tNoR3TkM26hrEAT6H3g8FHqW5sS4wIRcRsoU+pujJYDqy2k66EWLkOA8I6EIoqz5EDRobT98OAiINnBiWYEOfRjBtKMQ3nOHkL17Hq77E9rdPeMq4mqMLYJj3E44bGzWOJJTucjFvONf4Iw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l0E8Hbq+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l0E8Hbq+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A33C2C116C6;
	Fri, 13 Feb 2026 13:57:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770991033;
	bh=J5RbTe1Ci5fCeeeosLuUOumOaMX9xCYBhyfe2M1PYFc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l0E8Hbq+DKW4bHbVWNhuv93jl9RsrEHVCYpvhpccPR7uvE4nI0+UkmalsVFb1vJ8G
	 MuZ/txSOWaIT/YQtVuj4dtiZS3wNZypOQVzTFdbYRLd14gKdHR5MuI9JYXw12KCIgS
	 ngzcPZGCLW/SLvFrRmxZPZaqKs96dHq9vpOIkebo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Shkolnyy <kshk@linux.ibm.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.6 21/25] vsock/test: verify socket options after setting them
Date: Fri, 13 Feb 2026 14:48:47 +0100
Message-ID: <20260213134704.652792073@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260213134703.882698935@linuxfoundation.org>
References: <20260213134703.882698935@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Shkolnyy <kshk@linux.ibm.com>

commit 86814d8ffd55fd4ad19c512eccd721522a370fb2 upstream.

Replace setsockopt() calls with calls to functions that follow
setsockopt() with getsockopt() and check that the returned value and its
size are the same as have been set. (Except in vsock_perf.)

Signed-off-by: Konstantin Shkolnyy <kshk@linux.ibm.com>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
[Stefano: patch needed to avoid vsock test build failure reported by
 Johan Korsnes after backporting commit 0a98de8013696 ("vsock/test: fix
 seqpacket message bounds test") in 6.6-stable tree. Several tests are
 missing here compared to upstream, so this version has been adapted by
 removing some hunks.]
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/vsock/control.c    |    9 --
 tools/testing/vsock/util.c       |  143 +++++++++++++++++++++++++++++++++++++++
 tools/testing/vsock/util.h       |    7 +
 tools/testing/vsock/vsock_test.c |   31 +++-----
 4 files changed, 164 insertions(+), 26 deletions(-)

--- a/tools/testing/vsock/control.c
+++ b/tools/testing/vsock/control.c
@@ -27,6 +27,7 @@
 
 #include "timeout.h"
 #include "control.h"
+#include "util.h"
 
 static int control_fd = -1;
 
@@ -50,7 +51,6 @@ void control_init(const char *control_ho
 
 	for (ai = result; ai; ai = ai->ai_next) {
 		int fd;
-		int val = 1;
 
 		fd = socket(ai->ai_family, ai->ai_socktype, ai->ai_protocol);
 		if (fd < 0)
@@ -65,11 +65,8 @@ void control_init(const char *control_ho
 			break;
 		}
 
-		if (setsockopt(fd, SOL_SOCKET, SO_REUSEADDR,
-			       &val, sizeof(val)) < 0) {
-			perror("setsockopt");
-			exit(EXIT_FAILURE);
-		}
+		setsockopt_int_check(fd, SOL_SOCKET, SO_REUSEADDR, 1,
+				     "setsockopt SO_REUSEADDR");
 
 		if (bind(fd, ai->ai_addr, ai->ai_addrlen) < 0)
 			goto next;
--- a/tools/testing/vsock/util.c
+++ b/tools/testing/vsock/util.c
@@ -12,6 +12,7 @@
 #include <stdint.h>
 #include <stdlib.h>
 #include <signal.h>
+#include <string.h>
 #include <unistd.h>
 #include <assert.h>
 #include <sys/epoll.h>
@@ -420,3 +421,145 @@ unsigned long hash_djb2(const void *data
 
 	return hash;
 }
+
+/* Set "unsigned long long" socket option and check that it's indeed set */
+void setsockopt_ull_check(int fd, int level, int optname,
+			  unsigned long long val, char const *errmsg)
+{
+	unsigned long long chkval;
+	socklen_t chklen;
+	int err;
+
+	err = setsockopt(fd, level, optname, &val, sizeof(val));
+	if (err) {
+		fprintf(stderr, "setsockopt err: %s (%d)\n",
+			strerror(errno), errno);
+		goto fail;
+	}
+
+	chkval = ~val; /* just make storage != val */
+	chklen = sizeof(chkval);
+
+	err = getsockopt(fd, level, optname, &chkval, &chklen);
+	if (err) {
+		fprintf(stderr, "getsockopt err: %s (%d)\n",
+			strerror(errno), errno);
+		goto fail;
+	}
+
+	if (chklen != sizeof(chkval)) {
+		fprintf(stderr, "size mismatch: set %zu got %d\n", sizeof(val),
+			chklen);
+		goto fail;
+	}
+
+	if (chkval != val) {
+		fprintf(stderr, "value mismatch: set %llu got %llu\n", val,
+			chkval);
+		goto fail;
+	}
+	return;
+fail:
+	fprintf(stderr, "%s  val %llu\n", errmsg, val);
+	exit(EXIT_FAILURE);
+;
+}
+
+/* Set "int" socket option and check that it's indeed set */
+void setsockopt_int_check(int fd, int level, int optname, int val,
+			  char const *errmsg)
+{
+	int chkval;
+	socklen_t chklen;
+	int err;
+
+	err = setsockopt(fd, level, optname, &val, sizeof(val));
+	if (err) {
+		fprintf(stderr, "setsockopt err: %s (%d)\n",
+			strerror(errno), errno);
+		goto fail;
+	}
+
+	chkval = ~val; /* just make storage != val */
+	chklen = sizeof(chkval);
+
+	err = getsockopt(fd, level, optname, &chkval, &chklen);
+	if (err) {
+		fprintf(stderr, "getsockopt err: %s (%d)\n",
+			strerror(errno), errno);
+		goto fail;
+	}
+
+	if (chklen != sizeof(chkval)) {
+		fprintf(stderr, "size mismatch: set %zu got %d\n", sizeof(val),
+			chklen);
+		goto fail;
+	}
+
+	if (chkval != val) {
+		fprintf(stderr, "value mismatch: set %d got %d\n", val, chkval);
+		goto fail;
+	}
+	return;
+fail:
+	fprintf(stderr, "%s val %d\n", errmsg, val);
+	exit(EXIT_FAILURE);
+}
+
+static void mem_invert(unsigned char *mem, size_t size)
+{
+	size_t i;
+
+	for (i = 0; i < size; i++)
+		mem[i] = ~mem[i];
+}
+
+/* Set "timeval" socket option and check that it's indeed set */
+void setsockopt_timeval_check(int fd, int level, int optname,
+			      struct timeval val, char const *errmsg)
+{
+	struct timeval chkval;
+	socklen_t chklen;
+	int err;
+
+	err = setsockopt(fd, level, optname, &val, sizeof(val));
+	if (err) {
+		fprintf(stderr, "setsockopt err: %s (%d)\n",
+			strerror(errno), errno);
+		goto fail;
+	}
+
+	 /* just make storage != val */
+	chkval = val;
+	mem_invert((unsigned char *)&chkval, sizeof(chkval));
+	chklen = sizeof(chkval);
+
+	err = getsockopt(fd, level, optname, &chkval, &chklen);
+	if (err) {
+		fprintf(stderr, "getsockopt err: %s (%d)\n",
+			strerror(errno), errno);
+		goto fail;
+	}
+
+	if (chklen != sizeof(chkval)) {
+		fprintf(stderr, "size mismatch: set %zu got %d\n", sizeof(val),
+			chklen);
+		goto fail;
+	}
+
+	if (memcmp(&chkval, &val, sizeof(val)) != 0) {
+		fprintf(stderr, "value mismatch: set %ld:%ld got %ld:%ld\n",
+			val.tv_sec, val.tv_usec, chkval.tv_sec, chkval.tv_usec);
+		goto fail;
+	}
+	return;
+fail:
+	fprintf(stderr, "%s val %ld:%ld\n", errmsg, val.tv_sec, val.tv_usec);
+	exit(EXIT_FAILURE);
+}
+
+void enable_so_zerocopy_check(int fd)
+{
+	setsockopt_int_check(fd, SOL_SOCKET, SO_ZEROCOPY, 1,
+			     "setsockopt SO_ZEROCOPY");
+}
--- a/tools/testing/vsock/util.h
+++ b/tools/testing/vsock/util.h
@@ -50,4 +50,11 @@ void list_tests(const struct test_case *
 void skip_test(struct test_case *test_cases, size_t test_cases_len,
 	       const char *test_id_str);
 unsigned long hash_djb2(const void *data, size_t len);
+void setsockopt_ull_check(int fd, int level, int optname,
+			  unsigned long long val, char const *errmsg);
+void setsockopt_int_check(int fd, int level, int optname, int val,
+			  char const *errmsg);
+void setsockopt_timeval_check(int fd, int level, int optname,
+			      struct timeval val, char const *errmsg);
+void enable_so_zerocopy_check(int fd);
 #endif /* UTIL_H */
--- a/tools/testing/vsock/vsock_test.c
+++ b/tools/testing/vsock/vsock_test.c
@@ -503,17 +503,13 @@ static void test_seqpacket_msg_bounds_se
 
 	sock_buf_size = SOCK_BUF_SIZE;
 
-	if (setsockopt(fd, AF_VSOCK, SO_VM_SOCKETS_BUFFER_MAX_SIZE,
-		       &sock_buf_size, sizeof(sock_buf_size))) {
-		perror("setsockopt(SO_VM_SOCKETS_BUFFER_MAX_SIZE)");
-		exit(EXIT_FAILURE);
-	}
-
-	if (setsockopt(fd, AF_VSOCK, SO_VM_SOCKETS_BUFFER_SIZE,
-		       &sock_buf_size, sizeof(sock_buf_size))) {
-		perror("setsockopt(SO_VM_SOCKETS_BUFFER_SIZE)");
-		exit(EXIT_FAILURE);
-	}
+	setsockopt_ull_check(fd, AF_VSOCK, SO_VM_SOCKETS_BUFFER_MAX_SIZE,
+			     sock_buf_size,
+			     "setsockopt(SO_VM_SOCKETS_BUFFER_MAX_SIZE)");
+
+	setsockopt_ull_check(fd, AF_VSOCK, SO_VM_SOCKETS_BUFFER_SIZE,
+			     sock_buf_size,
+			     "setsockopt(SO_VM_SOCKETS_BUFFER_SIZE)");
 
 	/* Ready to receive data. */
 	control_writeln("SRVREADY");
@@ -648,10 +644,8 @@ static void test_seqpacket_timeout_clien
 	tv.tv_sec = RCVTIMEO_TIMEOUT_SEC;
 	tv.tv_usec = 0;
 
-	if (setsockopt(fd, SOL_SOCKET, SO_RCVTIMEO, (void *)&tv, sizeof(tv)) == -1) {
-		perror("setsockopt(SO_RCVTIMEO)");
-		exit(EXIT_FAILURE);
-	}
+	setsockopt_timeval_check(fd, SOL_SOCKET, SO_RCVTIMEO, tv,
+				 "setsockopt(SO_RCVTIMEO)");
 
 	read_enter_ns = current_nsec();
 
@@ -928,11 +922,8 @@ static void test_stream_poll_rcvlowat_cl
 		exit(EXIT_FAILURE);
 	}
 
-	if (setsockopt(fd, SOL_SOCKET, SO_RCVLOWAT,
-		       &lowat_val, sizeof(lowat_val))) {
-		perror("setsockopt(SO_RCVLOWAT)");
-		exit(EXIT_FAILURE);
-	}
+	setsockopt_int_check(fd, SOL_SOCKET, SO_RCVLOWAT,
+			     lowat_val, "setsockopt(SO_RCVLOWAT)");
 
 	control_expectln("SRVSENT");
 


