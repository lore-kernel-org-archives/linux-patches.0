Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9D131494DB;
	Thu,  5 Sep 2024 10:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725530417; cv=none; b=IPQLiFquYw+1RpO+lUKxMWrjNMEW253L2YGntEgTeT2aiKZ6SeW2kH1cSlELBrvnd5Elb238tNGUBwN7uVFICnW3B8t1P0Wh6SnUfQZZwV8hQOuVmSu3feDXbQdAEuYdDUtKJBujhetsJxZC8gXxeleDSqb/249ZrUI6Ox9WPWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725530417; c=relaxed/simple;
	bh=C0PiRwUAmXFBPq4TFl7c2b58dwGjjRIKiMwjP4gfg3M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S/lqW09Xu2eMIFXnwAocWpiYmijw4CqPF6uAyvyRwyTq8jt3vnU1gKVwzAHkw4gJuS7Bgbx3jYSzjOygnI9vCAW0dYpW/ZqyToSS+16y6GIfZmAez1uuP+yxQZ/q+/4Z299GFxlgPt5YOr17G8ZdFHxLU6lBcJFWUDOQCTGNNJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H12IDUiI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H12IDUiI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D935FC4CEC3;
	Thu,  5 Sep 2024 10:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725530417;
	bh=C0PiRwUAmXFBPq4TFl7c2b58dwGjjRIKiMwjP4gfg3M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H12IDUiIKsN/AWQ2x7sIk/7t7Yiq6ZZF7sz8XMBvyQHh1IwWBjr16ylVgYFhWA+tM
	 rT4h1OU4IaxlgKRlIUsE3COQv46F5iNVFP+n5IbifAPTz/AnUqiZZ4ctzuwNx3UHFI
	 CmzLuTx0sOFVDgiwg4ojF/SlQXHGPi6DFWERG0qY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 018/101] selftests: mptcp: join: check re-using ID of closed subflow
Date: Thu,  5 Sep 2024 11:40:50 +0200
Message-ID: <20240905093716.817414738@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093716.075835938@linuxfoundation.org>
References: <20240905093716.075835938@linuxfoundation.org>
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

commit 65fb58afa341ad68e71e5c4d816b407e6a683a66 upstream.

This test extends "delete and re-add" to validate the previous commit. A
new 'subflow' endpoint is added, but the subflow request will be
rejected. The result is that no subflow will be established from this
address.

Later, the endpoint is removed and re-added after having cleared the
firewall rule. Before the previous commit, the client would not have
been able to create this new subflow.

While at it, extra checks have been added to validate the expected
numbers of MPJ and RM_ADDR.

The 'Fixes' tag here below is the same as the one from the previous
commit: this patch here is not fixing anything wrong in the selftests,
but it validates the previous fix for an issue introduced by this commit
ID.

Fixes: b6c08380860b ("mptcp: remove addr and subflow in PM netlink")
Cc: stable@vger.kernel.org
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20240819-net-mptcp-pm-reusing-id-v1-4-38035d40de5b@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ Conflicts in mptcp_join.sh, because this subtest has been modified in
  newer versions, e.g. commit 9095ce97bf8a ("selftests: mptcp: add
  mptcp_info tests") added chk_mptcp_info check, commit 03668c65d153
  ("selftests: mptcp: join: rework detailed report") changed the way
  the info are displayed, commit 04b57c9e096a ("selftests: mptcp: join:
  stop transfer when check is done (part 2)") uses the new
  mptcp_lib_kill_wait helper instead of kill_tests_wait.
  Conflicts have been resolved by not using the new helpers, the rest
  was the same. ]
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/mptcp_join.sh |   25 +++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -402,9 +402,10 @@ reset_with_tcp_filter()
 	local ns="${!1}"
 	local src="${2}"
 	local target="${3}"
+	local chain="${4:-INPUT}"
 
 	if ! ip netns exec "${ns}" ${iptables} \
-			-A INPUT \
+			-A "${chain}" \
 			-s "${src}" \
 			-p tcp \
 			-j "${target}"; then
@@ -3265,10 +3266,10 @@ endpoint_tests()
 		kill_tests_wait
 	fi
 
-	if reset "delete and re-add" &&
+	if reset_with_tcp_filter "delete and re-add" ns2 10.0.3.2 REJECT OUTPUT &&
 	   mptcp_lib_kallsyms_has "subflow_rebuild_header$"; then
-		pm_nl_set_limits $ns1 1 1
-		pm_nl_set_limits $ns2 1 1
+		pm_nl_set_limits $ns1 0 2
+		pm_nl_set_limits $ns2 0 2
 		pm_nl_add_endpoint $ns2 10.0.2.2 id 2 dev ns2eth2 flags subflow
 		run_tests $ns1 $ns2 10.0.1.1 4 0 0 speed_20 2>/dev/null &
 
@@ -3277,10 +3278,24 @@ endpoint_tests()
 		sleep 0.5
 		chk_subflow_nr needtitle "after delete" 1
 
-		pm_nl_add_endpoint $ns2 10.0.2.2 dev ns2eth2 flags subflow
+		pm_nl_add_endpoint $ns2 10.0.2.2 id 2 dev ns2eth2 flags subflow
 		wait_mpj $ns2
 		chk_subflow_nr "" "after re-add" 2
+
+		pm_nl_add_endpoint $ns2 10.0.3.2 id 3 flags subflow
+		wait_attempt_fail $ns2
+		chk_subflow_nr "" "after new reject" 2
+
+		ip netns exec "${ns2}" ${iptables} -D OUTPUT -s "10.0.3.2" -p tcp -j REJECT
+		pm_nl_del_endpoint $ns2 3 10.0.3.2
+		pm_nl_add_endpoint $ns2 10.0.3.2 id 3 flags subflow
+		wait_mpj $ns2
+		chk_subflow_nr "" "after no reject" 3
+
 		kill_tests_wait
+
+		chk_join_nr 3 3 3
+		chk_rm_nr 1 1
 	fi
 }
 


