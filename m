Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B0F08063B;
	Mon,  8 Apr 2024 14:06:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712585202; cv=none; b=XofpwQK3V5LHHGhtxPc8xrVQnpJsuxRv4I06+pS+V6f1zXsYsUGPhBaV/R/KjVFSQVPAG9VQMe8gtHUztw/XbL4UEM0w2Qw7fDPqE9BeWNW8wv4z8UZ5qECcLMdnSnCxbs2bg84FKKR6jUFFhdy40JviD9xHgToxxOoPabmN1SY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712585202; c=relaxed/simple;
	bh=dxDU2PwRAiFE30XYaWdCEnkXbXC29wzdUMzsgNYZY1w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RR/QnuwriV5z3Rdynu/oZN9VvzCIxoZ45uyRllT3K3hn6yDSN1qo8NrMQkR83JrW5VIFrgWWHn6IcNyX1bbLUwEGeqH+Cw79o35lj15yadm0M8AyETwJMBX8rdlUBi1/belt6PB+j1xoLhSrlFSi8l2zsw0x5ZGyo3RTQPXeWXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cCPB5vPp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cCPB5vPp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F92BC43390;
	Mon,  8 Apr 2024 14:06:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712585200;
	bh=dxDU2PwRAiFE30XYaWdCEnkXbXC29wzdUMzsgNYZY1w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cCPB5vPptw+5+TdDpe5Ypq6x/lNRzTBKeSx/9XSpTVBqgrYlqC9A5XAfYZrR+4SWO
	 Uj2tvneLsqZambLfKAIsS/WF4pS5EbsaEUufdzqDMXJRyN20QPuH2WR2kYVSx8Sx5y
	 yBklOvjP4/v60gvtU4KLzciax1LPWM0aYSoyYRNQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Paasch <cpaasch@apple.com>,
	Davide Caratti <dcaratti@redhat.com>,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 687/690] mptcp: dont account accept() of non-MPC client as fallback to TCP
Date: Mon,  8 Apr 2024 14:59:13 +0200
Message-ID: <20240408125424.621951185@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Davide Caratti <dcaratti@redhat.com>

commit 7a1b3490f47e88ec4cbde65f1a77a0f4bc972282 upstream.

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
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/protocol.c                               |    3 ---
 net/mptcp/subflow.c                                |    3 +++
 tools/testing/selftests/net/mptcp/mptcp_connect.sh |    7 +++++++
 3 files changed, 10 insertions(+), 3 deletions(-)

--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -3018,9 +3018,6 @@ static struct sock *mptcp_accept(struct
 		sock_hold(new_mptcp_sock);
 		newsk = new_mptcp_sock;
 		MPTCP_INC_STATS(sock_net(sk), MPTCP_MIB_MPCAPABLEPASSIVEACK);
-	} else {
-		MPTCP_INC_STATS(sock_net(sk),
-				MPTCP_MIB_MPCAPABLEPASSIVEFALLBACK);
 	}
 
 out:
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -725,6 +725,9 @@ create_child:
 				goto dispose_child;
 			}
 
+			if (fallback)
+				SUBFLOW_REQ_INC_STATS(req, MPTCP_MIB_MPCAPABLEPASSIVEFALLBACK);
+
 			subflow_drop_ctx(child);
 			goto out;
 		}
--- a/tools/testing/selftests/net/mptcp/mptcp_connect.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_connect.sh
@@ -451,6 +451,7 @@ do_transfer()
 	local stat_cookierx_last=$(get_mib_counter "${listener_ns}" "TcpExtSyncookiesRecv")
 	local stat_csum_err_s=$(get_mib_counter "${listener_ns}" "MPTcpExtDataCsumErr")
 	local stat_csum_err_c=$(get_mib_counter "${connector_ns}" "MPTcpExtDataCsumErr")
+	local stat_tcpfb_last_l=$(get_mib_counter "${listener_ns}" "MPTcpExtMPCapableFallbackACK")
 
 	timeout ${timeout_test} \
 		ip netns exec ${listener_ns} \
@@ -516,6 +517,7 @@ do_transfer()
 	local stat_cookietx_now=$(get_mib_counter "${listener_ns}" "TcpExtSyncookiesSent")
 	local stat_cookierx_now=$(get_mib_counter "${listener_ns}" "TcpExtSyncookiesRecv")
 	local stat_ooo_now=$(get_mib_counter "${listener_ns}" "TcpExtTCPOFOQueue")
+	local stat_tcpfb_now_l=$(get_mib_counter "${listener_ns}" "MPTcpExtMPCapableFallbackACK")
 
 	expect_synrx=$((stat_synrx_last_l))
 	expect_ackrx=$((stat_ackrx_last_l))
@@ -560,6 +562,11 @@ do_transfer()
 		fi
 	fi
 
+	if [ ${stat_ooo_now} -eq 0 ] && [ ${stat_tcpfb_last_l} -ne ${stat_tcpfb_now_l} ]; then
+		printf "[ FAIL ]\nunexpected fallback to TCP"
+		rets=1
+	fi
+
 	if [ $retc -eq 0 ] && [ $rets -eq 0 ]; then
 		printf "[ OK ]"
 	fi


