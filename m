Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4825B47DFA5;
	Fri,  7 Aug 2026 15:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114812; cv=none; b=FM4jxUmw+ND0LeT84az+bpQSrdYcO5P+8TUPCJBhr5xKIIBgka7Hsfr8tnhQoroF7IjII2izeG8DDNTlRA/3lebHFBBHpUbUP3AdNQx8htp2XBmq4vYZfvBycXuyTDxoPJ1eoa8Kxf8eFDU/UhwdkAS+aylvIcAbQ+f4WnL9nZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114812; c=relaxed/simple;
	bh=pF2OmjP9iu4fk6Ong5vrLe6zneMx96aZy3jVvuHbPH4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=f3fSyFgAk69Uacg9gPZIDCy7G6AGElb0+x3CPj4vUDRUYmFd3MuGU4A3Cf5w7CJarRH14XWTeHCmDC9M2/+yBhIh6mp01lWt10BgPngT/1ywRe7cprAQOuyb65aIuylc12xiWMa1yL9C5QBI/N1ghcN+fktbNURI4T+RC9PprS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AY+llc7k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AY+llc7k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CA121F000E9;
	Fri,  7 Aug 2026 15:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114811;
	bh=+9FvQu4K39E/+0iAywqHwefDCTuNOC2t+ku4TCbr9xg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AY+llc7kJrySjdcTpsU4QT0Up2vz1LiZrbIFrrdiZcB5nHmSPNQdvrDodSo4g5U9s
	 r+DGlaXeApBCl6EY7w/7ts6UVWG+tY1/FWs/vztRvFyjsXn32Vp+dG+yDMmY72Jf9l
	 PhSjLh3On8YO26Bc4K6YDHLl9sIkxJ6b0CnPrahM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Sunday Adelodun <adelodunolaoluwa@yahoo.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 057/396] selftests: af_unix: Add tests for ECONNRESET and EOF semantics
Date: Fri,  7 Aug 2026 16:33:37 +0200
Message-ID: <20260807143425.501025335@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sunday Adelodun <adelodunolaoluwa@yahoo.com>

[ Upstream commit 45a1cd8346ca245a1ca475b26eb6ceb9d8b7c6f0 ]

Add selftests to verify and document Linux’s intended behaviour for
UNIX domain sockets (SOCK_STREAM and SOCK_DGRAM) when a peer closes.
The tests verify that:

 1. SOCK_STREAM returns EOF when the peer closes normally.
 2. SOCK_STREAM returns ECONNRESET if the peer closes with unread data.
 3. SOCK_SEQPACKET returns EOF when the peer closes normally.
 4. SOCK_SEQPACKET returns ECONNRESET if the peer closes with unread data.
 5. SOCK_DGRAM does not return ECONNRESET when the peer closes.

This follows up on review feedback suggesting a selftest to clarify
Linux’s semantics.

Suggested-by: Kuniyuki Iwashima <kuniyu@google.com>
Signed-off-by: Sunday Adelodun <adelodunolaoluwa@yahoo.com>
Link: https://patch.msgid.link/20251113112802.44657-1-adelodunolaoluwa@yahoo.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: 7f57c650d08b ("selftests/net/af_unix: test listen() rejects wrong socket states")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/.gitignore        |   1 +
 tools/testing/selftests/net/af_unix/Makefile  |   1 +
 .../selftests/net/af_unix/unix_connreset.c    | 177 ++++++++++++++++++
 3 files changed, 179 insertions(+)
 create mode 100644 tools/testing/selftests/net/af_unix/unix_connreset.c

diff --git a/tools/testing/selftests/net/.gitignore b/tools/testing/selftests/net/.gitignore
index 8f9850a71f542..f627f1a2a2b8c 100644
--- a/tools/testing/selftests/net/.gitignore
+++ b/tools/testing/selftests/net/.gitignore
@@ -66,3 +66,4 @@ udpgso
 udpgso_bench_rx
 udpgso_bench_tx
 unix_connect
+unix_connreset
diff --git a/tools/testing/selftests/net/af_unix/Makefile b/tools/testing/selftests/net/af_unix/Makefile
index 2889403e35468..4c0375e28bbee 100644
--- a/tools/testing/selftests/net/af_unix/Makefile
+++ b/tools/testing/selftests/net/af_unix/Makefile
@@ -13,6 +13,7 @@ TEST_GEN_PROGS := \
 	scm_rights \
 	so_peek_off \
 	unix_connect \
+	unix_connreset \
 # end of TEST_GEN_PROGS
 
 include ../../lib.mk
diff --git a/tools/testing/selftests/net/af_unix/unix_connreset.c b/tools/testing/selftests/net/af_unix/unix_connreset.c
new file mode 100644
index 0000000000000..bffef2b54bfd1
--- /dev/null
+++ b/tools/testing/selftests/net/af_unix/unix_connreset.c
@@ -0,0 +1,177 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Selftest for AF_UNIX socket close and ECONNRESET behaviour.
+ *
+ * This test verifies:
+ *  1. SOCK_STREAM returns EOF when the peer closes normally.
+ *  2. SOCK_STREAM returns ECONNRESET if peer closes with unread data.
+ *  3. SOCK_SEQPACKET returns EOF when the peer closes normally.
+ *  4. SOCK_SEQPACKET returns ECONNRESET if the peer closes with unread data.
+ *  5. SOCK_DGRAM does not return ECONNRESET when the peer closes.
+ *
+ * These tests document the intended Linux behaviour.
+ *
+ */
+
+#define _GNU_SOURCE
+#include <stdlib.h>
+#include <string.h>
+#include <fcntl.h>
+#include <unistd.h>
+#include <errno.h>
+#include <sys/socket.h>
+#include <sys/un.h>
+#include "../../kselftest_harness.h"
+
+#define SOCK_PATH "/tmp/af_unix_connreset.sock"
+
+static void remove_socket_file(void)
+{
+	unlink(SOCK_PATH);
+}
+
+FIXTURE(unix_sock)
+{
+	int server;
+	int client;
+	int child;
+};
+
+FIXTURE_VARIANT(unix_sock)
+{
+	int socket_type;
+	const char *name;
+};
+
+FIXTURE_VARIANT_ADD(unix_sock, stream) {
+	.socket_type = SOCK_STREAM,
+	.name = "SOCK_STREAM",
+};
+
+FIXTURE_VARIANT_ADD(unix_sock, dgram) {
+	.socket_type = SOCK_DGRAM,
+	.name = "SOCK_DGRAM",
+};
+
+FIXTURE_VARIANT_ADD(unix_sock, seqpacket) {
+	.socket_type = SOCK_SEQPACKET,
+	.name = "SOCK_SEQPACKET",
+};
+
+FIXTURE_SETUP(unix_sock)
+{
+	struct sockaddr_un addr = {};
+	int err;
+
+	addr.sun_family = AF_UNIX;
+	strcpy(addr.sun_path, SOCK_PATH);
+	remove_socket_file();
+
+	self->server = socket(AF_UNIX, variant->socket_type, 0);
+	ASSERT_LT(-1, self->server);
+
+	err = bind(self->server, (struct sockaddr *)&addr, sizeof(addr));
+	ASSERT_EQ(0, err);
+
+	if (variant->socket_type == SOCK_STREAM ||
+	    variant->socket_type == SOCK_SEQPACKET) {
+		err = listen(self->server, 1);
+		ASSERT_EQ(0, err);
+	}
+
+	self->client = socket(AF_UNIX, variant->socket_type | SOCK_NONBLOCK, 0);
+	ASSERT_LT(-1, self->client);
+
+	err = connect(self->client, (struct sockaddr *)&addr, sizeof(addr));
+	ASSERT_EQ(0, err);
+}
+
+FIXTURE_TEARDOWN(unix_sock)
+{
+	if (variant->socket_type == SOCK_STREAM ||
+	    variant->socket_type == SOCK_SEQPACKET)
+		close(self->child);
+
+	close(self->client);
+	close(self->server);
+	remove_socket_file();
+}
+
+/* Test 1: peer closes normally */
+TEST_F(unix_sock, eof)
+{
+	char buf[16] = {};
+	ssize_t n;
+
+	if (variant->socket_type == SOCK_STREAM ||
+	    variant->socket_type == SOCK_SEQPACKET) {
+		self->child = accept(self->server, NULL, NULL);
+		ASSERT_LT(-1, self->child);
+
+		close(self->child);
+	} else {
+		close(self->server);
+	}
+
+	n = recv(self->client, buf, sizeof(buf), 0);
+
+	if (variant->socket_type == SOCK_STREAM ||
+	    variant->socket_type == SOCK_SEQPACKET) {
+		ASSERT_EQ(0, n);
+	} else {
+		ASSERT_EQ(-1, n);
+		ASSERT_EQ(EAGAIN, errno);
+	}
+}
+
+/* Test 2: peer closes with unread data */
+TEST_F(unix_sock, reset_unread_behavior)
+{
+	char buf[16] = {};
+	ssize_t n;
+
+	/* Send data that will remain unread */
+	send(self->client, "hello", 5, 0);
+
+	if (variant->socket_type == SOCK_DGRAM) {
+		/* No real connection, just close the server */
+		close(self->server);
+	} else {
+		self->child = accept(self->server, NULL, NULL);
+		ASSERT_LT(-1, self->child);
+
+		/* Peer closes before client reads */
+		close(self->child);
+	}
+
+	n = recv(self->client, buf, sizeof(buf), 0);
+	ASSERT_EQ(-1, n);
+
+	if (variant->socket_type == SOCK_STREAM ||
+	    variant->socket_type == SOCK_SEQPACKET) {
+		ASSERT_EQ(ECONNRESET, errno);
+	} else {
+		ASSERT_EQ(EAGAIN, errno);
+	}
+}
+
+/* Test 3: closing unaccepted (embryo) server socket should reset client. */
+TEST_F(unix_sock, reset_closed_embryo)
+{
+	char buf[16] = {};
+	ssize_t n;
+
+	if (variant->socket_type == SOCK_DGRAM)
+		SKIP(return, "This test only applies to SOCK_STREAM and SOCK_SEQPACKET");
+
+	/* Close server without accept()ing */
+	close(self->server);
+
+	n = recv(self->client, buf, sizeof(buf), 0);
+
+	ASSERT_EQ(-1, n);
+	ASSERT_EQ(ECONNRESET, errno);
+}
+
+TEST_HARNESS_MAIN
+
-- 
2.53.0



