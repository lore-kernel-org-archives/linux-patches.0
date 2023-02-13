Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EF6A8F57
	for <patches@lists.linux.dev>; Mon, 13 Feb 2023 14:55:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91975C4339B;
	Mon, 13 Feb 2023 14:55:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676300147;
	bh=MbqiPFB46hWZuuccrVccW1XPi9Y59E/2ki4Ri2bG434=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ropBXO4uLBMV8lLJ3rLmJpNB9naYn5CggR6kXIpIRnpaU9Y7Jo0LisDTT2EbpmNH6
	 Khq226eCZJCdl4DAitqPiCRoLDkDtEsZsQp6fHmoS8NZODZqYgHw+Fi2301R4UjP7v
	 J1pYt1FRqYy07Yyapkzc0ytOfKB9bV44rlopSn7k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthieu Baerts <matthieu.baerts@tessares.net>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.1 082/114] selftests: mptcp: stop tests earlier
Date: Mon, 13 Feb 2023 15:48:37 +0100
Message-Id: <20230213144746.401171657@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144742.219399167@linuxfoundation.org>
References: <20230213144742.219399167@linuxfoundation.org>
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

commit 070d6dafacbaa9d1f2e4e3edc263853d194af15e upstream.

These 'endpoint' tests from 'mptcp_join.sh' selftest start a transfer in
the background and check the status during this transfer.

Once the expected events have been recorded, there is no reason to wait
for the data transfer to finish. It can be stopped earlier to reduce the
execution time by more than half.

For these tests, the exchanged data were not verified. Errors, if any,
were ignored but that's fine, plenty of other tests are looking at that.
It is then OK to mute stderr now that we are sure errors will be printed
(and still ignored) because the transfer is stopped before the end.

Fixes: e274f7154008 ("selftests: mptcp: add subflow limits test-cases")
Cc: stable@vger.kernel.org
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/mptcp_join.sh |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -472,6 +472,12 @@ kill_wait()
 	wait $1 2>/dev/null
 }
 
+kill_tests_wait()
+{
+	kill -SIGUSR1 $(ip netns pids $ns2) $(ip netns pids $ns1)
+	wait
+}
+
 pm_nl_set_limits()
 {
 	local ns=$1
@@ -2991,7 +2997,7 @@ endpoint_tests()
 		pm_nl_set_limits $ns1 2 2
 		pm_nl_set_limits $ns2 2 2
 		pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
-		run_tests $ns1 $ns2 10.0.1.1 0 0 0 slow &
+		run_tests $ns1 $ns2 10.0.1.1 0 0 0 slow 2>/dev/null &
 
 		wait_mpj $ns1
 		pm_nl_check_endpoint 1 "creation" \
@@ -3004,14 +3010,14 @@ endpoint_tests()
 		pm_nl_add_endpoint $ns2 10.0.2.2 flags signal
 		pm_nl_check_endpoint 0 "modif is allowed" \
 			$ns2 10.0.2.2 id 1 flags signal
-		wait
+		kill_tests_wait
 	fi
 
 	if reset "delete and re-add"; then
 		pm_nl_set_limits $ns1 1 1
 		pm_nl_set_limits $ns2 1 1
 		pm_nl_add_endpoint $ns2 10.0.2.2 id 2 dev ns2eth2 flags subflow
-		run_tests $ns1 $ns2 10.0.1.1 4 0 0 speed_20 &
+		run_tests $ns1 $ns2 10.0.1.1 4 0 0 speed_20 2>/dev/null &
 
 		wait_mpj $ns2
 		pm_nl_del_endpoint $ns2 2 10.0.2.2
@@ -3021,7 +3027,7 @@ endpoint_tests()
 		pm_nl_add_endpoint $ns2 10.0.2.2 dev ns2eth2 flags subflow
 		wait_mpj $ns2
 		chk_subflow_nr "" "after re-add" 2
-		wait
+		kill_tests_wait
 	fi
 }
 


