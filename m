Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1932945BE4
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 22:04:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HDMSreNV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDFF5C433CB;
	Wed, 15 Nov 2023 22:04:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700085842;
	bh=4yIAk2HBnPvWsxL33qJQjBelZxrzK2XWNOD+tFQwND8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HDMSreNVamSxeYH4txBw9Rkm5AmlmWO++BeirvutPGbdF7i5JJLZmeCpgUtpF0nB3
	 qHyd4YDHVooqxpqEKYUpIxEJM+1hFQwRPIweFN8qy+83wXGtZf60IGYxogFec43NER
	 JHwhq/3ok4eHI/2ckCIKGlc7tGmqCnm5uZ5NUIoY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zheng Wang <zyytlz.wz@163.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 091/119] media: bttv: fix use after free error due to btv->timeout timer
Date: Wed, 15 Nov 2023 17:01:21 -0500
Message-ID: <20231115220135.458602894@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115220132.607437515@linuxfoundation.org>
References: <20231115220132.607437515@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zheng Wang <zyytlz.wz@163.com>

[ Upstream commit bd5b50b329e850d467e7bcc07b2b6bde3752fbda ]

There may be some a race condition between timer function
bttv_irq_timeout and bttv_remove. The timer is setup in
probe and there is no timer_delete operation in remove
function. When it hit kfree btv, the function might still be
invoked, which will cause use after free bug.

This bug is found by static analysis, it may be false positive.

Fix it by adding del_timer_sync invoking to the remove function.

cpu0                cpu1
                  bttv_probe
                    ->timer_setup
                      ->bttv_set_dma
                        ->mod_timer;
bttv_remove
  ->kfree(btv);
                  ->bttv_irq_timeout
                    ->USE btv

Fixes: 162e6376ac58 ("media: pci: Convert timers to use timer_setup()")
Signed-off-by: Zheng Wang <zyytlz.wz@163.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/pci/bt8xx/bttv-driver.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/pci/bt8xx/bttv-driver.c b/drivers/media/pci/bt8xx/bttv-driver.c
index 6441e7d63d971..a0be1ca89b29a 100644
--- a/drivers/media/pci/bt8xx/bttv-driver.c
+++ b/drivers/media/pci/bt8xx/bttv-driver.c
@@ -4258,6 +4258,7 @@ static void bttv_remove(struct pci_dev *pci_dev)
 
 	/* free resources */
 	free_irq(btv->c.pci->irq,btv);
+	del_timer_sync(&btv->timeout);
 	iounmap(btv->bt848_mmio);
 	release_mem_region(pci_resource_start(btv->c.pci,0),
 			   pci_resource_len(btv->c.pci,0));
-- 
2.42.0



