Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50685472F91;
	Fri,  7 Aug 2026 15:34:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116864; cv=none; b=tJymDZ7Uwfo9i0Wm0f2rs8WiDw43R5oVumKj03tsozJomT2M3JMmgYa0sq+i3dZ9O603iBBeHCJbKibuLCopGxXO7nZUQ0KrBOm7vHCHAjsanXHgq0AZE9p9uYU7rp5X4v5u/gUa62PqwvK2nEvDMO5H/BgOAwYsK23f22Uh2qU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116864; c=relaxed/simple;
	bh=nbuCLptTyoJ70eELEgMY5ffVYOE2gZ4ta/K7ko/gQUY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q6PiOzNlt18FBESfaeDWZqKLGDqgu/UXKRjGOoCIob2xsD4hyxl6OFx0cOtiw0aI45lfL9TjN4yiNwH0R8A2xgOecbHp8jigfxD1nMpX49oxbBKamKGJ19xZIDoTAmBA0/i3+OaG6mw8xxT6Yz/V2V+8BFkYyE6UtdiPHxxMsOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rl4F3B9u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rl4F3B9u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64B821F000E9;
	Fri,  7 Aug 2026 15:34:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116863;
	bh=rKaVqU2NqZTqWVMK0fDpgDGQqSkvT+tpQKeXGXCd9uM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rl4F3B9uL0m3JoFDZDH2N1aMQYy6UtP6gRweRn3Y2DfIlBQuN56f9mW38wQea+JnH
	 V8vkpvqKfdPe9Ld5D0XJDoXDA1TenuOiTS38FHdhWl1V7xcUcFlRHPI8hWhCNUfFXT
	 emoll5acc1FpYdYvveJjeJJRPrPucMUSS17Qz5gI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Ericson <mail@johnericson.me>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 072/438] selftests/net/af_unix: test listen() rejects wrong socket states
Date: Fri,  7 Aug 2026 16:34:28 +0200
Message-ID: <20260807143429.522809628@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Ericson <mail@johnericson.me>

[ Upstream commit 7f57c650d08b8793bb551bdb33ad876535ef9fe8 ]

Add a regression test for the unix_listen() state check. The key case is
listen() on a bound socket that has already been connected: it is no
longer in TCP_CLOSE or TCP_LISTEN, so it must fail with EINVAL. A
prepare_peercred() call slipped in ahead of that check once left err at 0
and made listen() silently succeed there instead; this guards against a
repeat.

The neighbouring outcomes are covered too so they cannot regress the same
way: a bound socket in TCP_CLOSE listens fine, calling listen() again on a
socket already in TCP_LISTEN is allowed, and an unbound socket fails with
EINVAL.

Each case runs for both listenable socket types (SOCK_STREAM and
SOCK_SEQPACKET) and both pathname and abstract addresses.

Fixes: fd0a109a0f6b ("net, pidfs: prepare for handing out pidfds for reaped sk->sk_peer_pid")
Signed-off-by: John Ericson <mail@johnericson.me>
Link: https://patch.msgid.link/20260718182903.2295560-2-John.Ericson@Obsidian.Systems
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../testing/selftests/net/af_unix/.gitignore  |   1 +
 tools/testing/selftests/net/af_unix/Makefile  |   1 +
 .../selftests/net/af_unix/unix_listen.c       | 187 ++++++++++++++++++
 3 files changed, 189 insertions(+)
 create mode 100644 tools/testing/selftests/net/af_unix/unix_listen.c

diff --git a/tools/testing/selftests/net/af_unix/.gitignore b/tools/testing/selftests/net/af_unix/.gitignore
index 240b26740c9e0..9731766441036 100644
--- a/tools/testing/selftests/net/af_unix/.gitignore
+++ b/tools/testing/selftests/net/af_unix/.gitignore
@@ -6,3 +6,4 @@ scm_rights
 so_peek_off
 unix_connect
 unix_connreset
+unix_listen
diff --git a/tools/testing/selftests/net/af_unix/Makefile b/tools/testing/selftests/net/af_unix/Makefile
index 4c0375e28bbee..57d159803a3ab 100644
--- a/tools/testing/selftests/net/af_unix/Makefile
+++ b/tools/testing/selftests/net/af_unix/Makefile
@@ -14,6 +14,7 @@ TEST_GEN_PROGS := \
 	so_peek_off \
 	unix_connect \
 	unix_connreset \
+	unix_listen \
 # end of TEST_GEN_PROGS
 
 include ../../lib.mk
diff --git a/tools/testing/selftests/net/af_unix/unix_listen.c b/tools/testing/selftests/net/af_unix/unix_listen.c
new file mode 100644
index 0000000000000..416fa3e5bfe9b
--- /dev/null
+++ b/tools/testing/selftests/net/af_unix/unix_listen.c
@@ -0,0 +1,187 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Tests for the state checks in AF_UNIX listen().
+ *
+ * The central case is a regression test: listen() on a bound socket that
+ * is already connected (i.e. not in TCP_CLOSE or TCP_LISTEN state) must
+ * fail with EINVAL.  A prior change accidentally let it return success
+ * without doing anything, because a helper called in between reset the
+ * error code to 0.  The neighbouring checks (unbound, already listening)
+ * are tested too so they cannot silently regress the same way.
+ *
+ * Every case runs for both listenable socket types (SOCK_STREAM and
+ * SOCK_SEQPACKET) and both pathname and abstract addresses.
+ */
+#define _GNU_SOURCE
+
+#include <errno.h>
+#include <stddef.h>
+#include <stdio.h>
+#include <string.h>
+#include <unistd.h>
+
+#include <sys/socket.h>
+#include <sys/un.h>
+
+#include "kselftest_harness.h"
+
+#define SK_NAME		"unix_listen_sk"
+#define SRV_NAME	"unix_listen_srv"
+
+FIXTURE(unix_listen)
+{
+	int sk;			/* socket under test */
+	int server;		/* a listening peer, when a test needs one */
+	struct sockaddr_un addr, srv_addr;
+	socklen_t addrlen, srv_addrlen;
+};
+
+FIXTURE_VARIANT(unix_listen)
+{
+	int type;
+	int abstract;
+};
+
+FIXTURE_VARIANT_ADD(unix_listen, stream_pathname)
+{
+	.type = SOCK_STREAM,
+	.abstract = 0,
+};
+
+FIXTURE_VARIANT_ADD(unix_listen, stream_abstract)
+{
+	.type = SOCK_STREAM,
+	.abstract = 1,
+};
+
+FIXTURE_VARIANT_ADD(unix_listen, seqpacket_pathname)
+{
+	.type = SOCK_SEQPACKET,
+	.abstract = 0,
+};
+
+FIXTURE_VARIANT_ADD(unix_listen, seqpacket_abstract)
+{
+	.type = SOCK_SEQPACKET,
+	.abstract = 1,
+};
+
+/* Fill @addr with a pathname or abstract address named @name. */
+static socklen_t unix_set_addr(struct sockaddr_un *addr, const char *name,
+			       int abstract)
+{
+	size_t len = strlen(name);
+
+	memset(addr, 0, sizeof(*addr));
+	addr->sun_family = AF_UNIX;
+	/* An abstract address leads with a NUL and has no filesystem entry. */
+	memcpy(addr->sun_path + (abstract ? 1 : 0), name, len);
+
+	return offsetof(struct sockaddr_un, sun_path) + len + 1;
+}
+
+FIXTURE_SETUP(unix_listen)
+{
+	self->sk = -1;
+	self->server = -1;
+	self->addrlen = unix_set_addr(&self->addr, SK_NAME, variant->abstract);
+	self->srv_addrlen = unix_set_addr(&self->srv_addr, SRV_NAME,
+					  variant->abstract);
+}
+
+FIXTURE_TEARDOWN(unix_listen)
+{
+	if (self->sk >= 0)
+		close(self->sk);
+	if (self->server >= 0)
+		close(self->server);
+
+	/* Pathname sockets leave a filesystem entry behind; abstract ones do not. */
+	if (!variant->abstract) {
+		remove(SK_NAME);
+		remove(SRV_NAME);
+	}
+}
+
+/* A bound socket in TCP_CLOSE is the normal, allowed case. */
+TEST_F(unix_listen, bound_is_ok)
+{
+	int err;
+
+	self->sk = socket(AF_UNIX, variant->type, 0);
+	ASSERT_LE(0, self->sk);
+
+	err = bind(self->sk, (struct sockaddr *)&self->addr, self->addrlen);
+	ASSERT_EQ(0, err);
+
+	err = listen(self->sk, 8);
+	EXPECT_EQ(0, err);
+}
+
+/* Listening again on an already-listening socket (TCP_LISTEN) is allowed. */
+TEST_F(unix_listen, relisten_is_ok)
+{
+	int err;
+
+	self->sk = socket(AF_UNIX, variant->type, 0);
+	ASSERT_LE(0, self->sk);
+
+	err = bind(self->sk, (struct sockaddr *)&self->addr, self->addrlen);
+	ASSERT_EQ(0, err);
+
+	err = listen(self->sk, 8);
+	ASSERT_EQ(0, err);
+
+	err = listen(self->sk, 16);
+	EXPECT_EQ(0, err);
+}
+
+/* listen() on an unbound socket fails: there is nothing to listen on. */
+TEST_F(unix_listen, unbound_is_einval)
+{
+	int err;
+
+	self->sk = socket(AF_UNIX, variant->type, 0);
+	ASSERT_LE(0, self->sk);
+
+	err = listen(self->sk, 8);
+	EXPECT_EQ(-1, err);
+	EXPECT_EQ(EINVAL, errno);
+}
+
+/*
+ * The regression: a bound socket that has already been connected is not in
+ * TCP_CLOSE or TCP_LISTEN, so listen() must reject it with EINVAL rather
+ * than quietly succeeding.
+ */
+TEST_F(unix_listen, connected_is_einval)
+{
+	int err;
+
+	self->server = socket(AF_UNIX, variant->type, 0);
+	ASSERT_LE(0, self->server);
+
+	err = bind(self->server, (struct sockaddr *)&self->srv_addr,
+		   self->srv_addrlen);
+	ASSERT_EQ(0, err);
+
+	err = listen(self->server, 8);
+	ASSERT_EQ(0, err);
+
+	self->sk = socket(AF_UNIX, variant->type, 0);
+	ASSERT_LE(0, self->sk);
+
+	/* Bind first so the unbound check does not mask the state check. */
+	err = bind(self->sk, (struct sockaddr *)&self->addr, self->addrlen);
+	ASSERT_EQ(0, err);
+
+	err = connect(self->sk, (struct sockaddr *)&self->srv_addr,
+		      self->srv_addrlen);
+	ASSERT_EQ(0, err);
+
+	err = listen(self->sk, 8);
+	EXPECT_EQ(-1, err);
+	EXPECT_EQ(EINVAL, errno);
+}
+
+TEST_HARNESS_MAIN
-- 
2.53.0



