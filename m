Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B21F779C0
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:35:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 195DBC433C1;
	Wed, 30 Nov 2022 18:35:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669833347;
	bh=zflspKWmlBpyLDA94rrcWwVlq5dyaHkawg3eEQuXKek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AZZuPtS5jKcJtbPFj+r9DyTlFSgVXN+Nzv54VWLIVh3jRcG9Oi1FPCbQ7g1LEeTQg
	 b9sglq/U5dZkG39jPjILYRsOXQ+/8YoAELk1DIYzdGL8ySuTMCQ6KKnZgzfhsYQt0G
	 aZtJxlckaL9BfAin1eET4s6Kj/869ioNqPOkPAqI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Mat Martineau <mathew.j.martineau@linux.intel.com>,
	Matthieu Baerts <matthieu.baerts@tessares.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 073/206] selftests: mptcp: fix mibit vs mbit mix up
Date: Wed, 30 Nov 2022 19:22:05 +0100
Message-Id: <20221130180534.853345873@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180532.974348590@linuxfoundation.org>
References: <20221130180532.974348590@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Matthieu Baerts <matthieu.baerts@tessares.net>

[ Upstream commit 3de88b95c4d436d78afc0266a0bed76c35ddeb62 ]

The estimated time was supposing the rate was expressed in mibit
(bit * 1024^2) but it is in mbit (bit * 1000^2).

This makes the threshold higher but in a more realistic way to avoid
false positives reported by CI instances.

Before this patch, the thresholds were at 7561/4005ms and now they are
at 7906/4178ms.

While at it, also fix a typo in the linked comment, spotted by Mat.

Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/310
Fixes: 1a418cb8e888 ("mptcp: simult flow self-tests")
Suggested-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/mptcp/simult_flows.sh | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/simult_flows.sh b/tools/testing/selftests/net/mptcp/simult_flows.sh
index f441ff7904fc..7df4900dfaf7 100755
--- a/tools/testing/selftests/net/mptcp/simult_flows.sh
+++ b/tools/testing/selftests/net/mptcp/simult_flows.sh
@@ -235,9 +235,10 @@ run_test()
 	tc -n $ns2 qdisc add dev ns2eth1 root netem rate ${rate1}mbit $delay1
 	tc -n $ns2 qdisc add dev ns2eth2 root netem rate ${rate2}mbit $delay2
 
-	# time is measured in ms, account for transfer size, affegated link speed
+	# time is measured in ms, account for transfer size, aggregated link speed
 	# and header overhead (10%)
-	local time=$((size * 8 * 1000 * 10 / (( $rate1 + $rate2) * 1024 *1024 * 9) ))
+	#              ms    byte -> bit   10%        mbit      -> kbit -> bit  10%
+	local time=$((1000 * size  *  8  * 10 / ((rate1 + rate2) * 1000 * 1000 * 9) ))
 
 	# mptcp_connect will do some sleeps to allow the mp_join handshake
 	# completion (see mptcp_connect): 200ms on each side, add some slack
-- 
2.35.1



