Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FF9A4431
	for <patches@lists.linux.dev>; Wed, 15 Mar 2023 12:33:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB852C433D2;
	Wed, 15 Mar 2023 12:33:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678883630;
	bh=5fpAfLrEEXHcZU7KMHkBgmY48ywrvOIvcSiPj1Ma9JU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O8yJF3wHt8UCQ9GqkJpjcTC2Y4+Gj2U4RUZNl/9tw0aOU2WU+JnNp+3e0S5VeBHkx
	 aj2CJz8EzCWFkpyGcLpU2IIv1o/XYkEZx9v1zF0nsaEQt/dL9MJwJm6sup+f1olOrl
	 frHTHqJQMql35GxK+b/zFQN3LZe8FoZ9Lp6sjWgE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hangbin Liu <liuhangbin@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 071/143] selftests: nft_nat: ensuring the listening side is up before starting the client
Date: Wed, 15 Mar 2023 13:12:37 +0100
Message-Id: <20230315115742.708819112@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115740.429574234@linuxfoundation.org>
References: <20230315115740.429574234@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit 2067e7a00aa604b94de31d64f29b8893b1696f26 ]

The test_local_dnat_portonly() function initiates the client-side as
soon as it sets the listening side to the background. This could lead to
a race condition where the server may not be ready to listen. To ensure
that the server-side is up and running before initiating the
client-side, a delay is introduced to the test_local_dnat_portonly()
function.

Before the fix:
  # ./nft_nat.sh
  PASS: netns routing/connectivity: ns0-rthlYrBU can reach ns1-rthlYrBU and ns2-rthlYrBU
  PASS: ping to ns1-rthlYrBU was ip NATted to ns2-rthlYrBU
  PASS: ping to ns1-rthlYrBU OK after ip nat output chain flush
  PASS: ipv6 ping to ns1-rthlYrBU was ip6 NATted to ns2-rthlYrBU
  2023/02/27 04:11:03 socat[6055] E connect(5, AF=2 10.0.1.99:2000, 16): Connection refused
  ERROR: inet port rewrite

After the fix:
  # ./nft_nat.sh
  PASS: netns routing/connectivity: ns0-9sPJV6JJ can reach ns1-9sPJV6JJ and ns2-9sPJV6JJ
  PASS: ping to ns1-9sPJV6JJ was ip NATted to ns2-9sPJV6JJ
  PASS: ping to ns1-9sPJV6JJ OK after ip nat output chain flush
  PASS: ipv6 ping to ns1-9sPJV6JJ was ip6 NATted to ns2-9sPJV6JJ
  PASS: inet port rewrite without l3 address

Fixes: 282e5f8fe907 ("netfilter: nat: really support inet nat without l3 address")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/netfilter/nft_nat.sh | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/netfilter/nft_nat.sh b/tools/testing/selftests/netfilter/nft_nat.sh
index 924ecb3f1f737..dd40d9f6f2599 100755
--- a/tools/testing/selftests/netfilter/nft_nat.sh
+++ b/tools/testing/selftests/netfilter/nft_nat.sh
@@ -404,6 +404,8 @@ EOF
 	echo SERVER-$family | ip netns exec "$ns1" timeout 5 socat -u STDIN TCP-LISTEN:2000 &
 	sc_s=$!
 
+	sleep 1
+
 	result=$(ip netns exec "$ns0" timeout 1 socat TCP:$daddr:2000 STDOUT)
 
 	if [ "$result" = "SERVER-inet" ];then
-- 
2.39.2



