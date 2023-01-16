Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7121B46B5
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:17:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA5B3C433D2;
	Mon, 16 Jan 2023 16:17:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673885869;
	bh=qMI16NqUCFo4CvrFoXRLiUmoRr86cGc9+xjw0aTitY4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t9iPpZcfYO+MpdfUXJQakD8szMNZsnHSKWiaePsIbDeD0fgFG1X6ybSGj9wK6uQ3W
	 Fwhk+x6fiJVmgyLHDioaAF4LrjignjTUmMuDrQVqjCHBWDh0SQ1/kzDs8u/TjRac3q
	 R+peGLkDkSfbna7i8gWPEECV+amRXu2P4OtQHLfw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yongqiang Liu <liuyongqiang13@huawei.com>,
	Jiri Pirko <jiri@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 214/658] net: defxx: Fix missing err handling in dfx_init()
Date: Mon, 16 Jan 2023 16:45:02 +0100
Message-Id: <20230116154919.250431653@linuxfoundation.org>
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
index c866f58dab70..28bf530cb005 100644
--- a/drivers/net/fddi/defxx.c
+++ b/drivers/net/fddi/defxx.c
@@ -3844,10 +3844,24 @@ static int dfx_init(void)
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



