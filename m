Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7849B6FA0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 17:04:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00329C433EF;
	Mon, 16 Jan 2023 17:04:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673888645;
	bh=1ul6U5W55GVzZ8B6vDOCdW+Hqw2l8cPmJx2x4F6i2WQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r0BUW+9yxl+OKcQdPNfMWFmSMNlUSszKy5bWta+fa052uHSaemyD6qiKumWlbuXH+
	 GAGe9rz0uUmfT7Nt+1frUmenZhAqhaxMmUNE+D0BY0zLFWqV/TA7MLGMxAQ+sTWuiN
	 Zf7YzTZSKl2xnArxOFdTPj9kNFVGD4US0kh/fgPc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiu Jianfeng <xiujianfeng@huawei.com>,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 077/338] wifi: ath10k: Fix return value in ath10k_pci_init()
Date: Mon, 16 Jan 2023 16:49:10 +0100
Message-Id: <20230116154824.244819766@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154820.689115727@linuxfoundation.org>
References: <20230116154820.689115727@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Xiu Jianfeng <xiujianfeng@huawei.com>

[ Upstream commit 2af7749047d8d6ad43feff69f555a13a6a6c2831 ]

This driver is attempting to register to support two different buses.
if either of these is successful then ath10k_pci_init() should return 0
so that hardware attached to the successful bus can be probed and
supported. only if both of these are unsuccessful should ath10k_pci_init()
return an errno.

Fixes: 0b523ced9a3c ("ath10k: add basic skeleton to support ahb")
Signed-off-by: Xiu Jianfeng <xiujianfeng@huawei.com>
Reviewed-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20221110061926.18163-1-xiujianfeng@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/pci.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index f9e409caca68..07457eb9d455 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -3443,18 +3443,22 @@ static struct pci_driver ath10k_pci_driver = {
 
 static int __init ath10k_pci_init(void)
 {
-	int ret;
+	int ret1, ret2;
 
-	ret = pci_register_driver(&ath10k_pci_driver);
-	if (ret)
+	ret1 = pci_register_driver(&ath10k_pci_driver);
+	if (ret1)
 		printk(KERN_ERR "failed to register ath10k pci driver: %d\n",
-		       ret);
+		       ret1);
 
-	ret = ath10k_ahb_init();
-	if (ret)
-		printk(KERN_ERR "ahb init failed: %d\n", ret);
+	ret2 = ath10k_ahb_init();
+	if (ret2)
+		printk(KERN_ERR "ahb init failed: %d\n", ret2);
 
-	return ret;
+	if (ret1 && ret2)
+		return ret1;
+
+	/* registered to at least one bus */
+	return 0;
 }
 module_init(ath10k_pci_init);
 
-- 
2.35.1



