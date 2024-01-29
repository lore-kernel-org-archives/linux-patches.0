Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0C8C15A4B9;
	Mon, 29 Jan 2024 17:09:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548146; cv=none; b=lzQhwG396xQ8hqABejWNtvMs7nDn6PWsUCk7nDC2fw1Mz1MvjyXWpBMKUo68W/VMN0oiOxWzOkjUocx7tfwYTxjDd9eMSIfoKf8ZGEwlYOnCAfvKD/ihKFNBFhgwYU91LN35W1yTCLpXgs1CnZV1ZBejWRveuyWMQrgSlA7M03g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548146; c=relaxed/simple;
	bh=k2NZX2q+6f0ywMU+LhI/6/GT7i76Wf2TkDKHQr5jLLs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j/y5n+WEq7JIrdXRxWlqIzBJ33YLIlF5uQqoYPrq24tfEo4PVIFNoK80cR3af4O8SRAnVquZ4jpKNd+0RnZQGsZyPJASqEdxW/BQrO0m9mIBrtYU+ZeAqVBudA/fMwKROM/NxwMDgEFe94YFy864GKn0Qyxmaa5TOxpdQ1FMzk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kJ/xi8wl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kJ/xi8wl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9A13C433F1;
	Mon, 29 Jan 2024 17:09:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548145;
	bh=k2NZX2q+6f0ywMU+LhI/6/GT7i76Wf2TkDKHQr5jLLs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kJ/xi8wlI3en4gliSgs0c5h5lSECqHUjVkzvdT0/bwBiwNJF/agS0cnNdA0/Cox6F
	 JZgxDSbZTiAfsJONhpBWDLe4Dzq5J4uUeLATLsEaRe7tlDdsilTPihX4Sg0MdTzLPX
	 SCrACzbil014CY/sWDe0RffCYFcMwSva4q6ME3qw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 181/346] selftest: Dont reuse port for SO_INCOMING_CPU test.
Date: Mon, 29 Jan 2024 09:03:32 -0800
Message-ID: <20240129170021.717034075@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit 97de5a15edf2d22184f5ff588656030bbb7fa358 ]

Jakub reported that ASSERT_EQ(cpu, i) in so_incoming_cpu.c seems to
fire somewhat randomly.

  # #  RUN           so_incoming_cpu.before_reuseport.test3 ...
  # # so_incoming_cpu.c:191:test3:Expected cpu (32) == i (0)
  # # test3: Test terminated by assertion
  # #          FAIL  so_incoming_cpu.before_reuseport.test3
  # not ok 3 so_incoming_cpu.before_reuseport.test3

When the test failed, not-yet-accepted CLOSE_WAIT sockets received
SYN with a "challenging" SEQ number, which was sent from an unexpected
CPU that did not create the receiver.

The test basically does:

  1. for each cpu:
    1-1. create a server
    1-2. set SO_INCOMING_CPU

  2. for each cpu:
    2-1. set cpu affinity
    2-2. create some clients
    2-3. let clients connect() to the server on the same cpu
    2-4. close() clients

  3. for each server:
    3-1. accept() all child sockets
    3-2. check if all children have the same SO_INCOMING_CPU with the server

The root cause was the close() in 2-4. and net.ipv4.tcp_tw_reuse.

In a loop of 2., close() changed the client state to FIN_WAIT_2, and
the peer transitioned to CLOSE_WAIT.

In another loop of 2., connect() happened to select the same port of
the FIN_WAIT_2 socket, and it was reused as the default value of
net.ipv4.tcp_tw_reuse is 2.

As a result, the new client sent SYN to the CLOSE_WAIT socket from
a different CPU, and the receiver's sk_incoming_cpu was overwritten
with unexpected CPU ID.

Also, the SYN had a different SEQ number, so the CLOSE_WAIT socket
responded with Challenge ACK.  The new client properly returned RST
and effectively killed the CLOSE_WAIT socket.

This way, all clients were created successfully, but the error was
detected later by 3-2., ASSERT_EQ(cpu, i).

To avoid the failure, let's make sure that (i) the number of clients
is less than the number of available ports and (ii) such reuse never
happens.

Fixes: 6df96146b202 ("selftest: Add test for SO_INCOMING_CPU.")
Reported-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Tested-by: Jakub Kicinski <kuba@kernel.org>
Link: https://lore.kernel.org/r/20240120031642.67014-1-kuniyu@amazon.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/so_incoming_cpu.c | 68 ++++++++++++++-----
 1 file changed, 50 insertions(+), 18 deletions(-)

diff --git a/tools/testing/selftests/net/so_incoming_cpu.c b/tools/testing/selftests/net/so_incoming_cpu.c
index a14818164102..e9fa14e10732 100644
--- a/tools/testing/selftests/net/so_incoming_cpu.c
+++ b/tools/testing/selftests/net/so_incoming_cpu.c
@@ -3,19 +3,16 @@
 #define _GNU_SOURCE
 #include <sched.h>
 
+#include <fcntl.h>
+
 #include <netinet/in.h>
 #include <sys/socket.h>
 #include <sys/sysinfo.h>
 
 #include "../kselftest_harness.h"
 
-#define CLIENT_PER_SERVER	32 /* More sockets, more reliable */
-#define NR_SERVER		self->nproc
-#define NR_CLIENT		(CLIENT_PER_SERVER * NR_SERVER)
-
 FIXTURE(so_incoming_cpu)
 {
-	int nproc;
 	int *servers;
 	union {
 		struct sockaddr addr;
@@ -56,12 +53,47 @@ FIXTURE_VARIANT_ADD(so_incoming_cpu, after_all_listen)
 	.when_to_set = AFTER_ALL_LISTEN,
 };
 
+static void write_sysctl(struct __test_metadata *_metadata,
+			 char *filename, char *string)
+{
+	int fd, len, ret;
+
+	fd = open(filename, O_WRONLY);
+	ASSERT_NE(fd, -1);
+
+	len = strlen(string);
+	ret = write(fd, string, len);
+	ASSERT_EQ(ret, len);
+}
+
+static void setup_netns(struct __test_metadata *_metadata)
+{
+	ASSERT_EQ(unshare(CLONE_NEWNET), 0);
+	ASSERT_EQ(system("ip link set lo up"), 0);
+
+	write_sysctl(_metadata, "/proc/sys/net/ipv4/ip_local_port_range", "10000 60001");
+	write_sysctl(_metadata, "/proc/sys/net/ipv4/tcp_tw_reuse", "0");
+}
+
+#define NR_PORT				(60001 - 10000 - 1)
+#define NR_CLIENT_PER_SERVER_DEFAULT	32
+static int nr_client_per_server, nr_server, nr_client;
+
 FIXTURE_SETUP(so_incoming_cpu)
 {
-	self->nproc = get_nprocs();
-	ASSERT_LE(2, self->nproc);
+	setup_netns(_metadata);
+
+	nr_server = get_nprocs();
+	ASSERT_LE(2, nr_server);
+
+	if (NR_CLIENT_PER_SERVER_DEFAULT * nr_server < NR_PORT)
+		nr_client_per_server = NR_CLIENT_PER_SERVER_DEFAULT;
+	else
+		nr_client_per_server = NR_PORT / nr_server;
+
+	nr_client = nr_client_per_server * nr_server;
 
-	self->servers = malloc(sizeof(int) * NR_SERVER);
+	self->servers = malloc(sizeof(int) * nr_server);
 	ASSERT_NE(self->servers, NULL);
 
 	self->in_addr.sin_family = AF_INET;
@@ -74,7 +106,7 @@ FIXTURE_TEARDOWN(so_incoming_cpu)
 {
 	int i;
 
-	for (i = 0; i < NR_SERVER; i++)
+	for (i = 0; i < nr_server; i++)
 		close(self->servers[i]);
 
 	free(self->servers);
@@ -110,10 +142,10 @@ int create_server(struct __test_metadata *_metadata,
 	if (variant->when_to_set == BEFORE_LISTEN)
 		set_so_incoming_cpu(_metadata, fd, cpu);
 
-	/* We don't use CLIENT_PER_SERVER here not to block
+	/* We don't use nr_client_per_server here not to block
 	 * this test at connect() if SO_INCOMING_CPU is broken.
 	 */
-	ret = listen(fd, NR_CLIENT);
+	ret = listen(fd, nr_client);
 	ASSERT_EQ(ret, 0);
 
 	if (variant->when_to_set == AFTER_LISTEN)
@@ -128,7 +160,7 @@ void create_servers(struct __test_metadata *_metadata,
 {
 	int i, ret;
 
-	for (i = 0; i < NR_SERVER; i++) {
+	for (i = 0; i < nr_server; i++) {
 		self->servers[i] = create_server(_metadata, self, variant, i);
 
 		if (i == 0) {
@@ -138,7 +170,7 @@ void create_servers(struct __test_metadata *_metadata,
 	}
 
 	if (variant->when_to_set == AFTER_ALL_LISTEN) {
-		for (i = 0; i < NR_SERVER; i++)
+		for (i = 0; i < nr_server; i++)
 			set_so_incoming_cpu(_metadata, self->servers[i], i);
 	}
 }
@@ -149,7 +181,7 @@ void create_clients(struct __test_metadata *_metadata,
 	cpu_set_t cpu_set;
 	int i, j, fd, ret;
 
-	for (i = 0; i < NR_SERVER; i++) {
+	for (i = 0; i < nr_server; i++) {
 		CPU_ZERO(&cpu_set);
 
 		CPU_SET(i, &cpu_set);
@@ -162,7 +194,7 @@ void create_clients(struct __test_metadata *_metadata,
 		ret = sched_setaffinity(0, sizeof(cpu_set), &cpu_set);
 		ASSERT_EQ(ret, 0);
 
-		for (j = 0; j < CLIENT_PER_SERVER; j++) {
+		for (j = 0; j < nr_client_per_server; j++) {
 			fd  = socket(AF_INET, SOCK_STREAM, 0);
 			ASSERT_NE(fd, -1);
 
@@ -180,8 +212,8 @@ void verify_incoming_cpu(struct __test_metadata *_metadata,
 	int i, j, fd, cpu, ret, total = 0;
 	socklen_t len = sizeof(int);
 
-	for (i = 0; i < NR_SERVER; i++) {
-		for (j = 0; j < CLIENT_PER_SERVER; j++) {
+	for (i = 0; i < nr_server; i++) {
+		for (j = 0; j < nr_client_per_server; j++) {
 			/* If we see -EAGAIN here, SO_INCOMING_CPU is broken */
 			fd = accept(self->servers[i], &self->addr, &self->addrlen);
 			ASSERT_NE(fd, -1);
@@ -195,7 +227,7 @@ void verify_incoming_cpu(struct __test_metadata *_metadata,
 		}
 	}
 
-	ASSERT_EQ(total, NR_CLIENT);
+	ASSERT_EQ(total, nr_client);
 	TH_LOG("SO_INCOMING_CPU is very likely to be "
 	       "working correctly with %d sockets.", total);
 }
-- 
2.43.0



