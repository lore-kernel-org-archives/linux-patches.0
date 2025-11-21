Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61D5B246762;
	Fri, 21 Nov 2025 13:26:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731572; cv=none; b=QJkVHmSgiTICSEDOu46X5VR+IREfn0c4Pocnm1PIWauXm2iDxwljjRN09p0iO63fWAT+UECbauI94Olps99QmGOEL63evTID37Uy527p2pAvYPKpXZBRkxgUBn35PZuLPdEs3PE/SadK0ZbiZ+BVR0KInRYyPpnfBWCIxP0W+e8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731572; c=relaxed/simple;
	bh=1Tcs1Mmp9EFzTmE+iu27apRTTtMjZdlWB9WLs5bKDbw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sXsyZR8pbNp4+bch/ndm9ye/+mbM6AiBxcevUqXT/exNJVEbVl1ucm+LmbVhZpQw8jnfwxuN50sgGWb7U+Y0uFTxpn/127oaGD+CtF6N6QcG/Lder7i1z/zSeIZ4pyxXY8RNXDmPBcpa0xalG5Oa9rbTcN38aWDPyRLin2T1uwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vZqKdumO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vZqKdumO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCC03C4CEF1;
	Fri, 21 Nov 2025 13:26:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731572;
	bh=1Tcs1Mmp9EFzTmE+iu27apRTTtMjZdlWB9WLs5bKDbw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vZqKdumO+OEx0hUwEfyUjwS/NK4QUxhtwyp7ojGQdxIxYY+WMRf3iaMyqILe+G9Q8
	 do/rqJDvHzlVfbVf+K0c/jaXezv/pScQ7abBJ+mDqz8qiXnGKOHztkVAIOUkSkVGyH
	 Juf1EpFtbiV0Secg0oPajrJ7037pWCh4AKC1MQWU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <geliang@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.17 233/247] selftests: mptcp: connect: trunc: read all recv data
Date: Fri, 21 Nov 2025 14:13:00 +0100
Message-ID: <20251121130203.097482160@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
@@ -710,8 +710,14 @@ static int copyfd_io_poll(int infd, int
 
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
@@ -737,8 +743,10 @@ static int copyfd_io_poll(int infd, int
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
@@ -1433,7 +1441,7 @@ static void parse_opts(int argc, char **
 			 */
 			if (cfg_truncate < 0) {
 				cfg_rcv_trunc = true;
-				signal(SIGPIPE, handle_signal);
+				signal(SIGPIPE, SIG_IGN);
 			}
 			break;
 		case 'j':


