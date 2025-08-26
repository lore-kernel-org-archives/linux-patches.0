Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9340211187;
	Tue, 26 Aug 2025 13:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215467; cv=none; b=jfOrhAMFjbzb+n0DwMrmDyR8aNNXgiCzyJEEqIjtgPxV1AZ8a5Ar8qgMKpygF7t+3dGQ53hvuGxYL6vUGf2nNqazHLGWvP4sE9yQvj0NtvZq2m1BKITx1Al3VPtt2BdfVhvKvpoJiI5nMLQ8Wo0+A0FAu26m6MIRPdN+Xhz6JN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215467; c=relaxed/simple;
	bh=BiCCrrFxkRlc6ZrC0Rz5ZLHO5NXOxFsoLLROvZ/E1cE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HOHiYIeax4abGV42uHmN+beOlxVCGmZCwZhaYv9qsmB2Ojejm5rgnp+a1hl/tk2iOjCJV+K7c1+voVS/SwapFAgY4bq6QBgkkxhWmYnA3pHuwDWUxl6Q3imAAclEzm4Ajtf2kxLWaBAVNptJymYQy6GKy8cdOzjbzqRoPzhOz+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XcECkWS0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XcECkWS0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22AA6C113CF;
	Tue, 26 Aug 2025 13:37:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215467;
	bh=BiCCrrFxkRlc6ZrC0Rz5ZLHO5NXOxFsoLLROvZ/E1cE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XcECkWS08EYSseVKuk2/QoaR08gs8vv5RzYx+trw1gAyKBH1L/xjVs4De6uubvwvs
	 1N1MFzWKP3LkjV9cW2BUhJO3YfgTBmT+5PVLRxakV3kvsU8zgcQ3sAz77iHMNMw4BY
	 NmDO6ozTxS+zdIjs+evG+/5Ev5XFOCpAxqCRj4Rk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Hangbin Liu <liuhangbin@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 044/644] selftests: udpgro: report error when receive failed
Date: Tue, 26 Aug 2025 13:02:15 +0200
Message-ID: <20250826110947.599398843@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit 7167395a4be7930ecac6a33b4e54d7e3dd9ee209 ]

Currently, we only check the latest senders's exit code. If the receiver
report failed, it is not recoreded. Fix it by checking the exit code
of all the involved processes.

Before:
  bad GRO lookup       ok
  multiple GRO socks   ./udpgso_bench_rx: recv: bad packet len, got 1452, expected 14520

 ./udpgso_bench_rx: recv: bad packet len, got 1452, expected 14520

 failed
 $ echo $?
 0

After:
  bad GRO lookup       ok
  multiple GRO socks   ./udpgso_bench_rx: recv: bad packet len, got 1452, expected 14520

 ./udpgso_bench_rx: recv: bad packet len, got 1452, expected 14520

 failed
 $ echo $?
 1

Fixes: 3327a9c46352 ("selftests: add functionals test for UDP GRO")
Suggested-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 0e9418961f89 ("selftests: net: increase inter-packet timeout in udpgro.sh")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/udpgro.sh | 44 ++++++++++++++++-----------
 1 file changed, 27 insertions(+), 17 deletions(-)

diff --git a/tools/testing/selftests/net/udpgro.sh b/tools/testing/selftests/net/udpgro.sh
index 41d85eb745b7b..398f3bf969262 100755
--- a/tools/testing/selftests/net/udpgro.sh
+++ b/tools/testing/selftests/net/udpgro.sh
@@ -44,17 +44,19 @@ run_one() {
 	local -r all="$@"
 	local -r tx_args=${all%rx*}
 	local -r rx_args=${all#*rx}
+	local ret=0
 
 	cfg_veth
 
-	ip netns exec "${PEER_NS}" ./udpgso_bench_rx -C 1000 -R 10 ${rx_args} && \
-		echo "ok" || \
-		echo "failed" &
+	ip netns exec "${PEER_NS}" ./udpgso_bench_rx -C 1000 -R 10 ${rx_args} &
+	local PID1=$!
 
 	wait_local_port_listen ${PEER_NS} 8000 udp
 	./udpgso_bench_tx ${tx_args}
-	ret=$?
-	wait $(jobs -p)
+	check_err $?
+	wait ${PID1}
+	check_err $?
+	[ "$ret" -eq 0 ] && echo "ok" || echo "failed"
 	return $ret
 }
 
@@ -71,6 +73,7 @@ run_one_nat() {
 	local -r all="$@"
 	local -r tx_args=${all%rx*}
 	local -r rx_args=${all#*rx}
+	local ret=0
 
 	if [[ ${tx_args} = *-4* ]]; then
 		ipt_cmd=iptables
@@ -91,16 +94,17 @@ run_one_nat() {
 	# ... so that GRO will match the UDP_GRO enabled socket, but packets
 	# will land on the 'plain' one
 	ip netns exec "${PEER_NS}" ./udpgso_bench_rx -G ${family} -b ${addr1} -n 0 &
-	pid=$!
-	ip netns exec "${PEER_NS}" ./udpgso_bench_rx -C 1000 -R 10 ${family} -b ${addr2%/*} ${rx_args} && \
-		echo "ok" || \
-		echo "failed"&
+	local PID1=$!
+	ip netns exec "${PEER_NS}" ./udpgso_bench_rx -C 1000 -R 10 ${family} -b ${addr2%/*} ${rx_args} &
+	local PID2=$!
 
 	wait_local_port_listen "${PEER_NS}" 8000 udp
 	./udpgso_bench_tx ${tx_args}
-	ret=$?
-	kill -INT $pid
-	wait $(jobs -p)
+	check_err $?
+	kill -INT ${PID1}
+	wait ${PID2}
+	check_err $?
+	[ "$ret" -eq 0 ] && echo "ok" || echo "failed"
 	return $ret
 }
 
@@ -109,20 +113,26 @@ run_one_2sock() {
 	local -r all="$@"
 	local -r tx_args=${all%rx*}
 	local -r rx_args=${all#*rx}
+	local ret=0
 
 	cfg_veth
 
 	ip netns exec "${PEER_NS}" ./udpgso_bench_rx -C 1000 -R 10 ${rx_args} -p 12345 &
-	ip netns exec "${PEER_NS}" ./udpgso_bench_rx -C 2000 -R 10 ${rx_args} && \
-		echo "ok" || \
-		echo "failed" &
+	local PID1=$!
+	ip netns exec "${PEER_NS}" ./udpgso_bench_rx -C 2000 -R 10 ${rx_args} &
+	local PID2=$!
 
 	wait_local_port_listen "${PEER_NS}" 12345 udp
 	./udpgso_bench_tx ${tx_args} -p 12345
+	check_err $?
 	wait_local_port_listen "${PEER_NS}" 8000 udp
 	./udpgso_bench_tx ${tx_args}
-	ret=$?
-	wait $(jobs -p)
+	check_err $?
+	wait ${PID1}
+	check_err $?
+	wait ${PID2}
+	check_err $?
+	[ "$ret" -eq 0 ] && echo "ok" || echo "failed"
 	return $ret
 }
 
-- 
2.39.5



