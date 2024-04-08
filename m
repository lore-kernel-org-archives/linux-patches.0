Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6DEC1292FC;
	Mon,  8 Apr 2024 13:44:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583861; cv=none; b=LWZtOxXdpa7Qos7ypfwz+yBF2841Vu+L8kyj9VqPf3e1XP5W2c5mufG0Geh1mrXPfL7/VwLUbhJcm9JL21FpiSMbr5yNrB4R/E5uR+Ind10uRwHqveWQICOgVycsZwAoeoTmk+4MUcIASLiQc8ZsugeebeJxtCboJgsex7cGKSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583861; c=relaxed/simple;
	bh=AlC5v0nrF/HBrlk0yQDOTiZencsCOHAqrxl4H1yrQjU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=npDehXqUomPY92wDMTQs6zGHe/fGfxJmNh7Q/+h786RnjibZefyUbvRV+QCdn4oxn66vX4XB2MEvcniG1E5SPwjzyT2u67CBSypDh0U/v2VZeZe7cjiCOTiAr8e1h0Kdgt6eGJIclUaNQ6RU2v9DvfvsaiBlCrwPyzWifRBFIYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pEfoXffy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pEfoXffy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CDB0C433C7;
	Mon,  8 Apr 2024 13:44:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583861;
	bh=AlC5v0nrF/HBrlk0yQDOTiZencsCOHAqrxl4H1yrQjU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pEfoXffy//g3HLIq+zFHUmxEFG2qgmuDUtRCD0azh8OZcwEgqAIqBV4E/BW+N0AZ8
	 /wJ1XXMC0DrkVq5IV5FSk4x/rKr5Snryh+dFoO0treCHGky/bBoovZXlgB86w/7Vos
	 S9AooMJRG5S7ZHB0pQMmoxPLj7fw13u65Ik9EQis=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 243/252] selftests: mptcp: connect: fix shellcheck warnings
Date: Mon,  8 Apr 2024 14:59:02 +0200
Message-ID: <20240408125314.189160252@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
References: <20240408125306.643546457@linuxfoundation.org>
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

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

commit e3aae1098f109f0bd33c971deff1926f4e4441d0 upstream.

shellcheck recently helped to prevent issues. It is then good to fix the
other harmless issues in order to spot "real" ones later.

Here, two categories of warnings are now ignored:

- SC2317: Command appears to be unreachable. The cleanup() function is
  invoked indirectly via the EXIT trap.

- SC2086: Double quote to prevent globbing and word splitting. This is
  recommended, but the current usage is correct and there is no need to
  do all these modifications to be compliant with this rule.

For the modifications:

  - SC2034: ksft_skip appears unused.
  - SC2181: Check exit code directly with e.g. 'if mycmd;', not
            indirectly with $?.
  - SC2004: $/${} is unnecessary on arithmetic variables.
  - SC2155: Declare and assign separately to avoid masking return
            values.
  - SC2166: Prefer [ p ] && [ q ] as [ p -a q ] is not well defined.
  - SC2059: Don't use variables in the printf format string. Use printf
            '..%s..' "$foo".

Now this script is shellcheck (0.9.0) compliant. We can easily spot new
issues.

Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://lore.kernel.org/r/20240306-upstream-net-next-20240304-selftests-mptcp-shared-code-shellcheck-v2-8-bc79e6e5e6a0@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/mptcp_connect.sh |   76 ++++++++++++---------
 1 file changed, 47 insertions(+), 29 deletions(-)

--- a/tools/testing/selftests/net/mptcp/mptcp_connect.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_connect.sh
@@ -1,6 +1,11 @@
 #!/bin/bash
 # SPDX-License-Identifier: GPL-2.0
 
+# Double quotes to prevent globbing and word splitting is recommended in new
+# code but we accept it, especially because there were too many before having
+# address all other issues detected by shellcheck.
+#shellcheck disable=SC2086
+
 . "$(dirname "${0}")/mptcp_lib.sh"
 
 time_start=$(date +%s)
@@ -13,7 +18,6 @@ sout=""
 cin_disconnect=""
 cin=""
 cout=""
-ksft_skip=4
 capture=false
 timeout_poll=30
 timeout_test=$((timeout_poll * 2 + 1))
@@ -131,6 +135,8 @@ ns4="ns4-$rndh"
 TEST_COUNT=0
 TEST_GROUP=""
 
+# This function is used in the cleanup trap
+#shellcheck disable=SC2317
 cleanup()
 {
 	rm -f "$cin_disconnect" "$cout_disconnect"
@@ -225,8 +231,9 @@ set_ethtool_flags() {
 	local dev="$2"
 	local flags="$3"
 
-	ip netns exec $ns ethtool -K $dev $flags 2>/dev/null
-	[ $? -eq 0 ] && echo "INFO: set $ns dev $dev: ethtool -K $flags"
+	if ip netns exec $ns ethtool -K $dev $flags 2>/dev/null; then
+		echo "INFO: set $ns dev $dev: ethtool -K $flags"
+	fi
 }
 
 set_random_ethtool_flags() {
@@ -363,7 +370,7 @@ do_transfer()
 	local extra_args="$7"
 
 	local port
-	port=$((10000+$TEST_COUNT))
+	port=$((10000+TEST_COUNT))
 	TEST_COUNT=$((TEST_COUNT+1))
 
 	if [ "$rcvbuf" -gt 0 ]; then
@@ -420,12 +427,18 @@ do_transfer()
 			nstat -n
 	fi
 
-	local stat_synrx_last_l=$(mptcp_lib_get_counter "${listener_ns}" "MPTcpExtMPCapableSYNRX")
-	local stat_ackrx_last_l=$(mptcp_lib_get_counter "${listener_ns}" "MPTcpExtMPCapableACKRX")
-	local stat_cookietx_last=$(mptcp_lib_get_counter "${listener_ns}" "TcpExtSyncookiesSent")
-	local stat_cookierx_last=$(mptcp_lib_get_counter "${listener_ns}" "TcpExtSyncookiesRecv")
-	local stat_csum_err_s=$(mptcp_lib_get_counter "${listener_ns}" "MPTcpExtDataCsumErr")
-	local stat_csum_err_c=$(mptcp_lib_get_counter "${connector_ns}" "MPTcpExtDataCsumErr")
+	local stat_synrx_last_l
+	local stat_ackrx_last_l
+	local stat_cookietx_last
+	local stat_cookierx_last
+	local stat_csum_err_s
+	local stat_csum_err_c
+	stat_synrx_last_l=$(mptcp_lib_get_counter "${listener_ns}" "MPTcpExtMPCapableSYNRX")
+	stat_ackrx_last_l=$(mptcp_lib_get_counter "${listener_ns}" "MPTcpExtMPCapableACKRX")
+	stat_cookietx_last=$(mptcp_lib_get_counter "${listener_ns}" "TcpExtSyncookiesSent")
+	stat_cookierx_last=$(mptcp_lib_get_counter "${listener_ns}" "TcpExtSyncookiesRecv")
+	stat_csum_err_s=$(mptcp_lib_get_counter "${listener_ns}" "MPTcpExtDataCsumErr")
+	stat_csum_err_c=$(mptcp_lib_get_counter "${connector_ns}" "MPTcpExtDataCsumErr")
 
 	timeout ${timeout_test} \
 		ip netns exec ${listener_ns} \
@@ -488,11 +501,16 @@ do_transfer()
 	check_transfer $cin $sout "file received by server"
 	rets=$?
 
-	local stat_synrx_now_l=$(mptcp_lib_get_counter "${listener_ns}" "MPTcpExtMPCapableSYNRX")
-	local stat_ackrx_now_l=$(mptcp_lib_get_counter "${listener_ns}" "MPTcpExtMPCapableACKRX")
-	local stat_cookietx_now=$(mptcp_lib_get_counter "${listener_ns}" "TcpExtSyncookiesSent")
-	local stat_cookierx_now=$(mptcp_lib_get_counter "${listener_ns}" "TcpExtSyncookiesRecv")
-	local stat_ooo_now=$(mptcp_lib_get_counter "${listener_ns}" "TcpExtTCPOFOQueue")
+	local stat_synrx_now_l
+	local stat_ackrx_now_l
+	local stat_cookietx_now
+	local stat_cookierx_now
+	local stat_ooo_now
+	stat_synrx_now_l=$(mptcp_lib_get_counter "${listener_ns}" "MPTcpExtMPCapableSYNRX")
+	stat_ackrx_now_l=$(mptcp_lib_get_counter "${listener_ns}" "MPTcpExtMPCapableACKRX")
+	stat_cookietx_now=$(mptcp_lib_get_counter "${listener_ns}" "TcpExtSyncookiesSent")
+	stat_cookierx_now=$(mptcp_lib_get_counter "${listener_ns}" "TcpExtSyncookiesRecv")
+	stat_ooo_now=$(mptcp_lib_get_counter "${listener_ns}" "TcpExtTCPOFOQueue")
 
 	expect_synrx=$((stat_synrx_last_l))
 	expect_ackrx=$((stat_ackrx_last_l))
@@ -501,8 +519,8 @@ do_transfer()
 	cookies=${cookies##*=}
 
 	if [ ${cl_proto} = "MPTCP" ] && [ ${srv_proto} = "MPTCP" ]; then
-		expect_synrx=$((stat_synrx_last_l+$connect_per_transfer))
-		expect_ackrx=$((stat_ackrx_last_l+$connect_per_transfer))
+		expect_synrx=$((stat_synrx_last_l+connect_per_transfer))
+		expect_ackrx=$((stat_ackrx_last_l+connect_per_transfer))
 	fi
 
 	if [ ${stat_synrx_now_l} -lt ${expect_synrx} ]; then
@@ -510,7 +528,7 @@ do_transfer()
 			"${stat_synrx_now_l}" "${expect_synrx}" 1>&2
 		retc=1
 	fi
-	if [ ${stat_ackrx_now_l} -lt ${expect_ackrx} -a ${stat_ooo_now} -eq 0 ]; then
+	if [ ${stat_ackrx_now_l} -lt ${expect_ackrx} ] && [ ${stat_ooo_now} -eq 0 ]; then
 		if [ ${stat_ooo_now} -eq 0 ]; then
 			printf "[ FAIL ] lower MPC ACK rx (%d) than expected (%d)\n" \
 				"${stat_ackrx_now_l}" "${expect_ackrx}" 1>&2
@@ -521,18 +539,20 @@ do_transfer()
 	fi
 
 	if $checksum; then
-		local csum_err_s=$(mptcp_lib_get_counter "${listener_ns}" "MPTcpExtDataCsumErr")
-		local csum_err_c=$(mptcp_lib_get_counter "${connector_ns}" "MPTcpExtDataCsumErr")
+		local csum_err_s
+		local csum_err_c
+		csum_err_s=$(mptcp_lib_get_counter "${listener_ns}" "MPTcpExtDataCsumErr")
+		csum_err_c=$(mptcp_lib_get_counter "${connector_ns}" "MPTcpExtDataCsumErr")
 
 		local csum_err_s_nr=$((csum_err_s - stat_csum_err_s))
 		if [ $csum_err_s_nr -gt 0 ]; then
-			printf "[ FAIL ]\nserver got $csum_err_s_nr data checksum error[s]"
+			printf "[ FAIL ]\nserver got %d data checksum error[s]" ${csum_err_s_nr}
 			rets=1
 		fi
 
 		local csum_err_c_nr=$((csum_err_c - stat_csum_err_c))
 		if [ $csum_err_c_nr -gt 0 ]; then
-			printf "[ FAIL ]\nclient got $csum_err_c_nr data checksum error[s]"
+			printf "[ FAIL ]\nclient got %d data checksum error[s]" ${csum_err_c_nr}
 			retc=1
 		fi
 	fi
@@ -701,7 +721,7 @@ run_test_transparent()
 		return
 	fi
 
-ip netns exec "$listener_ns" nft -f /dev/stdin <<"EOF"
+	if ! ip netns exec "$listener_ns" nft -f /dev/stdin <<"EOF"
 flush ruleset
 table inet mangle {
 	chain divert {
@@ -712,7 +732,7 @@ table inet mangle {
 	}
 }
 EOF
-	if [ $? -ne 0 ]; then
+	then
 		echo "SKIP: $msg, could not load nft ruleset"
 		mptcp_lib_fail_if_expected_feature "nft rules"
 		mptcp_lib_result_skip "${TEST_GROUP}"
@@ -727,8 +747,7 @@ EOF
 		local_addr="0.0.0.0"
 	fi
 
-	ip -net "$listener_ns" $r6flag rule add fwmark 1 lookup 100
-	if [ $? -ne 0 ]; then
+	if ! ip -net "$listener_ns" $r6flag rule add fwmark 1 lookup 100; then
 		ip netns exec "$listener_ns" nft flush ruleset
 		echo "SKIP: $msg, ip $r6flag rule failed"
 		mptcp_lib_fail_if_expected_feature "ip rule"
@@ -736,8 +755,7 @@ EOF
 		return
 	fi
 
-	ip -net "$listener_ns" route add local $local_addr/0 dev lo table 100
-	if [ $? -ne 0 ]; then
+	if ! ip -net "$listener_ns" route add local $local_addr/0 dev lo table 100; then
 		ip netns exec "$listener_ns" nft flush ruleset
 		ip -net "$listener_ns" $r6flag rule del fwmark 1 lookup 100
 		echo "SKIP: $msg, ip route add local $local_addr failed"
@@ -900,7 +918,7 @@ stop_if_error "Could not even run ping t
 echo -n "INFO: Using loss of $tc_loss "
 test "$tc_delay" -gt 0 && echo -n "delay $tc_delay ms "
 
-reorder_delay=$(($tc_delay / 4))
+reorder_delay=$((tc_delay / 4))
 
 if [ -z "${tc_reorder}" ]; then
 	reorder1=$((RANDOM%10))


