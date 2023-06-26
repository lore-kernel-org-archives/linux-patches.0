Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42D56134C7
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 18:16:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F446C433C0;
	Mon, 26 Jun 2023 18:16:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687803389;
	bh=KdRgDaCP8dO9DRAjMUTs2E7kfdDI4XEhM7POANJl7xQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XN2k+kGlAG3dct49TrGvw8fuQRtzu+Jvaof+F1W0pxlTdr1rE913nkS1hvQZg49aQ
	 9xXQMq0IzQ0z6LOelY74zi41WOV26/n5x4sZl1Tw3D037uDjqLBMbnuGMVu/Lbk62v
	 apvZx53KPRz9LucFEopRBxwoqNrn0libE16lyKOI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthieu Baerts <matthieu.baerts@tessares.net>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.3 045/199] selftests: mptcp: join: skip userspace PM tests if not supported
Date: Mon, 26 Jun 2023 20:09:11 +0200
Message-ID: <20230626180807.558685638@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230626180805.643662628@linuxfoundation.org>
References: <20230626180805.643662628@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Matthieu Baerts <matthieu.baerts@tessares.net>

commit f2b492b04a167261e1c38eb76f78fb4294473a49 upstream.

Selftests are supposed to run on any kernels, including the old ones not
supporting all MPTCP features.

One of them is the support of the userspace PM introduced by commit
4638de5aefe5 ("mptcp: handle local addrs announced by userspace PMs")
and the following ones.

It is possible to look for the MPTCP pm_type's sysctl knob to know in
advance if the userspace PM is available.

Link: https://github.com/multipath-tcp/mptcp_net-next/issues/368
Fixes: 5ac1d2d63451 ("selftests: mptcp: Add tests for userspace PM type")
Cc: stable@vger.kernel.org
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/mptcp_join.sh |   26 +++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -84,7 +84,7 @@ init_partial()
 		ip netns add $netns || exit $ksft_skip
 		ip -net $netns link set lo up
 		ip netns exec $netns sysctl -q net.mptcp.enabled=1
-		ip netns exec $netns sysctl -q net.mptcp.pm_type=0
+		ip netns exec $netns sysctl -q net.mptcp.pm_type=0 2>/dev/null || true
 		ip netns exec $netns sysctl -q net.ipv4.conf.all.rp_filter=0
 		ip netns exec $netns sysctl -q net.ipv4.conf.default.rp_filter=0
 		if [ $checksum -eq 1 ]; then
@@ -3151,7 +3151,8 @@ fail_tests()
 userspace_tests()
 {
 	# userspace pm type prevents add_addr
-	if reset "userspace pm type prevents add_addr"; then
+	if reset "userspace pm type prevents add_addr" &&
+	   continue_if mptcp_lib_has_file '/proc/sys/net/mptcp/pm_type'; then
 		set_userspace_pm $ns1
 		pm_nl_set_limits $ns1 0 2
 		pm_nl_set_limits $ns2 0 2
@@ -3162,7 +3163,8 @@ userspace_tests()
 	fi
 
 	# userspace pm type does not echo add_addr without daemon
-	if reset "userspace pm no echo w/o daemon"; then
+	if reset "userspace pm no echo w/o daemon" &&
+	   continue_if mptcp_lib_has_file '/proc/sys/net/mptcp/pm_type'; then
 		set_userspace_pm $ns2
 		pm_nl_set_limits $ns1 0 2
 		pm_nl_set_limits $ns2 0 2
@@ -3173,7 +3175,8 @@ userspace_tests()
 	fi
 
 	# userspace pm type rejects join
-	if reset "userspace pm type rejects join"; then
+	if reset "userspace pm type rejects join" &&
+	   continue_if mptcp_lib_has_file '/proc/sys/net/mptcp/pm_type'; then
 		set_userspace_pm $ns1
 		pm_nl_set_limits $ns1 1 1
 		pm_nl_set_limits $ns2 1 1
@@ -3183,7 +3186,8 @@ userspace_tests()
 	fi
 
 	# userspace pm type does not send join
-	if reset "userspace pm type does not send join"; then
+	if reset "userspace pm type does not send join" &&
+	   continue_if mptcp_lib_has_file '/proc/sys/net/mptcp/pm_type'; then
 		set_userspace_pm $ns2
 		pm_nl_set_limits $ns1 1 1
 		pm_nl_set_limits $ns2 1 1
@@ -3193,7 +3197,8 @@ userspace_tests()
 	fi
 
 	# userspace pm type prevents mp_prio
-	if reset "userspace pm type prevents mp_prio"; then
+	if reset "userspace pm type prevents mp_prio" &&
+	   continue_if mptcp_lib_has_file '/proc/sys/net/mptcp/pm_type'; then
 		set_userspace_pm $ns1
 		pm_nl_set_limits $ns1 1 1
 		pm_nl_set_limits $ns2 1 1
@@ -3204,7 +3209,8 @@ userspace_tests()
 	fi
 
 	# userspace pm type prevents rm_addr
-	if reset "userspace pm type prevents rm_addr"; then
+	if reset "userspace pm type prevents rm_addr" &&
+	   continue_if mptcp_lib_has_file '/proc/sys/net/mptcp/pm_type'; then
 		set_userspace_pm $ns1
 		set_userspace_pm $ns2
 		pm_nl_set_limits $ns1 0 1
@@ -3216,7 +3222,8 @@ userspace_tests()
 	fi
 
 	# userspace pm add & remove address
-	if reset_with_events "userspace pm add & remove address"; then
+	if reset_with_events "userspace pm add & remove address" &&
+	   continue_if mptcp_lib_has_file '/proc/sys/net/mptcp/pm_type'; then
 		set_userspace_pm $ns1
 		pm_nl_set_limits $ns2 1 1
 		run_tests $ns1 $ns2 10.0.1.1 0 userspace_1 0 slow
@@ -3227,7 +3234,8 @@ userspace_tests()
 	fi
 
 	# userspace pm create destroy subflow
-	if reset_with_events "userspace pm create destroy subflow"; then
+	if reset_with_events "userspace pm create destroy subflow" &&
+	   continue_if mptcp_lib_has_file '/proc/sys/net/mptcp/pm_type'; then
 		set_userspace_pm $ns2
 		pm_nl_set_limits $ns1 0 1
 		run_tests $ns1 $ns2 10.0.1.1 0 0 userspace_1 slow


