Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0C1F190477;
	Fri, 21 Nov 2025 13:26:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731566; cv=none; b=ci60FyU6tIXpu/bKCownWbp9FoggUNYGb6Ic+NUuViL9aUtmWhdP1uwd/NkZdHmNmNGx5D0/2sxSkECbCFZCfJB6Ug7O+ZVLm66Kol6+R2U1avB0ICeQBeqgYcE0GutcgotwCwWSYk+cWhlzX7HYqqPbPdf1C2IYFIbgkhkrZNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731566; c=relaxed/simple;
	bh=4i9VhQ+pR1LOe8eddwwwCvkBc0L/oyILRjqZPUgxPwY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L72lwZRTQMzCu2c2ysDWfD3Gaj6sNvLdYqV7HcsRBi/ovuv8OvZ3ItKNIFKx7aGe/6wRkJF+lmRRmQzjAENRnLnkzPt2jKKen/1cdyhfW6RTSOgZILab1/8iktALFxN8Jj8BGPvpa+JCF7Z/Aogoc+TJxusWkJ/bVeKNGA+6Yww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GuwdwjFJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GuwdwjFJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16FA7C4CEF1;
	Fri, 21 Nov 2025 13:26:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731566;
	bh=4i9VhQ+pR1LOe8eddwwwCvkBc0L/oyILRjqZPUgxPwY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GuwdwjFJGsU96QX6alelOyi9VjEw+YHxSvWZ3+Nr9p8WvlfHEh8le7J9ptOSz1nHL
	 OM5f3c1x8f11CwDBBISfAiPFPc6scp9ebT663HvxAshJeO97GN3E4O93ePUoqZe1WR
	 b7wJEb8It4nzQm1yxvYo7YZSH57VGSFE7zI/+v0k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <geliang@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.17 231/247] selftests: mptcp: join: rm: set backup flag
Date: Fri, 21 Nov 2025 14:12:58 +0100
Message-ID: <20251121130203.025582012@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

commit aea73bae662a0e184393d6d7d0feb18d2577b9b9 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/mptcp_join.sh |   54 ++++++++++++------------
 1 file changed, 27 insertions(+), 27 deletions(-)

--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -2347,7 +2347,7 @@ remove_tests()
 	if reset "remove single subflow"; then
 		pm_nl_set_limits $ns1 0 1
 		pm_nl_set_limits $ns2 0 1
-		pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
+		pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow,backup
 		addr_nr_ns2=-1 speed=slow \
 			run_tests $ns1 $ns2 10.0.1.1
 		chk_join_nr 1 1 1
@@ -2360,8 +2360,8 @@ remove_tests()
 	if reset "remove multiple subflows"; then
 		pm_nl_set_limits $ns1 0 2
 		pm_nl_set_limits $ns2 0 2
-		pm_nl_add_endpoint $ns2 10.0.2.2 flags subflow
-		pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
+		pm_nl_add_endpoint $ns2 10.0.2.2 flags subflow,backup
+		pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow,backup
 		addr_nr_ns2=-2 speed=slow \
 			run_tests $ns1 $ns2 10.0.1.1
 		chk_join_nr 2 2 2
@@ -2372,7 +2372,7 @@ remove_tests()
 	# single address, remove
 	if reset "remove single address"; then
 		pm_nl_set_limits $ns1 0 1
-		pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
+		pm_nl_add_endpoint $ns1 10.0.2.1 flags signal,backup
 		pm_nl_set_limits $ns2 1 1
 		addr_nr_ns1=-1 speed=slow \
 			run_tests $ns1 $ns2 10.0.1.1
@@ -2385,9 +2385,9 @@ remove_tests()
 	# subflow and signal, remove
 	if reset "remove subflow and signal"; then
 		pm_nl_set_limits $ns1 0 2
-		pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
+		pm_nl_add_endpoint $ns1 10.0.2.1 flags signal,backup
 		pm_nl_set_limits $ns2 1 2
-		pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
+		pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow,backup
 		addr_nr_ns1=-1 addr_nr_ns2=-1 speed=slow \
 			run_tests $ns1 $ns2 10.0.1.1
 		chk_join_nr 2 2 2
@@ -2399,10 +2399,10 @@ remove_tests()
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
 		addr_nr_ns1=-1 addr_nr_ns2=-2 speed=10 \
 			run_tests $ns1 $ns2 10.0.1.1
 		chk_join_nr 3 3 3
@@ -2414,9 +2414,9 @@ remove_tests()
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
 		addr_nr_ns1=-3 speed=10 \
 			run_tests $ns1 $ns2 10.0.1.1
@@ -2429,10 +2429,10 @@ remove_tests()
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
 		addr_nr_ns1=-3 speed=10 \
 			run_tests $ns1 $ns2 10.0.1.1
@@ -2446,10 +2446,10 @@ remove_tests()
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
 		addr_nr_ns1=-8 addr_nr_ns2=-8 speed=slow \
 			run_tests $ns1 $ns2 10.0.1.1
 		chk_join_nr 3 3 3
@@ -2462,9 +2462,9 @@ remove_tests()
 	if reset "flush subflows"; then
 		pm_nl_set_limits $ns1 3 3
 		pm_nl_set_limits $ns2 3 3
-		pm_nl_add_endpoint $ns2 10.0.2.2 flags subflow id 150
-		pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
-		pm_nl_add_endpoint $ns2 10.0.4.2 flags subflow
+		pm_nl_add_endpoint $ns2 10.0.2.2 flags subflow,backup id 150
+		pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow,backup
+		pm_nl_add_endpoint $ns2 10.0.4.2 flags subflow,backup
 		addr_nr_ns1=-8 addr_nr_ns2=-8 speed=slow \
 			run_tests $ns1 $ns2 10.0.1.1
 		chk_join_nr 3 3 3
@@ -2481,9 +2481,9 @@ remove_tests()
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
 		addr_nr_ns1=-8 addr_nr_ns2=-8 speed=slow \
 			run_tests $ns1 $ns2 10.0.1.1
@@ -2496,9 +2496,9 @@ remove_tests()
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
 		addr_nr_ns1=-8 speed=slow \
 			run_tests $ns1 $ns2 10.0.1.1


