Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63F8526CE39;
	Wed,  3 Dec 2025 16:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779955; cv=none; b=lvdXrNbiJ95bqn8S9qmC4gR9uIeN53NLyEKtRQmoxKafqL/mYLVakd7i+kaLryDEWoE2UkZVAO5OPYmLc3JKrSr/NFtCZQvnZA/yr+iUmN0MJraaWWZ+1laOwpLzO+d6UNtkyKO5MM6ryI/JgoBZUzSKBC3nIW1Csjsu/JQJqIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779955; c=relaxed/simple;
	bh=B4vooNdUtFa9Li0hUoq0NZ6kS2ttN9lNs/rJlomyZLM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q5vOL0ifchvxlGSwQOnU0efXiBB5zof2nOExD4dWmOYuBS86oKUIOVKggM2JztiAhRVOdpSpY/lqlzDCvlHwIrQ1e6nTJDMUC7W9Y/FbX/ckDrUdRENGK8DgtllX6OMqQxg3olbufyJfUCIPXagJcS7fO8YjBALAclUYg2X4dSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ed9cVt/R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ed9cVt/R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C41C1C16AAE;
	Wed,  3 Dec 2025 16:39:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779955;
	bh=B4vooNdUtFa9Li0hUoq0NZ6kS2ttN9lNs/rJlomyZLM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ed9cVt/RtVEtOXcmgStGuPT/oBFUora+z5LUXqGo/jzU+VcFwkw5VpEj6BSvfnBO4
	 yBbkhKGtjPKFclhomJ5lCjnHvIu6siG5p0g6GZPbnpJpTXtOAylGtyj/LS/gcEjpaR
	 LUoDEFak0T6iL0aa+JNel4YH3ad3uyBJyMZIjR/8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <geliang@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 412/568] selftests: mptcp: connect: trunc: read all recv data
Date: Wed,  3 Dec 2025 16:26:54 +0100
Message-ID: <20251203152455.779475113@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

commit ee79980f7a428ec299f6261bea4c1084dcbc9631 upstream.

MPTCP Join "fastclose server" selftest is sometimes failing because the
client output file doesn't have the expected size, e.g. 296B instead of
1024B.

When looking at a packet trace when this happens, the server sent the
expected 1024B in two parts -- 100B, then 924B -- then the MP_FASTCLOSE.
It is then strange to see the client only receiving 296B, which would
mean it only got a part of the second packet. The problem is then not on
the networking side, but rather on the data reception side.

When mptcp_connect is launched with '-f -1', it means the connection
might stop before having sent everything, because a reset has been
received. When this happens, the program was directly stopped. But it is
also possible there are still some data to read, simply because the
previous 'read' step was done with a buffer smaller than the pending
data, see do_rnd_read(). In this case, it is important to read what's
left in the kernel buffers before stopping without error like before.

SIGPIPE is now ignored, not to quit the app before having read
everything.

Fixes: 6bf41020b72b ("selftests: mptcp: update and extend fastclose test-cases")
Cc: stable@vger.kernel.org
Reviewed-by: Geliang Tang <geliang@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20251110-net-mptcp-sft-join-unstable-v1-5-a4332c714e10@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/mptcp_connect.c |   18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

--- a/tools/testing/selftests/net/mptcp/mptcp_connect.c
+++ b/tools/testing/selftests/net/mptcp/mptcp_connect.c
@@ -655,8 +655,14 @@ static int copyfd_io_poll(int infd, int
 
 				bw = do_rnd_write(peerfd, wbuf + woff, wlen);
 				if (bw < 0) {
-					if (cfg_rcv_trunc)
-						return 0;
+					/* expected reset, continue to read */
+					if (cfg_rcv_trunc &&
+					    (errno == ECONNRESET ||
+					     errno == EPIPE)) {
+						fds.events &= ~POLLOUT;
+						continue;
+					}
+
 					perror("write");
 					return 111;
 				}
@@ -682,8 +688,10 @@ static int copyfd_io_poll(int infd, int
 		}
 
 		if (fds.revents & (POLLERR | POLLNVAL)) {
-			if (cfg_rcv_trunc)
-				return 0;
+			if (cfg_rcv_trunc) {
+				fds.events &= ~(POLLERR | POLLNVAL);
+				continue;
+			}
 			fprintf(stderr, "Unexpected revents: "
 				"POLLERR/POLLNVAL(%x)\n", fds.revents);
 			return 5;
@@ -1332,7 +1340,7 @@ static void parse_opts(int argc, char **
 			 */
 			if (cfg_truncate < 0) {
 				cfg_rcv_trunc = true;
-				signal(SIGPIPE, handle_signal);
+				signal(SIGPIPE, SIG_IGN);
 			}
 			break;
 		case 'j':


