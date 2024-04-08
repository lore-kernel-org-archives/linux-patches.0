Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 585956CDA9;
	Mon,  8 Apr 2024 13:32:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583136; cv=none; b=uAyxIigbsXws4NUEH18P+gWZFF6tGGCP5iLTip7mxCmVVmPiU+0kprSqGALABTWZ72L0TjO7xf6sG8L4CdeSQ+MspXWa44HEjqtQfwi4Wvf2PrJMRQYdVVPHAHo0z/YT0p67LxugLo+qxJjKHec5OLbaTR7rSj8bIJ3dQYUPm40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583136; c=relaxed/simple;
	bh=/tk0OV6gP7tAvthQ2MBqGXysUPDMGzFJ4sEfwKpBFXM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f4JlsMPO3b2TMtq2DZSJF0ixd5MhPsewyEyj4FwMsXtb/MP0b1idHzVaGcPND/EvkUjR1xIO1Sn19BXXFcwZCmWk1x03NRoj6CiWH4j5CUOKlu/IZ+ypB7tpa436hKd1l5cBDuidtkQseimEjtFFU7/yKottO1jkjootyTc+L1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CX0uQkQE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CX0uQkQE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD140C433C7;
	Mon,  8 Apr 2024 13:32:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583136;
	bh=/tk0OV6gP7tAvthQ2MBqGXysUPDMGzFJ4sEfwKpBFXM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CX0uQkQEAIvog0OMNHAuokqsELJJx+CwpeLFf2axUSxuVxWllDe77YuP5qJxTvOhF
	 q37w8PjFBYEYP+jD3NQ95PiK0HdiJD4JOiF7BoO7l34WKJDDoBWxNzg24SH+w9Xshw
	 h4Vcj4ri5z2/kmp/L1x1gLIQgyt/HCkTKFZUxO/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Paasch <cpaasch@apple.com>,
	Davide Caratti <dcaratti@redhat.com>,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 143/273] mptcp: dont account accept() of non-MPC client as fallback to TCP
Date: Mon,  8 Apr 2024 14:56:58 +0200
Message-ID: <20240408125313.730044529@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Davide Caratti <dcaratti@redhat.com>

[ Upstream commit 7a1b3490f47e88ec4cbde65f1a77a0f4bc972282 ]

Current MPTCP servers increment MPTcpExtMPCapableFallbackACK when they
accept non-MPC connections. As reported by Christoph, this is "surprising"
because the counter might become greater than MPTcpExtMPCapableSYNRX.

MPTcpExtMPCapableFallbackACK counter's name suggests it should only be
incremented when a connection was seen using MPTCP options, then a
fallback to TCP has been done. Let's do that by incrementing it when
the subflow context of an inbound MPC connection attempt is dropped.
Also, update mptcp_connect.sh kselftest, to ensure that the
above MIB does not increment in case a pure TCP client connects to a
MPTCP server.

Fixes: fc518953bc9c ("mptcp: add and use MIB counter infrastructure")
Cc: stable@vger.kernel.org
Reported-by: Christoph Paasch <cpaasch@apple.com>
Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/449
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
Reviewed-by: Mat Martineau <martineau@kernel.org>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://lore.kernel.org/r/20240329-upstream-net-20240329-fallback-mib-v1-1-324a8981da48@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/protocol.c                               | 2 --
 net/mptcp/subflow.c                                | 2 ++
 tools/testing/selftests/net/mptcp/mptcp_connect.sh | 9 +++++++++
 3 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 7833a49f6214a..2b921af2718d9 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -3916,8 +3916,6 @@ static int mptcp_stream_accept(struct socket *sock, struct socket *newsock,
 				mptcp_set_state(newsk, TCP_CLOSE);
 		}
 	} else {
-		MPTCP_INC_STATS(sock_net(ssk),
-				MPTCP_MIB_MPCAPABLEPASSIVEFALLBACK);
 tcpfallback:
 		newsk->sk_kern_sock = kern;
 		lock_sock(newsk);
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 71ba86246ff89..13f66d11b7a0b 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -905,6 +905,8 @@ static struct sock *subflow_syn_recv_sock(const struct sock *sk,
 	return child;
 
 fallback:
+	if (fallback)
+		SUBFLOW_REQ_INC_STATS(req, MPTCP_MIB_MPCAPABLEPASSIVEFALLBACK);
 	mptcp_subflow_drop_ctx(child);
 	return child;
 }
diff --git a/tools/testing/selftests/net/mptcp/mptcp_connect.sh b/tools/testing/selftests/net/mptcp/mptcp_connect.sh
index f8e1b3daa7489..713de81822227 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_connect.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_connect.sh
@@ -391,12 +391,14 @@ do_transfer()
 	local stat_cookierx_last
 	local stat_csum_err_s
 	local stat_csum_err_c
+	local stat_tcpfb_last_l
 	stat_synrx_last_l=$(mptcp_lib_get_counter "${listener_ns}" "MPTcpExtMPCapableSYNRX")
 	stat_ackrx_last_l=$(mptcp_lib_get_counter "${listener_ns}" "MPTcpExtMPCapableACKRX")
 	stat_cookietx_last=$(mptcp_lib_get_counter "${listener_ns}" "TcpExtSyncookiesSent")
 	stat_cookierx_last=$(mptcp_lib_get_counter "${listener_ns}" "TcpExtSyncookiesRecv")
 	stat_csum_err_s=$(mptcp_lib_get_counter "${listener_ns}" "MPTcpExtDataCsumErr")
 	stat_csum_err_c=$(mptcp_lib_get_counter "${connector_ns}" "MPTcpExtDataCsumErr")
+	stat_tcpfb_last_l=$(mptcp_lib_get_counter "${listener_ns}" "MPTcpExtMPCapableFallbackACK")
 
 	timeout ${timeout_test} \
 		ip netns exec ${listener_ns} \
@@ -465,11 +467,13 @@ do_transfer()
 	local stat_cookietx_now
 	local stat_cookierx_now
 	local stat_ooo_now
+	local stat_tcpfb_now_l
 	stat_synrx_now_l=$(mptcp_lib_get_counter "${listener_ns}" "MPTcpExtMPCapableSYNRX")
 	stat_ackrx_now_l=$(mptcp_lib_get_counter "${listener_ns}" "MPTcpExtMPCapableACKRX")
 	stat_cookietx_now=$(mptcp_lib_get_counter "${listener_ns}" "TcpExtSyncookiesSent")
 	stat_cookierx_now=$(mptcp_lib_get_counter "${listener_ns}" "TcpExtSyncookiesRecv")
 	stat_ooo_now=$(mptcp_lib_get_counter "${listener_ns}" "TcpExtTCPOFOQueue")
+	stat_tcpfb_now_l=$(mptcp_lib_get_counter "${listener_ns}" "MPTcpExtMPCapableFallbackACK")
 
 	expect_synrx=$((stat_synrx_last_l))
 	expect_ackrx=$((stat_ackrx_last_l))
@@ -516,6 +520,11 @@ do_transfer()
 		fi
 	fi
 
+	if [ ${stat_ooo_now} -eq 0 ] && [ ${stat_tcpfb_last_l} -ne ${stat_tcpfb_now_l} ]; then
+		mptcp_lib_pr_fail "unexpected fallback to TCP"
+		rets=1
+	fi
+
 	if [ $cookies -eq 2 ];then
 		if [ $stat_cookietx_last -ge $stat_cookietx_now ] ;then
 			extra+=" WARN: CookieSent: did not advance"
-- 
2.43.0



