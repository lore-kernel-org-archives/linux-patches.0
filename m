Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DAEA633
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 03:42:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA6D9C433D6;
	Wed,  2 Nov 2022 03:42:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667360536;
	bh=o+kQ0kibJIY6AUu6dMVdqw9OSZxD/dJ1lgAIFdQLZmE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F/RxCR+/uJKKwieZ3BfoinoKlXVVERxPru+iDINgEwjr/+UDp5OPy3avceyE+p0mQ
	 jmtQNC67G1SoOHlpXQpcfhdcIlRT+rgVxZDBDdkWTKmqrW3lvHwqwTOL1UkAQgF5oa
	 IGUSR3+ETZmZFtRMWfcYrfqSpslnBmPlxh49RynA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 54/60] net: ksz884x: fix missing pci_disable_device() on error in pcidev_init()
Date: Wed,  2 Nov 2022 03:35:15 +0100
Message-Id: <20221102022052.848355740@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022051.081761052@linuxfoundation.org>
References: <20221102022051.081761052@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 5da6d65590a0698199df44d095e54b0ed1708178 ]

pci_disable_device() need be called while module exiting, switch to use
pcim_enable(), pci_disable_device() will be called in pcim_release()
while unbinding device.

Fixes: 8ca86fd83eae ("net: Micrel KSZ8841/2 PCI Ethernet driver")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20221024131338.2848959-1-yangyingliang@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/micrel/ksz884x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/micrel/ksz884x.c b/drivers/net/ethernet/micrel/ksz884x.c
index b178e59baa2e..8212f24711bb 100644
--- a/drivers/net/ethernet/micrel/ksz884x.c
+++ b/drivers/net/ethernet/micrel/ksz884x.c
@@ -6939,7 +6939,7 @@ static int pcidev_init(struct pci_dev *pdev, const struct pci_device_id *id)
 	char banner[sizeof(version)];
 	struct ksz_switch *sw = NULL;
 
-	result = pci_enable_device(pdev);
+	result = pcim_enable_device(pdev);
 	if (result)
 		return result;
 
-- 
2.35.1



