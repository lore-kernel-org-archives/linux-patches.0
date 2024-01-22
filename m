Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86C9312BF15;
	Tue, 23 Jan 2024 00:15:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968906; cv=none; b=O7dOcLfoKAchrMP/CuNStMpLzXKCa4aBsav+pU1qdzm26u54CAUKY/O9XyMSizM7vFvUsnY6nTmWfOi6xFloWpmcmq6mlMf5NnrUyUkrPGn6QgsS0NvzIX4YVUojyyfRJeWnGWwzRZLlYJgoriZENd7RGtNvNoAVvcMa2c1yf6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968906; c=relaxed/simple;
	bh=VwnhC8k8NQbdFdMTawoiQDa1l4YvEzm97IiyEs7Gwkg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VMcsz0xVrtgWCkj+ouVkQjvMlepOhONFtSmKbx6+MtAIpN3gs4DwUU98WViqzvdsVoOUX1jN7GOx671kKHI9uKMVCwode0rPVXfHp/nxsYDygNbtVEQer7IFSJjvHyQDTtsngahbi6e7ZDSuhkCzaj4nZFBLh4VdavjdvFhHxAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Li3qukx+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Li3qukx+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F39C5C43390;
	Tue, 23 Jan 2024 00:15:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968906;
	bh=VwnhC8k8NQbdFdMTawoiQDa1l4YvEzm97IiyEs7Gwkg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Li3qukx+iGsI/xGaTChDmlo/bwKk+db2VdDyLnEM4FNg2h5iMYEHBeyG9PEhM0UHS
	 93wfxpzrseTSRwO1gS9W+z8euf26yFJVDrPlEwrzsASpF+8b65/5Y75mXBmiXRltoJ
	 OdFngMr8QVM0SR7gj6Ygeqb097ny46CHRW9VdGT4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hangbin Liu <liuhangbin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 092/194] selftests/net: fix grep checking for fib_nexthop_multiprefix
Date: Mon, 22 Jan 2024 15:57:02 -0800
Message-ID: <20240122235723.191454698@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235719.206965081@linuxfoundation.org>
References: <20240122235719.206965081@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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



