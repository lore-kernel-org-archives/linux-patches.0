Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 879EB1C26
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:06:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE867C433D7;
	Wed, 23 Nov 2022 09:06:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669194411;
	bh=uWbYkv+sonzVHGeotezogYwIrxjNFJkzgZ4k1f1l1GM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NVMAhrQKQP+IDKBTtajfQPlscExcTRIRkr0PjqOR8igiAh2/quU3sqAx1u0MeI2jQ
	 f0VhPpU0bqIKVOP95X2QPpo5eWZlgh0q/9uAYT9cG6IacwgHihO0TgyNvGCpGhIL82
	 bUfDh0k1UyR2CYTCCzd0K36aRKpg3+4fw1mkCUEM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gaosheng Cui <cuigaosheng1@huawei.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Michael Chan <michael.chan@broadcom.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 069/114] bnxt_en: Remove debugfs when pci_register_driver failed
Date: Wed, 23 Nov 2022 09:50:56 +0100
Message-Id: <20221123084554.638368443@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084551.864610302@linuxfoundation.org>
References: <20221123084551.864610302@linuxfoundation.org>
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

[ Upstream commit 991aef4ee4f6eb999924f429b943441a32835c8f ]

When pci_register_driver failed, we need to remove debugfs,
which will caused a resource leak, fix it.

Resource leak logs as follows:
[   52.184456] debugfs: Directory 'bnxt_en' with parent '/' already present!

Fixes: cabfb09d87bd ("bnxt_en: add debugfs support for DIM")
Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Reviewed-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index b49f8a97d753..dc106212259a 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -9383,8 +9383,16 @@ static struct pci_driver bnxt_pci_driver = {
 
 static int __init bnxt_init(void)
 {
+	int err;
+
 	bnxt_debug_init();
-	return pci_register_driver(&bnxt_pci_driver);
+	err = pci_register_driver(&bnxt_pci_driver);
+	if (err) {
+		bnxt_debug_exit();
+		return err;
+	}
+
+	return 0;
 }
 
 static void __exit bnxt_exit(void)
-- 
2.35.1



