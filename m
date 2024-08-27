Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 107211C86F2;
	Tue, 27 Aug 2024 14:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770501; cv=none; b=sToFl5EeMezQqu5adcUql4ZQW6nFEQ6e4zH2aToCFm3XyU74gGUgJdVr9s85RudMffucJ2ANN4SLCFdPE/VYxbghLbKMKsYMrKoVwkliTHUsc3RWuiHLlzyjxoDRfSp0a7k1d60A5UfjjbY8WeKXz47B5e4Y8hkZit+QBT48PGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770501; c=relaxed/simple;
	bh=R6yYvf1bImaedV2oIYPRop+XEKn91xw4JgqoMO5fadk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=otOo2CbTZY7lcdNdfgYSeZkC4h7kATnWV78UauyqIDsubhsL58e9jIFwEMZNt389T3Pa1Itb08M18Mb3PrgHfJzhMB+nXcU4gLb+1HFMmATBInL7JAlIR6KW6AS8kufaDcV9sNyq6sr4Db8Wy03Ixq3fG9Sw+Pt4CaFvHQNNl7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WjZ227Db; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WjZ227Db"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A159C4E690;
	Tue, 27 Aug 2024 14:55:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770500;
	bh=R6yYvf1bImaedV2oIYPRop+XEKn91xw4JgqoMO5fadk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WjZ227DblCMFI/dwX+FKi6kqxUPqXdAzaXcKrJiE71zl4SIX9hh/2O7K7biurpZ5a
	 /nrBkHKiT2QMS/TAA+zfWKO774kdeLqevmniYMA8pTv3o2/zZZseuGX34oPGSfa4i+
	 rOyufnLAmYKU+om9Z9/t7eRMZh9PjbdwcEN1XYB4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Hangbin Liu <liuhangbin@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 247/341] selftests: udpgro: report error when receive failed
Date: Tue, 27 Aug 2024 16:37:58 +0200
Message-ID: <20240827143852.805752915@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/udpgro.sh | 44 ++++++++++++++++-----------
 1 file changed, 27 insertions(+), 17 deletions(-)

diff --git a/tools/testing/selftests/net/udpgro.sh b/tools/testing/selftests/net/udpgro.sh
index 8802604148dda..53341c8135e88 100755
--- a/tools/testing/selftests/net/udpgro.sh
+++ b/tools/testing/selftests/net/udpgro.sh
@@ -46,17 +46,19 @@ run_one() {
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
 
@@ -73,6 +75,7 @@ run_one_nat() {
 	local -r all="$@"
 	local -r tx_args=${all%rx*}
 	local -r rx_args=${all#*rx}
+	local ret=0
 
 	if [[ ${tx_args} = *-4* ]]; then
 		ipt_cmd=iptables
@@ -93,16 +96,17 @@ run_one_nat() {
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
 
@@ -111,20 +115,26 @@ run_one_2sock() {
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
2.43.0



