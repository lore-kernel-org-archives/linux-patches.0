Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A79EB1C29
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:15:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F15A3C433D6;
	Wed, 23 Nov 2022 09:15:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669194939;
	bh=f4OIY5sPcdq/5cbSNKkbC18Mb7eCCZ472eJlEn5OB+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S2gdzwREkl0Q6dBkgEnwyUeWYsyTgHe4zoKlfAPL0tnKNeSqDXew/zFcmeRhmk9gY
	 SMHKD768DmqhfgXZlByVmsDdFLTkoAfkD61iiBVoPwALlFlWAs9s4h2HsVYqCqWnC/
	 PMuiKRXxkGXmxmwCvGejQCY0OuClatkx+7mx1gkA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gaosheng Cui <cuigaosheng1@huawei.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Michael Chan <michael.chan@broadcom.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 103/156] bnxt_en: Remove debugfs when pci_register_driver failed
Date: Wed, 23 Nov 2022 09:51:00 +0100
Message-Id: <20221123084601.700840088@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084557.816085212@linuxfoundation.org>
References: <20221123084557.816085212@linuxfoundation.org>
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
index d7d7d6421c48..3636849f6365 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -12232,8 +12232,16 @@ static struct pci_driver bnxt_pci_driver = {
 
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



