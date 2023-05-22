Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF000171A1
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:19:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B29AC433EF;
	Mon, 22 May 2023 19:19:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684783148;
	bh=68S8ja6ldITSYmNObUIzuVfF28vRzW2+BWztvWx/q9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yv7BgoYqJhqJekbrY31U1aZpWgFYDxqU2SzxlR4xcAZ4yWnkN3v6W12H0OS/jHb5l
	 r2WU3rjcxaQOxw5Q9LWlgrc7nDvKK0z/0nqNcbLcM+aVcjOYXBY4J0n3MAR4jCAL78
	 YXqSEYS7WcBQY3p09Va7RSiEtDHC/w1VoJTZsSOc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrea Mayer <andrea.mayer@uniroma2.it>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 117/203] selftests: seg6: disable DAD on IPv6 router cfg for srv6_end_dt4_l3vpn_test
Date: Mon, 22 May 2023 20:09:01 +0100
Message-Id: <20230522190358.217203862@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190354.935300867@linuxfoundation.org>
References: <20230522190354.935300867@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Andrea Mayer <andrea.mayer@uniroma2.it>

[ Upstream commit 21a933c79a33add3612808f3be4ad65dd4dc026b ]

The srv6_end_dt4_l3vpn_test instantiates a virtual network consisting of
several routers (rt-1, rt-2) and hosts.
When the IPv6 addresses of rt-{1,2} routers are configured, the Deduplicate
Address Detection (DAD) kicks in when enabled in the Linux distros running
the selftests. DAD is used to check whether an IPv6 address is already
assigned in a network. Such a mechanism consists of sending an ICMPv6 Echo
Request and waiting for a reply.
As the DAD process could take too long to complete, it may cause the
failing of some tests carried out by the srv6_end_dt4_l3vpn_test script.

To make the srv6_end_dt4_l3vpn_test more robust, we disable DAD on routers
since we configure the virtual network manually and do not need any address
deduplication mechanism at all.

Fixes: 2195444e09b4 ("selftests: add selftest for the SRv6 End.DT4 behavior")
Signed-off-by: Andrea Mayer <andrea.mayer@uniroma2.it>
Reviewed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/srv6_end_dt4_l3vpn_test.sh | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/srv6_end_dt4_l3vpn_test.sh b/tools/testing/selftests/net/srv6_end_dt4_l3vpn_test.sh
index 1003119773e5d..37f08d582d2fe 100755
--- a/tools/testing/selftests/net/srv6_end_dt4_l3vpn_test.sh
+++ b/tools/testing/selftests/net/srv6_end_dt4_l3vpn_test.sh
@@ -232,10 +232,14 @@ setup_rt_networking()
 	local nsname=rt-${rt}
 
 	ip netns add ${nsname}
+
+	ip netns exec ${nsname} sysctl -wq net.ipv6.conf.all.accept_dad=0
+	ip netns exec ${nsname} sysctl -wq net.ipv6.conf.default.accept_dad=0
+
 	ip link set veth-rt-${rt} netns ${nsname}
 	ip -netns ${nsname} link set veth-rt-${rt} name veth0
 
-	ip -netns ${nsname} addr add ${IPv6_RT_NETWORK}::${rt}/64 dev veth0
+	ip -netns ${nsname} addr add ${IPv6_RT_NETWORK}::${rt}/64 dev veth0 nodad
 	ip -netns ${nsname} link set veth0 up
 	ip -netns ${nsname} link set lo up
 
-- 
2.39.2



