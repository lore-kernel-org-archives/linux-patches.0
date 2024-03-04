Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE6711C680;
	Mon,  4 Mar 2024 21:32:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709587966; cv=none; b=pEGzStJN1kitqJFsjdGFjJON2V1v+RZtc2LOzCq9M9GjLVa+gBgptVk30I9pdgZ1BDgXJ1pI8JD19V/ZRcIDzWtvV12IE2fihIG5lelxExoMPXxa9QH7AEb+ube6/Pr1vYk6C4CoocRdfOqnsHLO8z4ei9FIEu++KFWauTnEfqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709587966; c=relaxed/simple;
	bh=Y4iG322U0bXik00y9Zf4Z4HsaJhqNpRCcAsbvs2GZSc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q62pFkpYeCvrqMCvj4wNlE71RtAH/zv4b64uZnGXc7+0v7qrLaogpN8hZCtACJISd/szJA0DglJm+BgNigeqCSA4sgKRwGJcWGg/SvwovGrka2vDJUMjgm3InQF4Drwrqc+/NyBmv81/URB1aBxWtYC176HRPCU7QhabpvK0mtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A6NNEpqd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A6NNEpqd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EDF0C433C7;
	Mon,  4 Mar 2024 21:32:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709587966;
	bh=Y4iG322U0bXik00y9Zf4Z4HsaJhqNpRCcAsbvs2GZSc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A6NNEpqdzV7A+ufJ1pUZd9VvSxwoCXSRAPku2WD6pnATnpYz0PnzLUDLgjUN/6FiY
	 ayNe93WObnhqAsNlqvcJp5kmgTEIPaM+N/BNgz7tAVmaqxyPBfd4I8gmhQbBrnb2DL
	 mWiw5SCZEXCVlZOlasrK7VCAHaegHhqQBYW8iP34=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthieu Baerts <matttbe@kernel.org>,
	Geliang Tang <geliang.tang@suse.com>,
	Mat Martineau <martineau@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.7 159/162] selftests: mptcp: update userspace pm test helpers
Date: Mon,  4 Mar 2024 21:23:44 +0000
Message-ID: <20240304211556.746485379@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211551.833500257@linuxfoundation.org>
References: <20240304211551.833500257@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geliang Tang <geliang.tang@suse.com>

commit 757c828ce94905a2975873d5e90a376c701b2b90 upstream.

This patch adds a new argument namespace to userspace_pm_add_addr() and
userspace_pm_add_sf() to make these two helper more versatile.

Add two more versatile helpers for userspace pm remove subflow or address:
userspace_pm_rm_addr() and userspace_pm_rm_sf(). The original test helpers
userspace_pm_rm_sf_addr_ns1() and userspace_pm_rm_sf_addr_ns2() can be
replaced by these new helpers.

Reviewed-by: Matthieu Baerts <matttbe@kernel.org>
Signed-off-by: Geliang Tang <geliang.tang@suse.com>
Signed-off-by: Mat Martineau <martineau@kernel.org>
Link: https://lore.kernel.org/r/20231128-send-net-next-2023107-v4-4-8d6b94150f6b@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/mptcp_join.sh |  100 +++++++++++-------------
 1 file changed, 49 insertions(+), 51 deletions(-)

--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -2824,6 +2824,7 @@ backup_tests()
 	fi
 }
 
+SUB_ESTABLISHED=10 # MPTCP_EVENT_SUB_ESTABLISHED
 LISTENER_CREATED=15 #MPTCP_EVENT_LISTENER_CREATED
 LISTENER_CLOSED=16  #MPTCP_EVENT_LISTENER_CLOSED
 
@@ -3284,75 +3285,70 @@ fail_tests()
 	fi
 }
 
+# $1: ns ; $2: addr ; $3: id
 userspace_pm_add_addr()
 {
-	local addr=$1
-	local id=$2
+	local evts=$evts_ns1
 	local tk
 
-	tk=$(grep "type:1," "$evts_ns1" |
-	     sed -n 's/.*\(token:\)\([[:digit:]]*\).*$/\2/p;q')
-	ip netns exec $ns1 ./pm_nl_ctl ann $addr token $tk id $id
+	[ "$1" == "$ns2" ] && evts=$evts_ns2
+	tk=$(mptcp_lib_evts_get_info token "$evts")
+
+	ip netns exec $1 ./pm_nl_ctl ann $2 token $tk id $3
 	sleep 1
 }
 
-userspace_pm_rm_sf_addr_ns1()
+# $1: ns ; $2: id
+userspace_pm_rm_addr()
 {
-	local addr=$1
-	local id=$2
-	local tk sp da dp
-	local cnt_addr cnt_sf
-
-	tk=$(grep "type:1," "$evts_ns1" |
-	     sed -n 's/.*\(token:\)\([[:digit:]]*\).*$/\2/p;q')
-	sp=$(grep "type:10" "$evts_ns1" |
-	     sed -n 's/.*\(sport:\)\([[:digit:]]*\).*$/\2/p;q')
-	da=$(grep "type:10" "$evts_ns1" |
-	     sed -n 's/.*\(daddr6:\)\([0-9a-f:.]*\).*$/\2/p;q')
-	dp=$(grep "type:10" "$evts_ns1" |
-	     sed -n 's/.*\(dport:\)\([[:digit:]]*\).*$/\2/p;q')
-	cnt_addr=$(rm_addr_count ${ns1})
-	cnt_sf=$(rm_sf_count ${ns1})
-	ip netns exec $ns1 ./pm_nl_ctl rem token $tk id $id
-	ip netns exec $ns1 ./pm_nl_ctl dsf lip "::ffff:$addr" \
-				lport $sp rip $da rport $dp token $tk
-	wait_rm_addr $ns1 "${cnt_addr}"
-	wait_rm_sf $ns1 "${cnt_sf}"
+	local evts=$evts_ns1
+	local tk
+	local cnt
+
+	[ "$1" == "$ns2" ] && evts=$evts_ns2
+	tk=$(mptcp_lib_evts_get_info token "$evts")
+
+	cnt=$(rm_addr_count ${1})
+	ip netns exec $1 ./pm_nl_ctl rem token $tk id $2
+	wait_rm_addr $1 "${cnt}"
 }
 
+# $1: ns ; $2: addr ; $3: id
 userspace_pm_add_sf()
 {
-	local addr=$1
-	local id=$2
+	local evts=$evts_ns1
 	local tk da dp
 
-	tk=$(sed -n 's/.*\(token:\)\([[:digit:]]*\).*$/\2/p;q' "$evts_ns2")
-	da=$(sed -n 's/.*\(daddr4:\)\([0-9.]*\).*$/\2/p;q' "$evts_ns2")
-	dp=$(sed -n 's/.*\(dport:\)\([[:digit:]]*\).*$/\2/p;q' "$evts_ns2")
-	ip netns exec $ns2 ./pm_nl_ctl csf lip $addr lid $id \
+	[ "$1" == "$ns2" ] && evts=$evts_ns2
+	tk=$(mptcp_lib_evts_get_info token "$evts")
+	da=$(mptcp_lib_evts_get_info daddr4 "$evts")
+	dp=$(mptcp_lib_evts_get_info dport "$evts")
+
+	ip netns exec $1 ./pm_nl_ctl csf lip $2 lid $3 \
 				rip $da rport $dp token $tk
 	sleep 1
 }
 
-userspace_pm_rm_sf_addr_ns2()
+# $1: ns ; $2: addr $3: event type
+userspace_pm_rm_sf()
 {
-	local addr=$1
-	local id=$2
+	local evts=$evts_ns1
+	local t=${3:-1}
+	local ip=4
 	local tk da dp sp
-	local cnt_addr cnt_sf
+	local cnt
+
+	[ "$1" == "$ns2" ] && evts=$evts_ns2
+	if is_v6 $2; then ip=6; fi
+	tk=$(mptcp_lib_evts_get_info token "$evts")
+	da=$(mptcp_lib_evts_get_info "daddr$ip" "$evts" $t)
+	dp=$(mptcp_lib_evts_get_info dport "$evts" $t)
+	sp=$(mptcp_lib_evts_get_info sport "$evts" $t)
 
-	tk=$(sed -n 's/.*\(token:\)\([[:digit:]]*\).*$/\2/p;q' "$evts_ns2")
-	da=$(sed -n 's/.*\(daddr4:\)\([0-9.]*\).*$/\2/p;q' "$evts_ns2")
-	dp=$(sed -n 's/.*\(dport:\)\([[:digit:]]*\).*$/\2/p;q' "$evts_ns2")
-	sp=$(grep "type:10" "$evts_ns2" |
-	     sed -n 's/.*\(sport:\)\([[:digit:]]*\).*$/\2/p;q')
-	cnt_addr=$(rm_addr_count ${ns2})
-	cnt_sf=$(rm_sf_count ${ns2})
-	ip netns exec $ns2 ./pm_nl_ctl rem token $tk id $id
-	ip netns exec $ns2 ./pm_nl_ctl dsf lip $addr lport $sp \
+	cnt=$(rm_sf_count ${1})
+	ip netns exec $1 ./pm_nl_ctl dsf lip $2 lport $sp \
 				rip $da rport $dp token $tk
-	wait_rm_addr $ns2 "${cnt_addr}"
-	wait_rm_sf $ns2 "${cnt_sf}"
+	wait_rm_sf $1 "${cnt}"
 }
 
 userspace_tests()
@@ -3439,13 +3435,14 @@ userspace_tests()
 			run_tests $ns1 $ns2 10.0.1.1 &
 		local tests_pid=$!
 		wait_mpj $ns1
-		userspace_pm_add_addr 10.0.2.1 10
+		userspace_pm_add_addr $ns1 10.0.2.1 10
 		chk_join_nr 1 1 1
 		chk_add_nr 1 1
 		chk_mptcp_info subflows 1 subflows 1
 		chk_subflows_total 2 2
 		chk_mptcp_info add_addr_signal 1 add_addr_accepted 1
-		userspace_pm_rm_sf_addr_ns1 10.0.2.1 10
+		userspace_pm_rm_addr $ns1 10
+		userspace_pm_rm_sf $ns1 "::ffff:10.0.2.1" $SUB_ESTABLISHED
 		chk_rm_nr 1 1 invert
 		chk_mptcp_info subflows 0 subflows 0
 		chk_subflows_total 1 1
@@ -3462,11 +3459,12 @@ userspace_tests()
 			run_tests $ns1 $ns2 10.0.1.1 &
 		local tests_pid=$!
 		wait_mpj $ns2
-		userspace_pm_add_sf 10.0.3.2 20
+		userspace_pm_add_sf $ns2 10.0.3.2 20
 		chk_join_nr 1 1 1
 		chk_mptcp_info subflows 1 subflows 1
 		chk_subflows_total 2 2
-		userspace_pm_rm_sf_addr_ns2 10.0.3.2 20
+		userspace_pm_rm_addr $ns2 20
+		userspace_pm_rm_sf $ns2 10.0.3.2 $SUB_ESTABLISHED
 		chk_rm_nr 1 1
 		chk_mptcp_info subflows 0 subflows 0
 		chk_subflows_total 1 1


