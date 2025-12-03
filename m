Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3BCC359FA4;
	Wed,  3 Dec 2025 17:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764781240; cv=none; b=FDzpa+BzjTfWjg+ynFgpfzpmzaj/t353ujIzSsXRNg0qicRjiUSIf319K9HtAI6dLdrFq8YwfAMXyXpXf5u/65qDs8TE+hk7Gbcj4gpDdWf+NA3ui4AYIr8p1vVosqowdnoaPj1hzsfQfvey2KiVgKkfs11bBGOtoyQMCZKjJyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764781240; c=relaxed/simple;
	bh=Dj9qB3BUPRLscfwgxn2aLKqtVu2wbU7q5XlujF9YfdQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZA3xaXHjuyl2/rMunukJyGmSQd0BWz3CEHaz7d6oswn/xJ3j9j0FoRpD922tBfkCzx9Ro4e9NbHb+BiaSAiwpP+j35QW9CETaZyHI2eMPjCc0AMyRwKjospfQXQeorML/KVTWFnV8V9T2ks4ye83Tr6a/ofY1j3/s36EhHMADb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0SKE5OD3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0SKE5OD3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25DBDC4CEF5;
	Wed,  3 Dec 2025 17:00:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764781240;
	bh=Dj9qB3BUPRLscfwgxn2aLKqtVu2wbU7q5XlujF9YfdQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0SKE5OD3ucImL4N5Tbuc906J3g7ALMn4I3nJQwqJ6N+Omq0FTHUxQFbRcfoqJ6rkh
	 DD+x4hG73rouP3eCVOQwKnI3RVIB2zONUgjxoPMzSwNp+XdY+pLNj+IbkGcywojwjr
	 aZuyG1DQzl4+oC76ANU9m7mVzzELLsGZJhWrsxHM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 88/93] selftests: mptcp: join: properly kill background tasks
Date: Wed,  3 Dec 2025 16:30:21 +0100
Message-ID: <20251203152339.810757901@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152336.494201426@linuxfoundation.org>
References: <20251203152336.494201426@linuxfoundation.org>
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

From: "Matthieu Baerts (NGI0)" <matttbe@kernel.org>

commit 852b644acbce1529307a4bb283752c4e77b5cda7 upstream.

The 'run_tests' function is executed in the background, but killing its
associated PID would not kill the children tasks running in the
background.

To properly kill all background tasks, 'kill -- -PID' could be used, but
this requires kill from procps-ng. Instead, all children tasks are
listed using 'ps', and 'kill' is called with all PIDs of this group.

Fixes: 31ee4ad86afd ("selftests: mptcp: join: stop transfer when check is done (part 1)")
Cc: stable@vger.kernel.org
Fixes: 04b57c9e096a ("selftests: mptcp: join: stop transfer when check is done (part 2)")
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20251110-net-mptcp-sft-join-unstable-v1-6-a4332c714e10@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ Conflicts in mptcp_join.sh, because commit e3b47e460b4b ("selftests:
  mptcp: userspace pm remove initial subflow") and commit b9fb176081fb
  ("selftests: mptcp: userspace pm send RM_ADDR for ID 0") are not in
  this version. They introduced new subtests that got modified by this
  patch. That's OK, no need to modify them if they are not there: the
  conflicts can be dropped. ]
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/mptcp_join.sh |   14 +++++++-------
 tools/testing/selftests/net/mptcp/mptcp_lib.sh  |   21 +++++++++++++++++++++
 2 files changed, 28 insertions(+), 7 deletions(-)

--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -3679,7 +3679,7 @@ userspace_tests()
 		chk_mptcp_info subflows 0 subflows 0
 		chk_subflows_total 1 1
 		kill_events_pids
-		mptcp_lib_kill_wait $tests_pid
+		mptcp_lib_kill_group_wait $tests_pid
 	fi
 
 	# userspace pm create destroy subflow
@@ -3707,7 +3707,7 @@ userspace_tests()
 		chk_mptcp_info subflows 0 subflows 0
 		chk_subflows_total 1 1
 		kill_events_pids
-		mptcp_lib_kill_wait $tests_pid
+		mptcp_lib_kill_group_wait $tests_pid
 	fi
 
 	# userspace pm create id 0 subflow
@@ -3728,7 +3728,7 @@ userspace_tests()
 		chk_mptcp_info subflows 1 subflows 1
 		chk_subflows_total 2 2
 		kill_events_pids
-		mptcp_lib_kill_wait $tests_pid
+		mptcp_lib_kill_group_wait $tests_pid
 	fi
 }
 
@@ -3758,7 +3758,7 @@ endpoint_tests()
 		pm_nl_add_endpoint $ns2 10.0.2.2 flags signal
 		pm_nl_check_endpoint "modif is allowed" \
 			$ns2 10.0.2.2 id 1 flags signal
-		mptcp_lib_kill_wait $tests_pid
+		mptcp_lib_kill_group_wait $tests_pid
 	fi
 
 	if reset_with_tcp_filter "delete and re-add" ns2 10.0.3.2 REJECT OUTPUT &&
@@ -3813,7 +3813,7 @@ endpoint_tests()
 			chk_mptcp_info subflows 3 subflows 3
 		done
 
-		mptcp_lib_kill_wait $tests_pid
+		mptcp_lib_kill_group_wait $tests_pid
 
 		kill_events_pids
 		chk_evt_nr ns1 MPTCP_LIB_EVENT_LISTENER_CREATED 1
@@ -3886,7 +3886,7 @@ endpoint_tests()
 		wait_mpj $ns2
 		chk_subflow_nr "after re-re-add ID 0" 3
 		chk_mptcp_info subflows 3 subflows 3
-		mptcp_lib_kill_wait $tests_pid
+		mptcp_lib_kill_group_wait $tests_pid
 
 		kill_events_pids
 		chk_evt_nr ns1 MPTCP_LIB_EVENT_LISTENER_CREATED 1
@@ -3933,7 +3933,7 @@ endpoint_tests()
 		wait_mpj $ns2
 		pm_nl_add_endpoint $ns1 10.0.3.1 id 2 flags signal
 		wait_mpj $ns2
-		mptcp_lib_kill_wait $tests_pid
+		mptcp_lib_kill_group_wait $tests_pid
 
 		chk_join_nr 2 2 2
 		chk_add_nr 2 2
--- a/tools/testing/selftests/net/mptcp/mptcp_lib.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_lib.sh
@@ -242,6 +242,27 @@ mptcp_lib_kill_wait() {
 	wait "${1}" 2>/dev/null
 }
 
+# $1: PID
+mptcp_lib_pid_list_children() {
+	local curr="${1}"
+	# evoke 'ps' only once
+	local pids="${2:-"$(ps o pid,ppid)"}"
+
+	echo "${curr}"
+
+	local pid
+	for pid in $(echo "${pids}" | awk "\$2 == ${curr} { print \$1 }"); do
+		mptcp_lib_pid_list_children "${pid}" "${pids}"
+	done
+}
+
+# $1: PID
+mptcp_lib_kill_group_wait() {
+	# Some users might not have procps-ng: cannot use "kill -- -PID"
+	mptcp_lib_pid_list_children "${1}" | xargs -r kill &>/dev/null
+	wait "${1}" 2>/dev/null
+}
+
 # $1: IP address
 mptcp_lib_is_v6() {
 	[ -z "${1##*:*}" ]


