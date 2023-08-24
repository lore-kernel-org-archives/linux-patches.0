Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE84911C86
	for <patches@lists.linux.dev>; Thu, 24 Aug 2023 14:56:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63560C433C7;
	Thu, 24 Aug 2023 14:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692888992;
	bh=ZMxO8ZSbns/R9RsVzuppopXHs4/9fgNVbmjrcQ8D/WE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UlsFBhD8h4CLm00rBYYl6NQvC2N3ZD6HVU2FPJPt55Fy8KPUMV6OkzMkvts2cZxot
	 YbAQN9Jx2gicbKsrCsLub87Rpxm8YRwVrStOtLgkmz4CzJtfgvlqV2QRHTyTqOvWrf
	 YIgqHJk3A7rdZXBSBUQKrmSVpMOJeZ9zhN0gkr+4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Valerio <pvalerio@redhat.com>,
	Xin Long <lucien.xin@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH 5.15 116/139] netfilter: set default timeout to 3 secs for sctp shutdown send and recv state
Date: Thu, 24 Aug 2023 16:50:39 +0200
Message-ID: <20230824145028.551207847@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230824145023.559380953@linuxfoundation.org>
References: <20230824145023.559380953@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Xin Long <lucien.xin@gmail.com>

commit 9bfab6d23a2865966a4f89a96536fbf23f83bc8c upstream.

In SCTP protocol, it is using the same timer (T2 timer) for SHUTDOWN and
SHUTDOWN_ACK retransmission. However in sctp conntrack the default timeout
value for SCTP_CONNTRACK_SHUTDOWN_ACK_SENT state is 3 secs while it's 300
msecs for SCTP_CONNTRACK_SHUTDOWN_SEND/RECV state.

As Paolo Valerio noticed, this might cause unwanted expiration of the ct
entry. In my test, with 1s tc netem delay set on the NAT path, after the
SHUTDOWN is sent, the sctp ct entry enters SCTP_CONNTRACK_SHUTDOWN_SEND
state. However, due to 300ms (too short) delay, when the SHUTDOWN_ACK is
sent back from the peer, the sctp ct entry has expired and been deleted,
and then the SHUTDOWN_ACK has to be dropped.

Also, it is confusing these two sysctl options always show 0 due to all
timeout values using sec as unit:

  net.netfilter.nf_conntrack_sctp_timeout_shutdown_recd = 0
  net.netfilter.nf_conntrack_sctp_timeout_shutdown_sent = 0

This patch fixes it by also using 3 secs for sctp shutdown send and recv
state in sctp conntrack, which is also RTO.initial value in SCTP protocol.

Note that the very short time value for SCTP_CONNTRACK_SHUTDOWN_SEND/RECV
was probably used for a rare scenario where SHUTDOWN is sent on 1st path
but SHUTDOWN_ACK is replied on 2nd path, then a new connection started
immediately on 1st path. So this patch also moves from SHUTDOWN_SEND/RECV
to CLOSE when receiving INIT in the ORIGINAL direction.

Fixes: 9fb9cbb1082d ("[NETFILTER]: Add nf_conntrack subsystem.")
Reported-by: Paolo Valerio <pvalerio@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_conntrack_proto_sctp.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/net/netfilter/nf_conntrack_proto_sctp.c
+++ b/net/netfilter/nf_conntrack_proto_sctp.c
@@ -49,8 +49,8 @@ static const unsigned int sctp_timeouts[
 	[SCTP_CONNTRACK_COOKIE_WAIT]		= 3 SECS,
 	[SCTP_CONNTRACK_COOKIE_ECHOED]		= 3 SECS,
 	[SCTP_CONNTRACK_ESTABLISHED]		= 210 SECS,
-	[SCTP_CONNTRACK_SHUTDOWN_SENT]		= 300 SECS / 1000,
-	[SCTP_CONNTRACK_SHUTDOWN_RECD]		= 300 SECS / 1000,
+	[SCTP_CONNTRACK_SHUTDOWN_SENT]		= 3 SECS,
+	[SCTP_CONNTRACK_SHUTDOWN_RECD]		= 3 SECS,
 	[SCTP_CONNTRACK_SHUTDOWN_ACK_SENT]	= 3 SECS,
 	[SCTP_CONNTRACK_HEARTBEAT_SENT]		= 30 SECS,
 };
@@ -105,7 +105,7 @@ static const u8 sctp_conntracks[2][11][S
 	{
 /*	ORIGINAL	*/
 /*                  sNO, sCL, sCW, sCE, sES, sSS, sSR, sSA, sHS */
-/* init         */ {sCL, sCL, sCW, sCE, sES, sSS, sSR, sSA, sCW},
+/* init         */ {sCL, sCL, sCW, sCE, sES, sCL, sCL, sSA, sCW},
 /* init_ack     */ {sCL, sCL, sCW, sCE, sES, sSS, sSR, sSA, sCL},
 /* abort        */ {sCL, sCL, sCL, sCL, sCL, sCL, sCL, sCL, sCL},
 /* shutdown     */ {sCL, sCL, sCW, sCE, sSS, sSS, sSR, sSA, sCL},


