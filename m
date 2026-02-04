Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67A502BE7C0;
	Wed,  4 Feb 2026 15:20:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218452; cv=none; b=XO7yCgVoyA5v74CZsSfpHCMHd9X9M6sjIKyxEQcF6Jh/RsmuMFSZsdavlFnWjB5s6SZ3IKPHBjGkOgut2tI4RMnoBeXLPLCZPv83Fv4C19Y3be5F/3ExMyB2SzceI5okSC9JfMNsgnFCnVaUnbrcRhSS060i6/DVD+5UF3miqf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218452; c=relaxed/simple;
	bh=CSjP2bHz/0XoiRvgTPJszvH9OcgxkkBM2DiT5R3YomY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b+Whu+FIj15vzplEUxa31eCOqpVcLHuIpCwShssfXjd97rznQHACVMHhtoOuHVLA1dy0ZBN+oW5N3xbfwPeTivuV16fkMk+Irguv46ReJuOFP7nI1mKLasREfokqtxk+lGCpQ/c06962lDbRrSzXQ5SnJjV+liXxXeYeEozVyME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TutCuivZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TutCuivZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BBB3C4CEF7;
	Wed,  4 Feb 2026 15:20:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218452;
	bh=CSjP2bHz/0XoiRvgTPJszvH9OcgxkkBM2DiT5R3YomY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TutCuivZwgriGz1eJklR60QNefiMdsdstSr1UzxdIa96+aY578gmiYYR4yxAQBumc
	 9JAcQCHRVQ6rX/5++HE+5KuO/n51Et1y0xkoWLFEZPWzJVxD3yL4FAFbCymqrhhW0j
	 hP5qub9VRNfL/MhCllM8lX8Z7JC90VNv+I9xPEKo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <geliang@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 33/72] selftests: mptcp: check no dup close events after error
Date: Wed,  4 Feb 2026 15:40:36 +0100
Message-ID: <20260204143846.826519069@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143845.603454952@linuxfoundation.org>
References: <20260204143845.603454952@linuxfoundation.org>
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

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/mptcp_join.sh |   51 ++++++++++++++++++++++++
 1 file changed, 51 insertions(+)

--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -3569,11 +3569,32 @@ chk_evt_nr()
 	count=$(grep -cw "type:${evt}" "${evts}")
 	if [ "${count}" != "${exp}" ]; then
 		fail_test "got ${count} events, expected ${exp}"
+		cat "${evts}"
 	else
 		print_ok
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
@@ -3730,6 +3751,36 @@ userspace_tests()
 		kill_events_pids
 		mptcp_lib_kill_group_wait $tests_pid
 	fi
+
+	# userspace pm no duplicated spurious close events after an error
+	if reset_with_events "userspace pm no dup close events after error" &&
+	   continue_if mptcp_lib_has_file '/proc/sys/net/mptcp/pm_type'; then
+		set_userspace_pm $ns2
+		pm_nl_set_limits $ns1 0 2
+		{ timeout_test=120 test_linkfail=128 speed=slow \
+			run_tests $ns1 $ns2 10.0.1.1 & } 2>/dev/null
+		local tests_pid=$!
+		wait_event ns2 MPTCP_LIB_EVENT_ESTABLISHED 1
+		userspace_pm_add_sf $ns2 10.0.3.2 20
+		chk_mptcp_info subflows 1 subflows 1
+		chk_subflows_total 2 2
+
+		# force quick loss
+		ip netns exec $ns2 sysctl -q net.ipv4.tcp_syn_retries=1
+		if ip netns exec "${ns1}" ${iptables} -A INPUT -s "10.0.1.2" \
+		      -p tcp --tcp-option 30 -j REJECT --reject-with tcp-reset &&
+		   ip netns exec "${ns2}" ${iptables} -A INPUT -d "10.0.1.2" \
+		      -p tcp --tcp-option 30 -j REJECT --reject-with tcp-reset; then
+			wait_event ns2 MPTCP_LIB_EVENT_SUB_CLOSED 1
+			wait_event ns1 MPTCP_LIB_EVENT_SUB_CLOSED 1
+			chk_subflows_total 1 1
+			userspace_pm_add_sf $ns2 10.0.1.2 0
+			wait_event ns2 MPTCP_LIB_EVENT_SUB_CLOSED 2
+			chk_evt_nr ns2 MPTCP_LIB_EVENT_SUB_CLOSED 2
+		fi
+		kill_events_pids
+		mptcp_lib_kill_group_wait $tests_pid
+	fi
 }
 
 endpoint_tests()


