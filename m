Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F69A6FA0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:45:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB014C433F0;
	Mon, 16 Jan 2023 16:45:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673887542;
	bh=p/fmj0xyg2TdTchYQw1fa6694miCpx4jkFcRFwgl+Gg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cv9MczVZHWAWSHvpZrUIkG392RAqP12OKRbLx9FtTzglJ3rVRocN1WR5d6idmjmnI
	 0kfT3rJQdaxnbRDQjZSWbAHPlneOPPlD1hzp5O7MYvEc0oHp8Ycl6XaSNA43JXkOnP
	 x2abmZ+FBobT7jmtJYdNK3NxjepOIQ7s3vPp2/e4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 188/521] crypto: ccree - Make cc_debugfs_global_fini() available for module init function
Date: Mon, 16 Jan 2023 16:47:30 +0100
Message-Id: <20230116154855.471086717@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit 8e96729fc26c8967db45a3fb7a60387619f77a22 ]

ccree_init() calls cc_debugfs_global_fini(), the former is an init
function and the latter an exit function though.

A modular build emits:

	WARNING: modpost: drivers/crypto/ccree/ccree.o: section mismatch in reference: init_module (section: .init.text) -> cc_debugfs_global_fini (section: .exit.text)

(with CONFIG_DEBUG_SECTION_MISMATCH=y).

Fixes: 4f1c596df706 ("crypto: ccree - Remove debugfs when platform_driver_register failed")
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/ccree/cc_debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/ccree/cc_debugfs.c b/drivers/crypto/ccree/cc_debugfs.c
index 5ca184e42483..3879f33fb59e 100644
--- a/drivers/crypto/ccree/cc_debugfs.c
+++ b/drivers/crypto/ccree/cc_debugfs.c
@@ -46,7 +46,7 @@ int __init cc_debugfs_global_init(void)
 	return !cc_debugfs_dir;
 }
 
-void __exit cc_debugfs_global_fini(void)
+void cc_debugfs_global_fini(void)
 {
 	debugfs_remove(cc_debugfs_dir);
 }
-- 
2.35.1



