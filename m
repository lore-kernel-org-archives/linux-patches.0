Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C28D2BF3E2;
	Tue, 10 Mar 2026 11:12:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141163; cv=none; b=axkYdPwx6GVS4k32rQSBIRyCQiqviMwuO0Ho8HNft0PWw+dqaJOpbav2F2Rsqq0ztb22FcySNCyQudBBkN7YpE0mWXEsrMslR8pvB0eAsVvvHQNoRmyYeh8PhNYrILF43CiXMEdR+tqBEq4wKQs+ubA4cUm3RDyh4ldMO2LtDKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141163; c=relaxed/simple;
	bh=lYtO2gjxWt85x2jQzyOrrGYWI6Dn2a0anzKTfo0EfQw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GEwxyplb8HueWgAm3Embg1T2HVCUukExGal2BKS5RC6ry/grxcbQpesQTRciYLO35YXGfBvEAO5A6zJYsbfY9g9wlJO23qR/WmQXNFHxVmnLCotUetJjSdnwpaPIDQ9cts/TC15xyBHc47ULWqVE2PINdoMKPpzk4jVCNVZBZ0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sM6Ei4l9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sM6Ei4l9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62D9FC2BC86;
	Tue, 10 Mar 2026 11:12:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141163;
	bh=lYtO2gjxWt85x2jQzyOrrGYWI6Dn2a0anzKTfo0EfQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sM6Ei4l9lkPLGNJe36w6R91FCeEMCYb3ZatZ4SE2O3jDXe+oNgr+4Vyp8W5+Y5mBx
	 9eoBB/Aa21EHXCmc+pjO4kxonMqjLq08ImPqhfNn8xbsB5Rw6EeS/pzjkhwsYkp7q2
	 fb2/SCqlJKVXEZTRTs613LSJB0D+/oyNJK4EKv4VIBOV4lIXGUdO4TLkPTHQ9Qd30x
	 7+3tnZXf0bakCrBjy0HUeMxXoQswY59wDpOJwbP24cgw25wA2XzSJngKjg1U4+8nJb
	 qNgZHcJ3kc/+ljn39W8zPpbCQyssq5x0zzBSsnbUJvdEgrPY/sb5fw4EKqpQJd3VNJ
	 Gq1ytY2YwJXow==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: "Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Mat Martineau <martineau@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 6.19 165/311] selftests: mptcp: join: check RM_ADDR not sent over same subflow
Date: Tue, 10 Mar 2026 07:03:32 -0400
Message-ID: <96dbdd4c0baf80b67df0c2eeda1a9c453581d2b0.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: "Matthieu Baerts (NGI0)" <matttbe@kernel.org>

commit 560edd99b5f58b2d4bbe3c8e51e1eed68d887b0e upstream.

This validates the previous commit: RM_ADDR were sent over the first
found active subflow which could be the same as the one being removed.
It is more likely to loose this notification.

For this check, RM_ADDR are explicitly dropped when trying to send them
over the initial subflow, when removing the endpoint attached to it. If
it is dropped, the test will complain because some RM_ADDR have not been
received.

Note that only the RM_ADDR are dropped, to allow the linked subflow to
be quickly and cleanly closed. To only drop those RM_ADDR, a cBPF byte
code is used. If the IPTables commands fail, that's OK, the tests will
continue to pass, but not validate this part. This can be ignored:
another subtest fully depends on such command, and will be marked as
skipped.

The 'Fixes' tag here below is the same as the one from the previous
commit: this patch here is not fixing anything wrong in the selftests,
but it validates the previous fix for an issue introduced by this commit
ID.

Fixes: 8dd5efb1f91b ("mptcp: send ack for rm_addr")
Cc: stable@vger.kernel.org
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20260303-net-mptcp-misc-fixes-7-0-rc2-v1-3-4b5462b6f016@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 .../testing/selftests/net/mptcp/mptcp_join.sh | 36 +++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_join.sh b/tools/testing/selftests/net/mptcp/mptcp_join.sh
index e70d3420954fc..2e7461c488c71 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -104,6 +104,24 @@ CBPF_MPTCP_SUBOPTION_ADD_ADDR="14,
 			       6 0 0 65535,
 			       6 0 0 0"
 
+# IPv4: TCP hdr of 48B, a first suboption of 12B (DACK8), the RM_ADDR suboption
+# generated using "nfbpf_compile '(ip[32] & 0xf0) == 0xc0 && ip[53] == 0x0c &&
+#				  (ip[66] & 0xf0) == 0x40'"
+CBPF_MPTCP_SUBOPTION_RM_ADDR="13,
+			      48 0 0 0,
+			      84 0 0 240,
+			      21 0 9 64,
+			      48 0 0 32,
+			      84 0 0 240,
+			      21 0 6 192,
+			      48 0 0 53,
+			      21 0 4 12,
+			      48 0 0 66,
+			      84 0 0 240,
+			      21 0 1 64,
+			      6 0 0 65535,
+			      6 0 0 0"
+
 init_partial()
 {
 	capout=$(mktemp)
@@ -4222,6 +4240,14 @@ endpoint_tests()
 		chk_subflow_nr "after no reject" 3
 		chk_mptcp_info subflows 2 subflows 2
 
+		# To make sure RM_ADDR are sent over a different subflow, but
+		# allow the rest to quickly and cleanly close the subflow
+		local ipt=1
+		ip netns exec "${ns2}" ${iptables} -I OUTPUT -s "10.0.1.2" \
+			-p tcp -m tcp --tcp-option 30 \
+			-m bpf --bytecode \
+			"$CBPF_MPTCP_SUBOPTION_RM_ADDR" \
+			-j DROP || ipt=0
 		local i
 		for i in $(seq 3); do
 			pm_nl_del_endpoint $ns2 1 10.0.1.2
@@ -4234,6 +4260,7 @@ endpoint_tests()
 			chk_subflow_nr "after re-add id 0 ($i)" 3
 			chk_mptcp_info subflows 3 subflows 3
 		done
+		[ ${ipt} = 1 ] && ip netns exec "${ns2}" ${iptables} -D OUTPUT 1
 
 		mptcp_lib_kill_group_wait $tests_pid
 
@@ -4293,11 +4320,20 @@ endpoint_tests()
 		chk_mptcp_info subflows 2 subflows 2
 		chk_mptcp_info add_addr_signal 2 add_addr_accepted 2
 
+		# To make sure RM_ADDR are sent over a different subflow, but
+		# allow the rest to quickly and cleanly close the subflow
+		local ipt=1
+		ip netns exec "${ns1}" ${iptables} -I OUTPUT -s "10.0.1.1" \
+			-p tcp -m tcp --tcp-option 30 \
+			-m bpf --bytecode \
+			"$CBPF_MPTCP_SUBOPTION_RM_ADDR" \
+			-j DROP || ipt=0
 		pm_nl_del_endpoint $ns1 42 10.0.1.1
 		sleep 0.5
 		chk_subflow_nr "after delete ID 0" 2
 		chk_mptcp_info subflows 2 subflows 2
 		chk_mptcp_info add_addr_signal 2 add_addr_accepted 2
+		[ ${ipt} = 1 ] && ip netns exec "${ns1}" ${iptables} -D OUTPUT 1
 
 		pm_nl_add_endpoint $ns1 10.0.1.1 id 99 flags signal
 		wait_mpj $ns2
-- 
2.51.0

