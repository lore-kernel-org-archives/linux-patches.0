Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BEE1274B2E;
	Fri, 21 Nov 2025 13:25:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731514; cv=none; b=HootoVT0FYwu29NWCz80gJXSKpeE7MwZqMvHzBZ9anJ8YP+v4M5tbKe2d6e5XZXCLKCCIrXU5jB8kX3DJIPkFOfi82M694hj0L+6Rl8J87tvmeJLAo9VKu5Hg88i2jANAnuVHqHzXiLTv50jz5IP0/KmWjgwPebV9E7oNo/ot7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731514; c=relaxed/simple;
	bh=x6J1fGtEkMcM49yZ/Wi92U+fGs7WTiFJx0B1Ur2abkw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UvHjHZpvjnT+TEkzGWN5AtmXo1Bv4U1NFtuWRFl9sUzLr/YE3oK9w0RUZW16g25qPcDVck4KYgOJZZ0or83REzUf3xEG2aQIg4ZFRCJJd2dwdY1cDMCzvlHR/hLB0U1LX1k+u5t5tulGL72TokrGXZbrGZzc81hzDNwvUrJTrhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iDuO6UdJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iDuO6UdJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24FF8C4CEF1;
	Fri, 21 Nov 2025 13:25:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731514;
	bh=x6J1fGtEkMcM49yZ/Wi92U+fGs7WTiFJx0B1Ur2abkw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iDuO6UdJn5YQLoeHGmp1eCs+sBdhiDFJ/BtW26fldXB6sMUkzyQeqs8PZwsEnsxP4
	 MRmCbgeorVvdWXQwLwGuHz7tA91HWGOGfsPW9ixrMAjlYk5jieqiBZRgGDHkDAZjN8
	 McgW1dPAJSNl3nOWrfl7cYjSLr+ZRba5FvWgemV4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.17 235/247] selftests: mptcp: join: properly kill background tasks
Date: Fri, 21 Nov 2025 14:13:02 +0100
Message-ID: <20251121130203.170556042@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/mptcp_join.sh |   18 +++++++++---------
 tools/testing/selftests/net/mptcp/mptcp_lib.sh  |   21 +++++++++++++++++++++
 2 files changed, 30 insertions(+), 9 deletions(-)

--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -3645,7 +3645,7 @@ userspace_tests()
 		chk_mptcp_info subflows 0 subflows 0
 		chk_subflows_total 1 1
 		kill_events_pids
-		mptcp_lib_kill_wait $tests_pid
+		mptcp_lib_kill_group_wait $tests_pid
 	fi
 
 	# userspace pm create destroy subflow
@@ -3673,7 +3673,7 @@ userspace_tests()
 		chk_mptcp_info subflows 0 subflows 0
 		chk_subflows_total 1 1
 		kill_events_pids
-		mptcp_lib_kill_wait $tests_pid
+		mptcp_lib_kill_group_wait $tests_pid
 	fi
 
 	# userspace pm create id 0 subflow
@@ -3694,7 +3694,7 @@ userspace_tests()
 		chk_mptcp_info subflows 1 subflows 1
 		chk_subflows_total 2 2
 		kill_events_pids
-		mptcp_lib_kill_wait $tests_pid
+		mptcp_lib_kill_group_wait $tests_pid
 	fi
 
 	# userspace pm remove initial subflow
@@ -3718,7 +3718,7 @@ userspace_tests()
 		chk_mptcp_info subflows 1 subflows 1
 		chk_subflows_total 1 1
 		kill_events_pids
-		mptcp_lib_kill_wait $tests_pid
+		mptcp_lib_kill_group_wait $tests_pid
 	fi
 
 	# userspace pm send RM_ADDR for ID 0
@@ -3744,7 +3744,7 @@ userspace_tests()
 		chk_mptcp_info subflows 1 subflows 1
 		chk_subflows_total 1 1
 		kill_events_pids
-		mptcp_lib_kill_wait $tests_pid
+		mptcp_lib_kill_group_wait $tests_pid
 	fi
 }
 
@@ -3774,7 +3774,7 @@ endpoint_tests()
 		pm_nl_add_endpoint $ns2 10.0.2.2 flags signal
 		pm_nl_check_endpoint "modif is allowed" \
 			$ns2 10.0.2.2 id 1 flags signal
-		mptcp_lib_kill_wait $tests_pid
+		mptcp_lib_kill_group_wait $tests_pid
 	fi
 
 	if reset_with_tcp_filter "delete and re-add" ns2 10.0.3.2 REJECT OUTPUT &&
@@ -3829,7 +3829,7 @@ endpoint_tests()
 			chk_mptcp_info subflows 3 subflows 3
 		done
 
-		mptcp_lib_kill_wait $tests_pid
+		mptcp_lib_kill_group_wait $tests_pid
 
 		kill_events_pids
 		chk_evt_nr ns1 MPTCP_LIB_EVENT_LISTENER_CREATED 1
@@ -3903,7 +3903,7 @@ endpoint_tests()
 		wait_mpj $ns2
 		chk_subflow_nr "after re-re-add ID 0" 3
 		chk_mptcp_info subflows 3 subflows 3
-		mptcp_lib_kill_wait $tests_pid
+		mptcp_lib_kill_group_wait $tests_pid
 
 		kill_events_pids
 		chk_evt_nr ns1 MPTCP_LIB_EVENT_LISTENER_CREATED 1
@@ -3951,7 +3951,7 @@ endpoint_tests()
 		wait_mpj $ns2
 		pm_nl_add_endpoint $ns1 10.0.3.1 id 2 flags signal
 		wait_mpj $ns2
-		mptcp_lib_kill_wait $tests_pid
+		mptcp_lib_kill_group_wait $tests_pid
 
 		join_syn_tx=3 join_connect_err=1 \
 			chk_join_nr 2 2 2
--- a/tools/testing/selftests/net/mptcp/mptcp_lib.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_lib.sh
@@ -350,6 +350,27 @@ mptcp_lib_kill_wait() {
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


