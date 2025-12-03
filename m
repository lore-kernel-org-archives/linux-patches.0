Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BE92361DB3;
	Wed,  3 Dec 2025 16:43:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780202; cv=none; b=kjahjPZ0QhxhoZuSjxgOhTHY7KZ1wJAx167uLgk/l8Mqxo2IczBDDhmIxVvbT3m0OaCFFBvIuoLsqvwgScyTBPCNJ5vXkFZVlsJSrhWS3Zit/kRqE7aNXNEuo2UdggN8rPHrKjU/zvF50SCAxuEBGS2EOlfZxIJgLxmfQnBwKLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780202; c=relaxed/simple;
	bh=WuTiAFzJcQnLKWBEbuU6pKIIcB0+w8ISD7n3ZBnGs4I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hdT0rwxV8H3t54l3GRlq8/t+FvVObeKIjJ0v/BQWz5AArMRUALqADpZEo/LJdDNSmHpSxJJ4qbn26crymgubUtRPwarAkX8FSrNY1R8HLqhLtt6gd803juqOPWVuj4fuKVLQu/UZQ/Su3kC4Yj+anEnbytUe+vx6rfDUiYFdxDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=trh/eaKE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="trh/eaKE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D792C16AAE;
	Wed,  3 Dec 2025 16:43:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780202;
	bh=WuTiAFzJcQnLKWBEbuU6pKIIcB0+w8ISD7n3ZBnGs4I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=trh/eaKEXrm/L6wXNpLU8W2bG5cFyluAsuXRVypZx2HMBUi6QuQhY6o7F1pvytlTo
	 QsQlHRNPNgbWwwuA0v0iCe/37nGSFI0tWpkkXY6vvaGJVOf4NZaiNz1/h9Ng9O+q9S
	 EgU0aoY5L91mabomTU/EtsYeNKSbnGxv/o+uS29g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <geliang@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 486/568] selftests: mptcp: join: rm: set backup flag
Date: Wed,  3 Dec 2025 16:28:08 +0100
Message-ID: <20251203152458.504041253@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Matthieu Baerts (NGI0)" <matttbe@kernel.org>

[ Upstream commit aea73bae662a0e184393d6d7d0feb18d2577b9b9 ]

Some of these 'remove' tests rarely fail because a subflow has been
reset instead of cleanly removed. This can happen when one extra subflow
which has never carried data is being closed (FIN) on one side, while
the other is sending data for the first time.

To avoid such subflows to be used right at the end, the backup flag has
been added. With that, data will be only carried on the initial subflow.

Fixes: d2c4333a801c ("selftests: mptcp: add testcases for removing addrs")
Cc: stable@vger.kernel.org
Reviewed-by: Geliang Tang <geliang@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20251110-net-mptcp-sft-join-unstable-v1-2-a4332c714e10@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ Adjust context ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/mptcp_join.sh |   54 ++++++++++++------------
 1 file changed, 27 insertions(+), 27 deletions(-)

--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -2332,7 +2332,7 @@ remove_tests()
 	if reset "remove single subflow"; then
 		pm_nl_set_limits $ns1 0 1
 		pm_nl_set_limits $ns2 0 1
-		pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
+		pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow,backup
 		run_tests $ns1 $ns2 10.0.1.1 0 0 -1 slow
 		chk_join_nr 1 1 1
 		chk_rm_nr 1 1
@@ -2343,8 +2343,8 @@ remove_tests()
 	if reset "remove multiple subflows"; then
 		pm_nl_set_limits $ns1 0 2
 		pm_nl_set_limits $ns2 0 2
-		pm_nl_add_endpoint $ns2 10.0.2.2 flags subflow
-		pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
+		pm_nl_add_endpoint $ns2 10.0.2.2 flags subflow,backup
+		pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow,backup
 		run_tests $ns1 $ns2 10.0.1.1 0 0 -2 slow
 		chk_join_nr 2 2 2
 		chk_rm_nr 2 2
@@ -2354,7 +2354,7 @@ remove_tests()
 	# single address, remove
 	if reset "remove single address"; then
 		pm_nl_set_limits $ns1 0 1
-		pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
+		pm_nl_add_endpoint $ns1 10.0.2.1 flags signal,backup
 		pm_nl_set_limits $ns2 1 1
 		run_tests $ns1 $ns2 10.0.1.1 0 -1 0 slow
 		chk_join_nr 1 1 1
@@ -2366,9 +2366,9 @@ remove_tests()
 	# subflow and signal, remove
 	if reset "remove subflow and signal"; then
 		pm_nl_set_limits $ns1 0 2
-		pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
+		pm_nl_add_endpoint $ns1 10.0.2.1 flags signal,backup
 		pm_nl_set_limits $ns2 1 2
-		pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
+		pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow,backup
 		run_tests $ns1 $ns2 10.0.1.1 0 -1 -1 slow
 		chk_join_nr 2 2 2
 		chk_add_nr 1 1
@@ -2379,10 +2379,10 @@ remove_tests()
 	# subflows and signal, remove
 	if reset "remove subflows and signal"; then
 		pm_nl_set_limits $ns1 0 3
-		pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
+		pm_nl_add_endpoint $ns1 10.0.2.1 flags signal,backup
 		pm_nl_set_limits $ns2 1 3
-		pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
-		pm_nl_add_endpoint $ns2 10.0.4.2 flags subflow
+		pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow,backup
+		pm_nl_add_endpoint $ns2 10.0.4.2 flags subflow,backup
 		run_tests $ns1 $ns2 10.0.1.1 0 -1 -2 speed_10
 		chk_join_nr 3 3 3
 		chk_add_nr 1 1
@@ -2393,9 +2393,9 @@ remove_tests()
 	# addresses remove
 	if reset "remove addresses"; then
 		pm_nl_set_limits $ns1 3 3
-		pm_nl_add_endpoint $ns1 10.0.2.1 flags signal id 250
-		pm_nl_add_endpoint $ns1 10.0.3.1 flags signal
-		pm_nl_add_endpoint $ns1 10.0.4.1 flags signal
+		pm_nl_add_endpoint $ns1 10.0.2.1 flags signal,backup id 250
+		pm_nl_add_endpoint $ns1 10.0.3.1 flags signal,backup
+		pm_nl_add_endpoint $ns1 10.0.4.1 flags signal,backup
 		pm_nl_set_limits $ns2 3 3
 		run_tests $ns1 $ns2 10.0.1.1 0 -3 0 speed_10
 		chk_join_nr 3 3 3
@@ -2407,10 +2407,10 @@ remove_tests()
 	# invalid addresses remove
 	if reset "remove invalid addresses"; then
 		pm_nl_set_limits $ns1 3 3
-		pm_nl_add_endpoint $ns1 10.0.12.1 flags signal
+		pm_nl_add_endpoint $ns1 10.0.12.1 flags signal,backup
 		# broadcast IP: no packet for this address will be received on ns1
-		pm_nl_add_endpoint $ns1 224.0.0.1 flags signal
-		pm_nl_add_endpoint $ns1 10.0.3.1 flags signal
+		pm_nl_add_endpoint $ns1 224.0.0.1 flags signal,backup
+		pm_nl_add_endpoint $ns1 10.0.3.1 flags signal,backup
 		pm_nl_set_limits $ns2 2 2
 		run_tests $ns1 $ns2 10.0.1.1 0 -3 0 speed_10
 		chk_join_nr 1 1 1
@@ -2422,10 +2422,10 @@ remove_tests()
 	# subflows and signal, flush
 	if reset "flush subflows and signal"; then
 		pm_nl_set_limits $ns1 0 3
-		pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
+		pm_nl_add_endpoint $ns1 10.0.2.1 flags signal,backup
 		pm_nl_set_limits $ns2 1 3
-		pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
-		pm_nl_add_endpoint $ns2 10.0.4.2 flags subflow
+		pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow,backup
+		pm_nl_add_endpoint $ns2 10.0.4.2 flags subflow,backup
 		run_tests $ns1 $ns2 10.0.1.1 0 -8 -8 slow
 		chk_join_nr 3 3 3
 		chk_add_nr 1 1
@@ -2437,9 +2437,9 @@ remove_tests()
 	if reset "flush subflows"; then
 		pm_nl_set_limits $ns1 3 3
 		pm_nl_set_limits $ns2 3 3
-		pm_nl_add_endpoint $ns2 10.0.2.2 flags subflow id 150
-		pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
-		pm_nl_add_endpoint $ns2 10.0.4.2 flags subflow
+		pm_nl_add_endpoint $ns2 10.0.2.2 flags subflow,backup id 150
+		pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow,backup
+		pm_nl_add_endpoint $ns2 10.0.4.2 flags subflow,backup
 		run_tests $ns1 $ns2 10.0.1.1 0 -8 -8 slow
 		chk_join_nr 3 3 3
 
@@ -2454,9 +2454,9 @@ remove_tests()
 	# addresses flush
 	if reset "flush addresses"; then
 		pm_nl_set_limits $ns1 3 3
-		pm_nl_add_endpoint $ns1 10.0.2.1 flags signal id 250
-		pm_nl_add_endpoint $ns1 10.0.3.1 flags signal
-		pm_nl_add_endpoint $ns1 10.0.4.1 flags signal
+		pm_nl_add_endpoint $ns1 10.0.2.1 flags signal,backup id 250
+		pm_nl_add_endpoint $ns1 10.0.3.1 flags signal,backup
+		pm_nl_add_endpoint $ns1 10.0.4.1 flags signal,backup
 		pm_nl_set_limits $ns2 3 3
 		run_tests $ns1 $ns2 10.0.1.1 0 -8 -8 slow
 		chk_join_nr 3 3 3
@@ -2468,9 +2468,9 @@ remove_tests()
 	# invalid addresses flush
 	if reset "flush invalid addresses"; then
 		pm_nl_set_limits $ns1 3 3
-		pm_nl_add_endpoint $ns1 10.0.12.1 flags signal
-		pm_nl_add_endpoint $ns1 10.0.3.1 flags signal
-		pm_nl_add_endpoint $ns1 10.0.14.1 flags signal
+		pm_nl_add_endpoint $ns1 10.0.12.1 flags signal,backup
+		pm_nl_add_endpoint $ns1 10.0.3.1 flags signal,backup
+		pm_nl_add_endpoint $ns1 10.0.14.1 flags signal,backup
 		pm_nl_set_limits $ns2 3 3
 		run_tests $ns1 $ns2 10.0.1.1 0 -8 0 slow
 		chk_join_nr 1 1 1


