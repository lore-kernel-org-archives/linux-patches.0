Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D7114C6A
	for <patches@lists.linux.dev>; Mon, 14 Nov 2022 12:57:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EC9FC433C1;
	Mon, 14 Nov 2022 12:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1668430674;
	bh=G5L8tBgpfWpUdvSTv+o0ttdDDtKbaCUMF7s2UNxjpdU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wpRLoLpVfhStAB6g2eDljkvRnH5UK0n9ARHgge303EawxhrRLXDU14orecqZ4OA/b
	 zmfLipAhveOPqs2LBtoqND3WTySHFflSWV5EGuVwZvCPvxgW/pr/B6oUDL47JLWAVq
	 vDhHiZtRCU9sHOlxlceOerHZSIurYGnUR+MBYzmE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Yongjun <weiyongjun1@huawei.com>,
	Matt Johnston <matt@codeconstruct.com.au>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 068/131] mctp: Fix an error handling path in mctp_init()
Date: Mon, 14 Nov 2022 13:45:37 +0100
Message-Id: <20221114124451.587278204@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124448.729235104@linuxfoundation.org>
References: <20221114124448.729235104@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Wei Yongjun <weiyongjun1@huawei.com>

[ Upstream commit d4072058af4fd8fb4658e7452289042a406a9398 ]

If mctp_neigh_init() return error, the routes resources should
be released in the error handling path. Otherwise some resources
leak.

Fixes: 4d8b9319282a ("mctp: Add neighbour implementation")
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Acked-by: Matt Johnston <matt@codeconstruct.com.au>
Link: https://lore.kernel.org/r/20221108095517.620115-1-weiyongjun@huaweicloud.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mctp/af_mctp.c | 4 +++-
 net/mctp/route.c   | 2 +-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/mctp/af_mctp.c b/net/mctp/af_mctp.c
index 85cc1a28cbe9..cbbde0f73a08 100644
--- a/net/mctp/af_mctp.c
+++ b/net/mctp/af_mctp.c
@@ -375,12 +375,14 @@ static __init int mctp_init(void)
 
 	rc = mctp_neigh_init();
 	if (rc)
-		goto err_unreg_proto;
+		goto err_unreg_routes;
 
 	mctp_device_init();
 
 	return 0;
 
+err_unreg_routes:
+	mctp_routes_exit();
 err_unreg_proto:
 	proto_unregister(&mctp_proto);
 err_unreg_sock:
diff --git a/net/mctp/route.c b/net/mctp/route.c
index bbb13dbc9227..6aebb4a3eded 100644
--- a/net/mctp/route.c
+++ b/net/mctp/route.c
@@ -1109,7 +1109,7 @@ int __init mctp_routes_init(void)
 	return register_pernet_subsys(&mctp_net_ops);
 }
 
-void __exit mctp_routes_exit(void)
+void mctp_routes_exit(void)
 {
 	unregister_pernet_subsys(&mctp_net_ops);
 	rtnl_unregister(PF_MCTP, RTM_DELROUTE);
-- 
2.35.1



