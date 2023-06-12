Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04156134A4
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 10:46:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82139C433EF;
	Mon, 12 Jun 2023 10:46:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686566808;
	bh=tM68sGVqE0tz5h7mYBc1/1KjITyctaa/18xD0/vfC8Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CCzzgLQKcr80TmcPXik7DT1zMGpfqH9wWsDeWQnk/9vsHL635NvrRQ0DzuSFabPKB
	 TWQ1P4Q4vZyaNi+X+vJoJ+pYu9+tiBVbwFbfPqJqjqo+c8XLrzQb+1Kcim01qeXTq8
	 ct9/6Sn+jpvtOguS+mXqJkOs7g/4D5yK53W+k4n4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanislav Fomichev <sdf@google.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 039/160] selftests/bpf: Verify optval=NULL case
Date: Mon, 12 Jun 2023 12:26:11 +0200
Message-ID: <20230612101716.834744237@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230612101715.129581706@linuxfoundation.org>
References: <20230612101715.129581706@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Stanislav Fomichev <sdf@google.com>

[ Upstream commit 833d67ecdc5f35f1ebf59d0fccc1ce771434be9c ]

Make sure we get optlen exported instead of getting EFAULT.

Signed-off-by: Stanislav Fomichev <sdf@google.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20230418225343.553806-3-sdf@google.com
Stable-dep-of: 69844e335d8c ("selftests/bpf: Fix sockopt_sk selftest")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/bpf/prog_tests/sockopt_sk.c     | 28 +++++++++++++++++++
 .../testing/selftests/bpf/progs/sockopt_sk.c  | 12 ++++++++
 2 files changed, 40 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/sockopt_sk.c b/tools/testing/selftests/bpf/prog_tests/sockopt_sk.c
index 60d952719d275..4512dd808c335 100644
--- a/tools/testing/selftests/bpf/prog_tests/sockopt_sk.c
+++ b/tools/testing/selftests/bpf/prog_tests/sockopt_sk.c
@@ -3,6 +3,7 @@
 #include "cgroup_helpers.h"
 
 #include <linux/tcp.h>
+#include <linux/netlink.h>
 #include "sockopt_sk.skel.h"
 
 #ifndef SOL_TCP
@@ -183,6 +184,33 @@ static int getsetsockopt(void)
 		goto err;
 	}
 
+	/* optval=NULL case is handled correctly */
+
+	close(fd);
+	fd = socket(AF_NETLINK, SOCK_RAW, 0);
+	if (fd < 0) {
+		log_err("Failed to create AF_NETLINK socket");
+		return -1;
+	}
+
+	buf.u32 = 1;
+	optlen = sizeof(__u32);
+	err = setsockopt(fd, SOL_NETLINK, NETLINK_ADD_MEMBERSHIP, &buf, optlen);
+	if (err) {
+		log_err("Unexpected getsockopt(NETLINK_ADD_MEMBERSHIP) err=%d errno=%d",
+			err, errno);
+		goto err;
+	}
+
+	optlen = 0;
+	err = getsockopt(fd, SOL_NETLINK, NETLINK_LIST_MEMBERSHIPS, NULL, &optlen);
+	if (err) {
+		log_err("Unexpected getsockopt(NETLINK_LIST_MEMBERSHIPS) err=%d errno=%d",
+			err, errno);
+		goto err;
+	}
+	ASSERT_EQ(optlen, 4, "Unexpected NETLINK_LIST_MEMBERSHIPS value");
+
 	free(big_buf);
 	close(fd);
 	return 0;
diff --git a/tools/testing/selftests/bpf/progs/sockopt_sk.c b/tools/testing/selftests/bpf/progs/sockopt_sk.c
index c8d810010a946..fe1df4cd206eb 100644
--- a/tools/testing/selftests/bpf/progs/sockopt_sk.c
+++ b/tools/testing/selftests/bpf/progs/sockopt_sk.c
@@ -32,6 +32,12 @@ int _getsockopt(struct bpf_sockopt *ctx)
 	__u8 *optval_end = ctx->optval_end;
 	__u8 *optval = ctx->optval;
 	struct sockopt_sk *storage;
+	struct bpf_sock *sk;
+
+	/* Bypass AF_NETLINK. */
+	sk = ctx->sk;
+	if (sk && sk->family == AF_NETLINK)
+		return 1;
 
 	/* Make sure bpf_get_netns_cookie is callable.
 	 */
@@ -131,6 +137,12 @@ int _setsockopt(struct bpf_sockopt *ctx)
 	__u8 *optval_end = ctx->optval_end;
 	__u8 *optval = ctx->optval;
 	struct sockopt_sk *storage;
+	struct bpf_sock *sk;
+
+	/* Bypass AF_NETLINK. */
+	sk = ctx->sk;
+	if (sk && sk->family == AF_NETLINK)
+		return 1;
 
 	/* Make sure bpf_get_netns_cookie is callable.
 	 */
-- 
2.39.2



