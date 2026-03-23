Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54661370D76;
	Mon, 23 Mar 2026 14:57:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277838; cv=none; b=JSbs07c+L92FPXI6rs9kUu+HLnAAsKt9k110uhFqGzhoD4ULt6wxtFX8serIlTRTz2LATvA534RzKedP+6BCphBxp/PVaynXPQ7N4Saf2AmEkvvAJkBhaXEKjV3hPO9sAv2iHIiEEFuv+dfNN2EtQ3XxmF8daP6NkJtFlt0+v5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277838; c=relaxed/simple;
	bh=DdHeYmo04e36Nxi1+rlSxj/1x4SFjs5gULAkiAn/y4s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B3nWCVXzkv4beB9mfRsJqWcehRZ3BG86veKUrDMp+t0vVEPdx/tbdvkwtcHNFu5p0pPJTm/tIPv7qeQR0ZVFiddzuG4tfZcvmvDkI1e4dCEVm2qeEyWikknucBi468Xx0l19vs45qGWjohktIsOvSp2Yi48q/5dyNE0A4SioElo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C1hZuo0G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C1hZuo0G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB3D3C4CEF7;
	Mon, 23 Mar 2026 14:57:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277838;
	bh=DdHeYmo04e36Nxi1+rlSxj/1x4SFjs5gULAkiAn/y4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C1hZuo0Gqmiia0dUOBOarACh6KZZMyfu6iQAsDvaEISFHbmnNl1/NEMuchBkOK+4M
	 rZRGfGKwFmzmIebfton8pmA566nR6QFLjOADikIPzQJ2IxXEqq8YEXzI8aBPKxjDO0
	 12FICCviU6RUpCo0KCi0fBg6pOhr9Ol8gOoYUsew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 119/567] selftests: mptcp: more stable simult_flows tests
Date: Mon, 23 Mar 2026 14:40:39 +0100
Message-ID: <20260323134536.754932954@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -227,10 +227,13 @@ run_test()
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


