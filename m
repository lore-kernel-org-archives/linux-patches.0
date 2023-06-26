Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43AE4134C7
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 18:16:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3045C433C0;
	Mon, 26 Jun 2023 18:16:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687803381;
	bh=7UkpvGdPN1UYklDmDm+COLBBHqsSqXA3nKccCxLUtsA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Al74dEIjp5R3gZp2TRA+yapATkjTsx5H4PY3Q9Ia2ZENcXpCN9FBVtfotjFl3+FDU
	 McqCDwuidM7+GoZ8MpyhUg25wMXxRFE8iS2ZUrp0+/NZi3Ob/EnIYO4YXgNywaBbso
	 BWRlDV90Ip+CvT3cMColBwc9EufYUHWDHCs93evU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthieu Baerts <matthieu.baerts@tessares.net>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.3 042/199] selftests: mptcp: join: skip implicit tests if not supported
Date: Mon, 26 Jun 2023 20:09:08 +0200
Message-ID: <20230626180807.441646929@linuxfoundation.org>
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

commit 36c4127ae8dd0ebac6d56d8a1b272dd483471c40 upstream.

Selftests are supposed to run on any kernels, including the old ones not
supporting all MPTCP features.

One of them is the support of the implicit endpoints introduced by
commit d045b9eb95a9 ("mptcp: introduce implicit endpoints").

It is possible to look for "mptcp_subflow_send_ack" in kallsyms because
it was needed to introduce the mentioned feature. So we can know in
advance if the feature is supported instead of trying and accepting any
results.

Note that here and in the following commits, we re-do the same check for
each sub-test of the same function for a few reasons. The main one is
not to break the ID assign to each test in order to be able to easily
compare results between different kernel versions. Also, we can still
run a specific test even if it is skipped. Another reason is that it
makes it clear during the review that a specific subtest will be skipped
or not under certain conditions. At the end, it looks OK to call the
exact same helper multiple times: it is not a critical path and it is
the same code that is executed, not really more cases to maintain.

Link: https://github.com/multipath-tcp/mptcp_net-next/issues/368
Fixes: 69c6ce7b6eca ("selftests: mptcp: add implicit endpoint test case")
Cc: stable@vger.kernel.org
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/mptcp_join.sh |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -3232,8 +3232,10 @@ userspace_tests()
 
 endpoint_tests()
 {
+	# subflow_rebuild_header is needed to support the implicit flag
 	# userspace pm type prevents add_addr
-	if reset "implicit EP"; then
+	if reset "implicit EP" &&
+	   mptcp_lib_kallsyms_has "subflow_rebuild_header$"; then
 		pm_nl_set_limits $ns1 2 2
 		pm_nl_set_limits $ns2 2 2
 		pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
@@ -3253,7 +3255,8 @@ endpoint_tests()
 		kill_tests_wait
 	fi
 
-	if reset "delete and re-add"; then
+	if reset "delete and re-add" &&
+	   mptcp_lib_kallsyms_has "subflow_rebuild_header$"; then
 		pm_nl_set_limits $ns1 1 1
 		pm_nl_set_limits $ns2 1 1
 		pm_nl_add_endpoint $ns2 10.0.2.2 id 2 dev ns2eth2 flags subflow


