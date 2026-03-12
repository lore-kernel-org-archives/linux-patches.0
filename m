Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8D8835A3A9;
	Thu, 12 Mar 2026 20:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773347066; cv=none; b=h8e2qlyAGbGs7uMkDgVQiXJNu6ySeBmxeArR6vTWEraX/mGFk6gYvCUNfsETqJKBOWs2TzR9ZaB6wYaf69Tq4zMinRy1Sw/0cgfwZ3maB4GEifd1muDwIe3BMyi6/B6OJpEvtqiH7JcOx8Z/AiQW0LWYX2Lwem1CUrP0/URAe3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773347066; c=relaxed/simple;
	bh=uM8pTdSI+zk8xI4R7+uOgNckmdE8u6rs8p9z807UiBU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e8/4Iacza9ds577EDakN2A2TKpwBCzfrGvYSXQCLxWet2yaS3TgLz0wdPyvaarmWRYLo/BIQAbB7BmbzfWU4jTdTS2g+VjGRTdr2kgLqTbHxQ3lnxUKzw65a3yRK/5gEtrV97DQ2FGI+92vcIEJtP6swNCMpmGqq50GRFLztL2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=goPn4oEH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="goPn4oEH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02B86C4CEF7;
	Thu, 12 Mar 2026 20:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773347066;
	bh=uM8pTdSI+zk8xI4R7+uOgNckmdE8u6rs8p9z807UiBU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=goPn4oEHURhetQMUJLM9orEwjA2cDUJ9XXn3oijAk8IxquPPbJwWgBvbTgQOU4gV7
	 H/+e+fWHJxMiv2VRzGLk0xTfUE5V9Xq5oBuSADoIkRa0As6BHubvQi1wpzqC+chidr
	 dFVMbub6b1zuntet9oJHRRyXMZE1La8F32C+/FFg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 161/265] selftests: mptcp: more stable simult_flows tests
Date: Thu, 12 Mar 2026 21:09:08 +0100
Message-ID: <20260312201024.088514541@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

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
 tools/testing/selftests/net/mptcp/simult_flows.sh |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/tools/testing/selftests/net/mptcp/simult_flows.sh
+++ b/tools/testing/selftests/net/mptcp/simult_flows.sh
@@ -226,10 +226,13 @@ run_test()
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


