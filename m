Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E65D515C8B
	for <patches@lists.linux.dev>; Mon,  5 Dec 2022 19:44:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62D4BC433C1;
	Mon,  5 Dec 2022 19:44:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670269472;
	bh=DZe4cbtR0ookrs+Ji5JYi1AJmCbg5jrRdGx4NXD3veY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XaZRObH1/Uwde2q5cBXzHnepRM6P3QIrAyd7zc8VQJ8UsC/8SV6Zlx8u6+RxMx+I/
	 yyOCEVmMQ9seX9gfdw5TAb+k2Nnwbp3Ia7E/3UUQ9dq99M1ttxMMJCczwPn909WTeh
	 oKghkeWvyjKxg75LvKGt8Y6CGBOEkf422FHYDj64=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gwangun Jung <exsociety@gmail.com>,
	David Ahern <dsahern@kernel.org>,
	Ido Schimmel <idosch@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 139/153] ipv4: Handle attempt to delete multipath route when fib_info contains an nh reference
Date: Mon,  5 Dec 2022 20:11:03 +0100
Message-Id: <20221205190812.624269613@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190808.733996403@linuxfoundation.org>
References: <20221205190808.733996403@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: David Ahern <dsahern@kernel.org>

[ Upstream commit 61b91eb33a69c3be11b259c5ea484505cd79f883 ]

Gwangun Jung reported a slab-out-of-bounds access in fib_nh_match:
    fib_nh_match+0xf98/0x1130 linux-6.0-rc7/net/ipv4/fib_semantics.c:961
    fib_table_delete+0x5f3/0xa40 linux-6.0-rc7/net/ipv4/fib_trie.c:1753
    inet_rtm_delroute+0x2b3/0x380 linux-6.0-rc7/net/ipv4/fib_frontend.c:874

Separate nexthop objects are mutually exclusive with the legacy
multipath spec. Fix fib_nh_match to return if the config for the
to be deleted route contains a multipath spec while the fib_info
is using a nexthop object.

Fixes: 493ced1ac47c ("ipv4: Allow routes to use nexthop objects")
Fixes: 6bf92d70e690 ("net: ipv4: fix route with nexthop object delete warning")
Reported-by: Gwangun Jung <exsociety@gmail.com>
Signed-off-by: David Ahern <dsahern@kernel.org>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Tested-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: d5082d386eee ("ipv4: Fix route deletion when nexthop info is not specified")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/fib_semantics.c                    | 8 ++++----
 tools/testing/selftests/net/fib_nexthops.sh | 5 +++++
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index 28da0443f3e9..31424172ff18 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -875,13 +875,13 @@ int fib_nh_match(struct fib_config *cfg, struct fib_info *fi,
 		return 1;
 	}
 
+	/* cannot match on nexthop object attributes */
+	if (fi->nh)
+		return 1;
+
 	if (cfg->fc_oif || cfg->fc_gw_family) {
 		struct fib_nh *nh;
 
-		/* cannot match on nexthop object attributes */
-		if (fi->nh)
-			return 1;
-
 		nh = fib_info_nh(fi, 0);
 		if (cfg->fc_encap) {
 			if (fib_encap_match(cfg->fc_encap_type, cfg->fc_encap,
diff --git a/tools/testing/selftests/net/fib_nexthops.sh b/tools/testing/selftests/net/fib_nexthops.sh
index 7b154b61d108..28f5121fac44 100755
--- a/tools/testing/selftests/net/fib_nexthops.sh
+++ b/tools/testing/selftests/net/fib_nexthops.sh
@@ -597,6 +597,11 @@ ipv4_fcnal()
 	log_test $rc 0 "Delete nexthop route warning"
 	run_cmd "$IP route delete 172.16.101.1/32 nhid 12"
 	run_cmd "$IP nexthop del id 12"
+
+	run_cmd "$IP nexthop add id 21 via 172.16.1.6 dev veth1"
+	run_cmd "$IP ro add 172.16.101.0/24 nhid 21"
+	run_cmd "$IP ro del 172.16.101.0/24 nexthop via 172.16.1.7 dev veth1 nexthop via 172.16.1.8 dev veth1"
+	log_test $? 2 "Delete multipath route with only nh id based entry"
 }
 
 ipv4_grp_fcnal()
-- 
2.35.1



