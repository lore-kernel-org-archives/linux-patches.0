Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1E2A3451AF;
	Fri, 21 Nov 2025 14:00:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733627; cv=none; b=XS1PbwG+kFBhd2ijSYMK2qL53jaZB9LCKC0CisqhtkdIyMaIZQXPPSka7rs/T74Rrx/ZCIKplN+rwt2VvYjtCtxNYL3NKpJ+2obNPhHwgjnnHTqMH1rTTFtqFDYJAHC3aJQBK7IOLxVXOr4Gcdr+8qSwp/eWeNlMQvT9rQ13pcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733627; c=relaxed/simple;
	bh=BEmRg/tslVWpVAYXXyvx+gO1Lgrv50kSh8tI8cZbgzs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XhatGcg9iwYQfXrX50kLTnFrn9ClJHXtSbMSr+FWG+zEYb4RoTfJjLnujkTDH4/1EFcqhtr1tm8QYlYQYvmgcsL8zbEgSqSpvWLBuYnaevor5PdeEXmiAVgiNxBXhvFlL4hxciXK/PH+vd52fvRdbd6WqJymIb89259Q7W8O+1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FvbMuaxD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FvbMuaxD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B120C4CEFB;
	Fri, 21 Nov 2025 14:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733627;
	bh=BEmRg/tslVWpVAYXXyvx+gO1Lgrv50kSh8tI8cZbgzs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FvbMuaxDYMp9yIBEGUIiVXrEac+5Y6eD9sRzC1cRdpJMuuxkYFqBnULT8kDEGxtnt
	 mmBiKdCH6210MK1vraU+7uGoYh4ed0c4wC6fBWaECVBBYGzw2VP+nj1jud9umyIdxR
	 /WCHwUWTcFTQo0wS8xMecONh8wbkC74E4mul5umk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <geliang@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 491/529] selftests: mptcp: connect: trunc: read all recv data
Date: Fri, 21 Nov 2025 14:13:10 +0100
Message-ID: <20251121130248.477410164@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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
@@ -696,8 +696,14 @@ static int copyfd_io_poll(int infd, int
 
 				bw = do_rnd_write(peerfd, winfo->buf + winfo->off, winfo->len);
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
@@ -723,8 +729,10 @@ static int copyfd_io_poll(int infd, int
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
@@ -1419,7 +1427,7 @@ static void parse_opts(int argc, char **
 			 */
 			if (cfg_truncate < 0) {
 				cfg_rcv_trunc = true;
-				signal(SIGPIPE, handle_signal);
+				signal(SIGPIPE, SIG_IGN);
 			}
 			break;
 		case 'j':


