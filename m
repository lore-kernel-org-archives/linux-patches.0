Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F9CC46B7
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:34:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A775DC433EF;
	Mon, 16 Jan 2023 16:34:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673886849;
	bh=TeVUh8dUZgnT16RGC+nQBIRxsr3/6yXJ8gB2mW3y3bE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wETgWiolT1VHV+cMK3Y+8bDeQCW7ZXu8qG9bJAgozW9i4zw7CpJd74TZhOXR1xh7e
	 1T76/PrdWsUlwp9hsKr648o1PP7W+FBl8xcjYrKUPiqF2iS7xE85B7jfOgaDB6Si3D
	 MbkZOH1Y0iKphob+akAxlH4PYeOpU+87Xayeo4Oo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhengchao Shao <shaozhengchao@huawei.com>,
	Jiri Pirko <jiri@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 586/658] caif: fix memory leak in cfctrl_linkup_request()
Date: Mon, 16 Jan 2023 16:51:14 +0100
Message-Id: <20230116154936.305155742@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zhengchao Shao <shaozhengchao@huawei.com>

[ Upstream commit fe69230f05897b3de758427b574fc98025dfc907 ]

When linktype is unknown or kzalloc failed in cfctrl_linkup_request(),
pkt is not released. Add release process to error path.

Fixes: b482cd2053e3 ("net-caif: add CAIF core protocol stack")
Fixes: 8d545c8f958f ("caif: Disconnect without waiting for response")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Link: https://lore.kernel.org/r/20230104065146.1153009-1-shaozhengchao@huawei.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/caif/cfctrl.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/caif/cfctrl.c b/net/caif/cfctrl.c
index 2809cbd6b7f7..d8cb4b2a076b 100644
--- a/net/caif/cfctrl.c
+++ b/net/caif/cfctrl.c
@@ -269,11 +269,15 @@ int cfctrl_linkup_request(struct cflayer *layer,
 	default:
 		pr_warn("Request setup of bad link type = %d\n",
 			param->linktype);
+		cfpkt_destroy(pkt);
 		return -EINVAL;
 	}
 	req = kzalloc(sizeof(*req), GFP_KERNEL);
-	if (!req)
+	if (!req) {
+		cfpkt_destroy(pkt);
 		return -ENOMEM;
+	}
+
 	req->client_layer = user_layer;
 	req->cmd = CFCTRL_CMD_LINK_SETUP;
 	req->param = *param;
-- 
2.35.1



