Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 487AB18BC28;
	Tue, 10 Sep 2024 10:11:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963086; cv=none; b=RKZwZ42mFjYW3Nn4jV0uMDFImHZo0yd1Dn1kDp32H7DSQ0GBPGEcwJJ6EquhKPTFEbekIDPZE8+Nq8yFDtO1UwBSRNPPZ7ToZwW8rxOJ18bHPGzGo11asgwEg9JKtqiJLMB7vjhz85BFQtB5EuUlf93PwO6q5wdDQ0qWmxZll80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963086; c=relaxed/simple;
	bh=1VbbEDvwZ3tBR9zUjfA6WiW36iDmtSA9ZMpljn2pShM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ABFfP3ACnOdmBAPe5kuYz1in7TWyABH3RQgdQnSr1UnidNmlX4ovoEAen6TgEFCMq87f1wlfOofcBgrCTgo+PA/MXC1HDLhzibq2sK7Ybz79XzSQygn2ag51dcqvkJEt86+1htXgu2EpX5UVi4S+hMrBpia8065kAJ8us2kFc6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t/UVmcCs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t/UVmcCs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C42B0C4CEC3;
	Tue, 10 Sep 2024 10:11:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963086;
	bh=1VbbEDvwZ3tBR9zUjfA6WiW36iDmtSA9ZMpljn2pShM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t/UVmcCs8uJruXEBwEPYHwc3NC6VhZ/e8c1UORymnCe5FqC6oDG9L21hcGMisy3mR
	 ySpttUDa3uB6qYi+x4EXQ0CQ348Gny6+xjGTzweaR39dn1wiiB6kq2XuvCCWjuLHaO
	 6CRkJbAqVOJ8E5Q8MUhnhMVaRAivyFq0o4I6J1z8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>
Subject: [PATCH 6.1 130/192] selftests: mptcp: fix backport issues
Date: Tue, 10 Sep 2024 11:32:34 +0200
Message-ID: <20240910092603.370503971@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092557.876094467@linuxfoundation.org>
References: <20240910092557.876094467@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Matthieu Baerts (NGI0)" <matttbe@kernel.org>

By accident, some patches modifying the MPTCP selftests have been
applied twice, using different versions of the patch [1].

These patches have been dropped, but it looks like quilt incorrectly
handled that by placing the new subtests at the wrong place: in
userspace_tests() instead of endpoint_tests(). That caused a few other
patches not to apply properly.

Not to have to revert and re-apply patches, this issue can be fixed by
moving some code around.

Link: https://lore.kernel.org/fc21db4a-508d-41db-aa45-e3bc06d18ce7@kernel.org [1]
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/mptcp_join.sh |  138 ++++++++++++------------
 1 file changed, 69 insertions(+), 69 deletions(-)

--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -3236,75 +3236,6 @@ userspace_tests()
 		chk_join_nr 1 1 1
 		chk_rm_nr 0 1
 	fi
-
-	# remove and re-add
-	if reset "delete re-add signal" &&
-	   mptcp_lib_kallsyms_has "subflow_rebuild_header$"; then
-		pm_nl_set_limits $ns1 0 3
-		pm_nl_set_limits $ns2 3 3
-		pm_nl_add_endpoint $ns1 10.0.2.1 id 1 flags signal
-		# broadcast IP: no packet for this address will be received on ns1
-		pm_nl_add_endpoint $ns1 224.0.0.1 id 2 flags signal
-		pm_nl_add_endpoint $ns1 10.0.1.1 id 42 flags signal
-		run_tests $ns1 $ns2 10.0.1.1 4 0 0 speed_20 2>/dev/null &
-		local tests_pid=$!
-
-		wait_mpj $ns2
-		chk_subflow_nr needtitle "before delete" 2
-
-		pm_nl_del_endpoint $ns1 1 10.0.2.1
-		pm_nl_del_endpoint $ns1 2 224.0.0.1
-		sleep 0.5
-		chk_subflow_nr "" "after delete" 1
-
-		pm_nl_add_endpoint $ns1 10.0.2.1 id 1 flags signal
-		pm_nl_add_endpoint $ns1 10.0.3.1 id 2 flags signal
-		wait_mpj $ns2
-		chk_subflow_nr "" "after re-add" 3
-
-		pm_nl_del_endpoint $ns1 42 10.0.1.1
-		sleep 0.5
-		chk_subflow_nr "" "after delete ID 0" 2
-
-		pm_nl_add_endpoint $ns1 10.0.1.1 id 99 flags signal
-		wait_mpj $ns2
-		chk_subflow_nr "" "after re-add" 3
-		kill_tests_wait
-
-		chk_join_nr 4 4 4
-		chk_add_nr 5 5
-		chk_rm_nr 3 2 invert
-	fi
-
-	# flush and re-add
-	if reset_with_tcp_filter "flush re-add" ns2 10.0.3.2 REJECT OUTPUT &&
-	   mptcp_lib_kallsyms_has "subflow_rebuild_header$"; then
-		pm_nl_set_limits $ns1 0 2
-		pm_nl_set_limits $ns2 1 2
-		# broadcast IP: no packet for this address will be received on ns1
-		pm_nl_add_endpoint $ns1 224.0.0.1 id 2 flags signal
-		pm_nl_add_endpoint $ns2 10.0.3.2 id 3 flags subflow
-		run_tests $ns1 $ns2 10.0.1.1 4 0 0 speed_20 2>/dev/null &
-		local tests_pid=$!
-
-		wait_attempt_fail $ns2
-		chk_subflow_nr needtitle "before flush" 1
-
-		pm_nl_flush_endpoint $ns2
-		pm_nl_flush_endpoint $ns1
-		wait_rm_addr $ns2 0
-		ip netns exec "${ns2}" ${iptables} -D OUTPUT -s "10.0.3.2" -p tcp -j REJECT
-		pm_nl_add_endpoint $ns2 10.0.3.2 id 3 flags subflow
-		wait_mpj $ns2
-		pm_nl_add_endpoint $ns1 10.0.3.1 id 2 flags signal
-		wait_mpj $ns2
-		kill_wait "${tests_pid}"
-		kill_tests_wait
-
-		chk_join_nr 2 2 2
-		chk_add_nr 2 2
-		chk_rm_nr 1 0 invert
-	fi
 }
 
 endpoint_tests()
@@ -3375,6 +3306,75 @@ endpoint_tests()
 		chk_join_nr 6 6 6
 		chk_rm_nr 4 4
 	fi
+
+	# remove and re-add
+	if reset "delete re-add signal" &&
+	   mptcp_lib_kallsyms_has "subflow_rebuild_header$"; then
+		pm_nl_set_limits $ns1 0 3
+		pm_nl_set_limits $ns2 3 3
+		pm_nl_add_endpoint $ns1 10.0.2.1 id 1 flags signal
+		# broadcast IP: no packet for this address will be received on ns1
+		pm_nl_add_endpoint $ns1 224.0.0.1 id 2 flags signal
+		pm_nl_add_endpoint $ns1 10.0.1.1 id 42 flags signal
+		run_tests $ns1 $ns2 10.0.1.1 4 0 0 speed_20 2>/dev/null &
+		local tests_pid=$!
+
+		wait_mpj $ns2
+		chk_subflow_nr needtitle "before delete" 2
+
+		pm_nl_del_endpoint $ns1 1 10.0.2.1
+		pm_nl_del_endpoint $ns1 2 224.0.0.1
+		sleep 0.5
+		chk_subflow_nr "" "after delete" 1
+
+		pm_nl_add_endpoint $ns1 10.0.2.1 id 1 flags signal
+		pm_nl_add_endpoint $ns1 10.0.3.1 id 2 flags signal
+		wait_mpj $ns2
+		chk_subflow_nr "" "after re-add" 3
+
+		pm_nl_del_endpoint $ns1 42 10.0.1.1
+		sleep 0.5
+		chk_subflow_nr "" "after delete ID 0" 2
+
+		pm_nl_add_endpoint $ns1 10.0.1.1 id 99 flags signal
+		wait_mpj $ns2
+		chk_subflow_nr "" "after re-add" 3
+		kill_tests_wait
+
+		chk_join_nr 4 4 4
+		chk_add_nr 5 5
+		chk_rm_nr 3 2 invert
+	fi
+
+	# flush and re-add
+	if reset_with_tcp_filter "flush re-add" ns2 10.0.3.2 REJECT OUTPUT &&
+	   mptcp_lib_kallsyms_has "subflow_rebuild_header$"; then
+		pm_nl_set_limits $ns1 0 2
+		pm_nl_set_limits $ns2 1 2
+		# broadcast IP: no packet for this address will be received on ns1
+		pm_nl_add_endpoint $ns1 224.0.0.1 id 2 flags signal
+		pm_nl_add_endpoint $ns2 10.0.3.2 id 3 flags subflow
+		run_tests $ns1 $ns2 10.0.1.1 4 0 0 speed_20 2>/dev/null &
+		local tests_pid=$!
+
+		wait_attempt_fail $ns2
+		chk_subflow_nr needtitle "before flush" 1
+
+		pm_nl_flush_endpoint $ns2
+		pm_nl_flush_endpoint $ns1
+		wait_rm_addr $ns2 0
+		ip netns exec "${ns2}" ${iptables} -D OUTPUT -s "10.0.3.2" -p tcp -j REJECT
+		pm_nl_add_endpoint $ns2 10.0.3.2 id 3 flags subflow
+		wait_mpj $ns2
+		pm_nl_add_endpoint $ns1 10.0.3.1 id 2 flags signal
+		wait_mpj $ns2
+		kill_wait "${tests_pid}"
+		kill_tests_wait
+
+		chk_join_nr 2 2 2
+		chk_add_nr 2 2
+		chk_rm_nr 1 0 invert
+	fi
 }
 
 # [$1: error message]


