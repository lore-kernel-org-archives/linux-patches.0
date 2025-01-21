Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 748A11F5439;
	Tue, 21 Jan 2025 18:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482759; cv=none; b=U7d00ThFRVUWzniBuhtRX552S4aTQbn3UyTbHuqBJ7G1BtRWJpQnndTbHcDXf+/GzQOaCgjrrM76XMMYdQP6cvOzY63e7z+zbnn9G1JHsn5/d0YQ4fYAGqnSDUMo5jYqAJzUU5X4rmQc6wIz8cw8dIq4SENgAl1sxwaleGKu6x8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482759; c=relaxed/simple;
	bh=4zv8pIJmFxkQKqd63k3G52E5a8rsF5jpFjPe4mab660=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gBeMwkCkPPXOmEuJRDwMRUcBMvzShcEGGvrw4bWYPY3xs0FwgCSpzsCnk6QwRaC7u/0aKN9g4dM15O4sEi8dETrE4JpZGtrLNwB2oP3UqwSWQzU0H5WcOHzBfxzN0Xh0d77lNtAHqt7k7/Ezy42WPVWSKOQoVF0fF5ke8M3AaSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mq1UM4ju; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mq1UM4ju"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3878C4CEE1;
	Tue, 21 Jan 2025 18:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482759;
	bh=4zv8pIJmFxkQKqd63k3G52E5a8rsF5jpFjPe4mab660=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mq1UM4juQpAmBH0AFcM88y83N1Bsc7VD64Uk5fhoAjpoqGTS2OBImUW2qN80oVbA3
	 Mw5Smfy8fJokiJofHcL8A8Xuxhnkn/hw4I/QWU7XLvHw4yg62z1oIvjxPDzcS+0CfD
	 XLgoHz2lEgmjh4vxf2+p1lR8D52Dl3/A/zyoRxaI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 33/64] selftests: mptcp: avoid spurious errors on disconnect
Date: Tue, 21 Jan 2025 18:52:32 +0100
Message-ID: <20250121174522.817426321@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174521.568417761@linuxfoundation.org>
References: <20250121174521.568417761@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Abeni <pabeni@redhat.com>

commit 218cc166321fb3cc8786677ffe0d09a78778a910 upstream.

The disconnect test-case generates spurious errors:

  INFO: disconnect
  INFO: extra options: -I 3 -i /tmp/tmp.r43niviyoI
  01 ns1 MPTCP -> ns1 (10.0.1.1:10000      ) MPTCP (duration 140ms) [FAIL]
  file received by server does not match (in, out):
  Unexpected revents: POLLERR/POLLNVAL(19)
  -rw-r--r-- 1 root root 10028676 Jan 10 10:47 /tmp/tmp.r43niviyoI.disconnect
  Trailing bytes are:
  ��\����R���!8��u2��5N%
  -rw------- 1 root root 9992290 Jan 10 10:47 /tmp/tmp.Os4UbnWbI1
  Trailing bytes are:
  ��\����R���!8��u2��5N%
  02 ns1 MPTCP -> ns1 (dead:beef:1::1:10001) MPTCP (duration 206ms) [ OK ]
  03 ns1 MPTCP -> ns1 (dead:beef:1::1:10002) TCP   (duration  31ms) [ OK ]
  04 ns1 TCP   -> ns1 (dead:beef:1::1:10003) MPTCP (duration  26ms) [ OK ]
  [FAIL] Tests of the full disconnection have failed
  Time: 2 seconds

The root cause is actually in the user-space bits: the test program
currently disconnects as soon as all the pending data has been spooled,
generating an FASTCLOSE. If such option reaches the peer before the
latter has reached the closed status, the msk socket will report an
error to the user-space, as per protocol specification, causing the
above failure.

Address the issue explicitly waiting for all the relevant sockets to
reach a closed status before performing the disconnect.

Fixes: 05be5e273c84 ("selftests: mptcp: add disconnect tests")
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20250113-net-mptcp-connect-st-flakes-v1-3-0d986ee7b1b6@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/mptcp_connect.c |   43 ++++++++++++++++------
 1 file changed, 32 insertions(+), 11 deletions(-)

--- a/tools/testing/selftests/net/mptcp/mptcp_connect.c
+++ b/tools/testing/selftests/net/mptcp/mptcp_connect.c
@@ -25,6 +25,8 @@
 #include <sys/types.h>
 #include <sys/mman.h>
 
+#include <arpa/inet.h>
+
 #include <netdb.h>
 #include <netinet/in.h>
 
@@ -1131,23 +1133,42 @@ static void parse_setsock_options(const
 	exit(1);
 }
 
-void xdisconnect(int fd, int addrlen)
+void xdisconnect(int fd)
 {
-	struct sockaddr_storage empty;
+	socklen_t addrlen = sizeof(struct sockaddr_storage);
+	struct sockaddr_storage addr, empty;
 	int msec_sleep = 10;
-	int queued = 1;
-	int i;
+	void *raw_addr;
+	int i, cmdlen;
+	char cmd[128];
+
+	/* get the local address and convert it to string */
+	if (getsockname(fd, (struct sockaddr *)&addr, &addrlen) < 0)
+		xerror("getsockname");
+
+	if (addr.ss_family == AF_INET)
+		raw_addr = &(((struct sockaddr_in *)&addr)->sin_addr);
+	else if (addr.ss_family == AF_INET6)
+		raw_addr = &(((struct sockaddr_in6 *)&addr)->sin6_addr);
+	else
+		xerror("bad family");
+
+	strcpy(cmd, "ss -M | grep -q ");
+	cmdlen = strlen(cmd);
+	if (!inet_ntop(addr.ss_family, raw_addr, &cmd[cmdlen],
+		       sizeof(cmd) - cmdlen))
+		xerror("inet_ntop");
 
 	shutdown(fd, SHUT_WR);
 
-	/* while until the pending data is completely flushed, the later
+	/*
+	 * wait until the pending data is completely flushed and all
+	 * the MPTCP sockets reached the closed status.
 	 * disconnect will bypass/ignore/drop any pending data.
 	 */
 	for (i = 0; ; i += msec_sleep) {
-		if (ioctl(fd, SIOCOUTQ, &queued) < 0)
-			xerror("can't query out socket queue: %d", errno);
-
-		if (!queued)
+		/* closed socket are not listed by 'ss' */
+		if (system(cmd) != 0)
 			break;
 
 		if (i > poll_timeout)
@@ -1195,9 +1216,9 @@ again:
 		return ret;
 
 	if (cfg_truncate > 0) {
-		xdisconnect(fd, peer->ai_addrlen);
+		xdisconnect(fd);
 	} else if (--cfg_repeat > 0) {
-		xdisconnect(fd, peer->ai_addrlen);
+		xdisconnect(fd);
 
 		/* the socket could be unblocking at this point, we need the
 		 * connect to be blocking


