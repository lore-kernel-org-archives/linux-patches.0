Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E62746B5
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:19:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAE61C433F0;
	Mon, 16 Jan 2023 16:19:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673885985;
	bh=/SommzC+MzCCr7Wuu8teBOrT7fZnRCyG4DGmQ/rucm4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iLxVNsjJHvGmW71TU8iM0ydCHzwLR5luJ63MhQB+ZvPchUJbxf5VD3qdZnusNGok+
	 1xk4kueiG4OfWTnKrXPi8B3HjTVtHfXgz2ZRoQ15UfNLpWQyoahRR2YGMBtPKekcm7
	 pQI3v2OhfvEhaG4sIAxsubtRtD449G8YogvvLSYU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gaosheng Cui <cuigaosheng1@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 251/658] crypto: ccree - Remove debugfs when platform_driver_register failed
Date: Mon, 16 Jan 2023 16:45:39 +0100
Message-Id: <20230116154921.038059198@linuxfoundation.org>
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
index 58ca59af0b2e..3d59fef1fbee 100644
--- a/drivers/crypto/ccree/cc_driver.c
+++ b/drivers/crypto/ccree/cc_driver.c
@@ -653,9 +653,17 @@ static struct platform_driver ccree_driver = {
 
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



