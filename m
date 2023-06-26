Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E571913AC4
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 18:28:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BA73C433C8;
	Mon, 26 Jun 2023 18:28:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687804121;
	bh=6Q3/vJXFrO8a6al7NTv74oR4fx86ymWg/6YmHt+ZlDA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=unFRmHMQMEDVBgTny+3wR0L8keeT/a5G71/6hwKwcpEtmg9o4QZaMVtLIzUxPI7k5
	 bfd2zeWE+h9ZlrManyzPE0RyFUzJu0Pvsvvx3Uvo21i7WTVcIpWB7OETLnlyvotLVW
	 8yvbnMmyrAkKabzPwJVLTV5Ur7KmV1LrB1uBJb9A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthieu Baerts <matthieu.baerts@tessares.net>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 020/170] selftests: mptcp: pm nl: skip fullmesh flag checks if not supported
Date: Mon, 26 Jun 2023 20:09:49 +0200
Message-ID: <20230626180801.462890851@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230626180800.476539630@linuxfoundation.org>
References: <20230626180800.476539630@linuxfoundation.org>
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

commit f3761b50b8e4cb4807b5d41e02144c8c8a0f2512 upstream.

Selftests are supposed to run on any kernels, including the old ones not
supporting all MPTCP features.

One of them is the fullmesh flag that can be given to the MPTCP
in-kernel path-manager and introduced in commit 2843ff6f36db ("mptcp:
remote addresses fullmesh").

If the flag is not visible in the dump after having set it, we don't
check the content. Note that if we expect to have this feature and
SELFTESTS_MPTCP_LIB_EXPECT_ALL_FEATURES env var is set to 1, we always
check the content to avoid regressions.

Link: https://github.com/multipath-tcp/mptcp_net-next/issues/368
Fixes: 6da1dfdd037e ("selftests: mptcp: add set_flags tests in pm_netlink.sh")
Cc: stable@vger.kernel.org
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/pm_netlink.sh | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/pm_netlink.sh b/tools/testing/selftests/net/mptcp/pm_netlink.sh
index 664cafc60705..d02e0d63a8f9 100755
--- a/tools/testing/selftests/net/mptcp/pm_netlink.sh
+++ b/tools/testing/selftests/net/mptcp/pm_netlink.sh
@@ -178,14 +178,19 @@ subflow,backup 10.0.1.1" "set flags (backup)"
 ip netns exec $ns1 ./pm_nl_ctl set 10.0.1.1 flags nobackup
 check "ip netns exec $ns1 ./pm_nl_ctl dump" "id 1 flags \
 subflow 10.0.1.1" "          (nobackup)"
+
+# fullmesh support has been added later
 ip netns exec $ns1 ./pm_nl_ctl set id 1 flags fullmesh
-check "ip netns exec $ns1 ./pm_nl_ctl dump" "id 1 flags \
+if ip netns exec $ns1 ./pm_nl_ctl dump | grep -q "fullmesh" ||
+   mptcp_lib_expect_all_features; then
+	check "ip netns exec $ns1 ./pm_nl_ctl dump" "id 1 flags \
 subflow,fullmesh 10.0.1.1" "          (fullmesh)"
-ip netns exec $ns1 ./pm_nl_ctl set id 1 flags nofullmesh
-check "ip netns exec $ns1 ./pm_nl_ctl dump" "id 1 flags \
+	ip netns exec $ns1 ./pm_nl_ctl set id 1 flags nofullmesh
+	check "ip netns exec $ns1 ./pm_nl_ctl dump" "id 1 flags \
 subflow 10.0.1.1" "          (nofullmesh)"
-ip netns exec $ns1 ./pm_nl_ctl set id 1 flags backup,fullmesh
-check "ip netns exec $ns1 ./pm_nl_ctl dump" "id 1 flags \
+	ip netns exec $ns1 ./pm_nl_ctl set id 1 flags backup,fullmesh
+	check "ip netns exec $ns1 ./pm_nl_ctl dump" "id 1 flags \
 subflow,backup,fullmesh 10.0.1.1" "          (backup,fullmesh)"
+fi
 
 exit $ret
-- 
2.41.0



