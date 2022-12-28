Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03E081C07
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:15:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AAF8C433EF;
	Wed, 28 Dec 2022 16:15:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672244130;
	bh=WECNFBqWMgfh/OaxO+PEGaV6v4ab824tu0+YC4JNa/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dY3Mq7jbgQ/jYXa/KTx07aGXQgh8Ayp3TbdqPTPtEmhgLd+pSFcnOkxWb586IVsdz
	 5wfCedd9cjVId3ZBweEQ9KkEFvkl99O15AtnH5mEPteLv6l2GBzCDUXbLTs1a61boD
	 U/ZmXoCGQelq3MJO6dsjoAubm78N/00GrqW+N3y4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gaosheng Cui <cuigaosheng1@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0616/1146] crypto: ccree - Remove debugfs when platform_driver_register failed
Date: Wed, 28 Dec 2022 15:35:55 +0100
Message-Id: <20221228144346.900987171@linuxfoundation.org>
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

From: Gaosheng Cui <cuigaosheng1@huawei.com>

[ Upstream commit 4f1c596df706c9aca662b6c214fad84047ae2a97 ]

When platform_driver_register failed, we need to remove debugfs,
which will caused a resource leak, fix it.

Failed logs as follows:
[   32.606488] debugfs: Directory 'ccree' with parent '/' already present!

Fixes: 4c3f97276e15 ("crypto: ccree - introduce CryptoCell driver")
Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/ccree/cc_driver.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/ccree/cc_driver.c b/drivers/crypto/ccree/cc_driver.c
index cadead18b59e..d489c6f80892 100644
--- a/drivers/crypto/ccree/cc_driver.c
+++ b/drivers/crypto/ccree/cc_driver.c
@@ -651,9 +651,17 @@ static struct platform_driver ccree_driver = {
 
 static int __init ccree_init(void)
 {
+	int rc;
+
 	cc_debugfs_global_init();
 
-	return platform_driver_register(&ccree_driver);
+	rc = platform_driver_register(&ccree_driver);
+	if (rc) {
+		cc_debugfs_global_fini();
+		return rc;
+	}
+
+	return 0;
 }
 module_init(ccree_init);
 
-- 
2.35.1



