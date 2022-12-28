Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 636591875
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:07:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD378C433F1;
	Wed, 28 Dec 2022 16:07:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672243659;
	bh=85omXn5FVO11lwaIPOdLpY9zVnj8HCnM54sZwW8BRuw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GUzOErOI4gM3zfD5WAiHOkdBWQjhF5yMAfC7LoTBhIF2hppY7k4Q3Zb4Nhxq213VN
	 FPPzEy1RqLCYbK1RNK+pyqM1hC7Ma/xGIbK7RqC5t3za4nS9VW7BOcNMZnNaOPn6w7
	 g2+eYsTRmzM1JqT+ne2sXkezuVck7SYZekCdYdeg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yongqiang Liu <liuyongqiang13@huawei.com>,
	Jiri Pirko <jiri@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0529/1146] net: defxx: Fix missing err handling in dfx_init()
Date: Wed, 28 Dec 2022 15:34:28 +0100
Message-Id: <20221228144344.545099471@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yongqiang Liu <liuyongqiang13@huawei.com>

[ Upstream commit ae18dcdff0f8d7e84cd3fd9f496518b5e72d185d ]

When eisa_driver_register() or tc_register_driver() failed,
the modprobe defxx would fail with some err log as follows:

 Error: Driver 'defxx' is already registered, aborting...

Fix this issue by adding err hanling in dfx_init().

Fixes: e89a2cfb7d7b5 ("[TC] defxx: TURBOchannel support")
Signed-off-by: Yongqiang Liu <liuyongqiang13@huawei.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/fddi/defxx.c | 22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/drivers/net/fddi/defxx.c b/drivers/net/fddi/defxx.c
index b584ffe38ad6..1fef8a9b1a0f 100644
--- a/drivers/net/fddi/defxx.c
+++ b/drivers/net/fddi/defxx.c
@@ -3831,10 +3831,24 @@ static int dfx_init(void)
 	int status;
 
 	status = pci_register_driver(&dfx_pci_driver);
-	if (!status)
-		status = eisa_driver_register(&dfx_eisa_driver);
-	if (!status)
-		status = tc_register_driver(&dfx_tc_driver);
+	if (status)
+		goto err_pci_register;
+
+	status = eisa_driver_register(&dfx_eisa_driver);
+	if (status)
+		goto err_eisa_register;
+
+	status = tc_register_driver(&dfx_tc_driver);
+	if (status)
+		goto err_tc_register;
+
+	return 0;
+
+err_tc_register:
+	eisa_driver_unregister(&dfx_eisa_driver);
+err_eisa_register:
+	pci_unregister_driver(&dfx_pci_driver);
+err_pci_register:
 	return status;
 }
 
-- 
2.35.1



