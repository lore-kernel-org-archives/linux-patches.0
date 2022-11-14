Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41F134C6A
	for <patches@lists.linux.dev>; Mon, 14 Nov 2022 13:04:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B86A3C433D6;
	Mon, 14 Nov 2022 13:04:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1668431098;
	bh=4DTsmTV7tjrPTVNor5mkQCVSPn2c9laJOxJjFztQ8Lo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VWSnNWyMpoxqFq+BPbq7PbEpYhp1jJ8JKauGki8F7xiGCA3ZS6Av+shzl9dIwBtHj
	 qAlI5IWVaMoj2FrdrgPy+Pt6GWDccCEo+O/2ejxx8odF2y5tbYLrDGQk075w6dJyVI
	 PUSbTjS9JTz+TSKOi/2CjAMmmm2t39yt1Aypq6qY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Yongjun <weiyongjun1@huawei.com>,
	Matt Johnston <matt@codeconstruct.com.au>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 099/190] mctp: Fix an error handling path in mctp_init()
Date: Mon, 14 Nov 2022 13:45:23 +0100
Message-Id: <20221114124503.031546933@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124458.806324402@linuxfoundation.org>
References: <20221114124458.806324402@linuxfoundation.org>
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
index b6b5e496fa40..fc9e728b6333 100644
--- a/net/mctp/af_mctp.c
+++ b/net/mctp/af_mctp.c
@@ -665,12 +665,14 @@ static __init int mctp_init(void)
 
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
index 2155f15a074c..f9a80b82dc51 100644
--- a/net/mctp/route.c
+++ b/net/mctp/route.c
@@ -1400,7 +1400,7 @@ int __init mctp_routes_init(void)
 	return register_pernet_subsys(&mctp_net_ops);
 }
 
-void __exit mctp_routes_exit(void)
+void mctp_routes_exit(void)
 {
 	unregister_pernet_subsys(&mctp_net_ops);
 	rtnl_unregister(PF_MCTP, RTM_DELROUTE);
-- 
2.35.1



