Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BDF1387562;
	Tue, 10 Mar 2026 11:27:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773142066; cv=none; b=MgtIq+7uIpgBaVrZNzOhyzzk6H8WMcmneiJGapMxI2lR7eNsClPhw53QkdegwZkca5BxwZZ6xAbmm3LRxeuM2ECSfmY70f+lD0sRTvwcLd5o6DXJqa2O5wn74e4r0FvjjqBAxreu1ZFFbcVKZNpuJatOaxjsyZz4RsZ7ftFokRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773142066; c=relaxed/simple;
	bh=AGYUiBl0VEhzybECeFUC7eElMo9vPYqUmFc/2crMo8g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tbc8DT/0A0Hd+I92oQa0KHi8U0xWGuVE9fl/cVGPKYkC2DR2Szo52T+yZ6Kv+Z+wiAdzK9rHTSkbiFtuS3un9XWpdqh7aP8k+JDCwH+dtENvc27uoWGT441NUTAJ8LxPhfBFOcg21asVt43w07qqa1LAnmEYI4KjUUbpmC4O+d4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qx3wCDcl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qx3wCDcl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 214BDC2BC86;
	Tue, 10 Mar 2026 11:27:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773142065;
	bh=AGYUiBl0VEhzybECeFUC7eElMo9vPYqUmFc/2crMo8g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qx3wCDclZG+cXKWKzDUCbgcnaC6vkTB6J8+7dcu6Xw9odukxLOwbDrN1CloMHVIBc
	 UzMEJCdQlrfr+eBh10aqrVctyr9dZHZDtwkxD/DOdHaSd7yjShdcCGntWhlOz5Du3S
	 8SWs7fJw+af5Y6Rb27GYc4K+2awDe9OiA/Bt3H0ZyWgstbT0XTPIh8j62R/DUTUqma
	 QDJE9bZeTgD+o41+BEQCXFEkFszwGC2BOJTw+lEMndy69C3whmX4qNZhj7+ArlkIwT
	 NWdb/caYI1NChO2c/HUotM/khZgL0GINmN1DJcg9eAsSTY+OEL5xNZCtZeGTTmca0P
	 AGhgwsaZ+8xkA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Paolo Abeni <pabeni@redhat.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 6.18 191/314] selftests: mptcp: more stable simult_flows tests
Date: Tue, 10 Mar 2026 07:17:30 -0400
Message-ID: <31c8db98ab16b38bf8a8ec978c648a2f61d4fd2a.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Paolo Abeni <pabeni@redhat.com>

commit 8c09412e584d9bcc0e71d758ec1008d1c8d1a326 upstream.

By default, the netem qdisc can keep up to 1000 packets under its belly
to deal with the configured rate and delay. The simult flows test-case
simulates very low speed links, to avoid problems due to slow CPUs and
the TCP stack tend to transmit at a slightly higher rate than the
(virtual) link constraints.

All the above causes a relatively large amount of packets being enqueued
in the netem qdiscs - the longer the transfer, the longer the queue -
producing increasingly high TCP RTT samples and consequently increasingly
larger receive buffer size due to DRS.

When the receive buffer size becomes considerably larger than the needed
size, the tests results can flake, i.e. because minimal inaccuracy in the
pacing rate can lead to a single subflow usage towards the end of the
connection for a considerable amount of data.

Address the issue explicitly setting netem limits suitable for the
configured link speeds and unflake all the affected tests.

Fixes: 1a418cb8e888 ("mptcp: simult flow self-tests")
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20260303-net-mptcp-misc-fixes-7-0-rc2-v1-1-4b5462b6f016@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/simult_flows.sh | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/simult_flows.sh b/tools/testing/selftests/net/mptcp/simult_flows.sh
index 1903e8e84a315..76730e511f92e 100755
--- a/tools/testing/selftests/net/mptcp/simult_flows.sh
+++ b/tools/testing/selftests/net/mptcp/simult_flows.sh
@@ -233,10 +233,13 @@ run_test()
 	for dev in ns2eth1 ns2eth2; do
 		tc -n $ns2 qdisc del dev $dev root >/dev/null 2>&1
 	done
-	tc -n $ns1 qdisc add dev ns1eth1 root netem rate ${rate1}mbit $delay1
-	tc -n $ns1 qdisc add dev ns1eth2 root netem rate ${rate2}mbit $delay2
-	tc -n $ns2 qdisc add dev ns2eth1 root netem rate ${rate1}mbit $delay1
-	tc -n $ns2 qdisc add dev ns2eth2 root netem rate ${rate2}mbit $delay2
+
+	# keep the queued pkts number low, or the RTT estimator will see
+	# increasing latency over time.
+	tc -n $ns1 qdisc add dev ns1eth1 root netem rate ${rate1}mbit $delay1 limit 50
+	tc -n $ns1 qdisc add dev ns1eth2 root netem rate ${rate2}mbit $delay2 limit 50
+	tc -n $ns2 qdisc add dev ns2eth1 root netem rate ${rate1}mbit $delay1 limit 50
+	tc -n $ns2 qdisc add dev ns2eth2 root netem rate ${rate2}mbit $delay2 limit 50
 
 	# time is measured in ms, account for transfer size, aggregated link speed
 	# and header overhead (10%)
-- 
2.51.0

