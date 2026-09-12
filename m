Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81B27399CEC;
	Sat, 12 Sep 2026 07:15:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197331; cv=none; b=K9+pDGqGnr57sIjWihHusNCk5NPjkeUZNLPYjMCniwXXq4fTTBp/KYE+43Awcr+tIrD/l20xX8+/QLqrYonFpwqmSzOXA5awYKBSOpWdy4DRf4W6rfMpNnbmEEJcQJ0rvERUz2i62ZhO0zAldGCt81eI+1bf/zlnvfSz0YE7IH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197331; c=relaxed/simple;
	bh=qGxTRQnmTwMpkkwBPMz/J+We42rSy4VSmFnnou8n52c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FHq9soAK3LpThiNfwxHubk0Hx/C2N4ME0UvHWOSzxROkhTGcs9+Zjh2D6Q0lMLIxMV0DqY9xClJzx1qtAKcHFQmlKcZ5MB+HPQZwmGYcFFFSuav9RSfYCxV76FgxC363ocYoknJ7FFSyCE501ytShf/GqxaXXPLFLIXp5nX6qPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QC6gSwZ0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QC6gSwZ0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12A8C1F000FF;
	Sat, 12 Sep 2026 07:15:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197330;
	bh=/KvlajvfJ93jcbTuVyzh7Xqmh2GqR0ws7NbO8qxuEvU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QC6gSwZ0x0O8fXx4/AfVHYcnHVRF0mgoPE2v1djDfKal6qKQt3meA9usfSNxmug8f
	 1damDeW0P+ucF4pyCTwugodojeq8cP5CiaxsuS99hPgefGPfqGheBEnn05Q4U7p83k
	 0kFUamffXbRfD1I/cLliSxFW9yHwqviz6cqVuNvw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guillaume Maudoux <layus.on@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0153/1815] selftests/bpf: Mask socket type flags in mptcpify prog
Date: Sat, 12 Sep 2026 08:31:43 +0200
Message-ID: <20260912065652.604717312@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guillaume Maudoux <layus.on@gmail.com>

[ Upstream commit b4b8b334f6b535a86ab83f18d3d241fe01270bc3 ]

The mptcpify BPF prog upgrades eligible TCP sockets to MPTCP, but only
when the socket type is exactly SOCK_STREAM. Its update_socket_protocol()
hook runs on the raw type from userspace, before the socket core masks
it with SOCK_TYPE_MASK, so the type may still carry SOCK_CLOEXEC or
SOCK_NONBLOCK in its upper bits and the equality check fails.

As a result, a socket(AF_INET, SOCK_STREAM | SOCK_CLOEXEC, 0) -- what
common libraries do by default -- is silently left as plain TCP. This
was hit in practice with curl. Since mptcpify.c is referenced as example
code for enabling MPTCP transparently, the same mistake is likely to be
copied into real deployments where it fails the same way and is hard to
diagnose.

Mask the type before comparing, mirroring the socket core. Extend the
test to also create the server with SOCK_CLOEXEC set; the same masking
is applied to start_server_addr() so a flagged type still listens.

Fixes: ddba122428a7 ("selftests/bpf: Add mptcpify test")
Signed-off-by: Guillaume Maudoux <layus.on@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://lore.kernel.org/bpf/20260630095723.564392-1-layus.on@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/network_helpers.c       |  4 ++--
 tools/testing/selftests/bpf/network_helpers.h       |  5 +++++
 tools/testing/selftests/bpf/prog_tests/mptcp.c      | 13 ++++++++++---
 tools/testing/selftests/bpf/progs/bpf_tracing_net.h |  3 +++
 tools/testing/selftests/bpf/progs/mptcpify.c        |  2 +-
 5 files changed, 21 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/bpf/network_helpers.c b/tools/testing/selftests/bpf/network_helpers.c
index b82f572641b7d..db935a9d9fc1a 100644
--- a/tools/testing/selftests/bpf/network_helpers.c
+++ b/tools/testing/selftests/bpf/network_helpers.c
@@ -111,7 +111,7 @@ int start_server_addr(int type, const struct sockaddr_storage *addr, socklen_t a
 	if (settimeo(fd, opts->timeout_ms))
 		goto error_close;
 
-	if (type == SOCK_STREAM &&
+	if ((type & SOCK_TYPE_MASK) == SOCK_STREAM &&
 	    setsockopt(fd, SOL_SOCKET, SO_REUSEADDR, &on, sizeof(on))) {
 		log_err("Failed to enable SO_REUSEADDR");
 		goto error_close;
@@ -128,7 +128,7 @@ int start_server_addr(int type, const struct sockaddr_storage *addr, socklen_t a
 		goto error_close;
 	}
 
-	if (type == SOCK_STREAM) {
+	if ((type & SOCK_TYPE_MASK) == SOCK_STREAM) {
 		if (listen(fd, opts->backlog ? MAX(opts->backlog, 0) : 1) < 0) {
 			log_err("Failed to listed on socket");
 			goto error_close;
diff --git a/tools/testing/selftests/bpf/network_helpers.h b/tools/testing/selftests/bpf/network_helpers.h
index 79a010c88e11c..75133119c04a3 100644
--- a/tools/testing/selftests/bpf/network_helpers.h
+++ b/tools/testing/selftests/bpf/network_helpers.h
@@ -25,6 +25,11 @@ typedef __u16 __sum16;
 #define VIP_NUM 5
 #define MAGIC_BYTES 123
 
+/* include/linux/net.h */
+#ifndef SOCK_TYPE_MASK
+#define SOCK_TYPE_MASK 0xf
+#endif
+
 struct network_helper_opts {
 	int timeout_ms;
 	int proto;
diff --git a/tools/testing/selftests/bpf/prog_tests/mptcp.c b/tools/testing/selftests/bpf/prog_tests/mptcp.c
index 8fade8bdc4516..32dfc1c511af6 100644
--- a/tools/testing/selftests/bpf/prog_tests/mptcp.c
+++ b/tools/testing/selftests/bpf/prog_tests/mptcp.c
@@ -264,7 +264,7 @@ static int verify_mptcpify(int server_fd, int client_fd)
 	return err;
 }
 
-static int run_mptcpify(int cgroup_fd)
+static int run_mptcpify(int cgroup_fd, int type)
 {
 	int server_fd, client_fd, err = 0;
 	struct mptcpify *mptcpify_skel;
@@ -280,7 +280,7 @@ static int run_mptcpify(int cgroup_fd)
 		goto out;
 
 	/* without MPTCP */
-	server_fd = start_server(AF_INET, SOCK_STREAM, NULL, 0, 0);
+	server_fd = start_server(AF_INET, type, NULL, 0, 0);
 	if (!ASSERT_GE(server_fd, 0, "start_server")) {
 		err = -EIO;
 		goto out;
@@ -317,7 +317,14 @@ static void test_mptcpify(void)
 	if (!ASSERT_OK_PTR(netns, "netns_new"))
 		goto fail;
 
-	ASSERT_OK(run_mptcpify(cgroup_fd), "run_mptcpify");
+	ASSERT_OK(run_mptcpify(cgroup_fd, SOCK_STREAM), "run_mptcpify");
+	/* userspace sets flags such as SOCK_CLOEXEC together with the type;
+	 * the BPF prog must still upgrade the socket to MPTCP. See
+	 * update_socket_protocol() in net/socket.c, which runs before the
+	 * type is masked with SOCK_TYPE_MASK.
+	 */
+	ASSERT_OK(run_mptcpify(cgroup_fd, SOCK_STREAM | SOCK_CLOEXEC),
+		  "run_mptcpify_cloexec");
 
 fail:
 	netns_free(netns);
diff --git a/tools/testing/selftests/bpf/progs/bpf_tracing_net.h b/tools/testing/selftests/bpf/progs/bpf_tracing_net.h
index d8dacef37c163..c4b4388545650 100644
--- a/tools/testing/selftests/bpf/progs/bpf_tracing_net.h
+++ b/tools/testing/selftests/bpf/progs/bpf_tracing_net.h
@@ -8,6 +8,9 @@
 #define AF_INET			2
 #define AF_INET6		10
 
+/* include/linux/net.h */
+#define SOCK_TYPE_MASK		0xf
+
 #define SOL_SOCKET		1
 #define SO_REUSEADDR		2
 #define SO_SNDBUF		7
diff --git a/tools/testing/selftests/bpf/progs/mptcpify.c b/tools/testing/selftests/bpf/progs/mptcpify.c
index cbdc730c3a471..e3f8cb54dbe97 100644
--- a/tools/testing/selftests/bpf/progs/mptcpify.c
+++ b/tools/testing/selftests/bpf/progs/mptcpify.c
@@ -15,7 +15,7 @@ int BPF_PROG(mptcpify, int family, int type, int protocol)
 		return protocol;
 
 	if ((family == AF_INET || family == AF_INET6) &&
-	    type == SOCK_STREAM &&
+	    (type & SOCK_TYPE_MASK) == SOCK_STREAM &&
 	    (!protocol || protocol == IPPROTO_TCP)) {
 		return IPPROTO_MPTCP;
 	}
-- 
2.53.0



