Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33F6A1F946
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 16:24:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAB44C433C8;
	Fri, 21 Jul 2023 16:24:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689956683;
	bh=x6+T2ujRuviIzY1/lstvCbKBvCcVo6zDWcr1HTkKedI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kaZsMv04ydKwe8I2kGGNpLDcsilyJ/0opIgOKOjB45mYO85m1NHiKHDOQNG2qvwt0
	 9zl2eanejlAq+dxG0oS2FZciUQmnsjJbSyOI2y3QaDTAzOSDz3f/KD3AL27g0mVtez
	 7WTkiZiaMhSqNs+6abR2o6AzCJ5amkXbAT1nBrJ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Matthieu Baerts <matthieu.baerts@tessares.net>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.4 262/292] selftests: mptcp: connect: fail if nft supposed to work
Date: Fri, 21 Jul 2023 18:06:11 +0200
Message-ID: <20230721160540.188783393@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160528.800311148@linuxfoundation.org>
References: <20230721160528.800311148@linuxfoundation.org>
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

commit 221e4550454a822f9a11834e30694c7d1d65747c upstream.

In case of "external" errors when preparing the environment for the
TProxy tests, the subtests were marked as skipped.

This is fine but it means these errors are ignored. On MPTCP Public CI,
we do want to catch such issues and mark the selftest as failed if there
are such issues. We can then use mptcp_lib_fail_if_expected_feature()
helper that has been recently added to fail if needed.

Link: https://github.com/multipath-tcp/mptcp_net-next/issues/368
Fixes: 5fb62e9cd3ad ("selftests: mptcp: add tproxy test case")
Cc: stable@vger.kernel.org
Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/mptcp_connect.sh |    3 +++
 1 file changed, 3 insertions(+)

--- a/tools/testing/selftests/net/mptcp/mptcp_connect.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_connect.sh
@@ -718,6 +718,7 @@ table inet mangle {
 EOF
 	if [ $? -ne 0 ]; then
 		echo "SKIP: $msg, could not load nft ruleset"
+		mptcp_lib_fail_if_expected_feature "nft rules"
 		return
 	fi
 
@@ -733,6 +734,7 @@ EOF
 	if [ $? -ne 0 ]; then
 		ip netns exec "$listener_ns" nft flush ruleset
 		echo "SKIP: $msg, ip $r6flag rule failed"
+		mptcp_lib_fail_if_expected_feature "ip rule"
 		return
 	fi
 
@@ -741,6 +743,7 @@ EOF
 		ip netns exec "$listener_ns" nft flush ruleset
 		ip -net "$listener_ns" $r6flag rule del fwmark 1 lookup 100
 		echo "SKIP: $msg, ip route add local $local_addr failed"
+		mptcp_lib_fail_if_expected_feature "ip route"
 		return
 	fi
 


