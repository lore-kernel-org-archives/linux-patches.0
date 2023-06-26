Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11A1E13AC5
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 18:27:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85EFCC433C0;
	Mon, 26 Jun 2023 18:27:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687804053;
	bh=jCdtrtpvdLOaV8b1aA11gRXspS3cfdYnQFjjc4IhBZ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Snu15B4py6kYjSTMW7n9/GguioT3yRCPYuXm+cFkjgFZHa5qjASRU0pG6QwgyLrO/
	 bjHaLDi18ZUYPl2OHjmfjfhFBmX5QTGi3xoCUdBiJmnuS7f73sENzdR2TGktjZN1Ue
	 L4qbYDLWCFh67zeb/bDfW71gxcZXO/+gezKL0gS4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthieu Baerts <matthieu.baerts@tessares.net>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 026/170] selftests: mptcp: join: use iptables-legacy if available
Date: Mon, 26 Jun 2023 20:09:55 +0200
Message-ID: <20230626180801.722630540@linuxfoundation.org>
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

commit 0c4cd3f86a40028845ad6f8af5b37165666404cd upstream.

IPTables commands using 'iptables-nft' fail on old kernels, at least
5.15 because it doesn't see the default IPTables chains:

  $ iptables -L
  iptables/1.8.2 Failed to initialize nft: Protocol not supported

As a first step before switching to NFTables, we can use iptables-legacy
if available.

Link: https://github.com/multipath-tcp/mptcp_net-next/issues/368
Fixes: 8d014eaa9254 ("selftests: mptcp: add ADD_ADDR timeout test case")
Cc: stable@vger.kernel.org
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/mptcp_join.sh |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -25,6 +25,8 @@ capout=""
 ns1=""
 ns2=""
 ksft_skip=4
+iptables="iptables"
+ip6tables="ip6tables"
 timeout_poll=30
 timeout_test=$((timeout_poll * 2 + 1))
 capture=0
@@ -141,7 +143,11 @@ check_tools()
 		exit $ksft_skip
 	fi
 
-	if ! iptables -V &> /dev/null; then
+	# Use the legacy version if available to support old kernel versions
+	if iptables-legacy -V &> /dev/null; then
+		iptables="iptables-legacy"
+		ip6tables="ip6tables-legacy"
+	elif ! iptables -V &> /dev/null; then
 		echo "SKIP: Could not run all tests without iptables tool"
 		exit $ksft_skip
 	fi
@@ -239,9 +245,9 @@ reset_with_add_addr_timeout()
 
 	reset "${1}" || return 1
 
-	tables="iptables"
+	tables="${iptables}"
 	if [ $ip -eq 6 ]; then
-		tables="ip6tables"
+		tables="${ip6tables}"
 	fi
 
 	ip netns exec $ns1 sysctl -q net.mptcp.add_addr_timeout=1
@@ -306,9 +312,9 @@ reset_with_fail()
 	local ip="${3:-4}"
 	local tables
 
-	tables="iptables"
+	tables="${iptables}"
 	if [ $ip -eq 6 ]; then
-		tables="ip6tables"
+		tables="${ip6tables}"
 	fi
 
 	ip netns exec $ns2 $tables \
@@ -678,7 +684,7 @@ filter_tcp_from()
 	local src="${2}"
 	local target="${3}"
 
-	ip netns exec "${ns}" iptables -A INPUT -s "${src}" -p tcp -j "${target}"
+	ip netns exec "${ns}" ${iptables} -A INPUT -s "${src}" -p tcp -j "${target}"
 }
 
 do_transfer()


