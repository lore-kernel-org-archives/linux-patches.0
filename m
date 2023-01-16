Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2A106FA0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 17:08:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49ECEC433EF;
	Mon, 16 Jan 2023 17:08:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673888885;
	bh=CtCPtv8nZlGKiEm5OonGSaIb5WvtKScuz0l5RWrUT7I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0uI2zNrD/Lx33ZiduNucXexzxYVbKo9dDUpg9sreuxpNprelME9p3L/dOrEJm9xEO
	 JCiMsx5dGxh5S4H9UMqiLtcqqB8SPTqVZEZs19TiZqZc/v9iNSddz37a9c56Sh/2Qk
	 8ef4r2Ud3Lel3aU87okx5wtCAjLIS0ZIt1AADBfs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hui Tang <tanghui20@huawei.com>,
	Wolfram Sang <wsa@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 175/338] i2c: pxa-pci: fix missing pci_disable_device() on error in ce4100_i2c_probe
Date: Mon, 16 Jan 2023 16:50:48 +0100
Message-Id: <20230116154828.537938208@linuxfoundation.org>
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

From: Hui Tang <tanghui20@huawei.com>

[ Upstream commit d78a167332e1ca8113268ed922c1212fd71b73ad ]

Using pcim_enable_device() to avoid missing pci_disable_device().

Fixes: 7e94dd154e93 ("i2c-pxa2xx: Add PCI support for PXA I2C controller")
Signed-off-by: Hui Tang <tanghui20@huawei.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-pxa-pci.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/i2c/busses/i2c-pxa-pci.c b/drivers/i2c/busses/i2c-pxa-pci.c
index 004deb96afe3..4e81fbdaf90f 100644
--- a/drivers/i2c/busses/i2c-pxa-pci.c
+++ b/drivers/i2c/busses/i2c-pxa-pci.c
@@ -105,7 +105,7 @@ static int ce4100_i2c_probe(struct pci_dev *dev,
 	int i;
 	struct ce4100_devices *sds;
 
-	ret = pci_enable_device_mem(dev);
+	ret = pcim_enable_device(dev);
 	if (ret)
 		return ret;
 
@@ -114,10 +114,8 @@ static int ce4100_i2c_probe(struct pci_dev *dev,
 		return -EINVAL;
 	}
 	sds = kzalloc(sizeof(*sds), GFP_KERNEL);
-	if (!sds) {
-		ret = -ENOMEM;
-		goto err_mem;
-	}
+	if (!sds)
+		return -ENOMEM;
 
 	for (i = 0; i < ARRAY_SIZE(sds->pdev); i++) {
 		sds->pdev[i] = add_i2c_device(dev, i);
@@ -133,8 +131,6 @@ static int ce4100_i2c_probe(struct pci_dev *dev,
 
 err_dev_add:
 	kfree(sds);
-err_mem:
-	pci_disable_device(dev);
 	return ret;
 }
 
-- 
2.35.1



