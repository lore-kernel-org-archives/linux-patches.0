Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48AD92773E4;
	Tue, 17 Feb 2026 20:47:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771361244; cv=none; b=ldIyMOe72uFGEyjGZogBGwDmIHenr8gGeyOGkMoyxMR5jhBzaX3LWjF5CaXiToUu0wCP1mAfH2aMuU8QvOrHT5NBTs7ImEJv/xAqbwYPLa/wj+F3dEexFKDvVVme6YdXG00qa8Qa8DlusqJZ1TQXnTj2m8RWHSJFKusKDIrpBbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771361244; c=relaxed/simple;
	bh=INXj2/1weNW6ctqsDJLgp41IbiLhoPiQiJKt4mM4fiY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G9YugnJeKiwNS8MIT1WFdeoq5d+SBOXavsRH7aFECBHhQHGkfuYTpaQCmIxhxXTLA/XH7JL+D1XVzVOOMmqii1aSIvRs2VM5aBO8bRGhhrSTq9CZh840R7zwJkfx4yX74QDatpXoaEMfdu0InOCArFmyBO1t1ofqKVNr6v791bw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pMRBI3Op; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pMRBI3Op"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7CA3C4CEF7;
	Tue, 17 Feb 2026 20:47:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771361244;
	bh=INXj2/1weNW6ctqsDJLgp41IbiLhoPiQiJKt4mM4fiY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pMRBI3Opt97bLR9+fpue0aULh3Kkk2PzzW6WlpcROXXoq8TbMT3W49RuWLWsdTmej
	 RpnYcAw+kdRZxZufvlns6zvvsc11H9ysuuOWbPMrnv9rb9yvpUcqd9+r16zWcsKRNM
	 7tm0pMz7mSvKLdJ6873njjKAWjk5NpSKyoNg0UAQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <geliang@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 44/64] selftests: mptcp: check no dup close events after error
Date: Tue, 17 Feb 2026 21:31:40 +0100
Message-ID: <20260217200009.156427718@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260217200007.505931165@linuxfoundation.org>
References: <20260217200007.505931165@linuxfoundation.org>
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

commit 8467458dfa61b37e259e3485a5d3e415d08193c1 upstream.

This validates the previous commit: subflow closed events are re-sent
with less info when the initial subflow is disconnected after an error
and each time a subflow is closed after that.

In this new test, the userspace PM is involved because that's how it was
discovered, but it is not specific to it. The initial subflow is
terminated with a RESET, and that will cause the subflow disconnect.
Then, a new subflow is initiated, but also got rejected, which cause a
second subflow closed event, but not a third one.

While at it, in case of failure to get the expected amount of events,
the events are printed.

The 'Fixes' tag here below is the same as the one from the previous
commit: this patch here is not fixing anything wrong in the selftests,
but it validates the previous fix for an issue introduced by this commit
ID.

Fixes: d82809b6c5f2 ("mptcp: avoid duplicated SUB_CLOSED events")
Cc: stable@vger.kernel.org
Reviewed-by: Geliang Tang <geliang@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20260127-net-mptcp-dup-nl-events-v1-2-7f71e1bc4feb@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ Conflicts in mptcp_join.sh, because in this version, commit
  20ccc7c5f7a3 ("selftests: mptcp: join: validate event numbers") has
  been backported with adaptations to display results correctly, see
  commit 5dc9170eee96 ("selftests: mptcp: join: validate event numbers")
  for more details. The same type of adaptations had to be made here as
  well, plus importing a few additional helpers: userspace_pm_add_sf,
  evts_get_info and get_info_value. ]
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/mptcp_join.sh |   79 ++++++++++++++++++++++++
 1 file changed, 79 insertions(+)

--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -3183,6 +3183,35 @@ fail_tests()
 	fi
 }
 
+# get the value of keyword $1 in the line marked by keyword $2
+get_info_value() {
+	grep "${2}" 2>/dev/null |
+		sed -n 's/.*\('"${1}"':\)\([0-9a-f:.]*\).*$/\2/p;q'
+		# the ';q' at the end limits to the first matched entry.
+}
+
+# $1: info name ; $2: evts_ns ; [$3: event type; [$4: addr]]
+evts_get_info() {
+	grep "${4:-}" "${2}" 2>/dev/null |
+		get_info_value "${1}" "^type:${3:-1},"
+}
+
+# $1: ns ; $2: addr ; $3: id
+userspace_pm_add_sf()
+{
+	local evts=$evts_ns1
+	local tk da dp
+
+	[ "$1" == "$ns2" ] && evts=$evts_ns2
+	tk=$(evts_get_info token "$evts")
+	da=$(evts_get_info daddr4 "$evts")
+	dp=$(evts_get_info dport "$evts")
+
+	ip netns exec $1 ./pm_nl_ctl csf lip $2 lid $3 \
+				rip $da rport $dp token $tk
+	sleep 1
+}
+
 # $1: ns ; $2: event type ; $3: count
 chk_evt_nr()
 {
@@ -3204,11 +3233,32 @@ chk_evt_nr()
 		echo "[fail] got $count events, expected $exp"
 		fail_test
 		dump_stats
+		cat "${evts}"
 	else
 		echo "[ ok ]"
 	fi
 }
 
+# $1: ns ; $2: event type ; $3: expected count
+wait_event()
+{
+	local ns="${1}"
+	local evt_name="${2}"
+	local exp="${3}"
+
+	local evt="${!evt_name}"
+	local evts="${evts_ns1}"
+	local count
+
+	[ "${ns}" == "ns2" ] && evts="${evts_ns2}"
+
+	for _ in $(seq 100); do
+		count=$(grep -cw "type:${evt}" "${evts}")
+		[ "${count}" -ge "${exp}" ] && break
+		sleep 0.1
+	done
+}
+
 userspace_tests()
 {
 	# userspace pm type prevents add_addr
@@ -3302,6 +3352,35 @@ userspace_tests()
 		chk_join_nr 1 1 1
 		chk_rm_nr 0 1
 	fi
+
+	# userspace pm no duplicated spurious close events after an error
+	if reset_with_events "userspace pm no dup close events after error" &&
+	   continue_if mptcp_lib_has_file '/proc/sys/net/mptcp/pm_type'; then
+		set_userspace_pm $ns2
+		pm_nl_set_limits $ns1 0 2
+		run_tests $ns1 $ns2 10.0.1.1 128 0 0 slow 2>/dev/null &
+		local tests_pid=$!
+		wait_event ns2 MPTCP_LIB_EVENT_ESTABLISHED 1
+		userspace_pm_add_sf $ns2 10.0.3.2 20
+		chk_subflow_nr needtitle "new subflow" 2
+
+		# force quick loss
+		ip netns exec $ns2 sysctl -q net.ipv4.tcp_syn_retries=1
+		if ip netns exec "${ns1}" ${iptables} -A INPUT -s "10.0.1.2" \
+		      -p tcp --tcp-option 30 -j REJECT --reject-with tcp-reset &&
+		   ip netns exec "${ns2}" ${iptables} -A INPUT -d "10.0.1.2" \
+		      -p tcp --tcp-option 30 -j REJECT --reject-with tcp-reset; then
+			wait_event ns2 MPTCP_LIB_EVENT_SUB_CLOSED 1
+			wait_event ns1 MPTCP_LIB_EVENT_SUB_CLOSED 1
+			chk_subflow_nr "" "after reject" 1
+			userspace_pm_add_sf $ns2 10.0.1.2 0
+			wait_event ns2 MPTCP_LIB_EVENT_SUB_CLOSED 2
+			chk_evt_nr ns2 MPTCP_LIB_EVENT_SUB_CLOSED 2
+		fi
+		kill_wait "${tests_pid}"
+		kill_events_pids
+		kill_tests_wait
+	fi
 }
 
 endpoint_tests()


