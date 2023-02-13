Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A8C98F57
	for <patches@lists.linux.dev>; Mon, 13 Feb 2023 14:55:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01429C433D2;
	Mon, 13 Feb 2023 14:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676300145;
	bh=CzXKolw3VNH31qMJVG0/I7sMwCnwjBxw4+R3H0E8lQk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IZcHJzt8liL9W593ZUB88QlfFizlDmhs0HNHkSPQqAeNomo/1o1cDEjZb4PnT2gWO
	 etbvfVxVk2fgMqGbOvRdHaP4vybCbd1cIF+LyRuNlOEahuSva6g+ir2Lgzze2Z+P6h
	 cq1s8XGM7OcRuiBr+IRP8WODqTq4DGwE0nIaajxQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Matthieu Baerts <matthieu.baerts@tessares.net>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.1 081/114] selftests: mptcp: allow more slack for slow test-case
Date: Mon, 13 Feb 2023 15:48:36 +0100
Message-Id: <20230213144746.339058540@linuxfoundation.org>
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

From: Paolo Abeni <pabeni@redhat.com>

commit a635a8c3df66ab68dc088c08a4e9e955e22c0e64 upstream.

A test-case is frequently failing on some extremely slow VMs.
The mptcp transfer completes before the script is able to do
all the required PM manipulation.

Address the issue in the simplest possible way, making the
transfer even more slow.

Additionally dump more info in case of failures, to help debugging
similar problems in the future and init dump_stats var.

Fixes: e274f7154008 ("selftests: mptcp: add subflow limits test-cases")
Cc: stable@vger.kernel.org
Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/323
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/mptcp_join.sh |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -1688,6 +1688,7 @@ chk_subflow_nr()
 	local subflow_nr=$3
 	local cnt1
 	local cnt2
+	local dump_stats
 
 	if [ -n "${need_title}" ]; then
 		printf "%03u %-36s %s" "${TEST_COUNT}" "${TEST_NAME}" "${msg}"
@@ -1705,7 +1706,12 @@ chk_subflow_nr()
 		echo "[ ok ]"
 	fi
 
-	[ "${dump_stats}" = 1 ] && ( ss -N $ns1 -tOni ; ss -N $ns1 -tOni | grep token; ip -n $ns1 mptcp endpoint )
+	if [ "${dump_stats}" = 1 ]; then
+		ss -N $ns1 -tOni
+		ss -N $ns1 -tOni | grep token
+		ip -n $ns1 mptcp endpoint
+		dump_stats
+	fi
 }
 
 chk_link_usage()
@@ -3005,7 +3011,7 @@ endpoint_tests()
 		pm_nl_set_limits $ns1 1 1
 		pm_nl_set_limits $ns2 1 1
 		pm_nl_add_endpoint $ns2 10.0.2.2 id 2 dev ns2eth2 flags subflow
-		run_tests $ns1 $ns2 10.0.1.1 4 0 0 slow &
+		run_tests $ns1 $ns2 10.0.1.1 4 0 0 speed_20 &
 
 		wait_mpj $ns2
 		pm_nl_del_endpoint $ns2 2 10.0.2.2


