Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C25F13D512;
	Thu, 13 Jun 2024 12:06:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280406; cv=none; b=F63bykCGU+vu7wJPx8j2MmGJ2bHxjyIq0hvvh4ZdX0baLEZAg5MjLiDgjuVNKxJ5Tj11DoAxX5g+/M9gwpe5vuAMjyp06UUUIctu8S4/XccDFc3d1HbdQxHMGWmYlsZPhbRxdKzGZBBadAaYIiHCH2R/DT/7MbKn7iFiuXgPpt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280406; c=relaxed/simple;
	bh=bjt3COYS8UtBT/lPuFwvNsXzwJ6lokgX/WA/ONNWk2o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gk2r9WFMCC511kNVaMtMGDinC/9Ovk4wL71RZqc9JcqxwQ7NHiutF2wI+dc/30X7HXK55ECvDDwxE35TXUhmKfGmEb5jgvhLeu5iuoI0fq6W93ZQw2ib85m6z259+mRnA7Gb74umCERxQbHmZ/8MLWLz6dPv0IfyudcAU6q5TAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wX9mvz+M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wX9mvz+M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FB67C2BBFC;
	Thu, 13 Jun 2024 12:06:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280406;
	bh=bjt3COYS8UtBT/lPuFwvNsXzwJ6lokgX/WA/ONNWk2o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wX9mvz+MU/8I4MMuQ9rn/sqooOUCdaEvUN8r1Yh/ZV/qsvpU8E83utxKjQ4IXh2NZ
	 +xfUenKUwvVLtfB5a0Fw0r7NC4023jWR9PMbnMGtnWHGNqBudEocR9+qYr+GVALNE5
	 LhdtBKbUefCAXBO0Vn4u89oNqS6UVjVUa3oce/dc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Lucas Karpinski <lkarpins@redhat.com>,
	Willem de Bruijn <willemb@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Po-Hsu Lin <po-hsu.lin@canonical.com>
Subject: [PATCH 6.6 012/137] selftests/net: synchronize udpgro tests tx and rx connection
Date: Thu, 13 Jun 2024 13:33:12 +0200
Message-ID: <20240613113223.767607382@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113223.281378087@linuxfoundation.org>
References: <20240613113223.281378087@linuxfoundation.org>
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

From: Po-Hsu Lin <po-hsu.lin@canonical.com>

From: Lucas Karpinski <lkarpins@redhat.com>

commit 3bdd9fd29cb0f136b307559a19c107210ad5c314 upstream.

The sockets used by udpgso_bench_tx aren't always ready when
udpgso_bench_tx transmits packets. This issue is more prevalent in -rt
kernels, but can occur in both. Replace the hacky sleep calls with a
function that checks whether the ports in the namespace are ready for
use.

Suggested-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Lucas Karpinski <lkarpins@redhat.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[PHLin: context adjustment for the differences in BPF_FILE]
Signed-off-by: Po-Hsu Lin <po-hsu.lin@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/net_helper.sh     |   22 ++++++++++++++++++++++
 tools/testing/selftests/net/udpgro.sh         |   13 ++++++-------
 tools/testing/selftests/net/udpgro_bench.sh   |    5 +++--
 tools/testing/selftests/net/udpgro_frglist.sh |    5 +++--
 4 files changed, 34 insertions(+), 11 deletions(-)
 create mode 100755 tools/testing/selftests/net/net_helper.sh

--- /dev/null
+++ b/tools/testing/selftests/net/net_helper.sh
@@ -0,0 +1,22 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+#
+# Helper functions
+
+wait_local_port_listen()
+{
+	local listener_ns="${1}"
+	local port="${2}"
+	local protocol="${3}"
+	local port_hex
+	local i
+
+	port_hex="$(printf "%04X" "${port}")"
+	for i in $(seq 10); do
+		if ip netns exec "${listener_ns}" cat /proc/net/"${protocol}"* | \
+		   grep -q "${port_hex}"; then
+			break
+		fi
+		sleep 0.1
+	done
+}
--- a/tools/testing/selftests/net/udpgro.sh
+++ b/tools/testing/selftests/net/udpgro.sh
@@ -3,6 +3,8 @@
 #
 # Run a series of udpgro functional tests.
 
+source net_helper.sh
+
 readonly PEER_NS="ns-peer-$(mktemp -u XXXXXX)"
 
 BPF_FILE="xdp_dummy.o"
@@ -51,8 +53,7 @@ run_one() {
 		echo "ok" || \
 		echo "failed" &
 
-	# Hack: let bg programs complete the startup
-	sleep 0.2
+	wait_local_port_listen ${PEER_NS} 8000 udp
 	./udpgso_bench_tx ${tx_args}
 	ret=$?
 	wait $(jobs -p)
@@ -97,7 +98,7 @@ run_one_nat() {
 		echo "ok" || \
 		echo "failed"&
 
-	sleep 0.1
+	wait_local_port_listen "${PEER_NS}" 8000 udp
 	./udpgso_bench_tx ${tx_args}
 	ret=$?
 	kill -INT $pid
@@ -118,11 +119,9 @@ run_one_2sock() {
 		echo "ok" || \
 		echo "failed" &
 
-	# Hack: let bg programs complete the startup
-	sleep 0.2
+	wait_local_port_listen "${PEER_NS}" 12345 udp
 	./udpgso_bench_tx ${tx_args} -p 12345
-	sleep 0.1
-	# first UDP GSO socket should be closed at this point
+	wait_local_port_listen "${PEER_NS}" 8000 udp
 	./udpgso_bench_tx ${tx_args}
 	ret=$?
 	wait $(jobs -p)
--- a/tools/testing/selftests/net/udpgro_bench.sh
+++ b/tools/testing/selftests/net/udpgro_bench.sh
@@ -3,6 +3,8 @@
 #
 # Run a series of udpgro benchmarks
 
+source net_helper.sh
+
 readonly PEER_NS="ns-peer-$(mktemp -u XXXXXX)"
 
 BPF_FILE="xdp_dummy.o"
@@ -40,8 +42,7 @@ run_one() {
 	ip netns exec "${PEER_NS}" ./udpgso_bench_rx ${rx_args} -r &
 	ip netns exec "${PEER_NS}" ./udpgso_bench_rx -t ${rx_args} -r &
 
-	# Hack: let bg programs complete the startup
-	sleep 0.2
+	wait_local_port_listen "${PEER_NS}" 8000 udp
 	./udpgso_bench_tx ${tx_args}
 }
 
--- a/tools/testing/selftests/net/udpgro_frglist.sh
+++ b/tools/testing/selftests/net/udpgro_frglist.sh
@@ -3,6 +3,8 @@
 #
 # Run a series of udpgro benchmarks
 
+source net_helper.sh
+
 readonly PEER_NS="ns-peer-$(mktemp -u XXXXXX)"
 
 BPF_FILE="xdp_dummy.o"
@@ -45,8 +47,7 @@ run_one() {
         echo ${rx_args}
 	ip netns exec "${PEER_NS}" ./udpgso_bench_rx ${rx_args} -r &
 
-	# Hack: let bg programs complete the startup
-	sleep 0.2
+	wait_local_port_listen "${PEER_NS}" 8000 udp
 	./udpgso_bench_tx ${tx_args}
 }
 


