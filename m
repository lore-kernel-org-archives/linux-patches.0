Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B418712BF1B;
	Tue, 23 Jan 2024 00:56:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971413; cv=none; b=BpgFehI9j1typ+D8kN41py9Y1iueF7OnWb0GyyLMtJLqHN9cN0Lc08ZLINCt04Ns7YdLL529UGMtyuvHKS88nHhHbmemtqiWV6UKCWi4121hJHyLNXW4e4yu3mMTkAHM+yf8XfbkZcMDPGjnDMDgPwpa+YgUdg3Y2gvDSg2/zW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971413; c=relaxed/simple;
	bh=eVNNH/hH9U3EON6UsfWphF/wyfrpHLI9QhvDpCWsPqA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kgwLy6LitXaiCRoIkh45/0Mw/NHaavx+gJQZFyy6w33IYL81Zn7RrTr3sjuwktKD0fk2V5FR9mOJmfIO8ucBtcD0qGDrxHaZe7Ya3OiIcxL2IcAiKXOt8qbt6JuFG88Iceg9sPyLWGksm9lmaWAtBDtIzhQE22YQn0fyvmVST9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UruIt8um; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UruIt8um"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADE55C433C7;
	Tue, 23 Jan 2024 00:56:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971413;
	bh=eVNNH/hH9U3EON6UsfWphF/wyfrpHLI9QhvDpCWsPqA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UruIt8umRzLydtw+T9yKeFgM9j/VpVYoe3g9YfajuwP4nOl9f0t8oeVM7fzAbxlWt
	 6j+IJg+njaT36LKIOxbQlch5qT/BOBK4Be/3AW2ECFRcJZiA3DUH+uFfjaJ8QHEvkW
	 UmHewpnKM4xkFMC9CcMJ00U3N0cWGwK6f5Xbbc9w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hangbin Liu <liuhangbin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 126/286] selftests/net: fix grep checking for fib_nexthop_multiprefix
Date: Mon, 22 Jan 2024 15:57:12 -0800
Message-ID: <20240122235736.986287528@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit a33e9da3470499e9ff476138f271fb52d6bfe767 ]

When running fib_nexthop_multiprefix test I saw all IPv6 test failed.
e.g.

 ]# ./fib_nexthop_multiprefix.sh
 TEST: IPv4: host 0 to host 1, mtu 1300                              [ OK ]
 TEST: IPv6: host 0 to host 1, mtu 1300                              [FAIL]

 With -v it shows

 COMMAND: ip netns exec h0 /usr/sbin/ping6 -s 1350 -c5 -w5 2001:db8:101::1
 PING 2001:db8:101::1(2001:db8:101::1) 1350 data bytes
 From 2001:db8:100::64 icmp_seq=1 Packet too big: mtu=1300

 --- 2001:db8:101::1 ping statistics ---
 1 packets transmitted, 0 received, +1 errors, 100% packet loss, time 0ms

 Route get
 2001:db8:101::1 via 2001:db8:100::64 dev eth0 src 2001:db8:100::1 metric 1024 expires 599sec mtu 1300 pref medium
 Searching for:
     2001:db8:101::1 from :: via 2001:db8:100::64 dev eth0 src 2001:db8:100::1 .* mtu 1300

The reason is when CONFIG_IPV6_SUBTREES is not enabled, rt6_fill_node() will
not put RTA_SRC info. After fix:

]# ./fib_nexthop_multiprefix.sh
TEST: IPv4: host 0 to host 1, mtu 1300                              [ OK ]
TEST: IPv6: host 0 to host 1, mtu 1300                              [ OK ]

Fixes: 735ab2f65dce ("selftests: Add test with multiple prefixes using single nexthop")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Link: https://lore.kernel.org/r/20231213060856.4030084-7-liuhangbin@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/fib_nexthop_multiprefix.sh | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/fib_nexthop_multiprefix.sh b/tools/testing/selftests/net/fib_nexthop_multiprefix.sh
index 51df5e305855..b52d59547fc5 100755
--- a/tools/testing/selftests/net/fib_nexthop_multiprefix.sh
+++ b/tools/testing/selftests/net/fib_nexthop_multiprefix.sh
@@ -209,12 +209,12 @@ validate_v6_exception()
 		echo "Route get"
 		ip -netns h0 -6 ro get ${dst}
 		echo "Searching for:"
-		echo "    ${dst} from :: via ${r1} dev eth0 src ${h0} .* mtu ${mtu}"
+		echo "    ${dst}.* via ${r1} dev eth0 src ${h0} .* mtu ${mtu}"
 		echo
 	fi
 
 	ip -netns h0 -6 ro get ${dst} | \
-	grep -q "${dst} from :: via ${r1} dev eth0 src ${h0} .* mtu ${mtu}"
+	grep -q "${dst}.* via ${r1} dev eth0 src ${h0} .* mtu ${mtu}"
 	rc=$?
 
 	log_test $rc 0 "IPv6: host 0 to host ${i}, mtu ${mtu}"
-- 
2.43.0



