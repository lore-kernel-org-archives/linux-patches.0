Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8E651863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:19:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24FD1C433EF;
	Wed, 28 Dec 2022 15:19:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672240748;
	bh=WI6CcsguI3tWGJBsi5fp+QL1JRy9bMscPPgNgEOfYAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dKwguqxObfmxrRv2a5fsrd+POZu10ATywK8ODDz6jMTPSIAFTDZr5aT8vXofTGfgx
	 I5d4eaZi3U/fdiTiNqG5On9/GUBuDF8N99tTwtwNjEnxpAU/kZPT4iKkKdQI4WAIdo
	 cWnnrosFrusQwaCw1l5LvWjbM2ZcQWJL+Ul21fmE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiongfeng Wang <wangxiongfeng2@huawei.com>,
	Weili Qian <qianweili@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 393/731] crypto: hisilicon/qm - add missing pci_dev_put() in q_num_set()
Date: Wed, 28 Dec 2022 15:38:20 +0100
Message-Id: <20221228144307.951318228@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Xiongfeng Wang <wangxiongfeng2@huawei.com>

[ Upstream commit cc7710d0d4ebc6998f04035cde4f32c5ddbe9d7f ]

pci_get_device() will increase the reference count for the returned
pci_dev. We need to use pci_dev_put() to decrease the reference count
before q_num_set() returns.

Fixes: c8b4b477079d ("crypto: hisilicon - add HiSilicon HPRE accelerator")
Signed-off-by: Xiongfeng Wang <wangxiongfeng2@huawei.com>
Reviewed-by: Weili Qian <qianweili@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/hisilicon/qm.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/hisilicon/qm.h b/drivers/crypto/hisilicon/qm.h
index 3068093229a5..bbb35de994eb 100644
--- a/drivers/crypto/hisilicon/qm.h
+++ b/drivers/crypto/hisilicon/qm.h
@@ -318,14 +318,14 @@ struct hisi_qp {
 static inline int q_num_set(const char *val, const struct kernel_param *kp,
 			    unsigned int device)
 {
-	struct pci_dev *pdev = pci_get_device(PCI_VENDOR_ID_HUAWEI,
-					      device, NULL);
+	struct pci_dev *pdev;
 	u32 n, q_num;
 	int ret;
 
 	if (!val)
 		return -EINVAL;
 
+	pdev = pci_get_device(PCI_VENDOR_ID_HUAWEI, device, NULL);
 	if (!pdev) {
 		q_num = min_t(u32, QM_QNUM_V1, QM_QNUM_V2);
 		pr_info("No device found currently, suppose queue number is %u\n",
@@ -335,6 +335,8 @@ static inline int q_num_set(const char *val, const struct kernel_param *kp,
 			q_num = QM_QNUM_V1;
 		else
 			q_num = QM_QNUM_V2;
+
+		pci_dev_put(pdev);
 	}
 
 	ret = kstrtou32(val, 10, &n);
-- 
2.35.1



