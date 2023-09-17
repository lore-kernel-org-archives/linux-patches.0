Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD5DD6ABA
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 19:50:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 491A4C433C8;
	Sun, 17 Sep 2023 19:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694980218;
	bh=XG1yvnM742iSHLXc8KxlOVseL3j9d68UH6NIHQott54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zrsaOLtTuuVL+dE48LDaprijam81Fc50Syi3C4B2zHrRXh1ACfguCfALjWpgTaEz+
	 XcveOdzXkqyceX/ywbKyRYRjHoljNwos2W3rcH+y1SFMNfpFwsrGdwEsjk4RSJt99C
	 2+F+x8HfZCqsDYooWVdFBfekYl/gFaDwgf0Fb0ko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Kuohai <xukuohai@huawei.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 126/285] selftests/bpf: Fix a CI failure caused by vsock write
Date: Sun, 17 Sep 2023 21:12:06 +0200
Message-ID: <20230917191056.028842505@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191051.639202302@linuxfoundation.org>
References: <20230917191051.639202302@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xu Kuohai <xukuohai@huawei.com>

[ Upstream commit c1970e26bdc1209974bb5cf31cc23f2b7ad6ce50 ]

While commit 90f0074cd9f9 ("selftests/bpf: fix a CI failure caused by vsock sockmap test")
fixes a receive failure of vsock sockmap test, there is still a write failure:

Error: #211/79 sockmap_listen/sockmap VSOCK test_vsock_redir
Error: #211/79 sockmap_listen/sockmap VSOCK test_vsock_redir
  ./test_progs:vsock_unix_redir_connectible:1501: egress: write: Transport endpoint is not connected
  vsock_unix_redir_connectible:FAIL:1501
  ./test_progs:vsock_unix_redir_connectible:1501: ingress: write: Transport endpoint is not connected
  vsock_unix_redir_connectible:FAIL:1501
  ./test_progs:vsock_unix_redir_connectible:1501: egress: write: Transport endpoint is not connected
  vsock_unix_redir_connectible:FAIL:1501

The reason is that the vsock connection in the test is set to ESTABLISHED state
by function virtio_transport_recv_pkt, which is executed in a workqueue thread,
so when the user space test thread runs before the workqueue thread, this
problem occurs.

To fix it, before writing the connection, wait for it to be connected.

Fixes: d61bd8c1fd02 ("selftests/bpf: add a test case for vsock sockmap")
Signed-off-by: Xu Kuohai <xukuohai@huawei.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20230901031037.3314007-1-xukuohai@huaweicloud.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../bpf/prog_tests/sockmap_helpers.h          | 26 +++++++++++++++++++
 .../selftests/bpf/prog_tests/sockmap_listen.c |  7 +++++
 2 files changed, 33 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/sockmap_helpers.h b/tools/testing/selftests/bpf/prog_tests/sockmap_helpers.h
index d12665490a905..36d829a65aa44 100644
--- a/tools/testing/selftests/bpf/prog_tests/sockmap_helpers.h
+++ b/tools/testing/selftests/bpf/prog_tests/sockmap_helpers.h
@@ -179,6 +179,32 @@
 		__ret;                                                         \
 	})
 
+static inline int poll_connect(int fd, unsigned int timeout_sec)
+{
+	struct timeval timeout = { .tv_sec = timeout_sec };
+	fd_set wfds;
+	int r, eval;
+	socklen_t esize = sizeof(eval);
+
+	FD_ZERO(&wfds);
+	FD_SET(fd, &wfds);
+
+	r = select(fd + 1, NULL, &wfds, NULL, &timeout);
+	if (r == 0)
+		errno = ETIME;
+	if (r != 1)
+		return -1;
+
+	if (getsockopt(fd, SOL_SOCKET, SO_ERROR, &eval, &esize) < 0)
+		return -1;
+	if (eval != 0) {
+		errno = eval;
+		return -1;
+	}
+
+	return 0;
+}
+
 static inline int poll_read(int fd, unsigned int timeout_sec)
 {
 	struct timeval timeout = { .tv_sec = timeout_sec };
diff --git a/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c b/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
index 5674a9d0cacf0..8df8cbb447f10 100644
--- a/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
+++ b/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
@@ -1452,11 +1452,18 @@ static int vsock_socketpair_connectible(int sotype, int *v0, int *v1)
 	if (p < 0)
 		goto close_cli;
 
+	if (poll_connect(c, IO_TIMEOUT_SEC) < 0) {
+		FAIL_ERRNO("poll_connect");
+		goto close_acc;
+	}
+
 	*v0 = p;
 	*v1 = c;
 
 	return 0;
 
+close_acc:
+	close(p);
 close_cli:
 	close(c);
 close_srv:
-- 
2.40.1



