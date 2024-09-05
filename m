Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0E06154BFF;
	Thu,  5 Sep 2024 09:55:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725530130; cv=none; b=McABw7pGukyzsPWOUJNXy+Cp7PiBjYz/s1gEtdPDsW4bcnvlc65E7VZ0uvTo3Ju5HWGGTDtUdPJ3yZe7/EDOFvYlHj6a5IqXfW8t1+3JHFQSQszhMsD5AbKQaz9dVQXM3aYx3Fzs6Lq4aYcQELa1jyJinb2DhHZJdFmrqHC4JPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725530130; c=relaxed/simple;
	bh=uS5SgDEJx9ECSU1GKTvm5S0deECWNfjYgGTYx3RrZiA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WZ0+sQAw7nP50k4WGpRgYvzQGN8IMlZP1atVIARVhxCYBjqxBx7karyJDN9Ru4KXObcjIP34m4fkri8Ri+iNK8Rj9nEJxfvqbZAv1aKXLsl8h6d5eKUKKj4TBMxiI7Ndu8DCx65YnuWB+c6OQg/F3vNgUJXg3cc8Hh4Vk0H0v5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N9X86VY5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N9X86VY5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75776C4CEC3;
	Thu,  5 Sep 2024 09:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725530129;
	bh=uS5SgDEJx9ECSU1GKTvm5S0deECWNfjYgGTYx3RrZiA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N9X86VY5aG/wHpGqbOTU76FsPnD/6tj3/Dz2rD03/NCTEJ0jkCUbExHsu0kSxmePo
	 qWPDRKUF+VnkTMBCZ2KuGF5gciQRQYg6CjFgsWummyjRJRe/aYWxVsjNqVDNU2nw+v
	 iKE9c8Zu8Tk9Zh1KJXTym6G2WzSySLN8hSeMGiGI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <tanggeliang@kylinos.cn>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 032/132] selftests: mptcp: add mptcp_lib_events helper
Date: Thu,  5 Sep 2024 11:40:19 +0200
Message-ID: <20240905093723.488566801@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093722.230767298@linuxfoundation.org>
References: <20240905093722.230767298@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geliang Tang <tanggeliang@kylinos.cn>

commit 35bc143a8514ee72b2e9d6b8b385468608b93a53 upstream.

To avoid duplicated code in different MPTCP selftests, we can add and
use helpers defined in mptcp_lib.sh.

This patch unifies "pm_nl_ctl events" related code in userspace_pm.sh
and mptcp_join.sh into a helper mptcp_lib_events(). Define it in
mptcp_lib.sh and use it in both scripts.

Note that mptcp_lib_kill_wait is now call before starting 'events' for
mptcp_join.sh as well, but that's fine: each test is started from a new
netns, so there will not be any existing pid there, and nothing is done
when mptcp_lib_kill_wait is called with 0.

Signed-off-by: Geliang Tang <tanggeliang@kylinos.cn>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://lore.kernel.org/r/20240306-upstream-net-next-20240304-selftests-mptcp-shared-code-shellcheck-v2-6-bc79e6e5e6a0@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 20ccc7c5f7a3 ("selftests: mptcp: join: validate event numbers")
[ Conflicts in mptcp_lib.sh, because the context is different at the end
  of the file, where the new helper is supposed to go. The new helper
  has simply be added at the end. ]
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/mptcp_join.sh   |   10 ++++------
 tools/testing/selftests/net/mptcp/mptcp_lib.sh    |   12 ++++++++++++
 tools/testing/selftests/net/mptcp/userspace_pm.sh |   14 ++------------
 3 files changed, 18 insertions(+), 18 deletions(-)

--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -468,12 +468,8 @@ reset_with_events()
 {
 	reset "${1}" || return 1
 
-	:> "$evts_ns1"
-	:> "$evts_ns2"
-	ip netns exec $ns1 ./pm_nl_ctl events >> "$evts_ns1" 2>&1 &
-	evts_ns1_pid=$!
-	ip netns exec $ns2 ./pm_nl_ctl events >> "$evts_ns2" 2>&1 &
-	evts_ns2_pid=$!
+	mptcp_lib_events "${ns1}" "${evts_ns1}" evts_ns1_pid
+	mptcp_lib_events "${ns2}" "${evts_ns2}" evts_ns2_pid
 }
 
 reset_with_tcp_filter()
@@ -672,7 +668,9 @@ wait_mpj()
 kill_events_pids()
 {
 	mptcp_lib_kill_wait $evts_ns1_pid
+	evts_ns1_pid=0
 	mptcp_lib_kill_wait $evts_ns2_pid
+	evts_ns2_pid=0
 }
 
 pm_nl_set_limits()
--- a/tools/testing/selftests/net/mptcp/mptcp_lib.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_lib.sh
@@ -258,3 +258,15 @@ mptcp_lib_get_counter() {
 
 	echo "${count}"
 }
+
+mptcp_lib_events() {
+	local ns="${1}"
+	local evts="${2}"
+	declare -n pid="${3}"
+
+	:>"${evts}"
+
+	mptcp_lib_kill_wait "${pid:-0}"
+	ip netns exec "${ns}" ./pm_nl_ctl events >> "${evts}" 2>&1 &
+	pid=$!
+}
--- a/tools/testing/selftests/net/mptcp/userspace_pm.sh
+++ b/tools/testing/selftests/net/mptcp/userspace_pm.sh
@@ -201,21 +201,11 @@ make_connection()
 	if [ -z "$client_evts" ]; then
 		client_evts=$(mktemp)
 	fi
-	:>"$client_evts"
-	if [ $client_evts_pid -ne 0 ]; then
-		mptcp_lib_kill_wait $client_evts_pid
-	fi
-	ip netns exec "$ns2" ./pm_nl_ctl events >> "$client_evts" 2>&1 &
-	client_evts_pid=$!
+	mptcp_lib_events "${ns2}" "${client_evts}" client_evts_pid
 	if [ -z "$server_evts" ]; then
 		server_evts=$(mktemp)
 	fi
-	:>"$server_evts"
-	if [ $server_evts_pid -ne 0 ]; then
-		mptcp_lib_kill_wait $server_evts_pid
-	fi
-	ip netns exec "$ns1" ./pm_nl_ctl events >> "$server_evts" 2>&1 &
-	server_evts_pid=$!
+	mptcp_lib_events "${ns1}" "${server_evts}" server_evts_pid
 	sleep 0.5
 
 	# Run the server


