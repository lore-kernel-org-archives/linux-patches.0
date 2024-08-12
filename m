Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECB49183CA6;
	Mon, 12 Aug 2024 16:22:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479771; cv=none; b=PVgG6G1eN8OOWHjP/HSiqr7I4ga5RB7PNcubhxIDCq4035KfIFT9apHJjZRw+mpy/TVS/T52A/u+ukFArsOZi0BcwUXVKJn6462g0f61w/5OcHrrdIgEXraKV+Rvu3l9WSJUOXMNWHBlQEDc6appqBaPcLW1yK8voleA8A4ThLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479771; c=relaxed/simple;
	bh=AJne4QNLcfLT3kivdKkMQ9CMVt5AhJ2cLpbg7VIfCF0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BPT/lOTwytGRNqGvt/GfPvNdWANgtN4/WgTHNI/LQ/VC+Tee9AbWrJLGZOhKn3zGibr046v3zh3SbmrETb3NKGNHFngKGA1lWXGpxAcFIojwf4AyIw8ZOcqeBrVlF8SsxW8ARf0VT3r8zjM1HOgG4u0BFdODJLTFACiClaFOQGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xl38w/oA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xl38w/oA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E948C32782;
	Mon, 12 Aug 2024 16:22:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479770;
	bh=AJne4QNLcfLT3kivdKkMQ9CMVt5AhJ2cLpbg7VIfCF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xl38w/oApTICDUzUxEVpYootXKnJ2O1pR5tLzvZ9uGEH1AJF84IhuW0ksxyEUCRLf
	 0m3tH9RQzB7/uCj1xCn1W5AZjsYq5Ophs5EvGsa095TRfoiKLGmoRqjnMCrOrL0QM0
	 NGsx8ffT80WzL+2FL6UWcMP+AZo04GhCMrf/VYtk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 186/189] selftests: mptcp: join: ability to invert ADD_ADDR check
Date: Mon, 12 Aug 2024 18:04:02 +0200
Message-ID: <20240812160139.309838754@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160132.135168257@linuxfoundation.org>
References: <20240812160132.135168257@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Matthieu Baerts (NGI0)" <matttbe@kernel.org>

commit bec1f3b119ebc613d08dfbcdbaef01a79aa7de92 upstream.

In the following commit, the client will initiate the ADD_ADDR, instead
of the server. We need to way to verify the ADD_ADDR have been correctly
sent.

Note: the default expected counters for when the port number is given
are never changed by the caller, no need to accept them as parameter
then.

The 'Fixes' tag here below is the same as the one from the previous
commit: this patch here is not fixing anything wrong in the selftests,
but it validates the previous fix for an issue introduced by this commit
ID.

Fixes: 86e39e04482b ("mptcp: keep track of local endpoint still available for each msk")
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20240731-upstream-net-20240731-mptcp-endp-subflow-signal-v1-6-c8a9b036493b@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/mptcp_join.sh |   40 +++++++++++++++---------
 1 file changed, 26 insertions(+), 14 deletions(-)

--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -1559,18 +1559,28 @@ chk_add_nr()
 	local add_nr=$1
 	local echo_nr=$2
 	local port_nr=${3:-0}
-	local syn_nr=${4:-$port_nr}
-	local syn_ack_nr=${5:-$port_nr}
-	local ack_nr=${6:-$port_nr}
-	local mis_syn_nr=${7:-0}
-	local mis_ack_nr=${8:-0}
+	local ns_invert=${4:-""}
+	local syn_nr=$port_nr
+	local syn_ack_nr=$port_nr
+	local ack_nr=$port_nr
+	local mis_syn_nr=0
+	local mis_ack_nr=0
+	local ns_tx=$ns1
+	local ns_rx=$ns2
+	local extra_msg=""
 	local count
 	local timeout
 
-	timeout=$(ip netns exec $ns1 sysctl -n net.mptcp.add_addr_timeout)
+	if [[ $ns_invert = "invert" ]]; then
+		ns_tx=$ns2
+		ns_rx=$ns1
+		extra_msg="invert"
+	fi
+
+	timeout=$(ip netns exec ${ns_tx} sysctl -n net.mptcp.add_addr_timeout)
 
 	print_check "add"
-	count=$(mptcp_lib_get_counter ${ns2} "MPTcpExtAddAddr")
+	count=$(mptcp_lib_get_counter ${ns_rx} "MPTcpExtAddAddr")
 	if [ -z "$count" ]; then
 		print_skip
 	# if the test configured a short timeout tolerate greater then expected
@@ -1582,7 +1592,7 @@ chk_add_nr()
 	fi
 
 	print_check "echo"
-	count=$(mptcp_lib_get_counter ${ns1} "MPTcpExtEchoAdd")
+	count=$(mptcp_lib_get_counter ${ns_tx} "MPTcpExtEchoAdd")
 	if [ -z "$count" ]; then
 		print_skip
 	elif [ "$count" != "$echo_nr" ]; then
@@ -1593,7 +1603,7 @@ chk_add_nr()
 
 	if [ $port_nr -gt 0 ]; then
 		print_check "pt"
-		count=$(mptcp_lib_get_counter ${ns2} "MPTcpExtPortAdd")
+		count=$(mptcp_lib_get_counter ${ns_rx} "MPTcpExtPortAdd")
 		if [ -z "$count" ]; then
 			print_skip
 		elif [ "$count" != "$port_nr" ]; then
@@ -1603,7 +1613,7 @@ chk_add_nr()
 		fi
 
 		print_check "syn"
-		count=$(mptcp_lib_get_counter ${ns1} "MPTcpExtMPJoinPortSynRx")
+		count=$(mptcp_lib_get_counter ${ns_tx} "MPTcpExtMPJoinPortSynRx")
 		if [ -z "$count" ]; then
 			print_skip
 		elif [ "$count" != "$syn_nr" ]; then
@@ -1614,7 +1624,7 @@ chk_add_nr()
 		fi
 
 		print_check "synack"
-		count=$(mptcp_lib_get_counter ${ns2} "MPTcpExtMPJoinPortSynAckRx")
+		count=$(mptcp_lib_get_counter ${ns_rx} "MPTcpExtMPJoinPortSynAckRx")
 		if [ -z "$count" ]; then
 			print_skip
 		elif [ "$count" != "$syn_ack_nr" ]; then
@@ -1625,7 +1635,7 @@ chk_add_nr()
 		fi
 
 		print_check "ack"
-		count=$(mptcp_lib_get_counter ${ns1} "MPTcpExtMPJoinPortAckRx")
+		count=$(mptcp_lib_get_counter ${ns_tx} "MPTcpExtMPJoinPortAckRx")
 		if [ -z "$count" ]; then
 			print_skip
 		elif [ "$count" != "$ack_nr" ]; then
@@ -1636,7 +1646,7 @@ chk_add_nr()
 		fi
 
 		print_check "syn"
-		count=$(mptcp_lib_get_counter ${ns1} "MPTcpExtMismatchPortSynRx")
+		count=$(mptcp_lib_get_counter ${ns_tx} "MPTcpExtMismatchPortSynRx")
 		if [ -z "$count" ]; then
 			print_skip
 		elif [ "$count" != "$mis_syn_nr" ]; then
@@ -1647,7 +1657,7 @@ chk_add_nr()
 		fi
 
 		print_check "ack"
-		count=$(mptcp_lib_get_counter ${ns1} "MPTcpExtMismatchPortAckRx")
+		count=$(mptcp_lib_get_counter ${ns_tx} "MPTcpExtMismatchPortAckRx")
 		if [ -z "$count" ]; then
 			print_skip
 		elif [ "$count" != "$mis_ack_nr" ]; then
@@ -1657,6 +1667,8 @@ chk_add_nr()
 			print_ok
 		fi
 	fi
+
+	print_info "$extra_msg"
 }
 
 chk_add_tx_nr()


